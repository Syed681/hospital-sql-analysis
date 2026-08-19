````markdown id="f4pj8w"
# Hospital SQL Analysis — Insights

## Purpose

This document translates the SQL analysis into business-oriented observations.

The numerical results should be obtained by executing the SQL queries against the actual Hospital database.

No numerical findings are fabricated in this document.

---

# 1. Patient Demographics

The `patients` table provides demographic information including:

- Gender
- Birth date
- Height
- Weight
- City
- Province
- Allergies

These attributes can be used to understand the overall patient population and create different patient segments.

### Analytical Value

Patient demographics provide the foundation for analyzing admission behavior and healthcare utilization.

---

# 2. Geographic Distribution

Patients can be grouped by city and province using:

```text
patients
    ↓
province_names
````

This allows the analysis to identify how patients are distributed geographically.

### Analytical Value

Geographic analysis can help identify areas with higher concentrations of patients and compare admission activity across provinces.

---

# 3. Allergy Analysis

Allergy information can be grouped and counted to identify frequently recorded allergies.

When analyzing actual allergy records, `NULL` and values such as `NKA` should be excluded from the allergy distribution.

### Analytical Value

This demonstrates how categorical patient attributes can be transformed into useful summary statistics.

---

# 4. Doctor Admission Volume

The `doctors` and `admissions` tables can be joined to calculate admission volume by doctor.

### Analytical Value

Doctor-level admission counts provide a measure of admission activity associated with each doctor.

Higher admission volume should not automatically be interpreted as better or worse performance. It is primarily an operational metric requiring additional context.

---

# 5. Patient Admission History

A single patient can have multiple admission records.

Therefore:

```text
1 patient
    ↓
multiple admissions
```

This distinction is important when calculating patient counts and admission counts.

### Analytical Value

Patients with multiple admissions can be identified and analyzed separately from patients with only one admission.

---

# 6. Diagnosis Analysis

The `diagnosis` column in the `admissions` table allows diagnosis-level analysis.

Possible analysis includes:

* Most common diagnoses
* Patient-diagnosis combinations
* Repeated diagnoses
* Diagnosis trends over time

### Analytical Value

Diagnosis-level aggregation provides another dimension for understanding admission activity.

---

# 7. Length of Stay

Length of stay can be calculated using:

```text
Discharge Date - Admission Date
```

In SQL:

```sql
DATEDIFF(
    discharge_date,
    admission_date
)
```

### Analytical Value

Length of stay provides an operational measure of how long patients remain admitted.

It can potentially be compared by:

* Diagnosis
* Doctor
* Time period
* Patient group

---

# 8. Daily Admission Activity

Admissions can be grouped by `admission_date` to calculate daily admission volume.

Example:

```sql
SELECT
    admission_date,
    COUNT(*) AS admission_count
FROM admissions
GROUP BY admission_date;
```

### Analytical Value

Daily admission volume provides the foundation for time-series analysis.

---

# 9. Previous-Day Admission Comparison

The `LAG()` window function allows each day's admission count to be compared with the previous available date.

Conceptually:

```text
Current admissions
        -
Previous admissions
        =
