/*
============================================================
HOSPITAL SQL ANALYSIS
04 - WINDOW FUNCTIONS
============================================================

Focus:
- LAG()
- RANK()
- DENSE_RANK()
- PARTITION BY
- Previous-period comparison
- Analytical ranking

============================================================
*/


-- =========================================================
-- Q52
-- Show daily admissions and the change from the
-- previous admission date
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
-- Additional Window Analysis 01
-- Rank doctors by total admission volume
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

    RANK() OVER (
        ORDER BY total_admissions DESC
    ) AS admission_rank

FROM doctor_admissions
ORDER BY admission_rank;


-- =========================================================
-- Additional Window Analysis 02
-- Rank doctors within each specialty
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
        PARTITION BY specialty
        ORDER BY total_admissions DESC
    ) AS specialty_rank

FROM doctor_admissions
ORDER BY
    specialty,
    specialty_rank;


-- =========================================================
-- Additional Window Analysis 03
-- Rank patients by number of admissions
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
-- Additional Window Analysis 04
-- Calculate a running total of admissions
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
