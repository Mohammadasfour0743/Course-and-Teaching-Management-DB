SELECT
    cl.course_code,
    ci.instance_id,
    ci.num_students,
    ci.study_year,
    SUM(pa.planned_hours) AS total_planned_hours,
    SUM(epa.allocated_hours) AS total_allocated_hours
FROM course_instance as ci
JOIN course_layout as cl ON ci.course_layout_id = cl.id
LEFT JOIN planned_activity as pa ON pa.course_instance_id = ci.id
LEFT JOIN employee_planned_activity AS epa ON pa.id = epa.planned_activity_id
WHERE ci.study_year = TO_CHAR(CURRENT_DATE, 'YYYY')
GROUP BY cl.course_code, ci.instance_id, ci.num_students, ci.study_year
HAVING ABS(SUM(pa.planned_hours) - SUM(epa.allocated_hours)) / (SUM(pa.planned_hours) * 1.0) > 0.15;