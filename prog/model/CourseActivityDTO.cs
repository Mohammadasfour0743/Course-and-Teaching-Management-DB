namespace DbCourse.Model;

public record CourseActivityDTO(
    string InstanceId,
    string CourseCode,
    string CourseName,
    string ActivityName)
{
    public override string ToString()
    {
        return $"Instance id = {InstanceId}, Course code = {CourseCode}, Course name = {CourseName}, Activity name = {ActivityName}";
    }
}