CREATE TABLE covideaths
(
    iso_code CHAR(8),
    continent VARCHAR(20),
    location VARCHAR (100),
    date TIMESTAMP,
    population INT,
    total_cases INT,
    new_cases INT,
    new_cases_smoothed DECIMAL(6,3),
    total_deaths INT,
    new_deaths INT,
    new_deaths_smoothed DECIMAL(6,3),
    total_cases_PM DECIMAL(6,3),
    new_cases_PM DECIMAL(6,3),
    new_cases_SPM DECIMAL(6,3),
    total_deaths_PM DECIMAL(6,3),
    new_deaths_PM DECIMAL(6,3),
    new_deaths_SPM DECIMAL(6,3),
    reproduction_rate DECIMAL(2,3),
    ICU_patients INT,
    ICU_patients_PM DECIMAL(6,3),
    hospital_patients INT,
    hospital_patients_PM DECIMAL(6,3),
    weekly_icu_admission DECIMAL(6,3),
    weekly_icu_admission_PM DECIMAL(6,3),
    weekly_hospital_admission DECIMAL(6,3),
    weekly_hosptial_admissions_PM DECIMAL(6,3)
)

ALTER TABLE covideaths 
ALTER COLUMN new_cases_smoothed TYPE DECIMAL(10,3);

ALTER TABLE covideaths 
ALTER COLUMN new_deaths_smoothed TYPE DECIMAL(10,3);

ALTER TABLE covideaths 
ALTER COLUMN new_cases_pm TYPE DECIMAL(10,3);

ALTER TABLE covideaths 
ALTER COLUMN total_deaths_PM TYPE DECIMAL(10,3);

ALTER TABLE covideaths 
ALTER COLUMN new_cases_SPM TYPE DECIMAL(10,3);


ALTER TABLE covideaths 
ALTER COLUMN new_deaths_PM TYPE DECIMAL(10,3);

ALTER TABLE covideaths 
ALTER COLUMN new_deaths_SPM TYPE DECIMAL(10,3);


ALTER TABLE covideaths 
ALTER COLUMN ICU_patients_PM TYPE DECIMAL(10,3);


ALTER TABLE covideaths 
ALTER COLUMN hospital_patients_PM TYPE DECIMAL(10,3);

ALTER TABLE covideaths 
ALTER COLUMN weekly_hospital_admission TYPE DECIMAL(10,3);


ALTER TABLE covideaths 
ALTER COLUMN weekly_icu_admission TYPE DECIMAL(10,3);

ALTER TABLE covideaths 
ALTER COLUMN weekly_hosptial_admissions_PM TYPE DECIMAL(10,3);

ALTER TABLE covideaths 
ALTER COLUMN weekly_icu_ TYPE DECIMAL(10,3);

ALTER TABLE covideaths 
ALTER COLUMN population TYPE bigint;


select *from covideaths
order by 3,4;


CREATE TABLE covidvaccs
(
    iso_code CHAR(8),
    continent VARCHAR(20),
    location VARCHAR (100),
    date TIMESTAMP,
    population INT,
    new_tests INT,
    total_tests INT,
    total_tests_PT INT,
    new_tests_PT INT,
    new_tests_smoothed INT,
    new_tests_smoothed_PT INT,
    positive_rate INT,
    tests_per_case INT,
    tests_unit VARCHAR,
    total_vaccs BIGINT,
    ppl_vaccd INT,
    ppl_fully_vaccd INT,
    new_vaccs INT,
    new_vacc_smoothed INT,
    total_vacc_PH INT,
    ppl_vacc_PH INT,
    ppl_fully_vacc_PH INT,
    new_vacc_smoothed_PM INT,
    stringency_ind INT,
    pop_den INT,
    median_age INT,
    aged_65_older INT
)

COPY covidvaccs
FROM 'C:\Users\Saksh\Downloads\vaccpro.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy covidvaccs FROM 'C:\Users\Saksh\Downloads\vaccpro.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');


ALTER TABLE covidvaccs 
ALTER COLUMN new_vacc_smoothed_PM TYPE DECIMAL(10,3);

ALTER TABLE covidvaccs 
ALTER COLUMN stringency_ind TYPE DECIMAL(10,3);

ALTER TABLE covidvaccs 
ALTER COLUMN pop_den TYPE DECIMAL(10,3);

ALTER TABLE covidvaccs 
ALTER COLUMN median_age TYPE DECIMAL(10,3);

ALTER TABLE covidvaccs 
DROP column aged_65_older;
ALTER TABLE covidvaccs 
ADD column aged_65_older NUMERIC(10,6);

ALTER TABLE covidvaccs
DROP column population;

ALTER TABLE covidvaccs alter column total_vacc_PH TYPE DECIMAL(10,6);

ALTER TABLE covidvaccs
ALTER COLUMN ppl_vacc_PH TYPE DECIMAL(10,6);

ALTER TABLE covidvaccs
ALTER COLUMN ppl_fully_vacc_PH TYPE DECIMAL(10,6);

ALTER TABLE covidvaccs
ALTER COLUMN total_tests_PT TYPE DECIMAL(10,6);

ALTER TABLE covidvaccs
ALTER COLUMN new_tests_PT TYPE DECIMAL(10,6);

ALTER TABLE covidvaccs
ALTER COLUMN new_tests_smoothed_PT TYPE DECIMAL(10,6);

