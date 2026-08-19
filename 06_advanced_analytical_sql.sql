/*
============================================================
HOSPITAL SQL ANALYSIS
06 - ADVANCED ANALYTICAL SQL
============================================================

Questions:
Q44 - Q54

Topics:
- CASE expressions
- Conditional aggregation
- CTEs
- Window functions
- Ranking
- Percentage calculations
- Patient analysis
- Doctor analysis
- Length-of-stay analysis
- Advanced business logic

IMPORTANT:
The original H1-H15 questions are not available in the
current project material. They are NOT fabricated here.

============================================================
*/


-- =========================================================
-- Q44
-- Group patients into weight groups
-- =========================================================

SELECT
    FLOOR(weight / 10) * 10 AS weight_group,
    COUNT(*) AS total_patients
FROM patients
GROUP BY FLOOR(weight / 10) * 10
ORDER BY weight_group DESC;


-- =========================================================
-- Q45
-- Calculate BMI and classify patients as obese
--
-- BMI = weight(kg) / height(m)^2
--
-- Obesity threshold used by the exercise:
-- BMI >= 30
-- =========================================================

SELECT
    patient_id,
    weight,
    height,

    ROUND(
        weight / POWER(height / 100.0, 2),
        2
    ) AS bmi,

    CASE
        WHEN weight / POWER(height / 100.0, 2) >= 30
            THEN 1
        ELSE 0
    END AS isObese

FROM patients;


-- =========================================================
-- Q46
-- Find Dementia patients treated by doctors named Lisa
-- =========================================================

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    d.specialty

FROM patients AS p

JOIN admissions AS a
    ON p.patient_id = a.patient_id

JOIN doctors AS d
    ON a.attending_doctor_id = d.doctor_id

WHERE a.diagnosis = 'Dementia'
  AND d.first_name = 'Lisa';


-- =========================================================
-- Q47
-- Generate temporary password using:
--
-- patient_id
-- + last name length
-- + birth year
-- =========================================================

SELECT DISTINCT
    p.patient_id,

    CONCAT(
        p.patient_id,
        LENGTH(p.last_name),
        YEAR(p.birth_date)
    ) AS temp_password

FROM patients AS p

JOIN admissions AS a
    ON p.patient_id = a.patient_id;


-- =========================================================
-- Q48
-- Calculate admission cost based on exercise assumption:
--
-- Even patient_id = insured = $10
-- Odd patient_id  = uninsured = $50
-- =========================================================

SELECT
    patient_id,
    admission_date,
    discharge_date,
    diagnosis,
    attending_doctor_id,

    CASE
        WHEN patient_id % 2 = 0 THEN 10
        ELSE 50
    END AS cost

FROM admissions;


-- =========================================================
-- Q49
-- Find provinces with more male patients than female patients
-- =========================================================

SELECT
    pn.province_name

FROM province_names AS pn

JOIN patients AS p
    ON pn.province_id = p.province_id

GROUP BY pn.province_name

HAVING
    SUM(
        CASE
            WHEN p.gender = 'M' THEN 1
            ELSE 0
        END
    )
    >
    SUM(
        CASE
            WHEN p.gender = 'F' THEN 1
            ELSE 0
        END
    );


-- =========================================================
-- Q50
-- Find female patients satisfying all conditions:
--
-- First name has 'r' as the third character
-- Birth month is February, May, or December
-- Weight between 60 and 80
-- Patient ID is odd
-- City is Kingston
-- =========================================================

SELECT *
FROM patients
WHERE first_name LIKE '__r%'
  AND gender = 'F'
  AND MONTH(birth_date) IN (2, 5, 12)
  AND weight BETWEEN 60 AND 80
  AND patient_id % 2 <> 0
  AND city = 'Kingston';


-- =========================================================
-- Q51
-- Calculate percentage of male patients
-- =========================================================

