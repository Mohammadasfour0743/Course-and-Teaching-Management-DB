namespace DbCourse.Model;

public class Employee : IEquatable<Employee>
{
    public int Id { get; init; }
    public int EmploymentId { get; set; }
    public int JobTitleId { get; set; }
    public string Name { get; set; } = string.Empty;
    public int DepartmentId { get; set; }
    public int? ManagerId { get; set; }
    public bool IsActive { get; set; }

    
    
    public override string ToString()
    {
        return $"ID: {Id} , Name: {Name}, Employment ID: {EmploymentId}, Job Title ID: {JobTitleId}, Department ID: {DepartmentId},Manager ID: {ManagerId},Activity: {IsActive}";
    }
    
    
    public bool Equals(Employee? other)
    {
        if (other is null) return false;
        if (ReferenceEquals(this, other)) return true;
        return Id == other.Id;
    }

    public override bool Equals(object? obj)
    {
        if (obj is null) return false;
        if (ReferenceEquals(this, obj)) return true;
        if (obj.GetType() != GetType()) return false;
        return Equals((Employee)obj);
    }

    public override int GetHashCode()
    {
        return Id;
    }
}

