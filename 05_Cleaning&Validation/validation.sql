use elearning_platform;

-- validating number of rows
SELECT 
    table_name, 
    table_rows 
FROM 
    information_schema.tables
WHERE 
    table_schema = 'elearning_platform';
    
-- validating referential integrity
SELECT count(*) FROM payment_table p
LEFT JOIN enrollment_table e 
ON p.enrollment_id = e.enrollment_id
WHERE e.enrollment_id IS NULL;

select count(*) from enrollment_table e 
left join student_table s
on e.student_id=s.student_id
where s.student_id is NULL;

select count(*) from enrollment_table e 
left join course_table c
on e.course_id=c.course_id
where c.course_id is NULL;

select count(*) from course_table c 
left join instructor_table i
on c.instructor_id=i.instructor_id
where i.instructor_id is NULL;

select count(*) from course_table c 
left join category_table cat
on c.category_id=cat.category_id
where cat.category_id is NULL;

-- validating accuracy/ no unrealistic outliers
show tables;
select * from course_table where price<200 or price>5000;
select * from enrollment_table where discount<0 or discount>50; 
select * from enrollment_table where final_price<200 or final_price>5000;
select * from student_table where age<12 or age>85;

SELECT MIN(signup_date), MAX(signup_date) FROM student_table;
SELECT MIN(enrollment_timestamp), MAX(enrollment_timestamp) FROM enrollment_table;
SELECT MIN(payment_date), MAX(payment_date) FROM payment_table;
select min(join_date), max(join_date) from instructor_table;

-- check cardinality
SELECT COUNT(DISTINCT student_id) FROM enrollment_table;
SELECT COUNT(DISTINCT course_id) FROM enrollment_table; 
SELECT status, COUNT(*) FROM payment_table GROUP BY status;
SELECT gender, COUNT(*) FROM student_table GROUP BY gender;

-- data inconsistencies
-- Payment date should be >= enrollment date
SELECT count(*)
FROM enrollment_table e
JOIN payment_table p ON e.enrollment_id = p.enrollment_id
WHERE p.payment_date < e.enrollment_timestamp;

-- Student enrolling in same course multiple times (if not allowed)
SELECT student_id, course_id, COUNT(*)
FROM enrollment_table
GROUP BY student_id, course_id
HAVING COUNT(*) > 1;

-- solving issues no. 2
UPDATE payment_table p
JOIN enrollment_table e ON p.enrollment_id = e.enrollment_id
SET p.payment_date = e.enrollment_timestamp
WHERE p.payment_date < e.enrollment_timestamp;


