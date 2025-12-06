using DbCourse.Model;

namespace DbCourse.View.Commands;

public class CostCommand(string? course_instance = null) : ICommand
{
    public void Execute(Controller.Controller controller)
    {
        if (course_instance is null)
        {
            List<CostDTO> result = controller.GetAllCosts();
            foreach (CostDTO cost in result)
            {
                Console.WriteLine(cost);
            }
        }
        else
        {
            CostDTO result = controller.GetCost(course_instance);
            Console.WriteLine(result);
        }
        
    }

    public void PrintHelp()
    {
        throw new NotImplementedException();
    }
}