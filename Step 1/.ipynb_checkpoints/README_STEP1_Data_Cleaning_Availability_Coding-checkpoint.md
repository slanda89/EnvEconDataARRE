# STEP 1: Data Cleaning and Availability Coding of Three Datasets

## Purpose

This step prepares and harmonizes three source datasets for the availability analysis. It cleans the United Nations Statistics Division (UNSD), World Bank (WB), and International Monetary Fund (IMF) datasets, combines them into one country-indicator availability file, identifies possible duplicated or overlapping indicators across sources, and applies human review decisions before producing the final cleaned availability dataset.

## Input Files

| No. | Input File | Description |
|---:|---|---|
| 1 | `UN_unenv_final.csv` | Input dataset from the United Nations Statistics Division or United Nations Environment data source. |
| 2 | `WB_final.csv` | Input dataset from the World Bank data source. |
| 3 | `IMF_final.csv` | Input dataset from the International Monetary Fund data source. |

## Workflow Overview

The workflow has three main stages:

1. Clean each source dataset separately.
2. Combine the three cleaned datasets into one harmonized dataset.
3. Filter potential replicated or overlapping indicators using automated screening and human review.

## 1. Data Cleaning

Each dataset is cleaned separately using a source-specific notebook. The purpose of this stage is to standardize variable names, country identifiers, indicator labels, year fields, and availability coding so that the three datasets can be combined consistently.

### 1.1 UNSD Data Cleaning

| No. | Item | Value |
|---:|---|---|
| 1 | Input file | `UN_unenv_final.csv` |
| 2 | Code file | `DataCleaning_UNSD.ipynb` |
| 3 | Main task | Clean and standardize the UNSD dataset for country-indicator availability coding. |

### 1.2 World Bank Data Cleaning

| No. | Item | Value |
|---:|---|---|
| 1 | Input file | `WB_final.csv` |
| 2 | Code file | `DataCleaning_WB.ipynb` |
| 3 | Main task | Clean and standardize the World Bank dataset for country-indicator availability coding. |

### 1.3 IMF Data Cleaning

| No. | Item | Value |
|---:|---|---|
| 1 | Input file | `IMF_final.csv` |
| 2 | Code file | `DataCleaning_IMF.ipynb` |
| 3 | Main task | Clean and standardize the IMF dataset for country-indicator availability coding. |

## 2. Combining the Three Datasets

After the three datasets are cleaned, they are combined into a single harmonized file.

| No. | Item | Value |
|---:|---|---|
| 1 | Code file | `CombiningData.ipynb` |
| 2 | Main task | Combine the cleaned UNSD, World Bank, and IMF datasets into one dataset. |
| 3 | Expected result | A harmonized country-indicator availability dataset before final filtering. |

This stage ensures that the three sources use a consistent structure for country, indicator, source, year, and availability fields.

## 3. Filtering

The filtering stage identifies potential indicator replication and cross-source overlap, then applies human review to decide which indicators should be retained or excluded.

| No. | Item | Value |
|---:|---|---|
| 1 | Code file | `Filtering.ipynb` |
| 2 | Main task | Identify, review, and filter potential duplicated or overlapping indicators across the three sources. |

### 3.1 Method for Identifying Potential Indicator Replication and Cross-Source Overlap

The first filtering task uses automated screening to identify possible overlap across indicators from different sources. The screening flags indicators that may measure the same or very similar concepts across UNSD, World Bank, and IMF datasets.

| No. | Item | Value |
|---:|---|---|
| 1 | Code file | `Filtering.ipynb` |
| 2 | Output file | `cross_source_overlap_candidates_recreated.csv` |
| 3 | Purpose | Create a list of potential cross-source indicator overlap candidates for human review. |

### 3.2 Human Review and Exclusion Decision

The automated overlap file is then reviewed manually. The human reviewer decides whether each flagged indicator pair or group represents a true duplication, a partial overlap, or a distinct indicator that should be retained.

| No. | Item | Value |
|---:|---|---|
| 1 | Review input file | `cross_source_overlap_candidates_recreated.csv` |
| 2 | Human review output file | `cross_source_overlap_candidates_evaluated.csv` |
| 3 | Main task | Add human review decisions on whether potential replicated or overlapping indicators should be excluded or retained. |

The file `cross_source_overlap_candidates_evaluated.csv` should contain the human review decision fields needed by the filtering script. These fields document the reviewer’s decision and provide a transparent record of why indicators were retained or excluded.

## Final Output from Step 1

| No. | Output File | Description |
|---:|---|---|
| 1 | `combined_country_availability_final.csv` | Final cleaned and filtered country-indicator availability dataset from UNSD, World Bank, and IMF sources. |

## Expected File Flow

```text
UN_unenv_final.csv
        │
        └── DataCleaning_UNSD.ipynb

WB_final.csv
        │
        └── DataCleaning_WB.ipynb

IMF_final.csv
        │
        └── DataCleaning_IMF.ipynb

Cleaned source datasets
        │
        └── CombiningData.ipynb
                │
                └── Combined availability dataset before filtering
                        │
                        └── Filtering.ipynb
                                │
                                ├── cross_source_overlap_candidates_recreated.csv
                                │       │
                                │       └── Human review
                                │               │
                                │               └── cross_source_overlap_candidates_evaluated.csv
                                │
                                └── combined_country_availability_final.csv
```

## Notes for Reproducibility

- Run the notebooks in the order listed above.
- Keep the original input files unchanged.
- Use `cross_source_overlap_candidates_recreated.csv` as the basis for human review.
- Save the reviewed file as `cross_source_overlap_candidates_evaluated.csv` before running the final filtering step.
- The final dataset for Step 1 is `combined_country_availability_final.csv`.
- Any changes to the cleaning logic, overlap screening rule, or human exclusion decision should be documented before rerunning the final filtering script.
