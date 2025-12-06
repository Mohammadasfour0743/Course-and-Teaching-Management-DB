namespace DbCourse.Model;

public record CourseActivityDTO(
    string instance_id,
    string course_code,
    string course_name,
    string activity_name);