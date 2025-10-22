import streamlit as st
import duckdb
import pandas as pd

st.set_page_config(page_title="Bank DQ Dashboard", layout="wide")

st.title("🏦 Bank Data Quality Dashboard")

# Connect to DuckDB
@st.cache_data
def load_dq_data():
    conn = duckdb.connect('bank.duckdb')
    df = conn.execute("SELECT * FROM dq_dashboard").fetchdf()
    conn.close()
    return df

@st.cache_data
def load_bank_data():
    conn = duckdb.connect('bank.duckdb')
    df = conn.execute("SELECT * FROM stg_bank LIMIT 100").fetchdf()
    conn.close()
    return df

# Load data
try:
    dq_data = load_dq_data()
    bank_data = load_bank_data()
    
    # Display metrics
    col1, col2, col3, col4 = st.columns(4)
    
    with col1:
        st.metric(
            label="Age Completeness", 
            value=f"{dq_data['age_completeness'].iloc[0]:.1%}",
            help="Percentage of non-null, non-empty age values"
        )
    
    with col2:
        st.metric(
            label="Job Validity", 
            value=f"{dq_data['job_validity'].iloc[0]:.1%}",
            help="Percentage of job values matching valid format"
        )
    
    with col3:
        st.metric(
            label="Contact Uniqueness", 
            value=f"{dq_data['contact_uniqueness'].iloc[0]:.1%}",
            help="Percentage of unique contact values"
        )
    
    with col4:
        st.metric(
            label="Loan Consistency", 
            value=f"{dq_data['loan_consistency'].iloc[0]:.1%}",
            help="Consistency between housing and loan fields"
        )
    
    # Visualizations
    st.subheader("Data Quality Scores")
    
    # Create a simple bar chart
    chart_data = pd.DataFrame({
        'Metric': ['Age Completeness', 'Job Validity', 'Contact Uniqueness', 'Loan Consistency'],
        'Score': [dq_data['age_completeness'].iloc[0], dq_data['job_validity'].iloc[0], dq_data['contact_uniqueness'].iloc[0], dq_data['loan_consistency'].iloc[0]]
    })
    
    st.bar_chart(chart_data.set_index('Metric'))
    
    # Sample data
    st.subheader("Sample Bank Data")
    st.dataframe(bank_data, use_container_width=True)
    
    # Raw DQ data
    with st.expander("Raw DQ Data"):
        st.dataframe(dq_data)
        
except Exception as e:
    st.error(f"Error loading data: {e}")
    st.info("Make sure to run 'dbt run' first to generate the data.")
