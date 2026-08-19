/*
============================================================
HOSPITAL SQL ANALYSIS
05 - TIME SERIES ANALYSIS
============================================================

Focus:
- Date extraction
- Daily admission trends
- Yearly admission trends
- First and last admission dates
- Daily admission statistics
- Period-over-period comparison

============================================================
*/


-- =========================================================
-- Time-Series Analysis 01
-- Admissions by day of the month
-- =========================================================

SELECT
    DAY(admission_date) AS day_number,
    COUNT(*) AS admission_count
FROM admissions
GROUP BY DAY(admission_date)
ORDER BY
    day_number;


-- =========================================================
-- Time-Series Analysis 02
-- Daily admission volume
-- =========================================================

SELECT
    admission_date,
    COUNT(*) AS admission_count
FROM admissions
GROUP BY admission_date
ORDER BY admission_date;


-- =========================================================
-- Time-Series Analysis 03
-- Admissions by year
-- =========================================================

SELECT
    YEAR(admission_date) AS admission_year,
    COUNT(*) AS admission_count
FROM admissions
GROUP BY YEAR(admission_date)
ORDER BY admission_year;


-- =========================================================
-- Time-Series Analysis 04
-- Admissions by year and month
-- =========================================================

SELECT
    YEAR(admission_date) AS admission_year,
    MONTH(admission_date) AS admission_month,
    COUNT(*) AS admission_count
FROM admissions
GROUP BY
    YEAR(admission_date),
    MONTH(admission_date)
ORDER BY
    admission_year,
    admission_month;


-- =========================================================
-- Time-Series Analysis 05
-- First and last admission date for each doctor
-- =========================================================

SELECT
    d.doctor_id,
    CONCAT(
        d.first_name,
        ' ',
        d.last_name
    ) AS doctor_name,

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
-- Time-Series Analysis 06
-- Maximum, minimum and average daily admissions
-- =========================================================

SELECT
    MAX(daily_admissions) AS maximum_daily_admissions,
    MIN(daily_admissions) AS minimum_daily_admissions,
    ROUND(
        AVG(daily_admissions),
        2
    ) AS average_daily_admissions

FROM (
    SELECT
        admission_date,
        COUNT(*) AS daily_admissions
    FROM admissions
    GROUP BY admission_date
) AS daily_summary;


-- =========================================================
-- Time-Series Analysis 07
-- Daily admission volume with previous-date comparison
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

    LAG(admission_count) OVER (
        ORDER BY admission_date
    ) AS previous_admission_count,

    admission_count
        - LAG(admission_count) OVER (
            ORDER BY admission_date
          ) AS admission_count_change

FROM daily_admissions
ORDER BY admission_date;


-- =========================================================
-- Time-Series Analysis 08
-- Yearly admission volume by doctor
-- =========================================================

SELECT
    d.doctor_id,

    CONCAT(
        d.first_name,
        ' ',
        d.last_name
    ) AS doctor_name,

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
