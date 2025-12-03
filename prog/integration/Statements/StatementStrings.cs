namespace DbCourse.Integration.Statements;

public static class StatementStrings
{
    public const string Getpersonbylastname = "SELECT id FROM person WHERE last_name = @last_name";
    public const string Listpeople = "SELECT * FROM person";

}