SELECT
    ROUND(
        SUM(
            CASE
                WHEN gender = 'M' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS percent_male_patients

FROM patients;


-- =========================================================
-- Q52
-- Show daily admissions and change from previous date
-- =========================================================

WITH daily_admissions AS (

    SELECT
        admission_date,
        COUNT(*) AS admission_count

    FROM admissions

    GROUP BY admission_date
)

SELECT
    admission_date,
    admission_count,

    admission_count
        - LAG(admission_count) OVER (
            ORDER BY admission_date
          ) AS admission_count_change

FROM daily_admissions

ORDER BY admission_date;


-- =========================================================
-- Q53
-- Sort provinces with Ontario first
-- =========================================================

SELECT
    province_name

FROM province_names

ORDER BY
    CASE
        WHEN province_name = 'Ontario' THEN 0
        ELSE 1
    END,
    province_name;


-- =========================================================
-- Q54
-- Show yearly admission count for each doctor
-- =========================================================

SELECT
    d.doctor_id,

    CONCAT(
        d.first_name,
        ' ',
        d.last_name
    ) AS doctor_full_name,

    d.specialty,

    YEAR(a.admission_date) AS admission_year,

    COUNT(a.admission_date) AS total_admissions

FROM doctors AS d

LEFT JOIN admissions AS a
    ON d.doctor_id = a.attending_doctor_id

GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name,
    d.specialty,
    YEAR(a.admission_date)

ORDER BY
    d.doctor_id,
    admission_year;


-- =========================================================
-- ADVANCED ANALYSIS 01
-- Rank doctors by admission volume
-- =========================================================

WITH doctor_admissions AS (

    SELECT
        d.doctor_id,

        CONCAT(
            d.first_name,
            ' ',
            d.last_name
        ) AS doctor_name,

        d.specialty,

        COUNT(a.patient_id) AS total_admissions

    FROM doctors AS d

    LEFT JOIN admissions AS a
        ON d.doctor_id = a.attending_doctor_id

    GROUP BY
        d.doctor_id,
        d.first_name,
        d.last_name,
        d.specialty
)

SELECT
    doctor_id,
    doctor_name,
    specialty,
    total_admissions,

    RANK() OVER (
        ORDER BY total_admissions DESC
    ) AS admission_rank

FROM doctor_admissions

ORDER BY admission_rank;


-- =========================================================
-- ADVANCED ANALYSIS 02
-- Rank patients by admission count
-- =========================================================

WITH patient_admissions AS (

    SELECT
        p.patient_id,

        CONCAT(
            p.first_name,
            ' ',
            p.last_name
        ) AS patient_name,

        COUNT(a.patient_id) AS total_admissions

    FROM patients AS p

    JOIN admissions AS a
        ON p.patient_id = a.patient_id

    GROUP BY
        p.patient_id,
        p.first_name,
        p.last_name
)

SELECT
    patient_id,
    patient_name,
    total_admissions,

    DENSE_RANK() OVER (
        ORDER BY total_admissions DESC
    ) AS admission_rank

FROM patient_admissions

ORDER BY admission_rank;


-- =========================================================
-- ADVANCED ANALYSIS 03
-- Calculate length of stay for each admission
-- =========================================================

SELECT
    patient_id,
    admission_date,
    discharge_date,
    DATEDIFF(
        discharge_date,
        admission_date
    ) AS length_of_stay_days

FROM admissions

ORDER BY length_of_stay_days DESC;


-- =========================================================
-- ADVANCED ANALYSIS 04
-- Calculate running total of admissions
-- =========================================================

WITH daily_admissions AS (

    SELECT
        admission_date,
        COUNT(*) AS admission_count

    FROM admissions

    GROUP BY admission_date
)

SELECT
    admission_date,
    admission_count,

    SUM(admission_count) OVER (
        ORDER BY admission_date
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS running_total_admissions

FROM daily_admissions

ORDER BY admission_date;


-- =========================================================
-- ADVANCED ANALYSIS 05
-- Calculate each doctor's percentage contribution
-- to total admissions
-- =========================================================

WITH doctor_admissions AS (

    SELECT
        d.doctor_id,

        CONCAT(
            d.first_name,
            ' ',
            d.last_name
        ) AS doctor_name,

        COUNT(a.patient_id) AS total_admissions

    FROM doctors AS d

    LEFT JOIN admissions AS a
        ON d.doctor_id = a.attending_doctor_id

    GROUP BY
        d.doctor_id,
        d.first_name,
        d.last_name
)

SELECT
    doctor_id,
    doctor_name,
    total_admissions,

    ROUND(
        total_admissions * 100.0
        / SUM(total_admissions) OVER (),
        2
    ) AS admission_percentage

FROM doctor_admissions

ORDER BY admission_percentage DESC;


-- =========================================================
-- ADVANCED ANALYSIS 06
-- Find doctors whose admission volume is above
-- the average doctor admission volume
-- =========================================================

WITH doctor_admissions AS (

    SELECT
        d.doctor_id,

        CONCAT(
            d.first_name,
            ' ',
            d.last_name
        ) AS doctor_name,

        COUNT(a.patient_id) AS total_admissions

    FROM doctors AS d

    LEFT JOIN admissions AS a
        ON d.doctor_id = a.attending_doctor_id

    GROUP BY
        d.doctor_id,
        d.first_name,
        d.last_name
),

average_admissions AS (

    SELECT
        AVG(total_admissions) AS avg_admissions

    FROM doctor_admissions
)

SELECT
    da.doctor_id,
    da.doctor_name,
    da.total_admissions

FROM doctor_admissions AS da

CROSS JOIN average_admissions AS aa

WHERE da.total_admissions > aa.avg_admissions

ORDER BY da.total_admissions DESC;


/*
============================================================
H1 - H15
============================================================

The original H1-H15 questions are not available in the
current conversation material.

They will be added here once the original questions and
solutions are available.

No questions have been fabricated.

============================================================
*/
