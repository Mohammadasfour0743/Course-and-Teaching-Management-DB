using System.Security.Claims;

namespace DbCourse.View.Commands;

public class UpdateStudentCountCommand(int? numStudents=null, string? ciInput = null) : ICommand
{
    public void Execute(Controller.Controller controller)
    {
        if (numStudents is null || string.IsNullOrEmpty(ciInput))
        {
            PrintHelp();
            return;
        }
        
        int ret = controller.UpdateStudentCount(numStudents.Value, ciInput);
        
        Console.WriteLine(ret + " rows affected");
    }

    public void PrintHelp()
    {
        Console.WriteLine("Input is Invalid bro");
        return;
    }
}