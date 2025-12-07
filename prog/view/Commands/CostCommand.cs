using DbCourse.Model;

namespace DbCourse.View.Commands;

public class CostCommand(string? courseInstance = null) : ICommand
{
    public void Execute(Controller.Controller controller)
    {
        if (string.IsNullOrEmpty(courseInstance))
        {
            List<CostDTO> result = controller.GetAllCosts();
            foreach (CostDTO cost in result)
            {
                Console.WriteLine(cost);
            }
        }
        else
        {
            CostDTO result = controller.GetCost(courseInstance);
            Console.WriteLine(result);
        }
        
    }

    public void PrintHelp()
    {
        throw new NotImplementedException();
    }
}