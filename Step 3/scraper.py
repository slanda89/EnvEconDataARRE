import argparse
import json
import logging
from typing import Dict, Any, List
import urllib.parse
from bs4 import BeautifulSoup
import httpx

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Removed dynamically embedded parse_search_elements function in favor of static JSON filter configuration.

def build_payload(filters_mapping: Dict[str, Any], user_filters: Dict[str, Any], page: int = 0) -> str:
    """Constructs the application/x-www-form-urlencoded body."""
    payload_data = []
    
    # Process Global Search
    keyword = user_filters.get('keywords', '')
    if 'Global Search' in filters_mapping and '_textfield_' in filters_mapping['Global Search']:
        name = filters_mapping['Global Search']['_textfield_']['name']
        payload_data.append(f"{name}={urllib.parse.quote(keyword)}")
        
    # Mapping configuration from json keys to widget names
    # Ensure they match the keys in search_elements.html
    filter_keys_map = {
        'topic_filter': 'Topic Filter',
        'location_filter': 'Location Filter',
        'type_filter': 'Type Filter',
        'language_filter': 'Language Filter',
        'date_filter': 'Search by Date'
    }
    
    for json_key, widget_name in filter_keys_map.items():
        if json_key in user_filters and widget_name in filters_mapping:
            choices = user_filters[json_key]
            if isinstance(choices, str):
                choices = [choices]
            
            for choice in choices:
                if choice in filters_mapping[widget_name]:
                    name = filters_mapping[widget_name][choice]['name']
                    val = filters_mapping[widget_name][choice]['value']
                    # encode array brackets and value
                    name_enc = urllib.parse.quote(name)
                    val_enc = urllib.parse.quote(val)
                    payload_data.append(f"{name_enc}={val_enc}")
                else:
                    logging.warning(f"Warning: Choice '{choice}' not found in {widget_name}")
                    
    # Constant parameters for Drupal Views AJAX
    constants = {
        'view_name': 'uw_f_document_search',
        'view_display_id': '__panel_pane__uw_f_document_search_grid',
        'view_args': '',
        'view_path': 'node/2250',
        'view_base_path': '',
        'view_dom_id': 'c43662ae74afe72857a62e362d6a7515',
        'pager_element': '0',
    }
    
    if page > 0:
        constants['page'] = str(page)
        
    for k, v in constants.items():
        # Using quote for safe encoding while maintaining compatibility
        payload_data.append(f"{urllib.parse.quote(k)}={urllib.parse.quote(v)}")
        
    return '&'.join(payload_data)

def extract_documents_from_html(html_str: str) -> List[Dict[str, Any]]:
    """Extracts document details (title, href, image, date, location) from the returned html."""
    soup = BeautifulSoup(html_str, 'html.parser')
    docs = []
    
    # Target li.views-row for structured extraction
    rows = soup.find_all('li', class_='views-row')
    for row in rows:
        title_div = row.find('div', class_='uw_f_document_search_title')
        title_tag = title_div.find('a') if title_div else None
        
        if not title_tag:
            continue
            
        href = title_tag.get('href', '')
        if href.startswith('/'):
            href = f"https://seea.un.org{href}"
            
        # Extract Image
        img_container = row.find('div', class_='views-field-node-field-basic-image-image-file-url')
        img_tag = img_container.find('img') if img_container else None
        img_url = img_tag.get('src') if img_tag else None
        
        # Extract Date
        date_container = row.find('div', class_='views-field-node-field-publication-date-value')
        date_tag = date_container.find('span', class_='field-content') if date_container else None
        date_val = date_tag.get_text(strip=True) if date_tag else None
        
        # Extract Location
        loc_container = row.find('div', class_='views-field-node-field-document-location')
        loc_tag = loc_container.find('span', class_='field-content') if loc_container else None
        loc_val = loc_tag.get_text(strip=True) if loc_tag else None
        
        docs.append({
            'title': title_tag.get_text(strip=True),
            'href': href,
            'image': img_url,
            'date': date_val,
            'location': loc_val
        })
            
    return docs

def apply_post_filters(docs: List[Dict[str, Any]], user_filters: Dict[str, Any]) -> List[Dict[str, Any]]:
    """Applies client-side filters to the extracted documents."""
    post_filters = user_filters.get('post_filters', {})
    if not post_filters:
        return docs
        
    year_start = post_filters.get('year_start')
    year_end = post_filters.get('year_end')
    
    filtered = []
    for doc in docs:
        keep = True
        
        # Year Filtering
        if year_start is not None or year_end is not None:
            doc_date = doc.get('date')
            try:
                doc_year = int(doc_date) if doc_date else None
                if doc_year:
                    if year_start is not None and doc_year < year_start:
                        keep = False
                    if year_end is not None and doc_year > year_end:
                        keep = False
            except (ValueError, TypeError):
                # If we can't parse the year, we skip year filtering for this doc
                pass
                
        # Generic String Filtering (e.g. location, title)
        for key, filter_val in post_filters.items():
            if key in ['year_start', 'year_end']:
                continue
            
            doc_val = doc.get(key)
            if doc_val is None:
                continue
                
            if isinstance(filter_val, str):
                if filter_val.lower() not in doc_val.lower():
                    keep = False
            elif isinstance(filter_val, list):
                if not any(v.lower() in doc_val.lower() for v in filter_val):
                    keep = False
        
        if keep:
            filtered.append(doc)
            
    return filtered

