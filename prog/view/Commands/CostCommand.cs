using DbCourse.Model;

namespace DbCourse.View.Commands;

public class CostCommand(string? courseInstance = null) : ICommand
{
    public void Execute(Controller.Controller controller)
    {
        if (string.IsNullOrEmpty(courseInstance))
        {
            List<CostDTO> result = controller.GetAllCosts();
            if(result.Count == 0)
                Console.WriteLine("No results. Check input");
            else
            {
                foreach (CostDTO cost in result)
                {
                    Console.WriteLine(cost);
                }
            }
            
        }
        else
        {
            //todo no res
            CostDTO result = controller.GetCost(courseInstance);
            Console.WriteLine(result);
        }
        
    }

    public void PrintHelp()
    {
        Console.WriteLine($"Usage: get_cost" +
                          $"\n {new string(' ',14)} <ci_id> " 
        );
    }
}