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

	public const string UpdateStudentNumber = @"
UPDATE course_instance
SET num_students = @new_num_students,
WHERE instance_id = @course_instance;";

}