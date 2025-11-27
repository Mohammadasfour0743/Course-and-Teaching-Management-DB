
SELECT 
	cl.course_code, 
	ci.instance_id,
	cl.hp,
	(person.first_name || ' ' || person.last_name) AS emp_name,
	jt.job_title,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Lecture'  THEN pa.planned_hours * ta.factor END),0) AS lecture_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Tutorial' THEN pa.planned_hours * ta.factor END),0) AS tutorial_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Lab'      THEN pa.planned_hours * ta.factor END),0) AS lab_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Seminar'  THEN pa.planned_hours * ta.factor END), 0) AS seminar_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Examination' THEN pa.planned_hours * ta.factor END), 0) AS exam_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Administration' THEN pa.planned_hours * ta.factor END), 0) AS admin_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name NOT IN ('Lecture','Tutorial','Lab','Seminar','Examination','Administration') 
             THEN pa.planned_hours * ta.factor END),0) AS other_overhead_hours,

	COALESCE(SUM(pa.planned_hours * ta.factor), 0) AS total_hours

FROM employee_planned_activity AS emp_pa
LEFT JOIN planned_activity AS pa ON pa.id = emp_pa.planned_activity_id
LEFT JOIN course_instance AS ci ON ci.id = pa.course_instance_id
LEFT JOIN course_layout AS cl ON ci.course_layout_id = cl.id
LEFT JOIN employee AS emp ON emp.id = emp_pa.employee_id
LEFT JOIN person ON emp.person_id = person.id
LEFT JOIN teaching_activity AS ta ON ta.id = pa.teaching_activity_id
LEFT JOIN job_title AS jt ON emp.job_title_id = jt.id

WHERE ci.study_year = TO_CHAR(CURRENT_DATE, 'YYYY') AND cl.course_code = 'DH2620' 
GROUP BY cl.course_code, 
	ci.instance_id,
	cl.hp,
	person.first_name,
	person.last_name,
	jt.job_title
ORDER BY emp_name;
