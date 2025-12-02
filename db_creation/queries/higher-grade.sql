
--creating the matrialized view to be used in queries 2 and 3
DROP MATERIALIZED VIEW IF EXISTS mv_employee_course_hours;
CREATE MATERIALIZED VIEW mv_employee_course_hours AS
SELECT 
    ci.study_year,
    cl.course_code, 
    ci.instance_id,
    cl.hp,
    cl.study_period,
    emp.id AS employee_id,
    person.first_name,
    person.last_name,
    (person.first_name || ' ' || person.last_name) AS emp_name,
    jt.job_title,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Lecture' THEN emp_pa.allocated_hours * ta.factor END),0) AS lecture_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Tutorial' THEN emp_pa.allocated_hours * ta.factor END),0) AS tutorial_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Lab' THEN emp_pa.allocated_hours * ta.factor END),0) AS lab_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Seminar' THEN emp_pa.allocated_hours * ta.factor END),0) AS seminar_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Examination' THEN emp_pa.allocated_hours * ta.factor END),0) AS exam_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Administration' THEN emp_pa.allocated_hours * ta.factor END),0) AS admin_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name NOT IN ('Lecture','Tutorial','Lab','Seminar','Examination','Administration') 
             THEN emp_pa.allocated_hours * ta.factor END),0) AS other_overhead_hours,
    COALESCE(SUM(emp_pa.allocated_hours * ta.factor), 0) AS total_hours

FROM employee_planned_activity AS emp_pa
JOIN planned_activity AS pa ON pa.id = emp_pa.planned_activity_id
JOIN course_instance AS ci ON ci.id = pa.course_instance_id
JOIN course_layout AS cl ON ci.course_layout_id = cl.id
JOIN employee AS emp ON emp.id = emp_pa.employee_id
JOIN person ON emp.person_id = person.id
JOIN teaching_activity AS ta ON ta.id = pa.teaching_activity_id
LEFT JOIN job_title AS jt ON emp.job_title_id = jt.id

GROUP BY 
    ci.study_year,
    cl.course_code, 
    ci.instance_id,
    cl.hp,
    cl.study_period,
    emp.id,
    person.first_name,
    person.last_name,
    jt.job_title;

----------------------------------------------------------------------------------------------

--INDICES PART:

--indices for query 1
CREATE INDEX idx_course_instance_study_year
    ON course_instance(study_year);

CREATE INDEX idx_planned_activity_course_instance_id
    ON planned_activity(course_instance_id);

--index for query 2
CREATE INDEX idx_mv_emp_year_last_name_first_name
    ON mv_employee_course_hours (study_year, last_name, first_name);

-- index for query 3
CREATE INDEX idx_mv_emp_year_course_empname
    ON mv_employee_course_hours (study_year, course_code, emp_name);


--------------------------------------------------------------------------------------------------
--QUERY PART:




--query 2 written with the matrialized view
SELECT 
    course_code, 
    instance_id,
    hp,
    emp_name,
    job_title,
    lecture_hours,
    tutorial_hours,
    lab_hours,
    seminar_hours,
    exam_hours,
    admin_hours,
    other_overhead_hours,
    total_hours
FROM mv_employee_course_hours
WHERE study_year = TO_CHAR(CURRENT_DATE, 'YYYY') AND course_code = 'DH2500'
ORDER BY emp_name;




--query 3 written with the matrialized view
SELECT 
    course_code, 
    instance_id,
    hp,
    study_period,
    emp_name,
    job_title,
    lecture_hours,
    tutorial_hours,
    lab_hours,
    seminar_hours,
    exam_hours,
    admin_hours,
    other_overhead_hours,
    total_hours
FROM mv_employee_course_hours
WHERE study_year = TO_CHAR(CURRENT_DATE, 'YYYY') AND first_name='Maria' AND last_name='Lindgren'
ORDER BY course_code;



