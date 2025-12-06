using DbCourse.Integration;
using DbCourse.Model;

namespace DbCourse.Controller;

public class Controller(DbContext dbContext)
{
    public List<Person> GetPeople()
    {
        return dbContext.GetPeople();
    }

    public List<Employee> GetEmployees(bool? isActive)
    {
        return dbContext.GetEmployees(isActive);
    }

    public List<CostDTO> GetAllCosts()
    {
        return dbContext.FindAllPlannedAllocatedCost();
    }

    public CostDTO GetCost(string ci_input)
    {
        return dbContext.FindPlannedAllocatedCost(ci_input);
    }

    public int UpdateStudentCount( int new_num_students, string ci_input)
    {
        try
        {
            int affected = dbContext.UpdateStudentCount(new_num_students, ci_input);
            if (affected == 0)
            {
                throw new ArgumentOutOfRangeException(nameof(ci_input), ci_input, "Course instance does not exist :(");
            }
            Commit();
            
            return affected;
        }
        catch (Exception e)
        {   
            Rollback();
            Console.WriteLine(e);
            throw;
        }
    }
    
    public void Commit() => dbContext.Commit();
    public void Rollback() => dbContext.Rollback();
}