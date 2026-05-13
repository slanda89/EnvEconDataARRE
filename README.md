# README: SEEA Data Availability and Account Accessibility Workflow

This README documents the workflow used to clean, classify, map, and visualize environmental-economic indicators and System of Environmental-Economic Accounting (SEEA) account accessibility data.

## Workflow Steps

1. [Step 1: Data Cleaning and Availability Coding of Three Datasets](#step-1-data-cleaning-and-availability-coding-of-three-datasets)
2. [Step 2: Indicator Classification and Figure Preparation](#step-2-indicator-classification-and-figure-preparation)
3. [Step 3: SEEA Account Accessibility Assessment](#step-3-seea-account-accessibility-assessment)
4. [Step 4: SEEA Account Grouping and Sankey Input Preparation](#step-4-seea-account-grouping-and-sankey-input-preparation)
5. [Step 5: SEEA Data Categorization and Visualization](#step-5-seea-data-categorization-and-visualization)
6. [Appendix III: Income-Group Coverage Figure](#appendix-iii-income-group-coverage-figure)


## STEP 1: Data Cleaning and Availability Coding of Three Datasets

### Purpose

This step prepares and harmonizes three source datasets for the availability analysis. It cleans the United Nations Statistics Division (UNSD), World Bank (WB), and International Monetary Fund (IMF) datasets, combines them into one country-indicator availability file, identifies possible duplicated or overlapping indicators across sources, and applies human review decisions before producing the final cleaned availability dataset.

### Input Files

| No. | Input File | Description |
|---:|---|---|
| 1 | `UN_unenv_final.csv` | Input dataset from the United Nations Statistics Division or United Nations Environment data source. |
| 2 | `WB_final.csv` | Input dataset from the World Bank data source. |
| 3 | `IMF_final.csv` | Input dataset from the International Monetary Fund data source. |

### Workflow Overview

The workflow has three main stages:

1. Clean each source dataset and code data availability separately.
2. Combine the three cleaned datasets into one harmonized dataset.
3. Filter potential duplicated or overlapping indicators using automated screening and human review.

### 1. Data Cleaning

Each dataset is cleaned separately using a source-specific notebook. The purpose of this stage is to standardize variable names, country identifiers, indicator labels, year fields, and availability coding so that the three datasets can be combined consistently.

#### 1.1 UNSD Data Cleaning

| No. | Item | Value |
|---:|---|---|
| 1 | Input file | `UN_unenv_final.csv` |
| 2 | Code file | `DataCleaning_UNSD.ipynb` |
| 3 | Main task | Clean and standardize the UNSD dataset for country-indicator availability coding. |

#### 1.2 World Bank Data Cleaning

| No. | Item | Value |
|---:|---|---|
| 1 | Input file | `WB_final.csv` |
| 2 | Code file | `DataCleaning_WB.ipynb` |
| 3 | Main task | Clean and standardize the World Bank dataset for country-indicator availability coding. |

#### 1.3 IMF Data Cleaning

| No. | Item | Value |
|---:|---|---|
| 1 | Input file | `IMF_final.csv` |
| 2 | Code file | `DataCleaning_IMF.ipynb` |
| 3 | Main task | Clean and standardize the IMF dataset for country-indicator availability coding. |

### 2. Combining the Three Datasets

After the three datasets are cleaned, they are combined into a single harmonized file.

| No. | Item | Value |
|---:|---|---|
| 1 | Code file | `CombiningData.ipynb` |
| 2 | Main task | Combine the cleaned UNSD, World Bank, and IMF datasets into one dataset. |
| 3 | Expected result | A harmonized country-indicator availability dataset before final filtering. |

This stage ensures that the three sources use a consistent structure for country, indicator, source, year, and availability fields.

### 3. Filtering

The filtering stage identifies potential indicator replication and cross-source overlap, then applies human review to decide which indicators should be retained or excluded.

| No. | Item | Value |
|---:|---|---|
| 1 | Code file | `Filtering.ipynb` |
| 2 | Main task | Identify, review, and filter potential duplicated or overlapping indicators across the three sources. |

#### 3.1 Method for Identifying Potential Indicator Replication and Cross-Source Overlap

The first filtering task uses automated screening to identify possible overlap across indicators from different sources. The screening flags indicators that may measure the same or very similar concepts across UNSD, World Bank, and IMF datasets.

| No. | Item | Value |
|---:|---|---|
| 1 | Code file | `Filtering.ipynb` |
| 2 | Output file | `cross_source_overlap_candidates_recreated.csv` |
| 3 | Purpose | Create a list of potential cross-source indicator overlap candidates for human review. |

#### 3.2 Human Review and Exclusion Decision

The automated overlap file is then reviewed manually. The human reviewer decides whether each flagged indicator pair or group represents a true duplication, a partial overlap, or a distinct indicator that should be retained.

| No. | Item | Value |
|---:|---|---|
| 1 | Review input file | `cross_source_overlap_candidates_recreated.csv` |
| 2 | Human review output file | `cross_source_overlap_candidates_evaluated.csv` |
| 3 | Main task | Add human review decisions on whether potential duplicated or overlapping indicators should be excluded or retained. |

The file `cross_source_overlap_candidates_evaluated.csv` should contain the human review decision fields needed by the filtering script. These fields document the reviewer’s decision and provide a transparent record of why indicators were retained or excluded.

### Final Output from Step 1

| No. | Output File | Description |
|---:|---|---|
| 1 | `combined_country_availability_final.csv` | Final cleaned and filtered country-indicator availability dataset from UNSD, World Bank, and IMF sources. |

### Expected File Flow

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
                                        │
                                        └── Human review
                                                │
                                                └── cross_source_overlap_candidates_evaluated.csv
                                                         │
                                                         └── combined_country_availability_final.csv
                                    
                                 
```

### Notes for Reproducibility

- Run the notebooks in the order listed above.
- Keep the original input files unchanged.
- Use `cross_source_overlap_candidates_recreated.csv` as the basis for human review.
- Save the reviewed file as `cross_source_overlap_candidates_evaluated.csv` before running the final filtering step.
- The final dataset for Step 1 is `combined_country_availability_final.csv`.
- Any changes to the cleaning logic, overlap screening rule, or human exclusion decision should be documented before rerunning the final filtering script.


## STEP 2: Indicator Classification and Figure Preparation

### Purpose

This step classifies each indicator into the study’s indicator coding framework and prepares the validated coding results for later figure development. The classification process combines large language model (LLM)-assisted coding, human validation, and post-validation preparation of indicator-level coding files.

The main purpose of this step is to identify whether each indicator belongs to one of four main categories: Stock, Flow, Action, or Policy Guide. For Stock and Flow indicators, the workflow also identifies the relevant accounting boundary flags: Household Produced Services (HPS), Depreciation or Degradation Process (DDP), Market Services and Near-Market Services (MS-NMS), and Avoided Defensive Expenditure (ADE).

This step also prepares filtered files for System of Environmental-Economic Accounting (SEEA) mapping and monetary-value analysis.

---

### Input Files

| No. | Input File | Description |
|---:|---|---|
| 1 | `combined_country_availability_final.csv` | Final cleaned country-indicator availability dataset from Step 1. |
| 2 | `LLM_indicator_coding_workflow.xlsx` | Excel workflow file used for LLM-assisted indicator classification. |
| 3 | `LLM_indicator_coding_workflow - Human Validation_MC.xlsx` | Human validation workbook used to review and correct the LLM classification. |

---

### Code Files

| No. | Code File | Description |
|---:|---|---|
| 1 | `A_categorization.ipynb` | Notebook used to conduct LLM-assisted classification of indicators. |
| 2 | `B_file_figure_preparation.ipynb` | Notebook used to prepare human-validated coding files for later figure development. |

---

### Workflow Overview

The workflow has four main stages:

1. Run LLM-assisted indicator classification.
2. Conduct human validation of the LLM output.
3. Merge the human-validated coding with the country-level availability dataset.
4. Prepare filtered files for SEEA mapping and monetary-value analysis.

---

### 2.1 LLM-Assisted Indicator Categorization

#### Purpose

This stage generates the initial classification for each indicator using the indicator coding framework. The LLM assigns a primary category, boundary flags, confidence score, reasoning summary, and review priority for each indicator.

#### Input Workbook

| No. | Sheet | Description |
|---:|---|---|
| 1 | `Step1_Input_Indicators` | Input indicator list to be classified. |
| 2 | `Step2_Codebook` | Coding framework used to classify indicators. |
| 3 | `Step3_Examples_Gold_Set` | Reviewed example indicators used as reference examples for the LLM. |

#### Code File

| No. | Code File | Description |
|---:|---|---|
| 1 | `A_categorization.ipynb` | Runs the LLM-assisted indicator categorization workflow. |

#### Main Process

1. Load the input workbook:  
   `LLM_indicator_coding_workflow.xlsx`

2. Read the following sheets:
   - `Step1_Input_Indicators`
   - `Step2_Codebook`
   - `Step3_Examples_Gold_Set`

3. Check and standardize the required input columns.

4. Convert the codebook and reviewed examples into prompt text.

5. Run LLM-assisted classification for each indicator.

6. Add quality-check notes to flag possible classification issues.

7. Reorder the output columns.

8. Create or replace the output sheet:  
   `Step4_LLM_Output`

#### Input Columns Used for LLM Classification

| No. | Column | Description |
|---:|---|---|
| 1 | `no` | Indicator number or unique row identifier. |
| 2 | `indicator` | Indicator name. |
| 3 | `Definition` | Indicator definition, where available. |
| 4 | `unit` | Unit of measurement. |
| 5 | `source` | Source database or source institution. |
| 6 | `original` | Original indicator name or source-specific label. |
| 7 | `dataset` | Dataset origin, such as UNSD, World Bank, or IMF. |

#### LLM Output Columns

| No. | Column | Description |
|---:|---|---|
| 1 | `llm_primary_category` | Short code for the assigned category. |
| 2 | `llm_primary_category_label` | Full label for the assigned category. |
| 3 | `llm_boundary_flags` | Boundary flags assigned to the indicator, where applicable. |
| 4 | `llm_confidence` | LLM confidence level for the classification. |
| 5 | `llm_reasoning_summary` | Short explanation of why the category and boundary flags were assigned. |
| 6 | `llm_human_review_needed` | Indicates whether the indicator requires human review. |
| 7 | `quality_check_note` | Notes on possible coding issues or ambiguity. |
| 8 | `review_priority` | Priority level for human review. |
| 9 | `llm_error` | Error message if the LLM classification failed. |

#### Output from This Stage

| No. | Output | Description |
|---:|---|---|
| 1 | `LLM_indicator_coding_workflow.xlsx`, sheet `Step4_LLM_Output` | Initial LLM-assisted indicator classification output. |

---

### 2.2 Human Validation of LLM Classification

#### Purpose

This stage reviews, validates, and corrects the LLM-assisted classification. Human validation ensures that the final indicator classification is consistent with the codebook and suitable for analysis.

#### Input File

| No. | Input File | Description |
|---:|---|---|
| 1 | `LLM_indicator_coding_workflow.xlsx`, sheet `Step4_LLM_Output` | LLM-generated classification output used as the starting point for review. |

#### Human Validation File

| No. | Output File | Description |
|---:|---|---|
| 1 | `LLM_indicator_coding_workflow - Human Validation_MC.xlsx` | Workbook used to store the reviewed and corrected indicator classification. |

#### Main Process

1. Use the LLM-generated output from:  
   `Step4_LLM_Output`

2. Create or update the human validation sheet:  
   `Step5_Human_Validation`

3. Review the LLM-generated classification fields, including:
   - primary category;
   - category label;
   - boundary flags;
   - confidence score;
   - reasoning summary;
   - human review flag;
   - quality-check note;
   - review priority; and
   - LLM error field.

4. Correct the classification where the reviewer determines that the LLM output does not follow the codebook.

5. Use the human-validated classification as the authoritative coding file for figure preparation.

#### Output from This Stage

| No. | Output | Description |
|---:|---|---|
| 1 | `LLM_indicator_coding_workflow - Human Validation_MC.xlsx`, sheet `Step5_Human_Validation` | Human-reviewed indicator classification file. |

---

### 2.3 Prepare Human-Validated Indicator Coding File

#### Purpose

This stage converts the human-validated classification into a clean indicator coding file that can be merged with the country-level availability dataset.

#### Code File

| No. | Code File | Description |
|---:|---|---|
| 1 | `B_file_figure_preparation.ipynb` | Prepares the validated indicator coding file for later analysis and figure development. |

#### Input Files

| No. | Input File | Description |
|---:|---|---|
| 1 | `combined_country_availability_final.csv` | Country-indicator availability dataset from Step 1. |
| 2 | `LLM_indicator_coding_workflow - Human Validation_MC.xlsx`, sheet `Step5_Human_Validation` | Human-validated indicator classification. |

#### Main Process

1. Load the country-level availability file:  
   `combined_country_availability_final.csv`

2. Load the human validation sheet:  
   `Step5_Human_Validation`

3. Clean and standardize the human coding fields.

4. Convert human validation entries into binary indicator coding columns.

5. Create the following category columns:
   - `Stock`
   - `Flow`
   - `Policy_Guide`
   - `Action`

6. Create the following boundary columns:
   - `HPS`
   - `DDP`
   - `MS-NMS`
   - `ADE`

7. Save the cleaned indicator coding file.

#### Output from This Stage

| No. | Output File | Description |
|---:|---|---|
| 1 | `indicator_coding.xlsx` | Clean human-validated indicator coding file. |
| 2 | `combined_country_availability_final_with_indicator_coding.csv` | Country-level availability dataset merged with human-validated indicator coding. |
| 3 | `combined_country_availability_final_with_indicator_coding.xlsx` | Excel version of the merged country-level availability and indicator coding file. |

---

### 2.4 Filter Indicators for SEEA Mapping

#### Purpose

This stage prepares the indicator list for System of Environmental-Economic Accounting (SEEA) mapping. Action and Policy Guide indicators are excluded because they are not directly used in the SEEA account completion process. The filtered file retains only Stock and Flow indicators.

#### Input File

| No. | Input File | Description |
|---:|---|---|
| 1 | `indicator_coding.xlsx` | Human-validated indicator coding file. |

#### Main Process

1. Load `indicator_coding.xlsx`.

2. Filter out rows where:
   - `Policy_Guide == 1`, or
   - `Action == 1`

3. Retain only indicators that are classified as Stock or Flow.

4. Save the filtered file for SEEA mapping.

#### Output from This Stage

| No. | Output File | Description |
|---:|---|---|
| 1 | `indicator_coding_filtered_no_policy_action.xlsx` | Filtered indicator coding file that excludes Action and Policy Guide indicators. |

---

### 2.5 Identify Monetary-Value Indicators

#### Purpose

This stage identifies indicators with monetary units. These indicators are used for additional analysis of monetary-value indicators in the availability dataset.

#### Input File

| No. | Input File | Description |
|---:|---|---|
| 1 | `combined_country_availability_final_with_indicator_coding.csv` | Country-level availability dataset merged with human-validated coding. |

#### Main Process

1. Load the merged country-level availability and indicator coding file.

2. Detect monetary-value indicators using keywords in the unit field.

3. Identify units related to currencies, including United States dollars, local currency units, purchasing power parity, euros, pounds, yen, yuan, rupiah, and other monetary units.

4. Save the monetary-only dataset.

5. Summarize monetary-value indicators by dataset and coding category.

#### Output from This Stage

| No. | Output File | Description |
|---:|---|---|
| 1 | `combined_country_availability_monetary_only.csv` | Monetary-value indicators only. |
| 2 | `combined_country_availability_monetary_only.xlsx` | Excel version of the monetary-value indicator dataset. |
| 3 | `monetary_only_summary_by_dataset.csv` | Summary of monetary-value indicators by dataset. |
| 4 | `monetary_only_summary_by_dataset.xlsx` | Excel version of the monetary-value summary. |

---

### Final Outputs from Step 2

| No. | Final Output | Description |
|---:|---|---|
| 1 | `LLM_indicator_coding_workflow.xlsx`, sheet `Step4_LLM_Output` | Initial LLM-assisted indicator classification. |
| 2 | `LLM_indicator_coding_workflow - Human Validation_MC.xlsx`, sheet `Step5_Human_Validation` | Human-reviewed indicator classification. |
| 3 | `indicator_coding.xlsx` | Clean binary indicator coding file based on human validation. |
| 4 | `combined_country_availability_final_with_indicator_coding.csv` | Country-level availability dataset merged with validated indicator coding. |
| 5 | `combined_country_availability_final_with_indicator_coding.xlsx` | Excel version of the merged availability and coding dataset. |
| 6 | `indicator_coding_filtered_no_policy_action.xlsx` | Stock and Flow indicators retained for SEEA mapping. |
| 7 | `combined_country_availability_monetary_only.csv` | Monetary-value indicators only. |
| 8 | `combined_country_availability_monetary_only.xlsx` | Excel version of the monetary-value indicators. |
| 9 | `monetary_only_summary_by_dataset.csv` | Summary of monetary-value indicators by dataset. |
| 10 | `monetary_only_summary_by_dataset.xlsx` | Excel version of the monetary-value summary. |

---

### Notes

- The LLM output is not treated as final. It is used only as the first classification draft.
- The human-validated sheet `Step5_Human_Validation` is the authoritative source for the final coding.
- SEEA mapping excludes Action and Policy Guide indicators because those indicators are not directly related to SEEA account completion.
- Monetary-value filtering is based on unit keywords and should be reviewed if new currency terms are added to the dataset.


## STEP 3: SEEA Account Accessibility Assessment

### Purpose

This step assesses the accessibility of System of Environmental-Economic Accounting (SEEA) accounts from downloaded official files. The workflow uses a conservative keyword-based text-mining approach to identify whether each country has accessible evidence for SEEA account availability.

The assessment uses two main sources of downloaded files:

1. files linked from the SEEA 2024 Global Assessment; and
2. files downloaded from the SEEA Knowledge Base.

The workflow then combines both sources into one country-level SEEA account accessibility dataset.

This step should be interpreted as an accessibility assessment, not as a definitive assessment of whether a country has formally compiled or reported each SEEA account. The method identifies whether evidence of account availability can be found in accessible downloaded files.

---

### Input Files

| No. | Input File | Description |
|---:|---|---|
| 1 | `global_assessment_for_website_2024_final.xlsx` | Official 2024 SEEA Global Assessment Excel file downloaded from the SEEA website. |
| 2 | `seea_keyword_config.json` | Country-language-aware keyword configuration used for SEEA account screening. |
| 3 | `Combination.xlsx` | Input file used by the crawler to support country website downloading and manual validation tracking. |
| 4 | `worldbank_classification.csv` | World Bank country classification file used to add region and income group information.We further divide Europe and Central Asia into two subgroups: Eurostat plus the United Kingdom, and non-Eurostat Europe and Central Asia. |
| 5 | `outputs_SEEAKB/` | Folder containing files downloaded from the SEEA Knowledge Base. |
| 6 | `seea_file/` | Folder containing files downloaded from links in the SEEA 2024 Global Assessment. |

---

### Code Files

| No. | Code File | Description |
|---:|---|---|
| 1 | `A_download_2024SEEA.ipynb` | Downloads the official 2024 SEEA Global Assessment Excel file. |
| 2 | `B_validate_seea_keyword_config.ipynb` | Validates the SEEA keyword configuration and checks language/topic coverage. |
| 3 | `C_seea_download_with_json_config.ipynb` | Crawls country websites and downloads files using the JSON keyword configuration. |
| 4 | `D_run_accessibility_SEEAKB.ipynb` | Runs the accessibility assessment for files downloaded from the SEEA Knowledge Base. |
| 5 | `E_run_seea_assessment2024links.ipynb` | Runs the accessibility assessment for files downloaded from SEEA 2024 Global Assessment links. |
| 6 | `F_combine_accessibility_seea.ipynb` | Combines accessibility results from both downloaded-file sources. |

---

### Workflow Overview

The workflow has six main stages:

1. Download the SEEA 2024 Global Assessment Excel file.
2. Validate the SEEA keyword configuration.
3. Download country-level files using the keyword configuration.
4. Assess accessibility from SEEA Knowledge Base files.
5. Assess accessibility from SEEA 2024 Global Assessment linked files.
6. Combine both accessibility assessments into one final dataset.

---

### 3.1 Download the 2024 SEEA Global Assessment File

#### Purpose

This stage downloads the official 2024 SEEA Global Assessment Excel file from the SEEA website. The website link opens the file through the Microsoft Office online viewer, so the code first extracts the real Excel download link from the viewer URL.

#### Code File

| No. | Code File | Description |
|---:|---|---|
| 1 | `A_download_2024SEEA.ipynb` | Downloads the 2024 SEEA Global Assessment Excel file and checks available worksheet names. |

#### Main Process

1. Open the SEEA 2024 Global Assessment link.
2. Extract the real Excel file URL from the Microsoft Office online viewer link.
3. Download the Excel file.
4. Save the file locally.
5. Check the available worksheet names to confirm the correct sheet for later analysis.

#### Output from This Stage

| No. | Output File | Description |
|---:|---|---|
| 1 | `global_assessment_for_website_2024_final.xlsx` | Downloaded 2024 SEEA Global Assessment workbook. |

---

### 3.2 Create and Validate the SEEA Keyword Configuration

#### Purpose

This stage validates the keyword configuration used to identify possible evidence of SEEA account availability in downloaded official files. The configuration is designed as a conservative dictionary-based text-mining instrument.

The keyword logic is conservative because a valid generated keyword should combine:

1. an account or accounting term; and
2. a SEEA account topic term.

Topic-only words, such as `water`, `energy`, `forest`, `land`, `carbon`, `ocean`, `species`, `taxes`, or `subsidies`, should not be treated as sufficient evidence of account availability when they appear alone.

#### Code File

| No. | Code File | Description |
|---:|---|---|
| 1 | `B_validate_seea_keyword_config.ipynb` | Validates language and topic coverage in the SEEA keyword configuration. |

#### Input File

| No. | Input File | Description |
|---:|---|---|
| 1 | `seea_keyword_config.json` | JSON configuration containing country-language mapping, account words, and topic translations. |

#### JSON Configuration Structure

| No. | Field | Description |
|---:|---|---|
| 1 | `metadata` | Describes the purpose, matching principle, validation recommendation, and research-use limitations. |
| 2 | `country_languages` | Maps each country to English and the main official or commonly used statistical-publication languages. |
| 3 | `account_words_by_language` | Lists account or accounting terms by language. |
| 4 | `topic_translations` | Lists SEEA account topic terms by language. |

#### Main Process

1. Load `seea_keyword_config.json`.

2. Check country-language coverage.

3. Check whether account words are available for each language.

4. Check topic translation coverage.

5. Produce a coverage table to identify languages or topics requiring additional manual review.

6. Save the validation output.

#### Output from This Stage

| No. | Output File | Description |
|---:|---|---|
| 1 | `seea_keyword_config_coverage.csv` | Coverage file showing language and topic coverage in the keyword configuration. |

#### Manual Review Note

The coverage file should be used to identify languages with lower topic-translation coverage. Manual review is especially important for high-impact findings, non-English matches, and cases where availability is inferred from downloaded files rather than from official reporting tables.

---

### 3.3 Download Country-Level Files Using the Keyword Configuration

#### Purpose

This stage crawls official country website links listed in the SEEA 2024 Global Assessment workbook and downloads files that may contain SEEA account evidence. The crawler uses the country-language-aware keyword configuration to avoid downloading irrelevant files.

#### Code File

| No. | Code File | Description |
|---:|---|---|
| 1 | `C_seea_download_with_json_config.ipynb` | Crawls official country websites and downloads files using the JSON keyword configuration. |

#### Input Files

| No. | Input File | Description |
|---:|---|---|
| 1 | `global_assessment_for_website_2024_final.xlsx` | Source workbook containing country information and website links. |
| 2 | `seea_keyword_config.json` | Keyword configuration used for country-language-aware matching. |
| 3 | `Combination.xlsx` | Additional input file used for validation and tracking. |

#### Main Process

1. Read the 2024 SEEA Global Assessment workbook.

2. Use the sheet:  
   `2024 Global Assessment results`

3. Create one folder per country inside:  
   `seea_file/`

4. Read the official website hyperlinks from the workbook.

5. Crawl each country website.

6. Generate country-specific keywords from:
   - country-language mapping;
   - account/accounting terms; and
   - SEEA account topic terms.

7. Download only files whose URL, link text, filename, or nearby webpage text matches conservative SEEA account keywords.

8. Save a download log.

#### Matching Rule

A downloaded file must match either:

1. an exact SEEA account phrase; or
2. a generated phrase that combines an account/accounting term with a SEEA topic phrase.

Topic-only matches are used only to help crawl webpages. They should not be treated as final evidence of account availability.

#### Output from This Stage

| No. | Output | Description |
|---:|---|---|
| 1 | `seea_file/` | Folder containing downloaded files organized by country. |
| 2 | `seea_file_download_log.csv` | Log file documenting downloaded files, skipped files, and file-read or download issues. |
| 3 | `manual_validation_summary.xlsx` | Workbook supporting manual validation and review of download results. |

---

### 3.4 Assess Accessibility from SEEA Knowledge Base Files

#### Purpose

This stage assesses SEEA account accessibility using files downloaded from the SEEA Knowledge Base. The workflow searches downloaded files for account-specific keyword evidence and converts the results into country-account accessibility matrices.

#### Code File

| No. | Code File | Description |
|---:|---|---|
| 1 | `D_run_accessibility_SEEAKB.ipynb` | Runs accessibility screening for files downloaded from the SEEA Knowledge Base. |

#### Input Files and Folder

| No. | Input | Description |
|---:|---|---|
| 1 | `global_assessment_for_website_2024_final.xlsx` | Source workbook used to define countries and SEEA accounts. |
| 2 | `seea_keyword_config.json` | Keyword configuration used for accessibility screening. |
| 3 | `outputs_SEEAKB/` | Folder containing files downloaded from the SEEA Knowledge Base. |

#### Main Process

1. Load the SEEA 2024 Global Assessment workbook.

2. Load the country-language-aware keyword configuration.

3. Read downloaded files from:  
   `outputs_SEEAKB/`

4. Search each file for SEEA account keyword evidence.

5. Create a wide country-account matrix.

6. Create a long-format country-account accessibility file.

7. Save the Excel and CSV outputs.

#### Output from This Stage

| No. | Output File | Description |
|---:|---|---|
| 1 | `availability_SEEAKB.xlsx` | Excel output containing the SEEA Knowledge Base accessibility matrix and related sheets. |
| 2 | `availability_SEEAKB.csv` | Wide CSV version of the SEEA Knowledge Base accessibility matrix. |
| 3 | `availability_SEEAKB_long.csv` | Long-format CSV version of the SEEA Knowledge Base accessibility results. |
| 4 | `availability_SEEAKB_updated.xlsx` | Fallback Excel output if the primary output file is open or cannot be overwritten. |

---

### 3.5 Assess Accessibility from SEEA 2024 Global Assessment Linked Files

#### Purpose

This stage assesses SEEA account accessibility using files downloaded from website links in the SEEA 2024 Global Assessment workbook. This stage uses the same keyword configuration and screening logic as the SEEA Knowledge Base assessment, but it applies the method to files saved in the country-specific `seea_file/` folders.

#### Code File

| No. | Code File | Description |
|---:|---|---|
| 1 | `E_run_seea_assessment2024links.ipynb` | Runs accessibility screening for files downloaded from SEEA 2024 Global Assessment links. |

#### Input Files and Folder

| No. | Input | Description |
|---:|---|---|
| 1 | `global_assessment_for_website_2024_final.xlsx` | Source workbook used to define countries and SEEA accounts. |
| 2 | `seea_keyword_config.json` | Keyword configuration used for accessibility screening. |
| 3 | `seea_file/` | Folder containing downloaded files from SEEA 2024 Global Assessment country links. |

#### Main Process

1. Load the SEEA 2024 Global Assessment workbook.

2. Load the country-language-aware keyword configuration.

3. Read files from each country folder in:  
   `seea_file/`

4. Extract readable text from supported file types.

5. Search the extracted text for conservative SEEA account keyword evidence.

6. Create a wide country-account matrix.

7. Create a long-format country-account accessibility file.

8. Save Excel and CSV outputs.

#### Output from This Stage

| No. | Output File | Description |
|---:|---|---|
| 1 | `seea_account_availability_assessment.xlsx` | Excel output containing the accessibility matrix and supporting evidence sheets. |
| 2 | `seea_account_availability_assessment.csv` | Wide CSV version of the accessibility matrix. |
| 3 | `seea_account_availability_assessment_long.csv` | Long-format CSV version of the country-account accessibility results. |

---

### 3.6 Combine SEEA Accessibility Results

#### Purpose

This stage combines the two accessibility assessments into one final country-level SEEA account accessibility dataset. The combined file uses evidence from both the SEEA Knowledge Base files and the SEEA 2024 Global Assessment linked files.

#### Code File

| No. | Code File | Description |
|---:|---|---|
| 1 | `F_combine_accessibility_seea.ipynb` | Combines the two accessibility matrices and adds region and income classification. |

#### Input Files

| No. | Input File | Description |
|---:|---|---|
| 1 | `seea_account_availability_assessment.xlsx` | Accessibility output from SEEA 2024 Global Assessment linked files. |
| 2 | `availability_SEEAKB.xlsx` | Accessibility output from SEEA Knowledge Base files. |
| 3 | `worldbank_classification.csv` | Country classification file used to add region and income group. |

#### Main Process

1. Load the accessibility matrix from:  
   `seea_account_availability_assessment.xlsx`

2. Load the accessibility matrix from:  
   `availability_SEEAKB.xlsx`

3. Standardize country names and account columns.

4. Combine the two matrices.

5. Mark an account as accessible if evidence is found in either source.

6. Add World Bank region and income classifications.

7. Save the combined output as Excel and CSV files.

#### Output from This Stage

| No. | Output File | Description |
|---:|---|---|
| 1 | `combined_availability_seea.xlsx` | Final combined SEEA account accessibility dataset. |
| 2 | `combined_availability_seea.csv` | CSV version of the final combined SEEA account accessibility dataset. |

---

### Final Outputs from Step 3

| No. | Final Output | Description |
|---:|---|---|
| 1 | `global_assessment_for_website_2024_final.xlsx` | Official 2024 SEEA Global Assessment workbook downloaded from the SEEA website. |
| 2 | `seea_keyword_config_coverage.csv` | Keyword configuration coverage validation file. |
| 3 | `seea_file/` | Country-level folder containing files downloaded from SEEA 2024 Global Assessment links. |
| 4 | `seea_file_download_log.csv` | Download log for the country-level file crawler. |
| 5 | `manual_validation_summary.xlsx` | Manual validation summary for downloaded country files. |
| 6 | `availability_SEEAKB.xlsx` | Accessibility assessment output from SEEA Knowledge Base files. |
| 7 | `availability_SEEAKB.csv` | Wide CSV output from SEEA Knowledge Base files. |
| 8 | `availability_SEEAKB_long.csv` | Long-format CSV output from SEEA Knowledge Base files. |
| 9 | `seea_account_availability_assessment.xlsx` | Accessibility assessment output from SEEA 2024 Global Assessment linked files. |
| 10 | `seea_account_availability_assessment.csv` | Wide CSV output from SEEA 2024 Global Assessment linked files. |
| 11 | `seea_account_availability_assessment_long.csv` | Long-format CSV output from SEEA 2024 Global Assessment linked files. |
| 12 | `combined_availability_seea.xlsx` | Final combined SEEA accessibility dataset. |
| 13 | `combined_availability_seea.csv` | CSV version of the final combined SEEA accessibility dataset. |

---

### Notes

- This step measures data accessibility from downloaded files, not official account completion.
- The keyword configuration is conservative and country-language-aware.
- Topic-only words should not be used as final evidence of account availability.
- The method preserves keyword evidence and logs file-read or download failures to support transparency.
- Manual review is recommended for high-impact findings, non-English evidence, and cases where `nonreport_avail = 1`.
- The final combined output should be used for SEEA account accessibility figures and regional or income-group summaries.


## STEP 4: SEEA Account Grouping and Sankey Input Preparation

### Purpose

This step maps the Stock and Flow indicators from Step 2 to the 36 System of Environmental-Economic Accounting (SEEA) account categories. The workflow uses a large language model (LLM)-assisted classification to identify whether each indicator can support one or more SEEA accounts.

In addition to the account grouping, the final cleaned input file for Sankey diagram preparation is created. This cleaned file standardizes the human-reviewed SEEA account coding, recalculates the `no_account` field, and creates dataset group labels for Sankey source nodes.

The main analytical purpose is to show how indicators from different data sources connect to SEEA thematic account groups.

---

### Input Files

| No. | Input File | Description |
|---:|---|---|
| 1 | `SEEA_36_account_LLM_coding_workflow.xlsx` | Workbook used for LLM-assisted mapping of indicators to the 36 SEEA accounts. |
| 2 | `indicator_coding_filtered_no_policy_action.xlsx` | Filtered indicator file from Step 2. This file excludes Action and Policy Guide indicators and retains Stock and Flow indicators only. |
| 3 | `SEEA_36_account_LLM_coding_workflow - Human_MC.xlsx` | Human-reviewed SEEA account coding workbook. |

---

### Code Files

| No. | Code File | Description |
|---:|---|---|
| 1 | `A_SEEA Grouping(1).ipynb` | Runs LLM-assisted mapping of Stock and Flow indicators to the 36 SEEA account categories. |
| 2 | `B_cleaned_sankey_input(1).ipynb` | Cleans the human-reviewed SEEA account coding and prepares the Sankey input file. |

---

### Workflow Overview

The workflow has two main stages:

1. Use LLM-assisted classification to map each Stock or Flow indicator to one or more SEEA accounts.
2. Clean the human-reviewed SEEA account coding and prepare the final input file for the Sankey diagram.

---

### 4.1 SEEA Account Grouping

#### Purpose

This stage classifies each eligible indicator according to whether it can be used to compile one or more of the 36 SEEA accounts. The classification uses the SEEA account codebook as the authoritative reference.

The indicators used in this stage exclude Action and Policy Guide indicators because those indicators are not directly related to SEEA account compilation. The input file should therefore be based on:

`indicator_coding_filtered_no_policy_action.xlsx`

#### Code File

| No. | Code File | Description |
|---:|---|---|
| 1 | `A_SEEA Grouping(1).ipynb` | Maps indicators to the 36 SEEA accounts using the SEEA account codebook and LLM-assisted coding. |

#### Input Workbook

| No. | Sheet | Description |
|---:|---|---|
| 1 | `Step1_Input_Dataset` | Input indicator list to be mapped to SEEA accounts. This sheet should use the filtered Stock and Flow indicator file. |
| 2 | `Step2_SEEA_Account_Codebook` | Authoritative SEEA account codebook. |
| 3 | `Step3_Examples_Gold_Set` | Optional example indicators used as reference examples for the LLM. |
| 4 | `Step4_LLM_Output` | Output sheet that will be created or replaced by the notebook. |

#### Main Process

1. Load the workbook:  
   `SEEA_36_account_LLM_coding_workflow.xlsx`

2. Read the following sheets:
   - `Step1_Input_Dataset`
   - `Step2_SEEA_Account_Codebook`
   - `Step3_Examples_Gold_Set`, if available

3. Validate the required input columns.

4. Read the SEEA account codebook, including:
   - account code;
   - SEEA account name;
   - thematic category;
   - definition;
   - inclusion rule;
   - exclusion rule;
   - typical data needed;
   - typical data sources; and
   - keywords.

5. Convert the codebook and examples into prompt text.

6. Classify each indicator using a strict JSON schema.

7. Assign one or more SEEA accounts where the indicator can reasonably support account compilation.

8. Assign `no_account = True` if the indicator does not clearly support any of the 36 SEEA accounts.

9. Create binary flags for all 36 SEEA account columns.

10. Add supporting fields, including:
    - selected account codes;
    - selected account names;
    - selected thematic categories;
    - confidence score;
    - reasoning summary;
    - human review flag;
    - quality-check note; and
    - review priority.

11. Write the LLM output to:  
    `Step4_LLM_Output`

#### Coding Rule

The coding question is:

Can this indicator be used as source data, a direct account variable, or a closely aligned compilation input for one or more of the 36 SEEA accounts?

The workflow should not assign an account only because the indicator has a similar topic. The account should be assigned only when the indicator provides data that can reasonably support SEEA account compilation.

#### Output from This Stage

| No. | Output | Description |
|---:|---|---|
| 1 | `SEEA_36_account_LLM_coding_workflow.xlsx`, sheet `Step4_LLM_Output` | Initial LLM-assisted mapping of indicators to the 36 SEEA accounts. |

---

### 4.2 Human Review of SEEA Account Grouping

#### Purpose

This stage uses human review to validate and correct the LLM-assisted SEEA account mapping. The human-reviewed workbook is treated as the authoritative source for the final Sankey input.

#### Input File

| No. | Input File | Description |
|---:|---|---|
| 1 | `SEEA_36_account_LLM_coding_workflow.xlsx`, sheet `Step4_LLM_Output` | Initial LLM-assisted SEEA account mapping. |

#### Human Review File

| No. | Human Review File | Description |
|---:|---|---|
| 1 | `SEEA_36_account_LLM_coding_workflow - Human_MC.xlsx`, sheet `Step5_Human_Validation` | Human-reviewed SEEA account coding file. |

#### Main Process

1. Review each indicator’s selected SEEA accounts.

2. Check whether the selected accounts follow the SEEA account codebook.

3. Correct binary account flags where needed.

4. Confirm whether an indicator should be coded as `no_account`.

5. Add or revise justification notes where needed.

6. Save the reviewed results in:  
   `Step5_Human_Validation`

#### Output from This Stage

| No. | Output | Description |
|---:|---|---|
| 1 | `SEEA_36_account_LLM_coding_workflow - Human_MC.xlsx`, sheet `Step5_Human_Validation` | Human-reviewed SEEA account mapping. |

---

### 4.3 Clean Human-Reviewed Coding for Sankey Diagram

#### Purpose

This stage cleans the human-reviewed SEEA account coding and prepares the final Sankey input file. The cleaning process ensures that only true SEEA account columns are treated as account flags and that the `no_account` field is recalculated correctly.

#### Code File

| No. | Code File | Description |
|---:|---|---|
| 1 | `B_cleaned_sankey_input(1).ipynb` | Cleans the human-reviewed coding file and creates the final Sankey input workbook. |

#### Input File

| No. | Input File | Description |
|---:|---|---|
| 1 | `SEEA_36_account_LLM_coding_workflow - Human_MC.xlsx`, sheet `Step5_Human_Validation` | Human-reviewed coding file used as the input for Sankey preparation. |

#### Main Process

1. Load the human-reviewed workbook:  
   `SEEA_36_account_LLM_coding_workflow - Human_MC.xlsx`

2. Read the sheet:  
   `Step5_Human_Validation`

3. Clean and standardize column names.

4. Keep base indicator fields, including:
   - `no`
   - `indicator`
   - `Definition`
   - `unit`
   - `source`
   - `original`
   - `dataset`
   - `selected_account_codes`
   - `selected_accounts`
   - `selected_thematic_categories`
   - `human_review_needed`
   - `selected_accounts_json`
   - `Justification`

5. Identify true SEEA account columns. The notebook treats columns ending with `accounts` as SEEA account flag columns.

6. Convert coding values into binary flags.

7. Treat the following values as `1`:
   - `1`
   - `A`
   - `Y`
   - `YES`
   - `TRUE`
   - `APPLICABLE`
   - `X`

8. Treat the following values as `0`:
   - blank
   - `0`
   - `N`
   - `NO`
   - `FALSE`
   - `NOT APPLICABLE`
   - `N/A`
   - `NA`
   - `NONE`

9. Recalculate `account_match_count` as the row-level sum of all SEEA account flags.

10. Recalculate `no_account` using the following rule:
    - `no_account = 1` if no SEEA account column is flagged;
    - `no_account = 0` if at least one SEEA account column is flagged.

11. Add the clearer review label:  
    `No direct SEEA account flag`

12. Create `dataset_group` for Sankey source nodes.

13. Check duplicate indicator numbers.

14. Sort indicators by `no`.

15. Save the cleaned Sankey input file.

#### Dataset Grouping Rule

The notebook classifies indicator sources into three dataset groups:

| No. | Dataset Group | Rule |
|---:|---|---|
| 1 | `UNSD` | Assigned when the source text includes United Nations Statistics Division environmental statistics, United Nations Comtrade, or related United Nations Department of Economic and Social Affairs references. |
| 2 | `WB` | Assigned when the source text includes World Bank, Changing Wealth of Nations, CWON, Findex, or Worldwide Governance Indicators references. |
| 3 | `IMF` | Assigned as the default group when the source is not classified as UNSD or WB. |

#### Output from This Stage

| No. | Output File | Description |
|---:|---|---|
| 1 | `SEEA_36_account_final.xlsx` | Final cleaned Sankey input workbook. |
| 2 | `cleaned_sankey_input` | Sheet in `SEEA_36_account_final.xlsx` containing the cleaned indicator-level SEEA account flags. |

---

### 4.4 Recommended Sankey Interpretation

#### Purpose

The Sankey diagram should show the connection between data sources and SEEA thematic account groups. Because one indicator can be linked to more than one SEEA account, the flow widths should be calculated as weighted counts.

#### Recommended Weighting Rule

Each indicator contributes a total weight of one unit.

If an indicator maps to one SEEA account, that account receives weight `1`.

If an indicator maps to more than one SEEA account, the indicator’s weight is divided equally across all mapped accounts.

For example:

| No. | Number of Linked SEEA Accounts | Weight Assigned to Each Linked Account |
|---:|---:|---:|
| 1 | 1 account | 1.00 |
| 2 | 2 accounts | 0.50 |
| 3 | 3 accounts | 0.33 |
| 4 | 4 accounts | 0.25 |

This avoids double-counting indicators that are linked to multiple SEEA accounts.

#### Recommended Figure Note

Use this note under the Sankey diagram:

`Flow widths are weighted counts: each indicator contributes one unit divided equally across linked SEEA accounts.`

---

### Final Outputs from Step 4

| No. | Final Output | Description |
|---:|---|---|
| 1 | `SEEA_36_account_LLM_coding_workflow.xlsx`, sheet `Step4_LLM_Output` | Initial LLM-assisted mapping of Stock and Flow indicators to the 36 SEEA accounts. |
| 2 | `SEEA_36_account_LLM_coding_workflow - Human_MC.xlsx`, sheet `Step5_Human_Validation` | Human-reviewed SEEA account mapping. |
| 3 | `SEEA_36_account_final.xlsx` | Cleaned workbook for Sankey diagram preparation. |
| 4 | `cleaned_sankey_input` | Final cleaned Sankey input sheet. |

---

### Notes

- This step uses only Stock and Flow indicators because Action and Policy Guide indicators are excluded from SEEA account mapping.
- The LLM output is not treated as final. It is used as the first classification draft.
- The human-reviewed sheet `Step5_Human_Validation` is the authoritative source for final SEEA account coding.
- The `no_account` field should be recalculated after human review, rather than copied directly from earlier LLM output.
- The Sankey diagram should use weighted counts to avoid double-counting indicators that map to more than one SEEA account.
- The final cleaned file `SEEA_36_account_final.xlsx` should be used as the input for the Sankey diagram.


## STEP 5: SEEA Data Categorization and Visualization

### Purpose

This step prepares the data for visualization by categorizing the SEEA indicators and finalizing the figures for analysis. The main output of this step is a set of visual representations that will be used to communicate the results of the SEEA account availability assessment across countries and account categories.

This step involves categorizing the data into appropriate country-level and account groupings, calculating country category shares, and creating the final figure that summarizes the accessibility of the SEEA accounts. The results will be displayed in a Sankey diagram to illustrate the flow of data sources into the different SEEA account categories.

---

### Input Files

| No. | Input File | Description |
|---:|---|---|
| 1 | `SEEA_36_account_final.xlsx` | Cleaned workbook from Step 4 used for categorizing and finalizing visualizations. |
| 2 | `cleaned_sankey_input` | Final cleaned Sankey input sheet containing SEEA account flags and country indicators. |
| 3 | `Step 2_country_category_shares.ipynb` | Notebook used to calculate country category shares and prepare data for visual presentation. |
| 4 | `Step 1_summary_categories.ipynb` | Notebook that provides an overview of category-level summaries for visual representation. |

---

### Code Files

| No. | Code File | Description |
|---:|---|---|
| 1 | `Step 3_panelA.ipynb` | Prepares panel A, which summarizes the SEEA data accessibility per country. |
| 2 | `Step 4_panelB.ipynb` | Prepares panel B, which categorizes SEEA account availability by thematic group. |
| 3 | `Step 5_panelC.ipynb` | Prepares panel C, which visualizes the weighted country-category shares for each indicator. |
| 4 | `Step 6_Final Figure.ipynb` | Finalizes the Sankey diagram and other visual outputs for the presentation. |

---

### Workflow Overview

The workflow has five main stages:

1. Categorize SEEA accounts by country and thematic category.
2. Calculate country-level category shares for each indicator.
3. Prepare the visual panels for the Sankey diagram.
4. Finalize the Sankey diagram and other figures.
5. Output the final figures for reporting and visualization.

---

### 5.1 Categorizing SEEA Accounts by Country and Thematic Category

#### Purpose

This stage categorizes SEEA account availability by country and thematic group, based on the SEEA indicators prepared in Step 4. The output categorizes each country’s data by the SEEA accounts that are available to them, grouped by thematic categories.

#### Code File

| No. | Code File | Description |
|---:|---|---|
| 1 | `Step 1_summary_categories.ipynb` | Summarizes the SEEA categories at the country level, grouping indicators by account. |

#### Main Process

1. Load the cleaned workbook from Step 4:  
   `SEEA_36_account_final.xlsx`

2. Categorize each country’s SEEA accounts by their thematic group, using the account codebook.

3. Summarize available SEEA accounts per country in the following categories:
   - Water
   - Energy
   - Forests
   - Land
   - Carbon
   - Species
   - Economy
   - Waste, etc.

4. Prepare the categorized data for visual output.

#### Output from This Stage

| No. | Output File | Description |
|---:|---|---|
| 1 | `Step1_summary_categories_output.csv` | Summary of categorized SEEA accounts per country. |
| 2 | `Step1_summary_categories_output.xlsx` | Excel version of the categorized SEEA account summary. |

---

### 5.2 Calculating Country Category Shares

#### Purpose

This stage calculates the share of available SEEA categories for each country. It helps visualize how each country contributes to the different SEEA account categories, which will later be used in the Sankey diagram.

#### Code File

| No. | Code File | Description |
|---:|---|---|
| 1 | `Step 2_country_category_shares.ipynb` | Calculates the country category shares based on the available SEEA accounts. |

#### Main Process

1. Load the categorized data from Step 1:  
   `Step1_summary_categories_output.xlsx`

2. Calculate the share of available accounts for each country within each category, using the formula:
   - Country Share = Available Indicator Count / Total Possible Indicator Count

3. Generate a data table showing the share of available categories by country.

#### Output from This Stage

| No. | Output File | Description |
|---:|---|---|
| 1 | `country_category_shares.csv` | CSV containing country-level shares for each SEEA category. |
| 2 | `country_category_shares.xlsx` | Excel version of country-level shares by category. |

---

### 5.3 Preparing Visualization Panels

#### Purpose

This stage prepares the individual panels for the final Sankey diagram. It involves preparing country-level and account-group-level data, as well as creating any necessary intermediary data visualizations.

#### Code Files

| No. | Code File | Description |
|---:|---|---|
| 1 | `Step 3_panelA.ipynb` | Prepares panel A by summarizing country-level data availability. |
| 2 | `Step 4_panelB.ipynb` | Prepares panel B by categorizing SEEA account availability by thematic group. |
| 3 | `Step 5_panelC.ipynb` | Prepares panel C by visualizing weighted country-category shares for each indicator. |

#### Main Process

1. Prepare data for each of the three panels:
   - **Panel A**: Summarizes SEEA account availability by country.
   - **Panel B**: Categorizes SEEA account availability by thematic groups.
   - **Panel C**: Visualizes the weighted country-category shares.

2. Aggregate data for each panel.

3. Prepare intermediary figures that will be used to construct the final Sankey diagram.

#### Output from This Stage

| No. | Output File | Description |
|---:|---|---|
| 1 | `panelA_summary.csv` | Data file summarizing SEEA account availability by country. |
| 2 | `panelB_grouped_data.csv` | Data file categorizing SEEA account availability by thematic group. |
| 3 | `panelC_weighted_shares.csv` | Data file visualizing weighted country-category shares. |

---

### 5.4 Finalizing the Sankey Diagram and Visual Figures

#### Purpose

This stage finalizes the Sankey diagram and other visual representations of SEEA account availability. The diagrams will represent the flow of data from countries to SEEA accounts, showing the extent to which different countries report on different SEEA account categories.

#### Code File

| No. | Code File | Description |
|---:|---|---|
| 1 | `Step 6_Final Figure.ipynb` | Finalizes the Sankey diagram and other visual figures for the SEEA account data. |

#### Main Process

1. Load the summary and share data from Panels A, B, and C.

2. Combine the data for the Sankey diagram, representing the flow of indicators from countries to SEEA account categories.

3. Plot the Sankey diagram using the weighted shares calculated in Panel C.

4. Add labels, titles, and notes to the final figure.

5. Save the Sankey diagram and other figures in a format suitable for reporting.

#### Output from This Stage

| No. | Output File | Description |
|---:|---|---|
| 1 | `final_sankey_diagram.png` | Final Sankey diagram showing the flow of SEEA account availability. |
| 2 | `final_sankey_diagram.svg` | SVG version of the Sankey diagram for high-resolution printing. |
| 3 | `final_figure_report.pdf` | Full PDF report containing the final Sankey diagram and supporting figures. |

---

### Final Outputs from Step 5

| No. | Final Output | Description |
|---:|---|---|
| 1 | `Step1_summary_categories_output.csv` | Summary of categorized SEEA accounts per country. |
| 2 | `country_category_shares.csv` | Country-level shares for each SEEA category. |
| 3 | `panelA_summary.csv` | Summary data for Panel A. |
| 4 | `panelB_grouped_data.csv` | Categorized SEEA account availability data for Panel B. |
| 5 | `panelC_weighted_shares.csv` | Weighted shares of country-category data for Panel C. |
| 6 | `final_sankey_diagram.png` | PNG version of the final Sankey diagram. |
| 7 | `final_sankey_diagram.svg` | SVG version of the final Sankey diagram. |
| 8 | `final_figure_report.pdf` | Final report containing Sankey diagram and supporting figures. |

## Appendix III: Income-Group Coverage Figure

### Purpose

Appendix III creates a supplementary income-group figure for the System of Environmental-Economic Accounting (SEEA) data availability and accessibility analysis. While the main figure summarizes regional patterns, Appendix III shows how indicator coverage and SEEA account coverage vary across World Bank income groups.

The appendix figure contains two heatmap panels:

1. **Panel A. Indicator coverage by income group across categories and boundaries**
2. **Panel B. SEEA account coverage by income group**

The figure is designed to support interpretation of income-group differences in the underlying data infrastructure. It should be read as a descriptive comparison of average country coverage within income groups, not as a causal estimate of the effect of income level on data availability.

---

### Input Files

| No. | Input File | Description |
|---:|---|---|
| 1 | `step2_income_category_average_shares.csv` | Pre-calculated income-group averages for indicator coverage across categories and monetary boundary fields. This file is used for Appendix III, Panel A. |
| 2 | `step4_income_seea_account_average_coverage.csv` | Pre-calculated income-group averages for SEEA account coverage. This file is used for Appendix III, Panel B. |
| 3 | `step1_indicator_category_summary.csv` | Indicator counts by category and boundary. These counts are added to the Panel A column labels as `n` values. |

---

### Code File

| No. | Code File | Description |
|---:|---|---|
| 1 | `Step7_Appendix III.ipynb` | Creates Appendix III Figure 1, including Panel A and Panel B, and exports the figure in PDF, SVG, and PNG formats. |

---

### Workflow Overview

The Appendix III workflow has four main stages:

1. Load pre-calculated income-group coverage files.
2. Standardize and order income groups.
3. Create heatmaps for indicator coverage and SEEA account coverage.
4. Export the final appendix figure in publication-ready formats.

---

### AIII.1 Load Input Files

#### Purpose

This stage loads the pre-calculated input files needed to draw the two appendix panels. The notebook uses the current Jupyter working directory through `Path.cwd()`, so the input CSV files should be located in the same folder as the notebook unless the file paths are changed manually.

#### Main Process

1. Set the working directory using:

   `BASE_DIR = Path.cwd()`

2. Load the Panel A input file:

   `step2_income_category_average_shares.csv`

3. Load the Panel B input file:

   `step4_income_seea_account_average_coverage.csv`

4. Load the Panel A category count file:

   `step1_indicator_category_summary.csv`

5. Define the figure output file names.

---

### AIII.2 Define Income-Group Order

#### Purpose

This stage ensures that the heatmap rows follow a consistent income-group order across both panels.

#### Income-Group Order

| No. | Income Group |
|---:|---|
| 1 | `Low income` |
| 2 | `Lower middle income` |
| 3 | `Upper middle income` |
| 4 | `High income` |
| 5 | `Unclassified income` |

#### Treatment of Missing Income Groups

The notebook treats missing, blank, or text-based `nan` income entries as:

`Unclassified income`

This ensures that countries without a World Bank income classification are retained in the appendix figure rather than dropped from the visualization.

---

### AIII.3 Prepare Panel A: Indicator Coverage by Income Group

#### Purpose

Panel A visualizes average country coverage across indicator categories and monetary boundary fields by income group. It uses pre-calculated income-group averages from:

`step2_income_category_average_shares.csv`

#### Panel A Columns

| No. | Column | Figure Label | Interpretation |
|---:|---|---|---|
| 1 | `Physical stock` | Physical stock | Average country coverage for physical stock indicators. |
| 2 | `Monetary stock` | Monetary stock | Average country coverage for monetary stock indicators. |
| 3 | `Physical flow` | Physical flow | Average country coverage for physical flow indicators. |
| 4 | `Monetary flow` | Monetary flow | Average country coverage for monetary flow indicators. |
| 5 | `Action_kept` | Action | Average country coverage for Action indicators. |
| 6 | `Policy Guide_kept` | Policy guide | Average country coverage for Policy Guide indicators. |
| 7 | `HPS_monetary_only` | Monetary HPS | Average country coverage for monetary Household Produced Services indicators. |
| 8 | `DDP_monetary_only` | Monetary DDP | Average country coverage for monetary Depreciation or Degradation Process indicators. |
| 9 | `MS-NMS_monetary_only` | Monetary MS-NMS | Average country coverage for monetary Market Services and Near-Market Services indicators. |
| 10 | `ADE_monetary_only` | Monetary ADE | Average country coverage for monetary Avoided Defensive Expenditure indicators. |

#### Labeling Rule

Panel A adds the number of indicators in each category to the column labels using:

`step1_indicator_category_summary.csv`

For example, if the category count file reports 740 Policy Guide indicators, the Panel A label will display the Policy Guide label with its corresponding `n` value.

---

### AIII.4 Prepare Panel B: SEEA Account Coverage by Income Group

#### Purpose

Panel B visualizes average country coverage for SEEA account accessibility categories by income group. It uses pre-calculated income-group averages from:

`step4_income_seea_account_average_coverage.csv`

#### Panel B Columns

| No. | Column | Figure Label | Interpretation |
|---:|---|---|---|
| 1 | `Reported SEEA accounts` | Reported SEEA accounts | Average share of SEEA accounts reported in the official assessment data. |
| 2 | `Easily accessible accounts` | Easily accessible accounts | Average share of SEEA accounts that could be located directly from accessible files. |
| 3 | `Found but not reported` | Account found but not reported | Average share of accounts where evidence was found in accessible files but not reported in the official assessment field. |

---

### AIII.5 Draw the Heatmaps

#### Purpose

This stage draws both appendix panels as heatmaps using a shared 0 to 100 percent scale. The same color scale is used for Panel A and Panel B so that the values can be compared visually across panels.

#### Main Process

1. Load the income-group average tables.
2. Check that each input file contains the required columns.
3. Fill missing income-group labels as `Unclassified income`.
4. Reorder rows using the predefined income-group order.
5. Draw Panel A using the indicator category and monetary boundary columns.
6. Draw Panel B using the SEEA account coverage columns.
7. Add country counts to the y-axis labels.
8. Add category counts to the Panel A x-axis labels.
9. Add cell values as percentages with one decimal place.
10. Add a shared color bar labeled:

    `Average country coverage (%)`

---

### AIII.6 Export Appendix III Figure 1

#### Purpose

This stage saves the final appendix figure in three formats for reporting, editing, and publication use.

#### Output Files

| No. | Output File | Description |
|---:|---|---|
| 1 | `appendixIII_figure1_panels_A_B_income_coverage.pdf` | PDF version for manuscript submission or print use. |
| 2 | `appendixIII_figure1_panels_A_B_income_coverage.svg` | SVG version for vector editing and high-resolution publication workflows. |
| 3 | `appendixIII_figure1_panels_A_B_income_coverage.png` | PNG version exported at 300 dots per inch for quick viewing and presentation use. |

---

### Interpretation Notes

- Appendix III uses average country coverage percentages within each income group.
- The country count shown beside each income group indicates the number of countries included in that income-group average.
- Panel A reports indicator availability across categories and monetary boundary fields.
- Panel B reports SEEA account coverage across reported, easily accessible, and found-but-not-reported account categories.
- The `Unclassified income` group is retained to avoid excluding countries without an assigned World Bank income group.
- Panel A category labels include indicator counts, so large categories and small categories should not be interpreted in the same way without considering their `n` values.
- Action and Policy Guide indicators may show high average coverage, but their interpretation should consider the much smaller or larger number of indicators in each category.
- The appendix figure is descriptive and should be used to support interpretation of income-group patterns, not to establish causal differences across income groups.

---

### Reproducibility Notes

- Run Appendix III after the Step 5 input files have been created.
- Keep the three input CSV files in the same folder as `Step7_Appendix III.ipynb`, or revise the file paths in the notebook.
- Do not rename the required input columns unless the notebook is updated accordingly.
- Check that the `Income` and `country_count` columns are present in both income-group input files.
- Check that `category` and `indicator_count` are present in `step1_indicator_category_summary.csv`.
- Use the PDF or SVG output for publication-quality figures.
- Use the PNG output for presentations, quick review, or README previews.

---

### Final Outputs from Appendix III

| No. | Final Output | Description |
|---:|---|---|
| 1 | `appendixIII_figure1_panels_A_B_income_coverage.pdf` | Final Appendix III Figure 1 in PDF format. |
| 2 | `appendixIII_figure1_panels_A_B_income_coverage.svg` | Final Appendix III Figure 1 in SVG format. |
| 3 | `appendixIII_figure1_panels_A_B_income_coverage.png` | Final Appendix III Figure 1 in PNG format. |

