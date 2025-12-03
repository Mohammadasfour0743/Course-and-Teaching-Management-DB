namespace DbCourse.View.Commands;

public class InvalidCommand : ICommand
{
    public void Execute(Controller.Controller controller)
    {
        Console.WriteLine("Invalid command! Type help for a list of commands.");
    }

    public void PrintHelp()
    {
        return;
    }
}