use elearning_platform;
SELECT 
    i.instructor_id,
    i.instructor_name,
    SUM(e.final_price) AS total_revenue
FROM instructor_table i
JOIN course_table c ON i.instructor_id = c.instructor_id
JOIN enrollment_table e ON c.course_id = e.course_id
GROUP BY i.instructor_id, i.instructor_name
ORDER BY total_revenue DESC;

