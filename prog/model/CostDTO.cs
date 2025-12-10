namespace DbCourse.Model;

public record CostDTO(
    string CourseCode,
    string CourseInstance,
    PeriodENUM Period,
    string StudyYear,
    int NumStudents,
    double PlannedCost,
    double AllocatedCost
)
{
    public override string ToString()
    {
        return $"Course code = {CourseCode}, Course instance = {CourseInstance}, " +
               $"Period: {Period}, Study year: {StudyYear}, Number of students: {NumStudents}," +
               $" Planned cost = {PlannedCost}, Allocated cost = {AllocatedCost}";
    }
}