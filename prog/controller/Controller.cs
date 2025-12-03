using DbCourse.Integration;
using DbCourse.Model;

namespace DbCourse.Controller;

public class Controller(DbContext dbContext)
{
    public List<Person> GetPeople()
    {
        return dbContext.GetPeople();
    }
    public void Commit() => dbContext.Commit();
    public void Rollback() => dbContext.Rollback();
}