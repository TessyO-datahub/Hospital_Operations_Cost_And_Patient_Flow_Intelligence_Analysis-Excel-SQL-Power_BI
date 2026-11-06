-- creating the encounters table to store patient encounter records, encounter date and time, payer coverage, and reasons for the encounter
create table encounters (
	encounter_id varchar(255) NOT NULL primary key,
    start_date_time datetime,
    stop_date_time datetime,
    patient_id varchar(255),
    organization_id varchar(255),
    payer_id varchar(255),
    encounter_class varchar(255),
    code varchar(255),
    description varchar(255),
    base_encounter_cost decimal(12,2),
    total_claim_cost decimal(12,2),
    payer_coverage decimal(12,2),
    reason_code varchar(255),
    reason_description varchar(255)
);

-- creating the organizations table to store organization information
create table organizations (
	organization_id varchar(255) NOT NULL primary key,
    name varchar(255),
    address varchar(255),
    city varchar(255),
    state varchar(255),
    zip_code varchar(255),
    latitude decimal(10,6),
    longitude decimal(10,6)
);

-- creating the patients table to store patient information
create table patients (
	patient_id varchar(255) NOT null primary key,
    birth_date date,
    death_date date,
    prefix varchar(255),
    first_name varchar(255),
    last_name varchar(255),
    suffix varchar(255),
    maiden_name varchar(255),
    marital_status varchar(255),
    race varchar(255),
    ethnicity varchar(255),
    gender varchar(255),
    birth_place varchar(255),
    address varchar(255),
    city varchar(255),
    state varchar(255),
    county varchar(255),
    zip_code varchar(255),
    latitude decimal(10,6),
    longitude decimal(10,6)
);

-- creating the payers table to store payer information
create table payers (
	payer_id varchar(255) NOT null primary key,
    name varchar(255),
    address varchar(255),
    city varchar(255),
    state_headquarters varchar(255),
    zip_code varchar(255),
    phone_number varchar(255)
);

-- creating the procedures table to store procedure information
create table procedures (
    start_date_time datetime,
    stop_date_time datetime,
    patient_id varchar(255),
    encounter_id varchar(255),
    code varchar(255),
    description varchar(255),
    base_cost decimal(12,2),
    reason_code varchar(255),
    reason_description varchar(255)
);
SHOW tables;
SHOW variables LIKE 'local_infile';
SET GLOBAL local_infile = 1;

-- import encounters table
LOAD data local infile 'D:/Data Analytics/AnalystLab Africa/Week 3 Task/CSVs/encounters.csv'
INTO table encounters
FIELDS TERMINATED BY ','
optionally enclosed by '"'
LINES terminated by '\n'
ignore 1 rows; 
SHOW count(*) warnings;

-- import patients table
LOAD data local infile 'C:/Users/totes/Downloads/patients.csv'
INTO table patients
FIELDS TERMINATED BY ','
optionally enclosed by '"'
LINES terminated by '\n'
ignore 1 rows; 

-- import organizations table
LOAD data local infile 'D:/Data Analytics/AnalystLab Africa/Week 3 Task/CSVs/organizations.csv'
INTO table organizations
FIELDS TERMINATED BY ','
optionally enclosed by '"'
LINES terminated by '\n'
ignore 1 rows; 

-- import payers table
LOAD data local infile 'D:/Data Analytics/AnalystLab Africa/Week 3 Task/CSVs/payers.csv'
INTO table payers
FIELDS TERMINATED BY ','
optionally enclosed by '"'
LINES terminated by '\n'
ignore 1 rows; 

-- import procedures table
LOAD data local infile 'D:/Data Analytics/AnalystLab Africa/Week 3 Task/CSVs/procedures.csv'
INTO table procedures
FIELDS TERMINATED BY ','
optionally enclosed by '"'
LINES terminated by '\r\n'
ignore 1 rows; 

-- count the rows in each table
select count(*) AS record_count_encounters
from encounters;
select count(*) AS record_count_patients
from patients;
select count(*) AS record_count_organizations
from organizations;
select count(*) AS record_count_payers
from payers;
select count(*) AS record_count_procedures
from procedures;