Admission change
```

### Analytical Value

This identifies increases and decreases in admission activity between consecutive recorded dates.

---

# 10. Doctor Ranking

Doctors can be ranked according to admission volume using window functions such as:

```sql
RANK()
```

or:

```sql
DENSE_RANK()
```

### Analytical Value

Ranking makes it easier to identify doctors associated with relatively high or low admission activity.

---

# 11. Doctor Contribution

Each doctor's admission volume can also be expressed as a percentage of total admissions.

Conceptually:

```text
Doctor Admissions
----------------- × 100
Total Admissions
```

### Analytical Value

Percentage contribution provides additional context beyond raw admission counts.

---

# 12. Above-Average Doctor Analysis

A CTE can be used to calculate total admissions for each doctor and then compare each doctor against the average doctor admission volume.

### Analytical Value

This identifies doctors whose admission activity is above the calculated benchmark.

The result should be treated as an analytical signal rather than a performance judgment.

---

# 13. Patient Weight Groups

Patients can be grouped into weight ranges using expressions such as:

```sql
FLOOR(weight / 10) * 10
```

### Analytical Value

Grouping continuous numerical values into ranges makes it easier to analyze the distribution of patient weights.

---

# 14. BMI Analysis

BMI can be calculated using:

```text
BMI = weight(kg) / height(m)^2
```

The exercise uses:

```text
BMI >= 30
```

as the obesity classification threshold.

### Analytical Value

This demonstrates how multiple patient attributes can be transformed into a derived analytical metric using SQL.

### Limitation

This is a SQL analysis exercise and should not be treated as a clinical assessment.

---

# 15. Admission Cost Logic

One exercise applies the following assumption:

```text
Even patient_id → insured → $10
Odd patient_id  → uninsured → $50
```

This is implemented using a `CASE` expression.

### Analytical Value

The example demonstrates how business rules can be converted into SQL logic.

### Limitation

The insurance rule is an exercise assumption and does not represent a real insurance policy.

---

# 16. Province-Level Gender Analysis

Patients can be grouped by province and gender to compare male and female patient counts.

### Analytical Value

This demonstrates conditional aggregation and allows geographic demographic comparisons.

---

# 17. Time-Series Analysis

The database supports several levels of time analysis:

```text
Daily
  ↓
Monthly
  ↓
Yearly
```

SQL date functions such as:

```sql
DAY()
MONTH()
YEAR()
```

can be used to extract the required time dimensions.

### Analytical Value

Time-series analysis helps identify changes in admission activity over time.

---

# 18. Running Total Analysis

A window function can calculate cumulative admissions over time.

Conceptually:

```text
Day 1 → admissions
Day 2 → Day 1 + Day 2
Day 3 → Day 1 + Day 2 + Day 3
...
```

### Analytical Value

Running totals provide a cumulative view of hospital admission activity.

---

# Key SQL Lessons

This project demonstrates several important SQL principles.

## 1. Understand Table Grain

Before aggregating data, determine what one row represents.

```text
patients
→ one row = one patient

doctors
→ one row = one doctor

admissions
→ one row = one admission
```

---

## 2. Understand Join Multiplication

Joining tables with different grains can increase the number of rows.

Therefore, aggregation must be performed at the correct level.

---

## 3. Distinguish Patients From Admissions

These are different metrics:

```sql
COUNT(DISTINCT patient_id)
```

counts unique patients.

```sql
COUNT(patient_id)
```

on the admissions table counts admission records.

---

## 4. Use the Correct Join

The required business question determines whether to use:

```text
INNER JOIN
```

or:

```text
LEFT JOIN
```

For example, a `LEFT JOIN` from doctors to admissions allows doctors with zero admissions to remain in the result.

---

## 5. Use Window Functions for Row-Level Comparisons

Window functions are useful when the query needs to compare rows without collapsing the result set.

Examples:

```text
RANK()
DENSE_RANK()
LAG()
SUM() OVER()
```

---

# Overall Project Takeaway

The Hospital SQL project demonstrates progression from basic querying to analytical SQL.

The project covers:

```text
Basic SQL
    ↓
Filtering
    ↓
Joins
    ↓
Aggregation
    ↓
Subqueries
    ↓
CTEs
    ↓
Window Functions
    ↓
Time-Series Analysis
    ↓
Advanced Analytical SQL
    ↓
Business Interpretation
```

The main objective is not simply to write SQL syntax, but to demonstrate the ability to translate business questions into structured analytical queries.

---

# Skills Demonstrated

* SQL querying
* Relational database analysis
* Data filtering
* NULL handling
* String functions
* Date functions
* INNER JOIN
* LEFT JOIN
* UNION
* Aggregation
* Conditional aggregation
* GROUP BY
* HAVING
* Subqueries
* Correlated subqueries
* CTEs
* Window functions
* Ranking
* Time-series analysis
* Running totals
* Percentage calculations
* Patient analysis
* Doctor analysis
* Admission analysis
* Business problem solving

---

# Future Extensions

Potential future extensions include:

* Patient readmission analysis
* Diagnosis trends
* Doctor workload analysis
* Length-of-stay benchmarking
* Monthly admission trends
* Patient cohort analysis
* Hospital KPI analysis
* SQL-to-Power BI integration

---
