import os
import re
import json
import logging
import datetime
import time
from typing import List, Dict, Any, Optional
from bs4 import BeautifulSoup
import httpx
import urllib3
from playwright.sync_api import sync_playwright

# Configure logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)
# Suppress SSL warnings for verify=False
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


def sanitize_filename(name: str) -> str:
    """Sanitizes a string for use as a directory or filename."""
    # Replace invalid characters with underscores
    sanitized = re.sub(r'[\\/*?:"<>|]', "_", name)
    # Trim and remove repeating underscores
    sanitized = re.sub(r"_+", "_", sanitized).strip()
    # Windows doesn't like trailing dots or spaces in folder names
    sanitized = sanitized.rstrip(". ")
    return sanitized[:120]  # Limit folder name length to stay safe


def create_url_file(path: str, url: str):
    """Creates a Windows .url shortcut file."""
    content = f"[InternetShortcut]\nURL={url}\n"
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)


def is_html_content(content_type: str) -> bool:
    """Checks if a content type is HTML."""
    return "text/html" in content_type.lower()


def is_asset_content(content_type: str) -> bool:
    """Checks if a content type is a web asset (CSS/JS)."""
    types = {
        "text/css",
        "application/javascript",
        "application/x-javascript",
        "text/javascript",
        "image/",
    }
    return any(t in content_type.lower() for t in types)


def get_browser_context(playwright):
    """Utility to get a configured browser context."""
    browser = playwright.chromium.launch(headless=True)
    context = browser.new_context(
        user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    )
    return browser, context


def browser_fallback_download(url: str, folder: str) -> Optional[str]:
    """Uses Playwright to download a file or capture a page if httpx fails."""
    logging.info(f"Attempting browser fallback for: {url}")
    filepath = None
    try:
        with sync_playwright() as p:
            browser, context = get_browser_context(p)
            page = context.new_page()

            # Handle possible download
            download_info = []

            def handle_download(download):
                download_info.append(download)

            page.on("download", handle_download)

            try:
                response = page.goto(url, wait_until="networkidle", timeout=60000)

                if download_info:
                    # It triggered a download
                    download = download_info[0]
                    suggested_name = sanitize_filename(download.suggested_filename)
                    filepath = os.path.join(folder, suggested_name)
                    download.save_as(filepath)
                    logging.info(f"Browser captured download: {filepath}")
                elif response and response.ok:
                    ctype = response.headers.get("content-type", "").lower()
                    if is_html_content(ctype):
                        # Save the rendered HTML
                        name = "external_page.html"
                        filepath = os.path.join(folder, name)
                        with open(
                            filepath, "w", encoding="utf-8", errors="ignore"
                        ) as f:
                            f.write(page.content())
                        logging.info(f"Browser captured page: {filepath}")
                    else:
                        logging.info(
                            f"Browser reached non-HTML content ({ctype}) but no download triggered."
                        )
            except Exception as e:
                logging.error(f"Browser navigation failed: {e}")

            browser.close()
    except Exception as e:
        logging.error(f"Playwright initialization failed: {e}")

    return filepath


def download_file(
    client: httpx.Client,
    url: str,
    folder: str,
    initial_response: Optional[httpx.Response] = None,
) -> Optional[str]:
    """Downloads a file, using an existing response if provided to avoid re-fetching."""
    try:
        response = (
            initial_response
            if initial_response
            else client.get(url, follow_redirects=True)
        )
        response.raise_for_status()

        # Determine filename from Content-Disposition if possible
        cd = response.headers.get("Content-Disposition", "")
        filename = None
        if "filename=" in cd:
            filename = cd.split("filename=")[-1].strip(" \"'")

        if not filename:
            filename = url.split("/")[-1].split("?")[0]
            if not filename or filename == "":
                filename = "downloaded_file"

        filename = sanitize_filename(filename)
        # Ensure extension if missing
        if "." not in filename:
            orig_ext = os.path.splitext(url.split("?")[0])[1]
            if not orig_ext:
                # Rudimentary mapping
                ctype = response.headers.get("Content-Type", "").split(";")[0]
                ext_map = {
                    "application/pdf": ".pdf",
                    "application/vnd.ms-excel": ".xls",
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet": ".xlsx",
                    "text/csv": ".csv",
                    "application/msword": ".doc",
                    "application/zip": ".zip",
                }
                orig_ext = ext_map.get(ctype, "")
            filename += orig_ext

        filepath = os.path.join(folder, filename)
        with open(filepath, "wb") as f:
            f.write(response.content)
        return filepath
    except Exception as e:
        logging.warning(
            f"Failed to download {url} via httpx: {e}. Trying browser fallback..."
        )
        return browser_fallback_download(url, folder)


