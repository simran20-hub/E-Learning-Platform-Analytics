-- to see how many new student came and how many students returned


show databases;
use elearning_platform;
show tables;
select * from student_table;

-- to understand how many instructors were actuvely creating courses in 2025
select * from instructor_table;

select * from course_table;
select instructor_id, count(*) from course_table group by instructor_id;
select count(distinct instructor_id) from course_table;

select Extract(year from c.creation_date), c.instructor_id, i.instructor_name, count(*) 
	from course_table c 
	join instructor_table i on c.instructor_id=i.instructor_id 
	where Extract(year from c.creation_date) = '2022' 
	group by Extract(year from c.creation_date), c.instructor_id 
	order by count(*) desc;

select course_id from course_table where instructor_id='INST016';
select sum(final_price), extract(year from enrollment_timestamp) from enrollment_table where course_id='C0045' group by Extract(year from enrollment_timestamp);


select course_id, extract(year from enrollment_timestamp), sum(final_price) from enrollment_table group by extract(year from enrollment_timestamp),course_id;
select c.course_id, i.instructor_name from course_table c join instructor_table i on c.instructor_id=i.instructor_i;


-- find Customer saturation point
select * from enrollment_table;
WITH ranked_enrollments AS (
  SELECT
    student_id,
    ROW_NUMBER() OVER (
      PARTITION BY student_id 
      ORDER BY enrollment_timestamp
    ) AS purchase_sequence
  FROM enrollment_table
),

sequence_counts AS (
  SELECT
    purchase_sequence,
    COUNT(DISTINCT student_id) AS students_reaching_this_purchase
  FROM ranked_enrollments
  GROUP BY purchase_sequence
),

cohort_base AS (
  SELECT students_reaching_this_purchase AS total_students
  FROM sequence_counts
  WHERE purchase_sequence = 1
)

SELECT
  s.purchase_sequence,
  s.students_reaching_this_purchase,
  ROUND(100.0 * s.students_reaching_this_purchase / c.total_students, 1) AS pct_of_cohort
FROM sequence_counts s
CROSS JOIN cohort_base c
ORDER BY s.purchase_sequence;

-- to find customer saturation point but by Cohort Year Split
WITH student_cohort AS (
  SELECT
    student_id,
    EXTRACT(YEAR FROM MIN(enrollment_timestamp)) AS cohort_year
  FROM enrollment_table
  GROUP BY student_id
),

ranked_enrollments AS (
  SELECT
    e.student_id,
    sc.cohort_year,
    ROW_NUMBER() OVER (
      PARTITION BY e.student_id 
      ORDER BY e.enrollment_timestamp
    ) AS purchase_sequence
  FROM enrollment_table e
  JOIN student_cohort sc ON e.student_id = sc.student_id
),

sequence_counts AS (
  SELECT
    cohort_year,
    purchase_sequence,
    COUNT(DISTINCT student_id) AS students_reaching_this_purchase
  FROM ranked_enrollments
  GROUP BY cohort_year, purchase_sequence
),

cohort_base AS (
  SELECT
    cohort_year,
    students_reaching_this_purchase AS total_students
  FROM sequence_counts
  WHERE purchase_sequence = 1
)

SELECT
  s.cohort_year,
  s.purchase_sequence,
  s.students_reaching_this_purchase,
  ROUND(100.0 * s.students_reaching_this_purchase / c.total_students, 1) AS pct_of_cohort
FROM sequence_counts s
JOIN cohort_base c ON s.cohort_year = c.cohort_year
ORDER BY s.cohort_year, s.purchase_sequence;

select * from student_table;
SELECT * 
FROM student_table a
WHERE NOT EXISTS (
    SELECT 1 
    FROM enrollment_table b 
    WHERE a.student_id = b.student_id
);

-- debugging
SELECT COUNT(*) AS rs,
       COUNT(DISTINCT student_id) AS unique_students
FROM student_table;

select * from student_table;

