using DbCourse.Model;

namespace DbCourse.View.Commands;

public class TeacherAllocationCommand(string? option = null, TeacherCommandDTO? args = null) : ICommand
{
    public void Execute(Controller.Controller controller)
    {
        if (string.IsNullOrEmpty(option) || args is null )
        {
            PrintHelp();
            return;
        }

        switch (option)
        {
            case "list":
                List<TeacherAllocationDTO> ret = controller.GetTeacherAllocation(args.EmpId);
                if(ret.Count == 0)
                    Console.WriteLine("No results. Check employee ID");
                else
                {
                    foreach (TeacherAllocationDTO ta in ret)
                    {
                        Console.WriteLine(ta);
                    }
                }
                break;
            case "allocate" when !string.IsNullOrEmpty(args.ActivityName) && !string.IsNullOrEmpty(args.CiInput) && args.Hours > 0:
                var  allocRes = controller.AllocateTeacherActivity(args.EmpId, args.CiInput,
                    args.ActivityName, args.Hours.Value);
                Console.WriteLine($"Allocation Successful. {allocRes} rows affected");
                break;
            case "deallocate" when !string.IsNullOrEmpty(args.ActivityName) && !string.IsNullOrEmpty(args.CiInput):
                var deallocRes =
                    controller.DeallocateTeacherActivity(args.EmpId, args.CiInput,
                        args.ActivityName);
                Console.WriteLine($"Deallocation Successful. {deallocRes} rows affected");
                break;
            default:
                PrintHelp();
                break;
        }
        
       
    }

    public void PrintHelp()
    {
        Console.WriteLine($"Usage: teacher_allocation list <employee_id> " +
                          $"\n {new string(' ',24)} allocate <employee_id> <ci_input> <activity_name> <hours>" +
                          $"\n {new string(' ',24)} deallocate <employee_id> <ci_input> <activity_name>");
        return;
    }
}