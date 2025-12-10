using DbCourse.Integration.Statements;
using DbCourse.Model;
using Npgsql;
using NpgsqlTypes;

namespace DbCourse.Integration;

public class DbContext : IDisposable
{
    private NpgsqlConnection DbConnection { get; }
    
    private NpgsqlTransaction? _transaction;
    private NpgsqlTransaction Transaction => _transaction ??= DbConnection.BeginTransaction();
    
    
    private PreparedStatement _getPersonStmt;
    
    private PreparedStatement _getPeopleStmt;
    
    private PreparedStatement _getEmployeesStmt;

    private PreparedStatement _findCostAllStmt;
    
    private PreparedStatement _findCostStmt;

    private PreparedStatement _updateStudentCount;
    
    private PreparedStatement _findCourseActivityStmt;
    
    private PreparedStatement _findTeacherAllocationStmt;

    private PreparedStatement _readInstanceId;
    
    private PreparedStatement _createTeacherAllocationStmt;
    
    private PreparedStatement _deleteTeacherAllocationStmt;
    
    private PreparedStatement _createTeachingActivityStmt;

    private PreparedStatement _createCourseAllocationStmt;
    
    
    
    public DbContext(string connectionString)
    {
        
        NpgsqlConnection.GlobalTypeMapper.EnableUnmappedTypes();
        NpgsqlConnection.GlobalTypeMapper.MapEnum<PeriodENUM>("period");
        DbConnection = new NpgsqlConnection(connectionString);
        DbConnection.Open();
        CreatePreparedStatements();
        
    }

    private void CreatePreparedStatements()
    {
       
        
        _getPeopleStmt = PreparedStatement
            .Create(DbConnection, StatementStrings.ListPeople)
            .Prepare();
        
        _getEmployeesStmt =  PreparedStatement
            .Create(DbConnection, StatementStrings.ListEmployees)
            .AddParameter("is_active", NpgsqlDbType.Boolean)
            .Prepare();
        
        _findCostAllStmt = PreparedStatement
            .Create(DbConnection, StatementStrings.PlannedActualCostAll)
            .Prepare();
        
        _findCostStmt = PreparedStatement
            .Create(DbConnection, StatementStrings.PlannedActualCost)
            .AddParameter("course_instance", NpgsqlDbType.Varchar)
            .Prepare();
        
        _updateStudentCount = PreparedStatement
            .Create(DbConnection, StatementStrings.UpdateStudentCount)
            .AddParameter("new_num_students",NpgsqlDbType.Integer)
            .AddParameter("course_instance", NpgsqlDbType.Varchar)
            .Prepare();
        
        _findCourseActivityStmt = PreparedStatement
            .Create(DbConnection, StatementStrings.GetTeachingActivityOfCourse)
            .AddParameter("course_instance", NpgsqlDbType.Varchar)
            .Prepare();
        
        _findTeacherAllocationStmt = PreparedStatement
            .Create(DbConnection, StatementStrings.GetAllocationsOfTeacher)
            .AddParameter("emp_id", NpgsqlDbType.Integer)
            .Prepare();
        
      
        
        _createTeacherAllocationStmt = PreparedStatement
            .Create(DbConnection, StatementStrings.AllocateTeachingLoad)
            .AddParameter("emp_id",  NpgsqlDbType.Integer)
            .AddParameter("course_instance", NpgsqlDbType.Varchar)
            .AddParameter("teaching_activity", NpgsqlDbType.Varchar)
            .AddParameter("amount_hours", NpgsqlDbType.Integer)
            .Prepare();

        _deleteTeacherAllocationStmt = PreparedStatement
            .Create(DbConnection, StatementStrings.DeallocateTeachingLoad)
            .AddParameter("emp_id",  NpgsqlDbType.Integer)
            .AddParameter("course_instance", NpgsqlDbType.Varchar)
            .AddParameter("teaching_activity", NpgsqlDbType.Varchar)
            .Prepare();
        
        _createTeachingActivityStmt = PreparedStatement
            .Create(DbConnection, StatementStrings.AddTeachingActivity)
            .AddParameter("new_activity", NpgsqlDbType.Varchar)
            .AddParameter("factor", NpgsqlDbType.Numeric)
            .Prepare();
        
        _createCourseAllocationStmt = PreparedStatement
            .Create(DbConnection, StatementStrings.AllocateTeachingActivity)
            .AddParameter("course_instance", NpgsqlDbType.Varchar)
            .AddParameter("hours",  NpgsqlDbType.Integer)
            .AddParameter("activity_name", NpgsqlDbType.Varchar)
            .Prepare();
    }



