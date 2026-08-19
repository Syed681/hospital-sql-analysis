````markdown
# Hospital Database Schema

## Overview

The Hospital database contains four main tables:

- `patients`
- `doctors`
- `admissions`
- `province_names`

The database supports analysis of patients, doctors, admissions, diagnoses, and geographic information.

---

# Entity Relationship Structure

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
````

---

# 1. patients

Stores demographic and patient-level information.

| Column        | Description                 | Key         |
| ------------- | --------------------------- | ----------- |
| `patient_id`  | Unique patient identifier   | Primary Key |
| `first_name`  | Patient first name          |             |
| `last_name`   | Patient last name           |             |
| `gender`      | Patient gender              |             |
| `birth_date`  | Patient date of birth       |             |
| `city`        | Patient city                |             |
| `province_id` | Patient province identifier | Foreign Key |
| `allergies`   | Recorded allergies          |             |
| `height`      | Patient height              |             |
| `weight`      | Patient weight              |             |

### Relationships

```text
patients.province_id
        ↓
province_names.province_id
```

```text
patients.patient_id
        ↓
admissions.patient_id
```

### Table Grain

```text
One row = one patient
```

---

# 2. doctors

Stores information about doctors.

| Column       | Description              | Key         |
| ------------ | ------------------------ | ----------- |
| `doctor_id`  | Unique doctor identifier | Primary Key |
| `first_name` | Doctor first name        |             |
| `last_name`  | Doctor last name         |             |
| `specialty`  | Doctor specialty         |             |

### Relationship

```text
doctors.doctor_id
        ↑
admissions.attending_doctor_id
```

### Table Grain

```text
One row = one doctor
```

---

# 3. admissions

Stores hospital admission records.

| Column                | Description                       | Key         |
| --------------------- | --------------------------------- | ----------- |
| `patient_id`          | Patient associated with admission | Foreign Key |
| `admission_date`      | Date of admission                 |             |
| `discharge_date`      | Date of discharge                 |             |
| `diagnosis`           | Admission diagnosis               |             |
| `attending_doctor_id` | Doctor associated with admission  | Foreign Key |

### Relationships

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

### Table Grain

```text
One row = one admission record
```

A patient can have multiple admission records.

```text
1 patient
   ↓
many admissions
```

---

# 4. province_names

Stores province identifiers and province names.

| Column          | Description         | Key         |
| --------------- | ------------------- | ----------- |
| `province_id`   | Province identifier | Primary Key |
| `province_name` | Full province name  |             |

### Relationship

```text
province_names.province_id
        ↑
patients.province_id
```

### Table Grain

```text
One row = one province
```

---

# Foreign Key Relationships

| From                             | To                           | Relationship                  |
| -------------------------------- | ---------------------------- | ----------------------------- |
| `patients.province_id`           | `province_names.province_id` | Many patients → one province  |
| `admissions.patient_id`          | `patients.patient_id`        | Many admissions → one patient |
| `admissions.attending_doctor_id` | `doctors.doctor_id`          | Many admissions → one doctor  |

---

# Common Join Paths

## Patients → Province

```sql
SELECT
    p.first_name,
    p.last_name,
    pn.province_name
FROM patients AS p
JOIN province_names AS pn
    ON p.province_id = pn.province_id;
```

## Patients → Admissions

```sql
SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    a.admission_date,
    a.diagnosis
FROM patients AS p
JOIN admissions AS a
    ON p.patient_id = a.patient_id;
```

## Admissions → Doctors

```sql
SELECT
    a.patient_id,
    a.admission_date,
    d.first_name,
    d.last_name,
    d.specialty
FROM admissions AS a
JOIN doctors AS d
    ON a.attending_doctor_id = d.doctor_id;
```

## Patients → Admissions → Doctors

```sql
SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    a.admission_date,
    a.diagnosis,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name
FROM patients AS p
JOIN admissions AS a
    ON p.patient_id = a.patient_id
JOIN doctors AS d
    ON a.attending_doctor_id = d.doctor_id;
```

---

# Important Analytical Consideration

Patient count and admission count are different metrics.

```text
Unique patients:
COUNT(DISTINCT patient_id)

Admission records:
COUNT(patient_id)
```

For example, if one patient has three admissions:

```text
Unique patients = 1
Admissions = 3
```

Therefore, the correct aggregation depends on the business question.

---

# Analytical Model

The database can be viewed conceptually as:

```text
                 province_names
                       │
                       │
                       ▼
                    patients
                       │
                       │
                       ▼
                   admissions
                       │
                       │
                       ▼
                    doctors
```

`patients` provides patient-level attributes.

`admissions` provides event-level healthcare activity.

`doctors` provides doctor attributes.

`province_names` provides geographic attributes.

This structure allows patient, admission, doctor, diagnosis, and geographic analysis using relational SQL.

```