-- count the columns for each table
select COUNT(*) AS column_count_encounters
from information_schema.columns
where table_schema = 'hospital_analytics'
and table_name = 'encounters';

select COUNT(*) AS column_count_patients
from information_schema.columns
where table_schema = 'hospital_analytics'
and table_name = 'patients';

select COUNT(*) AS column_count_organizations
from information_schema.columns
where table_schema = 'hospital_analytics'
and table_name = 'organizations';

select COUNT(*) AS column_count_payers
from information_schema.columns
where table_schema = 'hospital_analytics'
and table_name = 'payers';

select COUNT(*) AS column_count_procedures
from information_schema.columns
where table_schema = 'hospital_analytics'
and table_name = 'procedures';

-- count the number of null values in each colum of each table
-- missing values in encounters table
SELECT
    sum(start_date_time is null) as missing_start_date,
    sum(stop_date_time is null) as missing_stop_date,
    sum(patient_id ='') as missing_patient_id,
	sum(organization_id ='') as missing_organization_id,
    sum(payer_id ='') as missing_payer_id,
    sum(encounter_class ='') as missing_encounter_class,
    sum(code ='') as missing_code,
    sum(description ='') as missing_description,
    sum(base_encounter_cost ='') as missing_base_encounter_cost,
    sum(total_claim_cost ='') as missing_total_claim_cost,
    sum(payer_coverage ='') as missing_payer_coverage,
    sum(reason_code ='') as missing_reason_code,
    sum(reason_description ='') as missing_reason_description
FROM encounters;
update payers
set base_encounter_cost = 0
where base_encounter_cost ='';

-- change name to organization_name
alter table payers
rename column name to payer_name;

-- missing values in patients table
select
    sum(birth_date is null) as missing_birth_date,
    sum(death_date is null) as missing_death_date,
    sum(prefix ='') as missing_prefix,
	sum(first_name ='') as missing_first_name,
    sum(last_name ='') as missing_last_name,
    sum(suffix ='') as missing_suffix,
    sum(maiden_name ='') as missing_maiden_name,
    sum(marital_status ='') as missing_marital_status,
    sum(race ='') as missing_race,
    sum(ethnicity ='') as missing_ethnicity,
    sum(gender ='') as missing_gender,
    sum(birth_place ='') as missing_birth_place,
    sum(address ='') as missing_address,
	sum(city ='') as missing_city,
    sum(state ='') as missing_state,
    sum(county ='') as missing_county,
    sum(zip_code ='') as missing_zip_code,
    sum(latitude ='') as missing_latitude,
    sum(longitude ='') as missing_longitude
FROM patients;

UPDATE patients
SET death_date = NULL
WHERE YEAR(death_date) = 0;

-- missing values in payers table
select
    sum(payer_name ='') as missing_name,
    sum(address ='') as missing_address,
	sum(city ='') as missing_city,
    sum(state_headquarters ='') as missing_state,
    sum(zip_code ='') as missing_zip_code,
     sum(phone_number ='') as missing_phone_number
    FROM payers;
    
-- missing values in procedures table
select
    sum(start_date_time is null) as missing_start_date,
    sum(stop_date_time is null) as missing_stop_date,
    sum(patient_id ='') as missing_patient_id,
	sum(encounter_id ='') as missing_encounter_id,
    sum(code ='') as missing_code,
    sum(description ='') as missing_description,
    sum(base_cost ='') as missing_base_cost,
    sum(reason_code ='') as missing_reason_code,
    sum(reason_description ='') as missing_reason_description
FROM procedures;
    
-- validate counts
SELECT COUNT(*)
FROM procedures
WHERE reason_description = '';

-- review duplicates in encounters tables
select encounter_id, count(*) as duplicate_encounters
from encounters
group by encounter_id
having count(*)>1;

-- review duplicates in patients tables
select patient_id, count(*) as duplicate_patients
from patients
group by patient_id
having count(*)>1;

-- review duplicates in payer tables
select payer_id, count(*) as duplicate_payer
from payers
group by payer_id
having count(*)>1;

