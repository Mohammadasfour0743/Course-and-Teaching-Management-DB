namespace DbCourse.Model;

public record TeacherAllocationDTO(
    string EmpName,
    int EmpId,
    string CourseCode,
    string InstanceId,
    PeriodENUM Period,
    string ActivityName,
    int AllocatedHours)
{
    public override string ToString()
    {
        return
            $"Name = {EmpName}, Employment id = {EmpId}, Course code = {CourseCode}, Course instance = {InstanceId}," +
            $" Period = {Period}, Activity name = {ActivityName}, Allocated hours = {AllocatedHours}";
    }
}