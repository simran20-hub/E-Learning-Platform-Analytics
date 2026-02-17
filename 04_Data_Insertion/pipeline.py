# pipeline.py

import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv
import os

load_dotenv()

engine = create_engine(
    f"mysql+mysqlconnector://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"
)

def clean_students(filepath):
    student_df = pd.read_csv(filepath)
    # all your cleaning steps
    student_df.rename(columns={'Name': 'student_name', 'EmailID': 'email_id'}, inplace=True)
    student_df.columns = student_df.columns.str.strip().str.lower()
    student_df=student_df[['student_id','student_name', 'age', 'gender', 'contact', 'email_id', 'state', 'country', 'signup_date', 'active_status']]
    gender_map = {
    'f': 'Female',
    'F': 'Female',
    'Female': 'Female',
    'm': 'Male',
    'M': 'Male',
    'Male': 'Male',
    'Prefer not to say': 'Other'
    }

    student_df['gender'] = student_df['gender'].map(gender_map)
    student_df['signup_date'] = pd.to_datetime(student_df['signup_date'], dayfirst=True, format='mixed')
    student_df['signup_date'] = student_df['signup_date'].dt.strftime('%Y-%m-%d')
    
    return student_df

def insert(df, table_name):
    df.to_sql(name=table_name, con=engine, if_exists='append', index=False)
    print(f"{table_name} inserted successfully")

insert(clean_students('../03_Data/raw/students_data.csv'), "student_table")

def clean_instructors(filepath):
    instructor_df=pd.read_csv(filepath)
    instructor_df.columns = instructor_df.columns.str.strip().str.lower()
    instructor_df.rename(columns={'email': 'email_id'}, inplace=True)
    instructor_df['join_date'] = pd.to_datetime(instructor_df['join_date'], dayfirst=True, format='mixed')
    instructor_df['join_date'] = instructor_df['join_date'].dt.strftime('%Y-%m-%d')
    
    return instructor_df

insert(clean_instructors('../03_Data/raw/instructors_data.csv'), "instructor_table")

def clean_categories(filepath):
    category_df=pd.read_csv(filepath)
    category_df.columns = category_df.columns.str.strip().str.lower()
    
    return category_df

insert(clean_categories('../03_Data/raw/categories_data.csv'), "category_table")

def clean_courses(filepath):
    course_df=pd.read_csv(filepath)
    course_df.columns = course_df.columns.str.strip().str.lower()
    course_df['creation_date'] = pd.to_datetime(course_df['creation_date'], format='mixed', dayfirst=True)
    course_df['creation_date'] = course_df['creation_date'].dt.strftime('%Y-%m-%d')

    status_map = {
    'Active': 'active',
    'active': 'active',
    'inactive': 'inactive',
    'Inactive': 'inactive',
    'INACTIVE': 'inactive',
    'Removed': 'removed',
    'ACTIVE': 'active',
    'removed': 'removed'
    }
    course_df['status'] = course_df['status'].map(status_map)

    
    return course_df

insert(clean_courses('../03_Data/raw/courses_data.csv'), "course_table")

def clean_enrollments(filepath):
    enrollment_df=pd.read_csv(filepath)
    enrollment_df.drop(columns=['price'], inplace=True)
    enrollment_df.rename(columns={'discount_percentage': 'discount'}, inplace=True)
    enrollment_df.columns = enrollment_df.columns.str.strip().str.lower()
    enrollment_df['enrollment_timestamp'] = pd.to_datetime(enrollment_df['enrollment_timestamp'], format='mixed', dayfirst=True)
    enrollment_df['enrollment_timestamp'] = enrollment_df['enrollment_timestamp'].dt.strftime('%Y-%m-%d %H:%M:%S')
    enrollment_df['discount'] = pd.to_numeric(enrollment_df['discount'], errors='coerce')
    enrollment_df['final_price'] = pd.to_numeric(enrollment_df['final_price'], errors='coerce')

    return enrollment_df

insert(clean_enrollments('../03_Data/raw/enrollments_data.csv'), "enrollment_table")

def clean_payments(filepath):
    payment_df=pd.read_csv(filepath)
    payment_df.columns = payment_df.columns.str.strip().str.lower()
    payment_df.rename(columns={'payment_status': 'status'}, inplace=True)
    payment_df['payment_date'] = pd.to_datetime(payment_df['payment_date'], format='mixed', dayfirst=True)
    payment_df['payment_date'] = payment_df['payment_date'].dt.strftime('%Y-%m-%d %H:%M:%S')
    payment_df['amount_paid'] = pd.to_numeric(payment_df['amount_paid'], errors='coerce')
    payment_df = payment_df.dropna(subset=['status'])
    status_map = {
    'Successful': 'Success',
    'successful': 'Success',
    'Success': 'Success',
    'Failed': 'Failed',
    'failed': 'Failed',
    'failure': 'Failed'
    }
    payment_df['status'] = payment_df['status'].str.strip().map(status_map)

    return payment_df

insert(clean_payments('../03_Data/raw/payments_data.csv'), "payment_table")