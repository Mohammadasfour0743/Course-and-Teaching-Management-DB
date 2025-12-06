namespace DbCourse.Model;

public record CostDTO(
    string course_code,
    string course_instance,
    PeriodENUM period,
    string study_year,
    int num_students,
    double planned_cost,
    double allocated_cost
    );