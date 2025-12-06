using DbCourse.Model;

namespace DbCourse.View.Commands;

public class TeacherAllocationCommand(string first_n, string last_n) : ICommand
{
    public void Execute(Controller.Controller controller)
    {
        if (first_n.Length <= 0 || last_n.Length <= 0)
        {
            PrintHelp();
        }
        List<TeacherAllocationDTO> ret = controller.GetTeacherAllocation(first_n, last_n);
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