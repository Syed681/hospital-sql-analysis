# Hospital SQL Analysis

SQL analytics project using a relational Hospital database to solve healthcare-related business and data analysis problems.

The project progresses from foundational SQL querying to intermediate and advanced analytical SQL, covering filtering, joins, aggregation, subqueries, CTEs, window functions, time-series analysis, patient history, doctor workload, and business-oriented analysis.

---

## Project Overview

This project contains a structured collection of solved SQL problems based on a Hospital database.

The objective is to demonstrate the ability to:

* Understand relational database structure
* Retrieve and filter data
* Join multiple related tables
* Aggregate data correctly
* Use subqueries and CTEs
* Apply window functions
* Perform date and time-based analysis
* Analyze patient and admission patterns
* Translate business questions into SQL queries
* Produce analytical insights from relational data

---

## Database

**Database:** Hospital

### Tables

* `patients`
* `doctors`
* `admissions`
* `province_names`

---

## Database Relationships

```text
patients
    │
    ├── province_id
    ▼
province_names

patients
    │
    └── patient_id
            │
            ▼
       admissions
            │
            └── attending_doctor_id
                    │
                    ▼
                 doctors
```

### Key Relationships

```text
patients.province_id
        ↓
province_names.province_id
```

```text
admissions.patient_id
        ↓
patients.patient_id
```

```text
admissions.attending_doctor_id
        ↓
doctors.doctor_id
```

---

## Repository Structure

```text
hospital-sql-analysis/
│
├── README.md
├── database_schema.md
├── 01_basic_queries.sql
├── 02_joins_and_aggregation.sql
├── 03_subqueries_and_ctes.sql
├── 04_window_functions.sql
├── 05_time_series_analysis.sql
├── 06_advanced_analytical_sql.sql
└── insights.md
```

### File Description

| File                             | Purpose                                                       |
| -------------------------------- | ------------------------------------------------------------- |
| `README.md`                      | Project overview and documentation                            |
| `database_schema.md`             | Database tables, columns, relationships, and table grain      |
| `01_basic_queries.sql`           | Basic filtering, selection, NULL handling, strings, and dates |
| `02_joins_and_aggregation.sql`   | JOINs, UNION, GROUP BY, HAVING, and aggregation               |
| `03_subqueries_and_ctes.sql`     | Subqueries, derived tables, and multi-step analysis           |
| `04_window_functions.sql`        | Window-function based analysis                                |
| `05_time_series_analysis.sql`    | Date-based and time-series analysis                           |
| `06_advanced_analytical_sql.sql` | Advanced analytical SQL and business logic                    |
| `insights.md`                    | Business interpretation of the analysis                       |

---

# SQL Topics Demonstrated

## 1. Basic SQL

* `SELECT`
* `WHERE`
* `DISTINCT`
* `ORDER BY`
* `LIMIT`
* `IN`
* `BETWEEN`
* `LIKE`
* `IS NULL`
* `IS NOT NULL`

## 2. String Functions

* `CONCAT()`
* `UPPER()`
* `LOWER()`
* `LENGTH()`

## 3. Date Functions

* `YEAR()`
* `MONTH()`
* `DAY()`
* `DATEDIFF()`

## 4. Joins

* `INNER JOIN`
* `LEFT JOIN`
* Multi-table joins

## 5. Aggregation

* `COUNT()`
* `COUNT(DISTINCT)`
* `SUM()`
* `MIN()`
* `MAX()`
* `AVG()`
* `GROUP BY`
* `HAVING`

## 6. Conditional Logic

* `CASE`
* Conditional aggregation

## 7. Subqueries

* Scalar subqueries
* Correlated subqueries
* Derived tables
* `EXISTS`
* `NOT EXISTS`

## 8. CTEs

* Multi-step analytical queries
* Breaking complex logic into readable stages

## 9. Window Functions

* `ROW_NUMBER()`
* `RANK()`
* `DENSE_RANK()`
* `LAG()`
* `PARTITION BY`
* Running totals

## 10. Time-Series Analysis

* Daily admission trends
* Yearly admission analysis
* Previous-period comparisons
* Running admission totals

---

# Analysis Areas

## Patient Analysis

The project analyzes:

* Patient demographics
* Gender distribution
* Birth years
* Patient weight
* Patient height
* Allergies
* BMI-based classification
* Patient location
* Duplicate patient names
* Patients without admission records

---

## Doctor Analysis

The project analyzes:

* Doctor admission volume
* Doctor specialties
* First admission date
* Last admission date
* Doctor-level ranking
* Doctor admission activity by year
* Doctor contribution to total admissions

---

## Admission Analysis

The project analyzes:

* Total admissions
* Same-day admissions
* Patient admission history
* Diagnosis patterns
* Most recent patient admissions
* Daily admission volume
* Length of stay
* Admission changes over time
* Admission cost logic

---

## Geographic Analysis

The project analyzes:

* Patients by city
* Patients by province
* Province-level gender distribution
* Province-level patient counts
* Geographic ordering and comparison

---

# Important Analytical Concepts

## Patient Count vs Admission Count

A patient can have multiple admissions.

Therefore:

```text
Patient count ≠ Admission count
```

For unique patients:

```sql
COUNT(DISTINCT patient_id)
```

For admission records:

```sql
COUNT(patient_id)
```

The correct metric depends on the business question.

---

## Understanding Table Grain

### `patients`

```text
One row = one patient
```

### `doctors`

```text
One row = one doctor
```

### `admissions`

```text
One row = one admission record
```

### `province_names`

```text
One row = one province
```

Understanding table grain is important before performing joins and aggregations because joining tables at different grains can introduce duplicate counts.

---

# Analytical Approach

The project follows a progressive SQL analysis workflow:

```text
Business Question
       ↓
Understand Tables
       ↓
Identify Table Grain
       ↓
Select Required Columns
       ↓
Filter Records
       ↓
Join Related Tables
       ↓
Aggregate Data
       ↓
Apply Advanced SQL
       ↓
Validate Results
       ↓
Interpret Findings
```

---

# Query Organization

The SQL questions are organized by the primary SQL concepts they demonstrate.

### `01_basic_queries.sql`

Foundational querying and filtering.

### `02_joins_and_aggregation.sql`

Combining tables and summarizing data.

### `03_subqueries_and_ctes.sql`

Multi-step SQL analysis using subqueries, derived tables, and related techniques.

### `04_window_functions.sql`

Row-level analytical calculations using window functions.

### `05_time_series_analysis.sql`

Date-based analysis and admission trends.

### `06_advanced_analytical_sql.sql`

More complex analytical and business-oriented SQL problems.

---

# Data Quality and SQL Considerations

The project considers:

* NULL values
* Duplicate records
* Correct join keys
* Aggregation grain
* Unique patient counts
* Admission-level counts
* Date handling
* Conditional logic
* Window-function ordering

Queries were reviewed to improve SQL quality where necessary while preserving the original business question and intent.

---

# Assumptions

Some questions contain assumptions specifically required by the exercise.

For example:

### BMI

```text
BMI = weight(kg) / height(m)^2
```

The obesity classification used in the exercise is:

```text
BMI >= 30
```

### Admission Cost

The admission-cost exercise assumes:

```text
Even patient_id → insured → $10
Odd patient_id  → uninsured → $50
```

These are exercise assumptions and should not be interpreted as real healthcare or insurance rules.

---

# Limitations

* The analysis is limited to the supplied Hospital database.
* No external healthcare datasets are used.
* Numerical findings depend on the underlying database records.
* Exercise-specific assumptions are not intended to represent real clinical or insurance policies.
* The project is intended for SQL analytics practice and portfolio demonstration.

---

# Skills Demonstrated

This project demonstrates practical SQL capabilities in:

* Relational database querying
* Data filtering
* NULL handling
* String manipulation
* Date manipulation
* JOINs
* Aggregation
* Conditional aggregation
* Subqueries
* CTEs
* Window functions
* Ranking
* Time-series analysis
* Patient-level analysis
* Admission-level analysis
* Business problem solving

---

# Future Extensions

Potential future improvements include:

* Patient readmission analysis
* Doctor workload analysis
* Diagnosis-level trends
* Length-of-stay benchmarking
* Monthly admission trends
* Patient cohort analysis
* Hospital KPI analysis
* Power BI visualization

---

## Author

**Syed**

SQL Analytics Portfolio
 