    public List<CostDTO> ReadAllPlannedAllocatedCost()
    {
        List<CostDTO> result = new List<CostDTO>();
        try
        {
            using var reader = _findCostAllStmt.ExecuteReader(Transaction);
            while (reader.Read())
            {
                var courseCode =  reader.GetString(0);
                var courseInstance = reader.GetString(1);
                var period = reader.GetFieldValue<PeriodENUM>(2);
                var studyYear = reader.GetString(3);
                var numStudents = reader.GetInt32(4);
                var plannedCost = reader.GetDouble(5);
                var actualCost = reader.GetDouble(6);
                result.Add(new CostDTO(courseCode,courseInstance, period,studyYear,numStudents,plannedCost,actualCost));
            }
            return result;
        }
        catch (Exception e)
        {
            
            throw;
        }
    }

    public CostDTO ReadPlannedAllocatedCost(string ciInput)
    {
        try
        {
            using var reader = _findCostStmt
                .WithParameter("course_instance", ciInput)
                .ExecuteReader(Transaction);
            reader.Read();
            
            var courseCode =  reader.GetString(0);
            var courseInstance = reader.GetString(1);
            var period = reader.GetFieldValue<PeriodENUM>(2);
            var studyYear = reader.GetString(3);
            var numStudents = reader.GetInt32(4);
            var plannedCost = reader.GetDouble(5);
            var actualCost = reader.GetDouble(6);
                
            return new CostDTO(courseCode,courseInstance, period,studyYear,numStudents,plannedCost,actualCost);
        }
        catch (Exception e)
        {
            
            throw;
        }
    }

    public int UpdateStudentCount(int studentCount, string ciInput)
    {
        try
        {
            return _updateStudentCount
                .WithParameter("new_num_students", studentCount)
                .WithParameter("course_instance", ciInput)
                .ExecuteNonQuery(Transaction);
        }
        catch (Exception e)
        {
            
            throw;
        }
    }

    public int CreateTeacherAllocation(int empId, string ciInput, string activityName, int hours)
    {
        try
        {
            return _createTeacherAllocationStmt
                .WithParameter("emp_id", empId)
                .WithParameter("course_instance", ciInput)
                .WithParameter("teaching_activity", activityName)
                .WithParameter("amount_hours", hours)
                .ExecuteNonQuery(Transaction);
        }
        catch (Exception e)
        {
            
            throw;
        }
    }

    public int DeleteTeacherAllocation(int empId, string ciInput, string activityName)
    {
        try
        {
            return _deleteTeacherAllocationStmt
                .WithParameter("emp_id", empId)
                .WithParameter("course_instance", ciInput)
                .WithParameter("teaching_activity", activityName)
                .ExecuteNonQuery(Transaction);
        }
        catch (Exception e)
        {
            
            throw;
        }
    }

    public int CreateTeachingActivity(string newActivity, double factor)
    {
        try
        {
            return _createTeachingActivityStmt
                .WithParameter("new_activity", newActivity)
                .WithParameter("factor", factor)
                .ExecuteNonQuery(Transaction);
        }
        
        catch (Exception e)
        {
            throw;
        }
    }

    public int CreateCourseAllocation(string ciInput, int plannedHours, string activityName)
    {
        try
        {
            return _createCourseAllocationStmt
                .WithParameter("course_instance", ciInput)
                .WithParameter("hours", plannedHours)
                .WithParameter("activity_name", activityName)
                .ExecuteNonQuery(Transaction);
        }
        catch (Exception e)
        {
          
            throw;
        }
    }
    
    

   


    public List<CourseActivityDTO> ReadCourseActivity(string ciInput)
    {
        List<CourseActivityDTO> result = new List<CourseActivityDTO>();
        try
        {
            using var reader = _findCourseActivityStmt
                .WithParameter("course_instance", ciInput)
                .ExecuteReader(Transaction);
            
            while (reader.Read())
            {
                var courseInstance = reader.GetString(0);
                var courseCode =  reader.GetString(1);
                var courseName = reader.GetString(2);
                var activityName = reader.GetString(3);
                result.Add(new CourseActivityDTO(courseInstance,courseCode, courseName, activityName));
                
            }
            return result;
        }
        catch (Exception e)
        {
            
            throw;
        }
    }

