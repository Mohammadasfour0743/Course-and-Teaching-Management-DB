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

    public List<CourseActivityDTO> GetCourseActivity(string ci_input)
    {
        return dbContext.FindCourseActivity(ci_input);
    }

    public List<TeacherAllocationDTO> GetTeacherAllocation(string fn, string ln)
    {
        return dbContext.FindTeacherActivity(fn, ln);
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
    
   
//not implemented in view
    public int AllocateTeacherActivity(string fn, string ln, string ci_input, string activity_name, int hours)
    {
        try
        {
            int affected = dbContext.CreateTeacherAllocation(fn, ln, ci_input, activity_name, hours);
            if (affected == 0)
            {
                throw new InvalidOperationException("Unable to create a new TeacherAllocation. Input is wrong");
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
//not implemented in view
    public int DeallocateTeacherActivity(string fn, string ln, string ci_input, string activity_name)
    {
        try
        {
            int affected = dbContext.DeleteTeacherAllocation(fn, ln, ci_input, activity_name);
            if (affected == 0)
            {
                throw new InvalidOperationException("Unable to delete TeacherAllocation. Input is wrong");
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
//not implemented in view
    public int CreateActivity(string activity_name, double factor)
    {
        try
        {
            int affected = dbContext.CreateTeachingActivity(activity_name, factor);
            if (affected == 0)
            {
                throw new InvalidOperationException("Unable to create a new TeachingActivity. Input is wrong");
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
//not implemented in view
    public int AssignActivityToCourse(string ci_input, int planned_hours, string activity_name)
    {
        try
        {
            int affected = dbContext.CreateCourseAllocation(ci_input, planned_hours, activity_name);
            if (affected == 0)
            {
                throw new InvalidOperationException("Unable to create a new CourseAllocation. Input is wrong");
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