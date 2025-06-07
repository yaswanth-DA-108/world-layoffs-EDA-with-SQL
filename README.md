# 1.World Layoffs Data Cleaning Project
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

Sure! Here’s your README file with the SQL code included:

---

# 2.World Layoffs Dataset - Exploratory Data Analysis (EDA)

## Overview
This project performs exploratory data analysis on a global layoffs dataset to identify trends, patterns, and insights into workforce reductions across industries, locations, and companies.

## Dataset
The dataset contains records of company layoffs, including:
- **Company**: Name of the company that issued layoffs
- **Industry**: Sector in which the company operates
- **Location & Country**: Where the layoffs occurred
- **Total Laid Off**: Number of employees impacted
- **Percentage Laid Off**: Percentage of workforce affected
- **Stage**: Growth stage of the company at the time of layoffs
- **Date**: When layoffs occurred

## SQL Queries Used

### 1. Viewing Raw Data
```sql
SELECT * FROM layoffs_c1;
```

### 2. Maximum & Minimum Layoffs
```sql
SELECT MAX(total_laid_off), MIN(total_laid_off) FROM layoffs_c1;
SELECT MAX(percentage_laid_off), MIN(percentage_laid_off) FROM layoffs_c1;
```

### 3. Companies That Laid Off 100% of Employees
```sql
SELECT * FROM layoffs_c1 
WHERE percentage_laid_off = 1 
ORDER BY total_laid_off DESC;
```

### 4. Total Layoffs by Each Company
```sql
SELECT company, SUM(total_laid_off) 
FROM layoffs_c1 
GROUP BY company 
ORDER BY 2 DESC;
```

### 5. Timeframe Analysis
```sql
SELECT MIN(`date`), MAX(`date`) FROM layoffs_c1;
```

### 6. Layoffs by Industry
```sql
SELECT industry, SUM(total_laid_off) 
FROM layoffs_c1 
GROUP BY industry 
ORDER BY 2 DESC;
```

### 7. Layoffs by Location & Country
```sql
SELECT location, SUM(total_laid_off) 
FROM layoffs_c1 
GROUP BY location 
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off) 
FROM layoffs_c1 
GROUP BY country 
ORDER BY 2 DESC;
```

### 8. Layoffs by Year & Month
```sql
SELECT YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_c1 
GROUP BY YEAR(`date`) 
ORDER BY 1 DESC;

SELECT SUBSTRING(`date`,1,7) AS Months, SUM(total_laid_off) 
FROM layoffs_c1 
WHERE SUBSTRING(`date`,1,7) IS NOT NULL 
GROUP BY Months 
ORDER BY 1;
```

### 9. Rolling Total Layoffs by Month
```sql
WITH roll_total AS (
    SELECT SUBSTRING(`date`,1,7) AS Months, SUM(total_laid_off) AS total_offs
    FROM layoffs_c1
    WHERE SUBSTRING(`date`,1,7) IS NOT NULL
    GROUP BY Months
    ORDER BY 1
)
SELECT Months, total_offs, SUM(total_offs) OVER(ORDER BY Months) AS rolling_total 
FROM roll_total;
```

### 10. Layoffs by Each Company Per Year
```sql
SELECT company, YEAR(`date`), SUM(total_laid_off) lay_num
FROM layoffs_c1
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;
```

### 11. Top 5 Companies with Highest Layoffs Per Year
```sql
WITH com_year AS (
    SELECT company, YEAR(`date`), SUM(total_laid_off) lay_num
    FROM layoffs_c1
    GROUP BY company, YEAR(`date`)
),
com_yrank AS (
    SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ramk
    FROM com_year
    WHERE years IS NOT NULL
)
SELECT * FROM com_yrank
WHERE ramk <= 5;
```

### 12. Most Affected Location in Each Country
```sql
WITH rank_con AS (
    SELECT country, location, SUM(total_laid_off) AS location_layoffs,
           DENSE_RANK() OVER(PARTITION BY country ORDER BY SUM(total_laid_off) DESC) AS ranks
    FROM layoffs_c1 
    GROUP BY country, location
)
SELECT * FROM rank_con
WHERE ranks = 1 AND location_layoffs IS NOT NULL;
```


