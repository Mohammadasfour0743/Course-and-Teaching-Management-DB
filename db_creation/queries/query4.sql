SELECT e.employment_id AS employment_id,
p.first_name || ' ' || p.last_name AS employee_name,
cl.study_period AS study_period,
COUNT(DISTINCT ci.id) AS num_courses
FROM employee e
JOIN person p ON e.person_id = p.id
JOIN employee_planned_activity epa ON epa.employee_id = e.id
JOIN planned_activity pa ON pa.id = epa.planned_activity_id 
JOIN course_instance ci ON ci.id = pa.course_instance_id
JOIN course_layout cl ON cl.id = ci.course_layout_id
WHERE cl.study_period = '1' --period
GROUP BY 
e.employment_id, p.first_name, p.last_name, cl.study_period
HAVING COUNT(DISTINCT ci.id) > 1 ;--number