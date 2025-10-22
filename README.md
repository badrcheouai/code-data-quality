# Bank Data Quality Dashboard

A simple data quality monitoring dashboard using dbt + DuckDB + Streamlit.

## What it does

This project calculates 4 data quality metrics from bank data:
- **Completeness**: How many records have non-empty age values
- **Validity**: How many job titles match expected format (letters/spaces only)
- **Uniqueness**: How many unique contact values exist
- **Consistency**: How consistent housing and loan fields are

## Files

```
bank_dq_lab/
├── app.py                 # Streamlit dashboard
├── requirements.txt       # Python dependencies
├── data/
│   └── sample_bank.csv   # Sample bank data
├── models/
│   ├── stg_bank.sql      # Reads CSV data
│   └── dq_dashboard.sql  # Calculates quality metrics
├── macros/               # Reusable quality functions
│   ├── completeness.sql
│   ├── validity.sql
│   ├── uniqueness.sql
│   └── consistency.sql
└── profiles.yml          # dbt database config
```

## How to run

1. **Setup environment**:
   ```bash
   python -m venv .venv
   .\.venv\Scripts\Activate.ps1
   pip install -r requirements.txt
   ```

2. **Run data processing**:
   ```bash
   dbt run
   ```

3. **Start dashboard**:
   ```bash
   streamlit run app.py
   ```

Open http://localhost:8501 to see your dashboard!

## Data Quality Macros

- `completeness(column, table)` - Checks for null/empty values
- `validity(column, table, pattern)` - Validates against regex pattern  
- `uniqueness(column, table)` - Measures unique values
- `consistency(col1, col2, table)` - Compares two columns