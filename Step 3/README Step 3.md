# SEEA Knowledge Base Scraper

This project contains scripts to scrape documents from the SEEA Knowledge Base, apply user-defined filters, and download the resulting documents and their associated assets.

## Architecture / Flow

![Scraper Flowchart](flowchart.png)

## Files

- `scraper.py`: Fetches paginated results from the SEEA Knowledge Base based on defined filters and outputs them to `output.json`.
- `downloader.py`: Reads `output.json` and downloads the documents, HTML pages, and external links into organized folders under `outputs/`.
  <!-- - `generate_mapping.py`: Parses `search_elements.html` to generate `filter_mapping.json`, which the scraper uses to build request payloads. -->
  <!-- - `generate_yaml_template.py`: Creates a YAML template (`filters.template.yaml`) for users to define their search filters. -->

## Usage Instructions

### 1. Setup Environment

Ensure you have the dependencies installed:

```bash
pip install -r requirements.txt
playwright install chromium
```

<!-- ### 2. Generate Filter Mapping (Optional) -->

<!-- If the structure of the SEEA search page has changed, update `search_elements.html` and re-generate the filter mapping: -->

<!-- ```bash
python generate_mapping.py --input search_elements.html --output filter_mapping.json
``` -->

### 2. Create User Filters

Copy the template to create your own filters configuration:

```bash
cp filters.template.yaml filters.yaml
```

Edit `filters.yaml` to specify your search criteria (e.g., keywords, topics, locations, post-filters for years).

### 3. Run the Scraper

Run the scraper script to fetch metadata and links for matching documents:

```bash
python scraper.py --mapping filter_mapping.json --filters filters.yaml --output output.json
```

This will generate an `output.json` file containing a list of unique documents.

### 4. Download Documents

Run the downloader to download the documents referenced in `output.json`:

```bash
python downloader.py
```

This will create an `outputs/` directory and save the files, HTML pages, and external links there. It also maintains a `download_log.json` to track progress and allow resuming.