-- review duplicates in procedures tables
select encounter_id, patient_id, start_date_time, stop_date_time, code, description, base_cost, count(*) as duplicate_procedures
from procedures
group by encounter_id, patient_id, start_date_time, stop_date_time, code, description, base_cost
having count(*)>1;


-- date quality checks for invalid date order in procedures table
select *
from procedures
where stop_date_time < start_date_time;

-- date quality checks for invalid date order in encounters table
select *
from encounters
where stop_date_time < start_date_time;

-- date quality checks for invalid date order in patients table
select *
from patients
where death_date < birth_date;

-- date quality checks for any birth_dates in the future
select *
from patients
where birth_date > current_date();

-- check data types for the tables
describe encounters;
describe organizations;
describe patients;
describe payers;
describe procedures;

-- describe relationships between the encounters table and the other tables using joins and the primary and foreign keys
-- encounters to patients table
select count(*) as encounters_w_o_patients
from encounters e
left join patients p 
	on e.patient_id = p.patient_id
where p.patient_id is null;

-- encounters to payers table
select count(*) as encounters_w_o_payers
from encounters e
left join payers py 
	on e.payer_id = py.payer_id
where py.payer_id is null;

-- encounters to organizations table
select count(*) as encounters_w_o_organizations
from encounters e
left join organizations o 
	on e.organization_id = o.organization_id
where o.organization_id is null;

-- procedures to encounters table
select count(*) as encounters_w_o_procedures
from procedures pr 
left join encounters e 
	on pr.encounter_id = e.encounter_id
where e.encounter_id is null;

-- procedures to patients table
select count(*) as patients_w_o_procedures
from procedures pr 
left join patients p 
	on pr.patient_id = p.patient_id
where p.patient_id is null;

-- data analysis
-- encounter volume trends
select
    year(start_date_time) as encounter_year,
    COUNT(encounter_id) as encounter_count
from encounters
group by encounter_year
order by encounter_year;

-- which encounter_class is the largest - ambulatory is the largest - inpatient is the lowest
select
	encounter_class, count(*) as class_count
from encounters
group by encounter_class
order by class_count;

-- how do total claim costs vary across encounter classes?
select
	encounter_class, sum(total_claim_cost) as total_encounter_class_cost
from encounters
group by encounter_class
order by total_encounter_class_cost desc;

-- how much payer coverage is recorded, and how many encounters have zero recorded payer coverage?
-- how much payer coverage is recorded?
select
	sum(payer_coverage) as total_payer_coverage
from encounters;
-- how many encounters have zero recorded payer coverage?
select count(encounter_id)
from encounters
where payer_coverage = 0;

-- which procedures occur most frequently? 
select
	description, count(description) as procedure_count
from procedures
group by description
order by procedure_count desc;
-- spontaneous breach delievry occurs least frequently, while assessment of health and social care needs are the most frequently occurring procedures

-- which procedures have the highest average base cost, considering both frequency and the limitations of the data?
select
	description, round(avg(base_cost), 2) as avg_procedure_base_cost
from procedures
group by description
order by avg_procedure_base_cost desc
limit 10;
-- admit to ICU procedure has the highest average base cost

-- how do average total claim costs vary by payer?

select py.payer_name, count(*) as encounter_count, round(avg(total_claim_cost), 2) as avg_claim_cost
from encounters e
left join payers py 
	on e.payer_id = py.payer_id
group by py.payer_name
order by avg_claim_cost desc;

-- Power BI KPI validation 
-- Total Encounters
select count(distinct encounter_id) as total_encounters
from encounters;

-- Total Claim Cost and Average Claim Cost
select sum(total_claim_cost) as total_claim_cost, round(avg(total_claim_cost),2) as avg_claim_cost
from encounters;

-- Total Payer Coverage and Average Payer Coverage
select sum(payer_coverage) as total_payer_coverage, round(avg(payer_coverage),2) as avg_payer_coverage
from encounters;

-- Coverage Percentage
select round(sum(payer_coverage) / sum(total_claim_cost) * 100,2) as coverage_percentage
from encounters;

-- Total Procedures
