
using DbCourse.Model;
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
    
    private string? GetIfExists(int index, string[] arr) =>  arr.Length > index ? arr[index] : null;

    private int? ParseIntOrNull(string? input)
    {
        if (int.TryParse(input, out var res))
            return res;
        return null;
    }
    private double? ParseDoubleOrNull(string? input)
    {
        if (double.TryParse(input, out var res))
            return res;
        return null;
    }
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
                if (int.TryParse(split[2], out int newNumStudents))
                {
                    command = new UpdateStudentCountCommand(split[1], newNumStudents);
                }
                else
                {
                    command = new InvalidCommand();
                }
                break;
            
            case "teacher_allocation"  when split.Length > 2:
                if (int.TryParse(split[2], out int empId))
                {
                    var teacherCommandInput = new TeacherCommandDTO(
                        empId,
                        GetIfExists(3, split),
                        GetIfExists(4, split),
                        ParseIntOrNull(GetIfExists(5, split)));
                    command = new TeacherAllocationCommand(split[1].ToLowerInvariant(),teacherCommandInput);
                }
                else
                {
                    command = new InvalidCommand();
                }
               
                break;
            case "activity" when split.Length > 2:
                bool isCreate = split[1].Equals("create", StringComparison.InvariantCultureIgnoreCase);
                var activityCommandInput = new ActivityCommandDto(
                    isCreate ? split[2] : GetIfExists(3,split),
                    isCreate ? null : GetIfExists(2, split),
                    ParseIntOrNull(GetIfExists(4, split)),
                    isCreate ? ParseDoubleOrNull(GetIfExists(3, split)) : null
                );

                command = new ActivityCommand(split[1].ToLowerInvariant(), activityCommandInput);
                break;
            
            default:
                command = new InvalidCommand();
                break;
        }

        return command;
    }
}