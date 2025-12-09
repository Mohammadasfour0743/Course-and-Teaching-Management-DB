namespace DbCourse.Model;

public record TeacherAllocationDTO(
    string EmpName,
    int EmpId,
    string CourseCode,
    string InstanceId,
    PeriodENUM Period,
    string ActivityName,
    int AllocatedHours);