    public List<TeacherAllocationDTO> ReadTeacherActivity(int empId)
    {
        List<TeacherAllocationDTO> result = new List<TeacherAllocationDTO>();
        try
        {
            using var reader = _findTeacherAllocationStmt
                .WithParameter("emp_id", empId)
                .ExecuteReader(Transaction);
            
            while (reader.Read())
            {
                var empName = reader.GetString(0);
                var  courseCode = reader.GetString(1);
                var courseInstance = reader.GetString(2);
                var period = reader.GetFieldValue<PeriodENUM>(3);
                var activityName = reader.GetString(4);
                var allocatedHours = reader.GetInt32(5);
                var employeeId = reader.GetInt32(6);
                result.Add(new TeacherAllocationDTO(empName, employeeId, courseCode, courseInstance, period, activityName, allocatedHours));
            }
            return result;
        }
        catch (Exception e)
        {
            
            throw;
        }
    }
    
    
    
    
    
    
/// <summary>
/// fetches all employees, and can filter for is_active
/// </summary>
/// <param name="isActive"></param>
/// <returns></returns>
    public List<Employee> ReadEmployees(bool? isActive=true)
    {
        List<Employee> result = new List<Employee>();
        try
        {
            using var reader = _getEmployeesStmt
                .WithParameter("is_active", isActive ?? true)
                .ExecuteReader(Transaction);
            
            while (reader.Read())
            {
                result.Add(new Employee
                    {
                        Id = reader.GetInt32(reader.GetOrdinal("id")),
                        EmploymentId = reader.GetInt32(reader.GetOrdinal("employment_id")),
                        JobTitleId = reader.GetInt32(reader.GetOrdinal("job_title_id")),
                        Name = reader.GetString(reader.GetOrdinal("employee_name")),
                        DepartmentId = reader.GetInt32(reader.GetOrdinal("department_id")),
                        ManagerId =  reader.GetFieldValue<int?>(reader.GetOrdinal("manager_id")),
                        IsActive = reader.GetBoolean(reader.GetOrdinal("is_active")),
                    }
                );
            }
        }
        catch (Exception e)
        {
            
            throw;
        }
       
        return result;
    }
    

    

    //todo: move col names to constants?
    public List<Person> ReadPeople()
    {
        List<Person> result = [];
        using var reader = _getPeopleStmt.ExecuteReader(Transaction);
        while (reader.Read())
        {
            result.Add(new Person
            {
                Id = reader.GetInt32(reader.GetOrdinal("id")),
                PersonalNumber = reader.GetString(reader.GetOrdinal("personal_number")),
                FirstName = reader.GetString(reader.GetOrdinal("first_name")),
                LastName = reader.GetString(reader.GetOrdinal("last_name")),
                Street = reader.GetString(reader.GetOrdinal("street")),
                Zip = reader.GetString(reader.GetOrdinal("zip")),
            });
        }

        return result;
    }
    
    
    
    //todo:simple query not prepared
    
    public void Commit()
    {
        _transaction?.Commit();
        _transaction = null; 
    }

    public void Rollback()
    {
        _transaction?.Rollback();
        _transaction = null;
    }


    public void Dispose()
    {
        _transaction?.Dispose();
        _getPersonStmt.Dispose();
        _getPeopleStmt.Dispose();
        _getEmployeesStmt.Dispose();
        _findCostAllStmt.Dispose();
        _findCostStmt.Dispose();
        _updateStudentCount.Dispose();
        _findCourseActivityStmt.Dispose();
        _findTeacherAllocationStmt.Dispose();
        _readInstanceId.Dispose();
        _createTeacherAllocationStmt.Dispose();
        _deleteTeacherAllocationStmt.Dispose();
        _createTeachingActivityStmt.Dispose();
        _createCourseAllocationStmt.Dispose();
        DbConnection.Dispose();
    }
}
/*
| Code      | Meaning               |
| --------- | --------------------- |
| **23505** | unique violation      |
| **23503** | foreign key violation |
| **23502** | not-null violation    |
| **22001** | string too long       |
| **42601** | syntax error          |

 */