using DbCourse.Model;

namespace DbCourse.View.Commands;

public class GetActivityCommand(string course_instance) : ICommand
{
    public void Execute(Controller.Controller controller)
    {
        if (course_instance == "" || course_instance == null)
        {
            PrintHelp();
        }
        List<CourseActivityDTO> ret = controller.GetCourseActivity(course_instance);
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