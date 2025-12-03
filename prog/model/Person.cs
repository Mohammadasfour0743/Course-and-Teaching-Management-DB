namespace DbCourse.Model;

public class Person : IEquatable<Person>
{
    //todo: make required?
    public int Id { get; init; }
    public string PersonalNumber { get; set; } = string.Empty;
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string Street { get; set; } = string.Empty;
    public string Zip { get; set; } = string.Empty;

    public string FullName => $"{FirstName} {LastName}";

    public override string ToString()
    {
        return $"Id: {Id}, Personal number: {PersonalNumber}, Name: {FullName}, Address: {Street}, {Zip}";
    }

    public bool Equals(Person? other)
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
        return Equals((Person)obj);
    }

    public override int GetHashCode()
    {
        return Id;
    }
}