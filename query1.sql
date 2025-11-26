SELECT 
	cl.course_code, 
	ci.instance_id, 
	cl.hp, 
	cl.study_period, 
	ci.num_students,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Lecture'  THEN pa.planned_hours * ta.factor END),0) AS lecture_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Tutorial' THEN pa.planned_hours * ta.factor END),0) AS tutorial_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Lab'      THEN pa.planned_hours * ta.factor END),0) AS lab_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Seminar'  THEN pa.planned_hours * ta.factor END), 0) AS seminar_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Examination' THEN pa.planned_hours * ta.factor END), 0) AS exam_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Administration' THEN pa.planned_hours * ta.factor END), 0) AS admin_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name NOT IN ('Lecture','Tutorial','Lab','Seminar','Examination','Administration') 
             THEN pa.planned_hours * ta.factor END),0) AS other_overhead_hours,

	
	COALESCE(SUM(pa.planned_hours * ta.factor), 0) AS total_hours


FROM course_instance AS ci
JOIN course_layout AS cl ON ci.course_layout_id = cl.id
LEFT JOIN planned_activity AS pa ON pa.course_instance_id = ci.id
LEFT JOIN teaching_activity AS ta ON pa.teaching_activity_id = ta.id

WHERE ci.study_year = TO_CHAR(CURRENT_DATE, 'YYYY')
GROUP BY cl.course_code, ci.instance_id, cl.hp, cl.study_period, ci.num_students;


/*
SELECT teaching_activity_id, ta.activity_name, planned_hours, course_instance_id, ci.instance_id FROM planned_activity AS pa
JOIN teaching_activity AS ta ON ta.id = pa.teaching_activity_id
LEFT JOIN course_instance AS ci ON pa.course_instance_id = ci.id;

*/

/*
CREATE OR REPLACE VIEW actual_hours AS
SELECT pa.course_instance_id, pa.teaching_activity_id, ta.activity_name, (pa.planned_hours * ta.factor) AS actual
FROM planned_activity AS pa
JOIN teaching_activity AS ta ON pa.teaching_activity_id = ta.id;
*/
	

