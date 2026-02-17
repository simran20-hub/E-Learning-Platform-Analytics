## E-Elearning Platform BI Analytics

This project involves developing an end-to-end Business Intelligence and Analytics solution for an E-Learning platform using data modeling, SQL, Python, and visualization tools. The workflow includes designing a relational database schema to maintain structured relationships across multiple entities. Synthetic datasets were generated with real-world complexity, including missing values, inconsistencies, and outliers, to simulate practical data cleaning and preprocessing scenarios.

The project focuses to monitor platform performance across:
-revenue
-instructor effectiveness
-course portfolio health
-user engagment 
to gain useful insights and support data-driven decisions

## Project Status:
In development

## Project Structure

- `project_overview/` - Contains project objectives, business questions, and high-level requirements documentation
- `database_design/` - Includes ER diagrams, schema definitions, table relationships, and database architecture documentation
- `data/` - Stores raw CSV files, synthetic datasets, and data generation scripts for all tables
- `cleaning_validation/` - Contains data quality checks, cleaning scripts, handling missing values, and data standardization processes
- `sql_analysis/` - SQL queries for business insights, KPI calculations, and analytical reports addressing key business questions
- `dashboard/` - Interactive visualizations, charts, and dashboard files for monitoring platform performance and metrics

Progress:
- [x] Project Structure Setup
- [x] North star metric and KPI categorisation
- [x] Identification of Data Entities
- [x] Synthetic Data creation
- [x] Database Schema Designing
- [x] Table creation and Data insertion
- [ ] Cleaning and Transformation
- [ ] SQl Analysis (KPI Engineering)
- [ ] Insight generation
- [ ] BI visualization
- [ ] Documentation
- [ ] Business Recommendation

Steps to use this Project:
1. Download the project folder
2. open schema_design.sql in sql workbench and execute
3. open pipeline.py. put your databse username, password and database name in .env file and execute python file
4. data is inserted in database, now move ahead with your analysis