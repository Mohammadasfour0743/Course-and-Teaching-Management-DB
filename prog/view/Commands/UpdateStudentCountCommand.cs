using System.Security.Claims;

namespace DbCourse.View.Commands;

public class UpdateStudentCountCommand(int? num_students=null, string? ci_input=null) : ICommand
{
    public void Execute(Controller.Controller controller)
    {
        if (num_students == null || ci_input == null)
        {
            PrintHelp();
        }
        int ret = controller.UpdateStudentCount(num_students.Value, ci_input);
        Console.WriteLine(ret + " rows affected");
    }

    public void PrintHelp()
    {
        Console.WriteLine("Input is Invalid bro");
    }
}