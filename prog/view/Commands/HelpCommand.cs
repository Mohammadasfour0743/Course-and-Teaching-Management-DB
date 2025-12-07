namespace DbCourse.View.Commands;

public class HelpCommand : ICommand
{
    private static readonly List<ICommand> Commands = [
        new ListCommand(),
        new HelpCommand(),
        new CostCommand(),
        new UpdateStudentCountCommand(),
        new GetActivityCommand(),
        new TeacherAllocationCommand()
    ];
    public void Execute(Controller.Controller controller)
    {
        foreach (var command in Commands)
        {
            command.PrintHelp();
        }

        Console.WriteLine("Quits the program - Usage: quit");
    }

    public void PrintHelp()
    {
        Console.WriteLine("Prints help information - Usage: help");
    }
}