ALTER TABLE covidvaccs
ALTER COLUMN positive_rate TYPE DECIMAL(10,6);

ALTER TABLE covidvaccs
ALTER COLUMN tests_per_case TYPE DECIMAL(10,6);
ALTER TABLE covidvaccs
ALTER COLUMN tests_per_case TYPE DECIMAL(10,6);

ALTER TABLE covidvaccs
ALTER COLUMN tests_per_case TYPE DECIMAL(8,6);

ALTER TABLE covidvaccs
ALTER COLUMN tests_per_case TYPE NUMERIC(10,6);

ALTER TABLE covidvaccs
ALTER COLUMN tests_per_case TYPE NUMERIC;


/*-------------------------------------------------------*/

select * from covideaths
ORDER BY 3,4;

SELECT * from covidvaccs
ORDER BY 3,4;

--selecting data we will use in the project

select
location,
date,
total_cases,
new_cases,
total_deaths,
population
FROM covideaths;

--looking at total cases vs total deaths

SELECT
location,
date,
total_cases,
new_cases,
total_deaths,
population
FROM covideaths
ORDER BY 1,2;


SELECT
location,
date,
total_cases,
total_deaths,
(total_deaths:: DECIMAL/total_cases)*100 as cases_by_deaths 
FROM covideaths
where location like '%States%'
ORDER BY 1,2;

select total_cases,total_deaths, (total_deaths/total_cases) as percent_deaths
from covideaths

--Looking at Total cases vs population

Select
location,
date,
--total_cases,
population,
MAX(total_cases) as highest
(total_cases :: DECIMAL/population)*100 as covid_by_popn
FROM covideaths
where location like '%States%'
ORDER BY covid_by_popn desc;

SELECT
location,
population,
Date,
MAX(total_cases) as highest_infections_num,
MAX((total_cases::DECIMAL/population))*100 as Max_infectionsperpopn
FROM covideaths
where population IS NOT NULL and total_cases is not null
GROUP BY location, population,date
ORDER BY Max_infectionsperpopn DESC;

--Countries with highest death count per population

SELECT
location,
population,
MAX(total_deaths) as highest_deaths_num,
MAX((total_deaths::DECIMAL/population))*100 as Max_deathsperpopn
FROM covideaths
where total_deaths IS NOT NULL AND population IS NOT NULL
GROUP BY location, population
ORDER BY Max_deathsperpopn DESC;

SELECT
continent,
MAX(total_deaths) as highest_deaths_num
From covideaths
WHERE continent is not NULL
GROUP BY continent
ORDER BY highest_deaths_num DESC;

SELECT
location,
MAX(total_deaths) AS Max_d
FROM covideaths
where continent is null
AND location not in ('World', 'European Union', 'International')
group by location
order by Max_d

--Global numbers

select
--date,
sum(new_cases) as sum_cases,
sum(new_deaths) as sum_deaths,
SUM(new_deaths:: DECIMAL)/sum(new_cases:: DECIMAL)*100 as death_percent
FROM covideaths
WHERE continent is not null
--GROUP BY date

--looking at total population vs vaccinations
select
covideaths.continent,
covideaths.location,
covideaths.date,
covideaths.population,
covidvaccs.new_vaccs,
SUM(covidvaccs.new_vaccs)
OVER (Partition by covideaths.location
ORDER BY covideaths.location, covideaths.date) AS Rollingpplvaccs
FROM covideaths
LEFT join covidvaccs ON covideaths.location = covidvaccs.location and
covideaths.date = covidvaccs.date
where covideaths.continent IS NOT NULL AND new_vaccs IS NOT NULL

--CTE for rolling pop vs vaccs

WITH popvsvacc(
    continent, location, date, population, new_vaccs,
    Rollingpplvaccs
) AS(
    select
covideaths.continent,
covideaths.location,
covideaths.date,
covideaths.population,
covidvaccs.new_vaccs,
SUM(covidvaccs.new_vaccs)
OVER (Partition by covideaths.location
ORDER BY covideaths.location, covideaths.date) AS Rollingpplvaccs
FROM covideaths
LEFT join covidvaccs ON covideaths.location = covidvaccs.location and
covideaths.date = covidvaccs.date
where covideaths.continent IS NOT NULL AND new_vaccs IS NOT NULL
)
Select * , (Rollingpplvaccs::DECIMAL/population)*100 as popvaccpercent from popvsvacc;


-- Creating views

CREATE VIEW PopulationVaccinated AS
select
covideaths.continent,
covideaths.location,
covideaths.date,
covideaths.population,
covidvaccs.new_vaccs,
SUM(covidvaccs.new_vaccs)
OVER (Partition by covideaths.location
ORDER BY covideaths.location, covideaths.date) AS Rollingpplvaccs
FROM covideaths
LEFT join covidvaccs ON covideaths.location = covidvaccs.location and
covideaths.date = covidvaccs.date
where covideaths.continent IS NOT NULL AND new_vaccs IS NOT NULL

CREATE VIEW globalnums AS
select
--date,
sum(covideaths.new_cases),
sum(covideaths.new_deaths),
SUM(covideaths.new_deaths:: DECIMAL)/sum(covideaths.new_cases:: DECIMAL)*100 as death_percent
FROM covideaths
WHERE covideaths.continent is not null  

