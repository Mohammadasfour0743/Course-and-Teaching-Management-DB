using DbCourse.Model;

namespace DbCourse.View.Commands;

public class ActivityCommand(string? option = null, ActivityCommandDto? args = null) : ICommand
{
    public void Execute(Controller.Controller controller)
    {
        if (string.IsNullOrEmpty(option) || args is null)
        {
            PrintHelp();
            return;
        }
        switch (option)
        {
            case "create" when args.Factor is { } factor && !string.IsNullOrEmpty(args.ActivityName):
                var createRes = controller.CreateActivity(args.ActivityName, factor);
                Console.WriteLine($"{createRes} rows affected");
                break;
            case "assign" when !string.IsNullOrEmpty(args.ActivityName) && args.CiInput is not null && args.PlannedHours is > 0:
                var assignRes = controller.AssignActivityToCourse(args.CiInput, args.PlannedHours.Value, args.ActivityName);
                Console.WriteLine($"{assignRes} rows affected");
                break;
            case "list" when args.CiInput is not null:
                List<CourseActivityDTO> ret = controller.GetCourseActivity(args.CiInput);
                if(ret.Count == 0)
                    Console.WriteLine("course instance is wrong. No results");
                else
                {
                    foreach (CourseActivityDTO ca in ret)
                    {
                        Console.WriteLine(ca);
                    }
                }
              
                break;
            default:
                PrintHelp(); 
                break;
        }
    }

    public void PrintHelp()
    {
        Console.WriteLine($"Usage: activity create <activity_name> <factor>" +
                          $"\n{new string(' ', 15)} assign <ci_input> <activity_name> <planned_hours>" +
                          $"\n{new string(' ', 15)} list <ci_input>");
    }
}