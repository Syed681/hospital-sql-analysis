/*
============================================================
HOSPITAL SQL ANALYSIS
01 - BASIC QUERIES
============================================================

Questions:
Q01 - Q16

Topics:
- SELECT
- WHERE
- DISTINCT
- ORDER BY
- LIMIT
- IN
- BETWEEN
- LIKE
- NULL handling
- String functions
- Date functions

============================================================
*/


-- =========================================================
-- Q01
-- Show first name, last name, and gender of male patients
-- =========================================================

SELECT
    first_name,
    last_name,
    gender
FROM patients
WHERE gender = 'M';


-- =========================================================
-- Q02
-- Show patients who have no allergies recorded
-- =========================================================

SELECT
    first_name,
    last_name
FROM patients
WHERE allergies IS NULL;


-- =========================================================
-- Q03
-- Show patients whose first name starts with C
-- =========================================================

SELECT
    first_name
FROM patients
WHERE first_name LIKE 'C%';


-- =========================================================
-- Q04
-- Show patients whose weight is between 100 and 120
-- =========================================================

SELECT
    first_name,
    last_name,
    weight
FROM patients
WHERE weight BETWEEN 100 AND 120;


-- =========================================================
-- Q05
-- Replace NULL allergies with NKA
-- =========================================================

UPDATE patients
SET allergies = 'NKA'
WHERE allergies IS NULL;


-- =========================================================
-- Q06
-- Display patient first name and last name as one full name
-- =========================================================

SELECT
    CONCAT(first_name, ' ', last_name) AS full_name
FROM patients;


-- =========================================================
-- Q07
-- Display patient name along with full province name
-- =========================================================

SELECT
    p.first_name,
    p.last_name,
    pn.province_name
FROM patients AS p
JOIN province_names AS pn
    ON p.province_id = pn.province_id;


-- =========================================================
-- Q08
-- Count patients born in 2010
-- =========================================================

SELECT
    COUNT(*) AS total_patients
FROM patients
WHERE YEAR(birth_date) = 2010;


-- =========================================================
-- Q09
-- Find the patient with the greatest height
-- =========================================================

SELECT
    first_name,
    last_name,
    height
FROM patients
ORDER BY height DESC
LIMIT 1;


-- =========================================================
-- Q10
-- Show patients with the specified patient IDs
-- =========================================================

SELECT *
FROM patients
WHERE patient_id IN (1, 45, 534, 879, 1000);


-- =========================================================
-- Q11
-- Count the total number of admissions
-- =========================================================

SELECT
    COUNT(*) AS total_admissions
FROM admissions;


-- =========================================================
-- Q12
-- Find admissions where admission and discharge
-- occurred on the same day
-- =========================================================

SELECT *
FROM admissions
WHERE admission_date = discharge_date;


-- =========================================================
-- Q13
-- Count admissions for patient 579
-- =========================================================

SELECT
    patient_id,
    COUNT(*) AS total_admissions
FROM admissions
WHERE patient_id = 579
GROUP BY patient_id;


-- =========================================================
-- Q14
-- Show unique cities for patients from province NS
-- =========================================================

SELECT DISTINCT
    city
FROM patients
WHERE province_id = 'NS';


-- =========================================================
-- Q15
-- Find patients taller than 160 and heavier than 70
-- =========================================================

SELECT
    first_name,
    last_name,
    birth_date,
    height,
    weight
FROM patients
WHERE height > 160
  AND weight > 70;


-- =========================================================
-- Q16
-- Find patients from Hamilton who have allergies recorded
-- =========================================================

SELECT
    first_name,
    last_name,
    allergies
FROM patients
WHERE allergies IS NOT NULL
  AND city = 'Hamilton';
