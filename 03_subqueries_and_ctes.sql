/*
============================================================
HOSPITAL SQL ANALYSIS
03 - SUBQUERIES AND CTES
============================================================

Questions:
Q32 - Q43

Topics:
- Subqueries
- Correlated subqueries
- Derived tables
- NOT EXISTS
- GROUP BY
- HAVING
- Aggregation
- Multi-table joins
- Date analysis

============================================================
*/


-- =========================================================
-- Q32
-- Show number of admissions for each day of the month
-- =========================================================

SELECT
    DAY(admission_date) AS day_number,
    COUNT(*) AS number_of_admissions
FROM admissions
GROUP BY DAY(admission_date)
ORDER BY number_of_admissions DESC;


-- =========================================================
-- Q33
-- Find the most recent admission for patient 542
-- =========================================================

SELECT *
FROM admissions
WHERE patient_id = 542
ORDER BY admission_date DESC
LIMIT 1;


-- =========================================================
-- Q34
-- Find admissions where:
--
-- Condition 1:
-- Patient ID is odd AND doctor ID is 1, 5, or 19
--
-- OR
--
-- Condition 2:
-- Doctor ID contains 2 AND patient ID has 3 digits
-- =========================================================

SELECT
    patient_id,
    attending_doctor_id,
    diagnosis
FROM admissions
WHERE (
        patient_id % 2 <> 0
        AND attending_doctor_id IN (1, 5, 19)
      )
   OR (
        CAST(attending_doctor_id AS CHAR) LIKE '%2%'
        AND LENGTH(CAST(patient_id AS CHAR)) = 3
      );


-- =========================================================
-- Q35
-- Show the total number of admissions attended by
-- each doctor
-- =========================================================

SELECT
    d.doctor_id,
    d.first_name,
    d.last_name,
    COUNT(a.patient_id) AS total_admissions
FROM doctors AS d
LEFT JOIN admissions AS a
    ON d.doctor_id = a.attending_doctor_id
GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name
ORDER BY total_admissions DESC;


-- =========================================================
-- Q36
-- Find the first and last admission date for each doctor
-- =========================================================

SELECT
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS full_name,
    MIN(a.admission_date) AS first_admission_date,
    MAX(a.admission_date) AS last_admission_date
FROM doctors AS d
LEFT JOIN admissions AS a
    ON d.doctor_id = a.attending_doctor_id
GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name
ORDER BY d.doctor_id;


-- =========================================================
-- Q37
-- Show the total number of patients in each province
-- =========================================================

SELECT
    pn.province_name,
    COUNT(p.patient_id) AS patient_count
FROM province_names AS pn
JOIN patients AS p
    ON pn.province_id = p.province_id
GROUP BY pn.province_name
ORDER BY patient_count DESC;


-- =========================================================
-- Q38
-- Show patient name, diagnosis, and attending doctor
-- =========================================================

SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    a.diagnosis,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name
FROM admissions AS a
JOIN patients AS p
    ON a.patient_id = p.patient_id
JOIN doctors AS d
    ON a.attending_doctor_id = d.doctor_id;


-- =========================================================
-- Q39
-- Find patients with duplicate first and last names
-- =========================================================

SELECT
    first_name,
    last_name,
    COUNT(*) AS num_of_duplicates
FROM patients
GROUP BY
    first_name,
    last_name
HAVING COUNT(*) > 1;


-- =========================================================
-- Q40
-- Display:
-- - Patient name
-- - Height in feet
-- - Weight in pounds
-- - Birth date
-- - Full gender
-- =========================================================

SELECT
    CONCAT(first_name, ' ', last_name) AS patient_name,

    ROUND(
        height / 30.48,
        1
    ) AS height_feet,

    ROUND(
        weight * 2.205,
        0
    ) AS weight_pounds,

    birth_date,

    CASE
        WHEN gender = 'M' THEN 'Male'
        WHEN gender = 'F' THEN 'Female'
    END AS gender_type

FROM patients;


-- =========================================================
-- Q41
-- Find patients who have never been admitted
-- =========================================================

SELECT
    p.patient_id,
    p.first_name,
    p.last_name
FROM patients AS p
WHERE NOT EXISTS (
    SELECT a.patient_id
    FROM admissions AS a
    WHERE a.patient_id = p.patient_id
);


-- =========================================================
-- Q42
-- Find:
-- - Maximum number of admissions in a day
-- - Minimum number of admissions in a day
-- - Average number of admissions per day
-- =========================================================

SELECT
    MAX(visits_count) AS max_visits,
    MIN(visits_count) AS min_visits,
    ROUND(
        AVG(visits_count),
        2
    ) AS average_visits
FROM (
    SELECT
        admission_date,
        COUNT(*) AS visits_count
    FROM admissions
    GROUP BY admission_date
) AS daily_visits;


-- =========================================================
-- Q43
-- Find the most recent admission for every patient
-- =========================================================

SELECT
    CONCAT(
        p.first_name,
        ' ',
        p.last_name
    ) AS patient_name,

    a.admission_date,

    CONCAT(
        d.first_name,
        ' ',
        d.last_name
    ) AS doctor_name

FROM patients AS p

JOIN admissions AS a
    ON p.patient_id = a.patient_id

JOIN doctors AS d
    ON a.attending_doctor_id = d.doctor_id

WHERE a.admission_date = (
    SELECT MAX(a2.admission_date)
    FROM admissions AS a2
    WHERE a2.patient_id = p.patient_id
);
