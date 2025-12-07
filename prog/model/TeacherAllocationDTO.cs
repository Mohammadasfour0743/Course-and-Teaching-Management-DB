namespace DbCourse.Model;

public record TeacherAllocationDTO(
    string EmpName,
    string CourseCode,
    string InstanceId,
    PeriodENUM Period,
    string ActivityName,
    int AllocatedHours);