use world_layoffs;
select *
from layoffs;

select distinct industry from
layoffs; 

-- 1. Remove duplicates
-- 2. Standardize then Data
-- 3. Null values or blanck values
--  4. Remove Any Irrelavent coloumns

# It is Importtant to have a Back up Dataset so that If We Mess Up any thing we have a back up to roll back
CREATE TABLE layoffs_c 
like layoffs;

insert layoffs_c
select * from layoffs;

select * from layoffs_c;

-- 1.Remove Duplicates
select * ,
row_number() over(
partition by company,industry,total_laid_off,percentage_laid_off,`date`
) as row_num
from layoffs_c;

/* Above Query Will Return Extra Coloumnn row_num 
where if there is a match between two or more records in partition by window function fields
that many numbers are displayed i.e if row_num>1 those fields are having duplicates */

# now we select duplicates
with cte_1 as (
select * ,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions
) as row_num
from layoffs_c
)
select * from cte_1 
where row_num>1;

#Now we cannot update tabble through CTEs so we create new table to store filtered data

CREATE TABLE `layoffs_c1` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

 
# inserting data in layoffs_c table with extra cloumn row number that shows duplicate values  
  insert into layoffs_c1
 select * ,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions
) as row_num
from layoffs_c;

-- deleting duplicate values
delete 
from layoffs_c1 
where row_num>1;


-- standardizing data

-- removing satrting and ending spaces
select company,trim(company)
from layoffs_c1;

update layoffs_c1
set company=trim(company);


select distinct industry
from layoffs_c1
order by 1
;
-- from the above query we observe that there are two industries crypto and crypto currency they are same so we standardise them.
select *
from layoffs_c1
where industry like 'crypto%'
;

update layoffs_c1
set industry='crypto'
where industry like 'crypto%'
;

select industry
from layoffs_c1
where industry like 'crypto%'
;


select distinct location 
from layoffs_c1
order by 1 ;

select distinct country
from layoffs_c1
order by 1 ;
-- from above query we can obseve that 
-- country coloumn contains 'united states' and 'united states.'  despite beeing same country diffrentiated by '.'
-- so we remove trailing '.'

update layoffs_c1
set country =trim(trailing '.' from country)
where country like 'United States%';

#change date from text to date
select `date`, str_to_date(`date`,'%m/%d/%Y')
from layoffs_c1;

update layoffs_c1
set `date`=str_to_date(`date`,'%m/%d/%Y');

select `date` from layoffs_c1;

alter table layoffs_c1
modify column `date` date;

select * from layoffs_c1;


-- 3. Null values or blanck values

select * from layoffs_c1
where total_laid_off is null
and  percentage_laid_off is null;

select * from layoffs_c1
where industry is null
or industry ='';

select * from layoffs_c1 
where company ='Airbnb';

select t1.industry,t2.industry 
from layoffs_c1 t1
join layoffs_c1 t2
	on t1.company=t2.company
	and t1.location=t2.location
where (t1.industry is null or t1.industry='')
and t2.industry is not null;

update layoffs_c1 t1
join layoffs_c1 t2
	on t1.company=t2.company
    set t1.industry=t2.industry
where (t1.industry is null or t1.industry='')
and t2.industry is not null;

#not worked set blanks with null

update layoffs_c1
set industry = null
where industry='';

update layoffs_c1 t1
join layoffs_c1 t2
	on t1.company=t2.company
    set t1.industry=t2.industry
where t1.industry is null 
and t2.industry is not null;

select * from layoffs_c1 
where company ='Airbnb';

select * from layoffs_c1
where industry is null
or industry ='';

select * from layoffs_c1 
where company like 'ball%';

select * from layoffs_c1;

-- remove rows and columns that are not needed

select * from layoffs_c1
where total_laid_off is null
and  percentage_laid_off is null;

delete
from layoffs_c1
where total_laid_off is null
and  percentage_laid_off is null;

select * from layoffs_c1
where total_laid_off is null
and  percentage_laid_off is null;

select * from layoffs_c1;

alter table layoffs_c1 
drop column row_num;











 
 
 
 