def scan_and_download(
    client: httpx.Client, url: str, folder: str, is_external_scan: bool = False
) -> List[str]:
    """
    Fetches a URL and decided whether to save it as a file/external page
    or scan it if it is HTML.
    """
    downloaded = []
    try:
        logging.info(f"Fetching: {url}")
        resp = client.get(url, follow_redirects=True)
        resp.raise_for_status()

        ctype = resp.headers.get("Content-Type", "").lower()
        logging.info(f"Content-Type: {ctype} for {url}")

        if is_html_content(ctype):
            # Save the HTML
            name = "external_page.html" if is_external_scan else "seea_page.html"
            html_path = os.path.join(folder, name)
            with open(html_path, "w", encoding="utf-8", errors="ignore") as f:
                f.write(resp.text)
            logging.info(f"Saved HTML: {html_path}")
            downloaded.append(name)  # Return basename

            # If we are allowed to scan further (only for the first external page)
            if is_external_scan:
                soup = BeautifulSoup(resp.text, "html.parser")
                links = soup.find_all("a", href=True)
                for link in links:
                    href = link["href"]
                    if not href.startswith(("http://", "https://")):
                        try:
                            href = str(httpx.URL(url).join(href))
                        except Exception:
                            continue

                    try:
                        # Use HEAD to check type quickly
                        h = client.head(href, follow_redirects=True)
                        h_ctype = h.headers.get("Content-Type", "").lower()
                        if not is_html_content(h_ctype) and not is_asset_content(
                            h_ctype
                        ):
                            path = download_file(client, href, folder)
                            if path:
                                downloaded.append(os.path.basename(path))
                    except Exception as e:
                        logging.debug(f"Skipping link {href} due to error: {e}")
        elif not is_asset_content(ctype):
            # It's a file, download it
            path = download_file(client, url, folder, initial_response=resp)
            if path:
                downloaded.append(os.path.basename(path))
        else:
            logging.info(f"Skipping asset: {url} ({ctype})")

    except Exception as e:
        logging.warning(
            f"Error processing {url} via httpx: {e}. Trying browser fallback..."
        )
        path = browser_fallback_download(url, folder)
        if path:
            downloaded.append(os.path.basename(path))

    return downloaded


