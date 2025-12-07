namespace DbCourse.Model;

public record TeacherCommandDTO(string FirstName , string LastName,
    string? CiInput = null, string? ActivityName= null, int? Hours= null);