def scrape_documents(filters_mapping: Dict[str, Any], user_filters: Dict[str, Any], output_path: str):
    """Fetches paginated results from the SEEA Knowledge Base."""
    base_url = "https://seea.un.org/views/ajax"
    
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/115.0",
        "Accept": "application/json, text/javascript, */*; q=0.01",
        "Accept-Language": "en-US,en;q=0.9",
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "X-Requested-With": "XMLHttpRequest",
        "Origin": "https://seea.un.org",
        "Referer": "https://seea.un.org/content/knowledge-base"
    }

    all_documents = []
    page = 0
    
    with httpx.Client(headers=headers, timeout=30.0) as client:
        while True:
            logging.info(f"Fetching page {page}...")
            payload = build_payload(filters_mapping, user_filters, page)
            
            try:
                # content sends raw bytes or string, correct for application/x-www-form-urlencoded
                response = client.post(base_url, content=payload)
                response.raise_for_status()
                json_resp = response.json()
                
                html_data = None
                for command in json_resp:
                    if command.get('command') == 'insert' and command.get('method') == 'replaceWith':
                        # The view data is inside one of the replaceWith commands, usually containing our documents
                        if 'uw_f_document_search_title' in command.get('data', ''):
                            html_data = command.get('data')
                            break
                        # fallback
                        elif 'view-uw-f-document-search' in command.get('data', ''):
                            html_data = command.get('data')
                            
                if not html_data:
                    logging.info("No valid HTML data found in response. Ending pagination.")
                    break
                    
                docs = extract_documents_from_html(html_data)
                if not docs:
                    logging.info("No more documents found on this page. Ending pagination.")
                    break
                
                # Apply post-filters page by page or at the end? 
                # Doing it at the end allows cross-page deduplication first if needed,
                # but doing it here is more memory efficient.
                # However, deduplication is better at the end.
                all_documents.extend(docs)
                logging.info(f"Found {len(docs)} documents on page {page}.")
                
                # Detecting if there is a next page
                if 'pager-next' not in html_data and 'title="Go to next page"' not in html_data:
                    logging.info("Next page button not found. Reached the end.")
                    break
                    
                page += 1
                
            except httpx.HTTPStatusError as e:
                logging.error(f"HTTP error occurred: {e}")
                # We can choose to break or attempt retry...
                break
            except Exception as e:
                logging.error(f"An error occurred: {e}")
                break

    # Apply post-filtering
    filtered_docs = apply_post_filters(all_documents, user_filters)
    
    # Deduplicate while preserving order
    seen = set()
    unique_docs = []
    for d in filtered_docs:
        if d['href'] not in seen:
            seen.add(d['href'])
            unique_docs.append(d)

    # Save output to JSON file
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(unique_docs, f, indent=2, ensure_ascii=False)
    logging.info(f"Saved {len(unique_docs)} total documents to {output_path} (after post-filtering and deduplication).")

def main():
    parser = argparse.ArgumentParser(description="Scrape SEEA Knowledge Base Documents")
    parser.add_argument('--mapping', type=str, default='filter_mapping.json', 
                        help='Path to the JSON mapping file (e.g. filter_mapping.json)')
    parser.add_argument('--filters', type=str, default='filters.json', 
                        help='Path to the user selection JSON file (e.g. filters.json)')
    parser.add_argument('--output', type=str, default='output.json', 
                        help='Output file to state results context (e.g. output.json)')
    
    args = parser.parse_args()
    
    # 1. Load configuration mapping
    logging.info("Loading pre-generated search elements mapping...")
    try:
        with open(args.mapping, 'r', encoding='utf-8') as f:
            filters_mapping = json.load(f)
    except Exception as e:
        logging.error(f"Failed to load mapping. Did you run generate_mapping.py? {e}")
        return
        
    # 2. Load user filters
    logging.info(f"Loading user filters from {args.filters}...")
    try:
        with open(args.filters, 'r', encoding='utf-8') as f:
            if args.filters.endswith('.yaml') or args.filters.endswith('.yml'):
                import yaml
                user_filters = yaml.safe_load(f) or {}
            else:
                user_filters = json.load(f)
    except FileNotFoundError:
        logging.warning(f"{args.filters} not found. Using an empty filter (fetching everything).")
        user_filters = {}
        
    # 3. Scrape documents
    scrape_documents(filters_mapping, user_filters, args.output)

if __name__ == "__main__":
    main()
