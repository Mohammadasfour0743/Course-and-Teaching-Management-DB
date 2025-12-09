namespace DbCourse.Model;

public record TeacherCommandDTO(int EmpId,
    string? CiInput = null, string? ActivityName= null, int? Hours= null);