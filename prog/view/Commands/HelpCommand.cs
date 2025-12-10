namespace DbCourse.View.Commands;

public class HelpCommand : ICommand
{
    private static readonly List<ICommand> Commands = [
        new ListCommand(),
        new HelpCommand(),
        new CostCommand(),
        new UpdateStudentCountCommand(),
        new TeacherAllocationCommand(),
        new ActivityCommand()
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
        
    }
}