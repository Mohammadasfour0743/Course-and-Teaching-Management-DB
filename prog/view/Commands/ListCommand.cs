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
            case "employee":
                foreach (var emp in controller.GetEmployees(true))
                {
                    Console.WriteLine(emp);
                }
                break;
            default:
                PrintHelp();
                break;
        }
       
    }

    public void PrintHelp()
    {
        Console.WriteLine("Lists a table - Usage: list <people/employee>");
    }
}