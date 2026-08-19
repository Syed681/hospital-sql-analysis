/*
============================================================
HOSPITAL SQL ANALYSIS
02 - JOINS AND AGGREGATION
============================================================

Questions:
Q17 - Q31

Topics:
- DISTINCT
- GROUP BY
- HAVING
- INNER JOIN
- UNION
- COUNT
- SUM
- MIN
- MAX
- Conditional aggregation
- String functions
- Filtering

============================================================
*/


-- =========================================================
-- Q17
-- Show unique birth years of patients
-- =========================================================

SELECT DISTINCT
    YEAR(birth_date) AS birth_year
FROM patients
ORDER BY YEAR(birth_date) ASC;


-- =========================================================
-- Q18
-- Show first names that occur only once
-- =========================================================

SELECT
    first_name
FROM patients
GROUP BY first_name
HAVING COUNT(*) = 1;


-- =========================================================
-- Q19
-- Show patients whose first name:
-- - starts with s
-- - ends with s
-- - contains at least 6 characters
-- =========================================================

SELECT
    patient_id,
    first_name
FROM patients
WHERE first_name LIKE 's%s'
  AND LENGTH(first_name) >= 6;


-- =========================================================
-- Q20
-- Show patients who have been diagnosed with Dementia
-- =========================================================

SELECT
    p.patient_id,
    p.first_name,
    p.last_name
FROM patients AS p
JOIN admissions AS a
    ON p.patient_id = a.patient_id
WHERE a.diagnosis = 'Dementia';


-- =========================================================
-- Q21
-- Sort first names by:
-- 1. Length
-- 2. Alphabetical order
-- =========================================================

SELECT
    first_name
FROM patients
ORDER BY
    LENGTH(first_name),
    first_name;


-- =========================================================
-- Q22
-- Display male and female patient counts in one row
-- =========================================================

SELECT
    SUM(
        CASE
            WHEN gender = 'M' THEN 1
            ELSE 0
        END
    ) AS male_count,

    SUM(
        CASE
            WHEN gender = 'F' THEN 1
            ELSE 0
        END
    ) AS female_count
FROM patients;


-- =========================================================
-- Q23
-- Find patients allergic to Penicillin or Morphine
-- =========================================================

SELECT
    first_name,
    last_name,
    allergies
FROM patients
WHERE allergies IN ('Penicillin', 'Morphine')
ORDER BY
    allergies ASC,
    first_name ASC,
    last_name ASC;


-- =========================================================
-- Q24
-- Find patient-diagnosis combinations occurring
-- more than once
-- =========================================================

SELECT
    patient_id,
    diagnosis
FROM admissions
GROUP BY
    patient_id,
    diagnosis
HAVING COUNT(*) > 1;


-- =========================================================
-- Q25
-- Count patients in each city
-- =========================================================

SELECT
    city,
    COUNT(*) AS total_patients
FROM patients
GROUP BY city
ORDER BY
    total_patients DESC,
    city ASC;


-- =========================================================
-- Q26
-- Combine patients and doctors into one result
-- =========================================================

SELECT
    first_name,
    last_name,
    'Patient' AS role
FROM patients

UNION

SELECT
    first_name,
    last_name,
    'Doctor' AS role
FROM doctors;


-- =========================================================
-- Q27
-- Show allergies ordered by number of patients
-- Exclude NULL and NKA
-- =========================================================

SELECT
    allergies,
    COUNT(*) AS total_patients
FROM patients
WHERE allergies IS NOT NULL
  AND allergies <> 'NKA'
GROUP BY allergies
ORDER BY total_patients DESC;


-- =========================================================
-- Q28
-- Show patients born during the 1970s
-- =========================================================

SELECT
    first_name,
    last_name,
    birth_date
FROM patients
WHERE YEAR(birth_date) BETWEEN 1970 AND 1979
ORDER BY birth_date ASC;


-- =========================================================
-- Q29
-- Display last name in uppercase and first name
-- in lowercase
-- =========================================================

SELECT
    CONCAT(
        UPPER(last_name),
        ' ',
        LOWER(first_name)
    ) AS full_name
FROM patients
ORDER BY first_name DESC;


-- =========================================================
-- Q30
-- Find provinces where the total patient height
-- is at least 7000
-- =========================================================

SELECT
    province_id,
    SUM(height) AS sum_height
FROM patients
GROUP BY province_id
HAVING SUM(height) >= 7000;


-- =========================================================
-- Q31
-- Find the difference between maximum and minimum
-- weight for patients with the last name Maroni
-- =========================================================

SELECT
    MAX(weight) - MIN(weight) AS weight_difference
FROM patients
WHERE last_name = 'Maroni';
