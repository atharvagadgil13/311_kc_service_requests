# Data Profiling Observations & Inconsistencies

During the profiling of the 311 Call Center Service Requests dataset (2007–March 2021) using Alteryx, several data quality issues were identified. These were addressed before staging the data to SQL Server for analysis.

---

## 1. Missing Values

- **Address fields**: Multiple records have null or missing values for Street Address, ZIP Code, and Latitude/Longitude, which impacts geographic analysis and mapping.
- **Closure fields**: `CLOSED DATE` and resolution-related columns contain nulls, particularly for cases still marked as Open or In Progress.
- **Contact information**: Optional contact fields (phone, email) are sparsely populated.

## 2. Duplicates

- Several records appear duplicated, sharing the same Case ID, Service Request Type, and Created Date.
- Likely caused by system re-entry or logging errors. Deduplication was considered during the cleaning phase.

## 3. Date & Time Format Issues

- Date columns (`CREATION DATE`, `CLOSED DATE`) have inconsistent formats — some include full datetime stamps (with `hh:mm:ss`), others store only the date.
- A small number of records have `CLOSED DATE` earlier than `CREATION DATE`, producing negative resolution times (data entry errors).
- Records from 2007–2009 contain placeholder dates (e.g., `1900-01-01` or NULL) rather than valid entries.

## 4. Data Type / Conversion Issues

- `ZIP CODE` is stored as numeric in some cases and text in others, leading to potential loss of leading zeros.
- `LATITUDE` and `LONGITUDE` are sometimes auto-aggregated (averaged) by BI tools due to incorrect data category assignment.
- Resolution time calculations required careful datetime conversion; invalid dates produced null or negative results.

## 5. Inconsistent / Dirty Values

- **Department names**: Minor variations create separate categories for the same entity (e.g., `Public Works` vs. `Public_Work`).
- **Status field**: Multiple representations of the same status — `Closed`, `closed`, `Closed - Completed` — required normalization.
- **Category / Service Type**: Some records have misspellings or truncated values.

## 6. Outliers

- **Resolution times**: A few records show extremely high closure times (>1,000 days), which skew averages and distributions.
- **Geographic coordinates**: Certain lat/long values fall well outside Kansas City boundaries (e.g., latitude 35.798 appearing in top results), indicating entry errors or default geocoding failures.

## 7. Special Characters & Encoding

- Some Address and Request Description fields contain special characters (`#`, `?`, `*`) that can affect SQL joins and filtering.
- Non-printable whitespace characters were detected in text fields; trimming was applied during cleaning.

## 8. General Observations

- The dataset spans 2006–2021 but volume is unevenly distributed — request volumes are significantly higher after 2015 compared to earlier years.
- Seasonal patterns are visible, with spikes in certain request types (e.g., snow/ice removal in winter months, mowing in summer).
- A significant number of records remain Open or In Progress, which may bias trend analysis depending on the analysis cutoff date.
- The 2021 data appears to be partial (only through approximately March 2021 based on substantial data, with scattered records through October).
