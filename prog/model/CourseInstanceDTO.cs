namespace DbCourse.Model;

public record CourseInstanceDTO(
    string CourseCode,
    string CourseInstance,
    PeriodENUM Period,
    string StudyYear,
    int NumStudents
)
{
    public override string ToString()
    {
        return $"Course code = {CourseCode}, Course instance = {CourseInstance}, " +
               $"Period = {Period}, Study year = {StudyYear}, Number of students = {NumStudents}";
    }
}