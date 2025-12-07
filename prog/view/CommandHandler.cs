
using DbCourse.View.Commands;

namespace DbCourse.View;

public class CommandHandler(Controller.Controller controller)
{
    private const string Prompt = "> ";
    private bool _isRunning = true;

    public void StartHandler()
    {
        _isRunning = true;
        while (_isRunning)
        {
            Console.Write(Prompt);
            string input = Console.ReadLine() ?? string.Empty;
            
            if(string.IsNullOrWhiteSpace(input)) continue;
            if (input.Equals("quit", StringComparison.OrdinalIgnoreCase))
            {
                StopHandler();
                break;
            }
            var cmd = ParseCommand(input);
            try
            {
                cmd.Execute(controller);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }
    }

    private void StopHandler() => _isRunning = false;

    private ICommand ParseCommand(string cmdString)
    {
        ICommand command;
        
        var split = cmdString.Split(' ', StringSplitOptions.TrimEntries | StringSplitOptions.RemoveEmptyEntries);
        
        switch (split[0].ToLowerInvariant())
        {
            case "list" when split.Length > 1:
                command = new ListCommand(split[1].ToLowerInvariant());
                break;
            case "help":
                command = new HelpCommand();
                break;
            case "get_cost":
                var costArgs = split.Length > 1 ? split[1] : null;
                command = new CostCommand(costArgs);
                break;
            case "update_student_number" when split.Length > 2:
                if (int.TryParse(split[1], out int newNumStudents))
                {
                    command = new UpdateStudentCountCommand(newNumStudents, split[2]);
                }
                else
                {
                    command = new InvalidCommand();
                }
                break;
            case "get_activity" when split.Length > 1:
                command = new GetActivityCommand(split[1]);
                break;
            case "get_teacher_allocation"  when split.Length > 2:
                command = new TeacherAllocationCommand(split[1], split[2]);
                break;
            default:
                command = new InvalidCommand();
                break;
        }

        return command;
    }
}