def process_document(
    client: httpx.Client, doc: Dict[str, Any], output_root: str
) -> Dict[str, Any]:
    """Processes a single document entry from output.json."""
    full_title = (doc.get("title") or "Unknown").strip()
    short_title = full_title[:60]  # Shorten for the folder name
    location = (doc.get("location") or "Global").strip()
    date = (doc.get("date") or "Unknown").strip()
    seea_url = doc.get("href")

    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    # Clean parts before joining
    parts = [p for p in [short_title, location, date] if p]
    folder_name = " - ".join(parts)
    folder_path = os.path.abspath(
        os.path.join(output_root, sanitize_filename(folder_name))
    )

    os.makedirs(folder_path, exist_ok=True)

    log_entry = {
        "title": full_title,
        "seea_url": seea_url,
        "folder": folder_path,
        "downloads": [],
        "status": "partial",
    }

    try:
        logging.info(f"Processing document: {full_title}")
        # Process the SEEA page first to find external links
        res = client.get(seea_url, follow_redirects=True)
        res.raise_for_status()

        # Save SEEA page HTML
        seea_html_path = os.path.join(folder_path, "seea_page.html")
        with open(seea_html_path, "w", encoding="utf-8", errors="ignore") as f:
            f.write(res.text)
        log_entry["downloads"].append("seea_page.html")

        soup = BeautifulSoup(res.text, "html.parser")
        external_links = []

        # Find links in .field-name-field-external-link and .file
        # This covers cases where .file is a container OR the <a> tag itself.
        links_to_process = soup.select(
            ".field-name-field-external-link a[href], .file a[href], a.file[href]"
        )

        external_links = []
        for tag in links_to_process:
            href = tag["href"]
            if not href.startswith(("http://", "https://")):
                href = f"https://seea.un.org{href}"
            external_links.append(href)

        if not external_links:
            logging.warning(f"No external links found for {full_title}")
            log_entry["status"] = "no_links"
            return log_entry

        for idx, ext_url in enumerate(external_links):
            # Create subfolder for each external link if there are multiple
            subfolder = folder_path
            if len(external_links) > 1:
                link_sub = sanitize_filename(f"link_{idx+1}")
                subfolder = os.path.join(folder_path, link_sub)
                os.makedirs(subfolder, exist_ok=True)

            # Save shortcut
            create_url_file(os.path.join(subfolder, "shortcut.url"), ext_url)
            log_entry["downloads"].append(f"shortcut_{idx+1}.url")

            # Scan and download from the external link
            logging.info(f"Scanning/Downloading from external link: {ext_url}")
            paths = scan_and_download(client, ext_url, subfolder, is_external_scan=True)
            for p in paths:
                if p not in log_entry["downloads"]:
                    log_entry["downloads"].append(p)

        log_entry["status"] = "success"

    except Exception as e:
        logging.error(f"Error processing {full_title}: {e}")
        log_entry["status"] = f"error: {str(e)}"

    return log_entry


def main():
    if not os.path.exists("output.json"):
        logging.error("output.json not found. Run scraper.py first.")
        return

    with open("output.json", "r", encoding="utf-8") as f:
        documents = json.load(f)

    output_root = "outputs"
    os.makedirs(output_root, exist_ok=True)

    # Dict keyed by seea_url for deduplication
    results_map = {}

    # Load existing log to resume
    if os.path.exists("download_log.json"):
        try:
            with open("download_log.json", "r", encoding="utf-8") as f:
                old_results = json.load(f)
                for entry in old_results:
                    url = entry.get("seea_url")
                    if url:
                        results_map[url] = entry
            logging.info(f"Loaded {len(results_map)} entries from existing log.")
        except Exception as e:
            logging.warning(f"Could not load download_log.json for resume: {e}")

    # Realistic browser headers
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8",
        "Accept-Language": "en-US,en;q=0.9",
        "Referer": "https://seea.un.org/",
    }

    # Disable SSL verification for broad access
    with httpx.Client(
        timeout=60.0, follow_redirects=True, verify=False, headers=headers
    ) as client:
        # Process one by one as requested
        for doc in documents:
            url = doc.get("href")

            # Skip if already successful AND contains external_page.html or a file (not just seea_page)
            # This ensures we retry those that might be missing the external content.
            if url in results_map:
                entry = results_map[url]
                if entry.get("status") == "success":
                    # Heuristic: if status is success but only seea_page.html was saved, maybe retry with browser
                    saved = entry.get("downloads", [])
                    if len(saved) > 1:  # Usually seea_page.html + something else
                        continue
                elif entry.get("status") == "no_links":
                    continue

            res = process_document(client, doc, output_root)
            results_map[url] = res

            # Save log cumulatively (as list)
            with open("download_log.json", "w", encoding="utf-8") as lf:
                json.dump(list(results_map.values()), lf, indent=2, ensure_ascii=False)

    logging.info(f"Downloader finished. Processed {len(documents)} document entries.")


if __name__ == "__main__":
    main()
