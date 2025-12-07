using System.Security.Claims;

namespace DbCourse.View.Commands;

public class UpdateStudentCountCommand( string? ciInput = null ,int? numStudents=null) : ICommand
{
    public void Execute(Controller.Controller controller)
    {
        if (numStudents is null || string.IsNullOrEmpty(ciInput))
        {
            PrintHelp();
            return;
        }
        
        int ret = controller.UpdateStudentCount(numStudents.Value, ciInput);
        
        Console.WriteLine("Student number updated successfully. " + ret + " row(s) affected");
    }

    public void PrintHelp()
    {
        Console.WriteLine("Usage: ");
        return;
    }
}