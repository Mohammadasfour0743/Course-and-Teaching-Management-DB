namespace DbCourse.View;

public interface ICommand
{
    public void Execute(Controller.Controller controller);
    public void PrintHelp();
}