using DbCourse.Integration;
using DbCourse.Model;
using Npgsql;

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

    public CostDTO GetCost(string ciInput)
    {
        try
        {
            return dbContext.FindPlannedAllocatedCost(ciInput);
        }
        catch (InvalidOperationException e)
        {
            throw new InvalidOperationException($"Unable to find course instance. Input: {ciInput}", e);

        }
        catch (Exception e)
        {
            throw;
        }
        
    }

    public List<CourseActivityDTO> GetCourseActivity(string ciInput)
    {
        
        return dbContext.FindCourseActivity(ciInput);
    }

    public List<TeacherAllocationDTO> GetTeacherAllocation(string firstName, string lastName)
    {
        return dbContext.FindTeacherActivity(firstName, lastName);
    }

    public int UpdateStudentCount( int newNumStudents, string ciInput)
    {
        try
        {
            int affected = dbContext.UpdateStudentCount(newNumStudents, ciInput);
            if (affected <= 0)
            {
                throw new ArgumentOutOfRangeException(nameof(ciInput), ciInput, "Course instance does not exist :(");
            }
            Commit();
            
            return affected;
        }
        catch (Exception e)
        {   
            Rollback();
            throw;
        }
    }
    
   

    public int AllocateTeacherActivity(string firstName, string lastName, string ciInput, string activityName, int hours)
    {
        try
        {
            int affected = dbContext.CreateTeacherAllocation(firstName, lastName, ciInput, activityName, hours);
            if (affected <= 0)
            {
                throw new InvalidOperationException("Unable to create a new TeacherAllocation. Input is wrong");
            }
            Commit();
            return affected;
        }
        catch (Exception e)
        {
            Rollback();
            throw;
        }
        
    }

    public int DeallocateTeacherActivity(string firstName, string lastName, string ciInput, string activityName)
    {
        try
        {
            int affected = dbContext.DeleteTeacherAllocation(firstName, lastName, ciInput, activityName);
            if (affected <= 0)
            {
                throw new InvalidOperationException("Unable to delete TeacherAllocation. Input is wrong");
            }
            Commit();
            return affected;
        }
        catch (Exception e)
        {
            Rollback();
            throw;
        }
    }
    public int CreateActivity(string activityName, double factor)
    {
        try
        {
            int affected = dbContext.CreateTeachingActivity(activityName, factor);
            if (affected <= 0)
            {
                throw new InvalidOperationException("Unable to create a new TeachingActivity. Input is wrong");
            }
            Commit();
            return affected;
        }
        catch (NpgsqlException e)
        {
            Rollback();
            if (e.SqlState == "23505")
            {
                throw new InvalidOperationException("Teaching activity already exists");
            }

            throw;

        }
        catch (Exception e)
        {
            Rollback();
            throw;
        }
    }
    public int AssignActivityToCourse(string ciInput, int plannedHours, string activityName)
    {
        try
        {
            int affected = dbContext.CreateCourseAllocation(ciInput, plannedHours, activityName);
            if (affected <= 0)
            {
                throw new InvalidOperationException("Unable to create a new CourseAllocation. Input is wrong");
            }
            Commit();
            return affected;
        }
        catch (Exception e)
        {
            Rollback();
            throw;
        }
    }


    private void Commit() => dbContext.Commit();
    private void Rollback() => dbContext.Rollback();
}