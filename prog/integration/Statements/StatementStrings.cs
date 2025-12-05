namespace DbCourse.Integration.Statements;

public static class StatementStrings
{
    public const string Getpersonbylastname = "SELECT id FROM person WHERE last_name = @last_name";
    public const string Listpeople = "SELECT * FROM person";

    public const string Listemployees = "SELECT * FROM employee WHERE is_active = @is_active";

    //3q1:
    //planned and allocated hours for all courses instances if not input is given (input is instance)
    //planned and allocated hours for a specific course instance if input is given (input is instance)

    public const string PlannedActualCostAll = @"
SELECT 
	pc.course_code AS ""Course Code"",
	pc.instance_id AS ""Course Instance"",
	pc.study_period AS ""Period"",
	pc.study_year AS ""Study year"",
	pc.num_students AS ""Number of students"",
	ROUND(pc.planned_cost_ksek,0) AS ""Planned cost (KSEK)"",
	ROUND(COALESCE(ac.allocated_cost_ksek,0),0) AS ""Actual Cost (KSEK)""
FROM planned_cost AS pc
JOIN allocated_cost AS ac ON pc.id = ac.id
WHERE pc.study_year = TO_CHAR(CURRENT_DATE, 'YYYY');";


    public const string PlannedActualCost = @"
SELECT 
	pc.course_code AS ""Course Code"",
	pc.instance_id AS ""Course Instance"",
	pc.study_period AS ""Period"",
	pc.study_year AS ""Study year"",
	pc.num_students AS ""Number of students"",
	ROUND(pc.planned_cost_ksek,0) AS ""Planned cost (KSEK)"",
	ROUND(COALESCE(ac.allocated_cost_ksek,0),0) AS ""Actual Cost (KSEK)""
FROM planned_cost AS pc
JOIN allocated_cost AS ac ON pc.id = ac.id
WHERE pc.instance_id = @course_instance AND pc.study_year = TO_CHAR(CURRENT_DATE, 'YYYY');";

    
    //3q2:
//update student number for a course instance

	public const string UpdateStudentCount = @"
UPDATE course_instance
SET num_students = @new_num_students,
WHERE instance_id = @course_instance;";

	
	//display only planned teaching activites of a course instance. If a course instance only has
	//labs and seminars, it will display them. This will be used for teacher allocation. The user will
	//be able to see what course instance has what planned activities, and assign teachers to existing activities.
	public const string GetTeachingActivityOfCourse = @"
SELECT 
    ci.instance_id ,
    cl.course_code ,
    cl.course_name ,
    ta.activity_name ,
    pa.planned_hours ,
    pa.id 
FROM planned_activity pa
JOIN course_instance ci ON pa.course_instance_id = ci.id
JOIN course_layout cl ON ci.course_layout_id = cl.id
JOIN teaching_activity ta ON pa.teaching_activity_id = ta.id
WHERE ci.instance_id = @course_instance  
ORDER BY ta.activity_name;";
	
	
	
	//List all course_instances a teacher is associated with (query 3 from task 2)
	public const string GetAllocationsOfTeacher = @"

SELECT 
	cl.course_code, 
	ci.instance_id,
	cl.hp,
	cl.study_period,
	(person.first_name || ' ' || person.last_name) AS emp_name,
	jt.job_title,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Lecture'  THEN emp_pa.allocated_hours * ta.factor END),0) AS lecture_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Tutorial' THEN emp_pa.allocated_hours * ta.factor END),0) AS tutorial_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Lab'      THEN emp_pa.allocated_hours * ta.factor END),0) AS lab_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Seminar'  THEN emp_pa.allocated_hours * ta.factor END), 0) AS seminar_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Examination' THEN emp_pa.allocated_hours * ta.factor END), 0) AS exam_hours,
    COALESCE(SUM(CASE WHEN ta.activity_name = 'Administration' THEN emp_pa.allocated_hours * ta.factor END), 0) AS admin_hours,
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

WHERE ci.study_year = TO_CHAR(CURRENT_DATE, 'YYYY') AND person.first_name =@first_name AND person.last_name = @last_name
GROUP BY cl.course_code, 
	ci.instance_id,
	cl.hp,
	person.first_name,
	person.last_name,
	jt.job_title,
	cl.study_period
ORDER BY emp_name;";
	
	
	//3q3:
	//to test: the course DH2100 has only lectures and seminars assigned to it. Maria Lindgren has 3 course instances assigned to her.
	//first assign Maria Lindgren some Lecture hours in the course instance (get the instance_id before), then show allocation (use query 3 from task 2)
	//then allocate Seminar hours and show error.
	
	
	//allocate new teaching activity to a teacher. The activity for this ci must exist before.
	public const string AllocateTeachingLoad = @"
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT
	e.id,
	pa.id,
	@amount_hours
FROM employee AS e
JOIN person AS p ON p.id = e.person_id
JOIN planned_activity AS pa ON pa.course_instance_id = (
SELECT ci.id
FROM course_instance AS ci
WHERE ci.instance_id = @course_instance
)
JOIN teaching_activity AS ta ON ta.id=pa.teaching_activity_id
WHERE p.first_name = @first_name AND p.last_name = @last_name AND ta.activity_name = @teaching_activity;
";
	
	
	//deallocate a teaching activity from teacher.
	public const string DeallocateTeachingLoad = @"
DELETE FROM employee_planned_activity
WHERE employee_id = (
	SELECT e.id
	FROM employee as e
	JOIN person AS p ON e.person_id = p.id
	WHERE p.first_name = @first_name AND p.last_name = @last_name
)
AND planned_activity_id IN (
	SELECT pa.id
	FROM planned_activity AS pa
	JOIN course_instance AS ci ON pa.course_instance_id = ci.id
	JOIN teaching_activity AS ta ON ta.id = pa.teaching_activity_id
	WHERE ci.instance_id = @course_instance AND ta.activity_name = @teaching_activity;
);
";


}