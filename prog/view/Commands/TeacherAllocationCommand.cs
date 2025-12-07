using DbCourse.Model;

namespace DbCourse.View.Commands;

public class TeacherAllocationCommand(string? option = null, TeacherCommandDTO? args = null) : ICommand
{
    public void Execute(Controller.Controller controller)
    {
        if (string.IsNullOrEmpty(option) || args is null || string.IsNullOrEmpty(args.FirstName) || string.IsNullOrEmpty(args.LastName))
        {
            PrintHelp();
            return;
        }

        switch (option)
        {
            case "list":
                List<TeacherAllocationDTO> ret = controller.GetTeacherAllocation(args.FirstName, args.LastName);
                if(ret.Count == 0)
                    Console.WriteLine("No results");
                else
                {
                    foreach (TeacherAllocationDTO ta in ret)
                    {
                        Console.WriteLine(ta);
                    }
                }
                break;
            case "allocate" when !string.IsNullOrEmpty(args.ActivityName) && !string.IsNullOrEmpty(args.CiInput) && args.Hours > 0:
                var  allocRes = controller.AllocateTeacherActivity(args.FirstName, args.LastName, args.CiInput,
                    args.ActivityName, args.Hours.Value);
                Console.WriteLine($"{allocRes} rows affected");
                break;
            case "deallocate" when !string.IsNullOrEmpty(args.ActivityName) && !string.IsNullOrEmpty(args.CiInput):
                var deallocRes =
                    controller.DeallocateTeacherActivity(args.FirstName, args.LastName, args.CiInput,
                        args.ActivityName);
                Console.WriteLine($"{deallocRes} rows affected");
                break;
            default:
                PrintHelp();
                break;
        }
        
       
    }

    public void PrintHelp()
    {
        Console.WriteLine($"Usage: teacher_allocation list <first_name> <last_name> " +
                          $"\n {new string(' ',24)} allocate <first_name> <last_name> <ci_input> <activity_name> <hours>" +
                          $"\n {new string(' ',24)} deallocate <first_name> <last_name> <ci_input> <activity_name>");
        return;
    }
}