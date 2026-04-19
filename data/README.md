# Data Directory

## About

This directory is a placeholder for the raw dataset. The file is too large (~80 MB+) to include in the GitHub repository.

## Download Instructions

1. Visit the **Kansas City Open Data Portal**: [https://data.kcmo.org/](https://data.kcmo.org/)
2. Search for **"311 Call Center Service Requests"**
3. Download the full dataset as a TSV file
4. Rename it to `311_CallCenterServiceRequests_KansasCity_2007-March2021.tsv`
5. Place it in this `data/` directory

## Dataset Schema

| Column | Description |
|---|---|
| `CASE ID` | Unique identifier for each service request |
| `SOURCE` | Channel used to submit (PHONE, WEB, EMAIL, etc.) |
| `DEPARTMENT` | City department assigned |
| `WORK GROUP` | Sub-unit within the department |
| `TYPE` | Specific request type |
| `DETAIL` | Additional details |
| `CREATION DATE` | Date the request was created |
| `CREATION TIME` | Time the request was created |
| `STATUS` | Current status (RESOL, OPEN, CANC, DUP, etc.) |
| `EXCEEDED EST TIMEFRAME` | Whether resolution exceeded the estimated timeframe |
| `CLOSED DATE` | Date the request was closed |
| `DAYS TO CLOSE` | Number of days between creation and closure |
| `STREET ADDRESS` | Street address of the reported issue |
| `ZIP CODE` | ZIP code |
| `NEIGHBORHOOD` | Neighborhood name |
| `COUNTY` | County |
| `POLICE DISTRICT` | Police district |
| `PARCEL ID NO` | Parcel identification number |
| `LATITUDE` | Latitude coordinate |
| `LONGITUDE` | Longitude coordinate |
| `CATEGORY1` | Primary category of the request |

## Alternative: Git LFS

If you want to track the data file with Git, consider using [Git Large File Storage (LFS)](https://git-lfs.github.com/):

```bash
git lfs install
git lfs track "data/*.tsv"
git add .gitattributes
```
