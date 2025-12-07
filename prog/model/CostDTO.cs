namespace DbCourse.Model;

public record CostDTO(
    string CourseCode,
    string CourseInstance,
    PeriodENUM Period,
    string StudyYear,
    int NumStudents,
    double PlannedCost,
    double AllocatedCost
    );