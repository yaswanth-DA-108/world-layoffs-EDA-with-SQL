# World Layoffs Data Cleaning Project
## Overview
This project involves cleaning and preprocessing the World Layoffs dataset using SQL to ensure data accuracy and usability. The dataset contains information about layoffs across industries, including company names, locations, total layoffs, and funding details. By applying systematic data cleaning techniques, we aim to prepare the dataset for effective analysis.

## Data Cleaning Steps
We performed the following key transformations:

Removing Duplicates

Identified duplicate records using ROW_NUMBER().

Created a clean version of the dataset without duplicate entries.

Standardizing Data

Trimmed unnecessary spaces from text fields (TRIM()).

Unified industry names (e.g., "Crypto" vs. "Cryptocurrency").

Fixed country name inconsistencies (e.g., "United States" vs. "United States.").

Handling Null and Blank Values

Replaced blank values with NULL.

Imputed missing industry values using existing company data.

Converting Data Types

Changed the date column from text to proper DATE format.

Removing Unnecessary Rows and Columns

Dropped records where both total_laid_off and percentage_laid_off were missing.

Removed the row_num column used for duplicate identification.

SQL Queries Used
Below are a few key SQL snippets from the cleaning process:

```sql
-- Removing duplicates using ROW_NUMBER()
WITH cte AS (
SELECT *, ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_c
)
DELETE FROM layoffs_c1 WHERE row_num > 1;
```
```sql
-- Standardizing industry names
UPDATE layoffs_c1
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
```
```sql
-- Handling missing values in the industry column using known company data
UPDATE layoffs_c1 t1
JOIN layoffs_c1 t2 ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;
```
## Insights
After cleaning the data, we can derive meaningful insights regarding:

Trends in layoffs across industries.

How company size and funding impact layoffs.

Regional variations in workforce reductions.

How to Use
Load the dataset into MySQL.

Run the SQL scripts provided in data_clean.txt.

The final cleaned dataset (layoffs_c1) is ready for analysis.
