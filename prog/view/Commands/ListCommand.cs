namespace DbCourse.View.Commands;

public class ListCommand(string? option = null) : ICommand
{

    public void Execute(Controller.Controller controller)
    {
        switch (option)
        {
            case "people":
                foreach (var person in controller.GetPeople())
                {
                    Console.WriteLine(person);
                }
                break;
            case "employees":
                foreach (var emp in controller.GetEmployees(true))
                {
                    Console.WriteLine(emp);
                }
                break;
            case "course_instances":
                foreach (var ci in controller.GetActiveCourseInstances())
                {
                    Console.WriteLine(ci);
                }
                break;
            default:
                PrintHelp();
                break;
        }
       
    }

    public void PrintHelp()
    {
        Console.WriteLine($"Usage: list people" +
                          $"\n {new string(' ',10)} employees" +
                          $"\n {new string(' ',10)} course_instances" 
                           
        );
    }
}