namespace DbCourse.Model;

public record ActivityCommandDto(string? ActivityName = null, string? CiInput = null, int? PlannedHours= null, double? Factor= null);