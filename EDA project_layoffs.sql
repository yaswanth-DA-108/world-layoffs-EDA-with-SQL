-- Exploratory Data Analysis

select * 
from layoffs_c1;

select max(total_laid_off),min(total_laid_off)
from layoffs_c1;

select max(percentage_laid_off) ,min(percentage_laid_off)
from layoffs_c1;

select *
from  layoffs_c1 
where percentage_laid_off=1
order by total_laid_off desc;

--  Total Layoffs by Each company
select company,sum(total_laid_off)
from layoffs_c1
group by company
order by 2 desc;

select min(`date`),max(`date`)
from layoffs_c1;

-- layoffs by industry
select industry,sum(total_laid_off)
from layoffs_c1
group by industry
order by 2 desc;

-- layoffs by location
select location,sum(total_laid_off)
from layoffs_c1
group by location
order by 2 desc;

-- layoffs by country
select country,sum(total_laid_off)
from layoffs_c1
group by country
order by 2 desc;

-- layoffs by year
select year(`date`),sum(total_laid_off)
from layoffs_c1
group by year(`date`)
order by 1 desc;

-- layoffs by satge
select stage,sum(total_laid_off)
from layoffs_c1
group by stage
order by 2 desc;

-- layoffs by months
select substring(`date`,1,7) as Months,sum(total_laid_off)
from layoffs_c1
where substring(`date`,1,7) is not null
group by Months
order by 1;

-- rolling total by each month
with roll_total as
(
select substring(`date`,1,7) as Months,sum(total_laid_off) as total_offs
from layoffs_c1
where substring(`date`,1,7) is not null
group by Months
order by 1
)
select Months,total_offs,sum(total_offs) over(order by Months) as rolling_total
from roll_total;

-- layoffs by each company each year
select company,year(`date`),sum(total_laid_off) lay_num
from layoffs_c1
group by company,year(`date`)
order by 3 desc;

-- top 5 companies with highes layoffs each year
with com_year (company,years,total_laid_off) as 
(
select company,year(`date`),sum(total_laid_off) lay_num
from layoffs_c1
group by company,year(`date`)
),
com_yrank as(
select * ,
dense_rank() over(partition by years order by total_laid_off desc) as ramk
from com_year
where years is not null
)
select * from com_yrank
where ramk<=5;

-- top locations of each countries with highest layoffs
with rank_con as (
select country,location,sum(total_laid_off) as location_layoffs,
dense_rank() over(partition by country order by sum(total_laid_off) desc) as ranks
from layoffs_c1 group by country,location
)
select * from rank_con
where ranks=1 and location_layoffs is not null
;




