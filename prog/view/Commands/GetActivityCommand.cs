using DbCourse.Model;

namespace DbCourse.View.Commands;

public class GetActivityCommand(string? courseInstance = null) : ICommand
{
    public void Execute(Controller.Controller controller)
    {
        if (string.IsNullOrEmpty(courseInstance))
        {
            PrintHelp();
            return;
        }
        List<CourseActivityDTO> ret = controller.GetCourseActivity(courseInstance);
        foreach (CourseActivityDTO ca in ret)
        {
            Console.WriteLine(ca);
        }
    }

    public void PrintHelp()
    {
        Console.WriteLine("Wrong input");
        return;
    }
}