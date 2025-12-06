namespace DbCourse.Model;

public record TeacherAllocationDTO(
    string emp_name,
    string course_code,
    string instance_id,
    PeriodENUM period,
    string activity_name,
    int allocated_hours);