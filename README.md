# 311 Call Center Service Requests — Kansas City (2007–2021)

An end-to-end data analytics project that profiles, cleans, stages, and visualizes **1.5 million+ 311 service requests** from Kansas City, MO. The pipeline spans **Alteryx → SQL Server → Tableau / Power BI**, producing actionable insights about city operations, request volumes, response times, and geographic hotspots.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Dataset](#dataset)
- [Project Architecture](#project-architecture)
- [Repository Structure](#repository-structure)
- [Tools & Technologies](#tools--technologies)
- [Data Profiling & Cleaning (Alteryx)](#data-profiling--cleaning-alteryx)
- [SQL Analysis](#sql-analysis)
- [Visualizations](#visualizations)
- [Key Findings](#key-findings)
- [How to Reproduce](#how-to-reproduce)
- [Author](#author)

---

## Project Overview

Kansas City's 311 system allows residents to report non-emergency issues — from potholes and trash collection to noise complaints and water service problems. This project analyzes ~15 years of that data to answer questions such as:

1. **How have request volumes trended over time?** (yearly & monthly, 2018–2021)
2. **Which channels do residents use to submit requests?** (phone, web, email, etc.)
3. **Which city departments receive the most requests?**
4. **What are the fastest- and slowest-resolved case types?**
5. **Where are the geographic hotspots?** (by ZIP code, street address, lat/long)
6. **How are work groups distributed within departments?**
7. **What does resolution time look like across departments?** (avg, median, P90)
8. **What is the year-over-year status breakdown?** (resolved, open, cancelled, etc.)
9. **Which service categories take the longest to close?**
10. **How do departments compare on volume vs. resolution speed?**

---

## Dataset

| Detail | Value |
|---|---|
| **Source** | Kansas City Open Data — 311 Call Center Service Requests |
| **Time Span** | December 2006 – October 2021 |
| **Records** | ~1.56 million rows |
| **Format** | Tab-separated values (`.tsv`) |
| **Key Columns** | `CASE ID`, `SOURCE`, `DEPARTMENT`, `WORK GROUP`, `TYPE`, `CREATION DATE`, `CLOSED DATE`, `STATUS`, `DAYS TO CLOSE`, `ZIP CODE`, `STREET ADDRESS`, `LATITUDE`, `LONGITUDE`, `CATEGORY1` |

> **Note:** The raw dataset is too large for GitHub (100 MB+). See [How to Reproduce](#how-to-reproduce) for download instructions.

---

## Project Architecture

```
Raw TSV Data
    │
    ▼
┌──────────────┐
│   Alteryx    │  ← Data profiling, cleaning, deduplication,
│   Workflow   │    type normalization, staging
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  SQL Server  │  ← 10 analytical queries (aggregation,
│  (T-SQL)     │    window functions, CTEs)
└──────┬───────┘
       │
       ▼
┌──────────────────────────┐
│  Tableau  &  Power BI    │  ← Interactive dashboards
│  Dashboards              │    and visual storytelling
└──────────────────────────┘
```

---

## Repository Structure

```
311-kc-service-requests/
│
├── README.md                          ← You are here
├── .gitignore
├── LICENSE
│
├── data/
│   └── README.md                      ← Dataset download instructions
│
├── alteryx/
│   └── data_profiling_workflow.yxmd   ← Alteryx Designer workflow
│
├── sql/
│   └── analysis_queries.sql           ← All 10 analytical queries (T-SQL)
│
├── tableau/
│   └── dashboard.twb                  ← Tableau workbook
│
├── powerbi/
│   └── dashboard.pbix                 ← Power BI report
│
└── docs/
    ├── analysis_report.pdf            ← Full report with screenshots & results
    └── data_profiling_notes.md        ← Data quality observations
```

---

## Tools & Technologies

| Tool | Purpose |
|---|---|
| **Alteryx Designer 2025.1** | Data profiling, cleaning, and staging to SQL Server |
| **Microsoft SQL Server** (SSMS) | Data storage and analytical querying (T-SQL) |
| **Tableau Desktop** | Interactive dashboards and geographic visualizations |
| **Power BI Desktop** | Alternative dashboards and drill-down reports |

---

## Data Profiling & Cleaning (Alteryx)

Before analysis, the raw dataset was profiled and cleaned using an Alteryx workflow. Key issues identified and addressed:

- **Missing values** in address fields, ZIP codes, lat/long, and closure dates
- **Duplicate records** sharing the same Case ID, type, and creation date
- **Date format inconsistencies** — mixed datetime vs. date-only formats; some records with placeholder dates (e.g., `1900-01-01`)
- **Negative resolution times** — closed dates earlier than creation dates (data entry errors)
- **Dirty categorical values** — inconsistent department names (`Public Works` vs. `Public_Work`), status variations (`Closed`, `closed`, `Closed - Completed`)
- **Outliers** — closure times exceeding 1,000 days; geographic coordinates outside Kansas City
- **Encoding issues** — special characters and non-printable whitespace in text fields

Full profiling notes are documented in [`docs/data_profiling_notes.md`](docs/data_profiling_notes.md).

---

## SQL Analysis

All queries are in [`sql/analysis_queries.sql`](sql/analysis_queries.sql). Summary of the 10 analytical questions:

| # | Question | Technique |
|---|---|---|
| Q1 | Request volume trends (2018–2021) — yearly & monthly | `GROUP BY YEAR()`, `DATEFROMPARTS()` |
| Q2 | Requests by source channel | `GROUP BY [SOURCE]`, monthly breakdown |
| Q3 | Requests by department | `GROUP BY [DEPARTMENT]` |
| Q4 | Fastest-resolved cases (top 10) | `ORDER BY DaysToClose ASC`, `TRY_CONVERT` |
| Q5 | Geographic hotspots — ZIP, street, lat/long | `TOP 10`, `ROUND()`, `CAST` |
| Q6 | Work group distribution within departments | Multi-column `GROUP BY` |
| Q7 | Resolution time stats by department | `PERCENTILE_CONT`, window functions, CTE |
| Q8 | Year-over-year status breakdown | CTEs, percentage calculation |
| Q9 | Slowest-closing service categories (top 10) | `AVG()`, `ORDER BY DESC` |
| Q10 | Department volume vs. avg resolution time | Combined aggregation |

---

## Key Findings

- **2019 was the peak year** with ~166K requests; 2020 saw a drop to ~126K (likely COVID-related), and 2021 data is partial (through ~March).
- **Phone remains the dominant channel** at ~1.2M requests (~77% of total), followed by Web (~212K) and Email (~81K).
- **NHS (Neighborhood & Housing Services)** handles the most requests (~783K), followed by Public Works (~354K) and Water Services (~217K).
- **Snow & Ice cases showed negative closure times** (closed before created) — a data quality issue flagged in Q4.
- **ZIP code 64130** is the top hotspot with ~133K requests; **414 E 12th St** is the most-reported street address (~5,773 requests).
- **"Data Not Available" and "Weeds" categories** have the longest average resolution times (1,189 and 420 days respectively).
- **~95–98% of cases are resolved each year**, with open cases rising slightly in 2020–2021.

---

## How to Reproduce

### 1. Get the Data

The raw TSV file is too large for this repository. Download it from:
- **Kansas City Open Data Portal**: Search for "311 Call Center Service Requests"
- Direct link (if available): `https://data.kcmo.org/`

Place the file as `data/311_CallCenterServiceRequests_KansasCity_2007-March2021.tsv`.

### 2. Run the Alteryx Workflow (Optional)

Open `alteryx/data_profiling_workflow.yxmd` in **Alteryx Designer 2025.1+**. Update the input file path to point to your local copy of the TSV. The workflow profiles and stages the data to SQL Server.

### 3. Set Up SQL Server

- Create a database and import the cleaned data into a table named `dbo.Atharva311Data`
- Run the queries in `sql/analysis_queries.sql` using SSMS or Azure Data Studio

### 4. Open the Dashboards

- **Tableau**: Open `tableau/dashboard.twb` in Tableau Desktop. Update the data connection to point to your SQL Server instance.
- **Power BI**: Open `powerbi/dashboard.pbix` in Power BI Desktop. Update the data source connection.

---

## Author

**Atharva Gadgil**

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

The underlying dataset is provided by Kansas City, MO under open data policies. Please review their terms of use for redistribution.
