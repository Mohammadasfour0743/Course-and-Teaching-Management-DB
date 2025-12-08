namespace DbCourse.Model;

public record CourseInstanceDTO(  
    string CourseCode,
    string CourseInstance,
    PeriodENUM Period,
    string StudyYear,
    int NumStudents
    );