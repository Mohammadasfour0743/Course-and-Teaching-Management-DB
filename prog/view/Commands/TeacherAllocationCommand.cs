using DbCourse.Model;

namespace DbCourse.View.Commands;

public class TeacherAllocationCommand(string? firstName = null, string? lastName = null) : ICommand
{
    public void Execute(Controller.Controller controller)
    {
        if (string.IsNullOrEmpty(firstName) || string.IsNullOrEmpty(lastName))
        {
            PrintHelp();
            return;
        }
        
        List<TeacherAllocationDTO> ret = controller.GetTeacherAllocation(firstName, lastName);
        
        foreach (TeacherAllocationDTO ta in ret)
        {
            Console.WriteLine(ta);
        }
    }

    public void PrintHelp()
    {
        Console.WriteLine("Usage: get_teacher-allocation + first name + last name");
        return;
    }
}