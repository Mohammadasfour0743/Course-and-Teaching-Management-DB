using DbCourse.Integration.Statements;
using DbCourse.Model;
using Npgsql;
using NpgsqlTypes;

namespace DbCourse.Integration;

public class DbContext : IDisposable
{
    public NpgsqlConnection DbConnection { get; }
    
    private NpgsqlTransaction? _transaction;
    private NpgsqlTransaction Transaction => _transaction ??= DbConnection.BeginTransaction();
    
    private PreparedStatement _getPersonStmt;
    private PreparedStatement _GetPeopleStmt;
    private PreparedStatement _GetEmployeesStmt;

    private PreparedStatement _FindCostAllStmt;
    private PreparedStatement _FindCostStmt;

    private PreparedStatement _UpdateStudentCount;
    
    private PreparedStatement _FindCourseActivityStmt;
    
    private PreparedStatement _FindTeacherAllocationStmt;

    private PreparedStatement _ReadInstanceId;
    
    private PreparedStatement _CreateTeacherAllocationStmt;
    
    private PreparedStatement _DeleteTeacherAllocationStmt;
    
    private PreparedStatement _CreateTeachingActivityStmt;

    private PreparedStatement _CreateCourseAllocationStmt;
    
    
    
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
        _getPersonStmt = PreparedStatement.Create(DbConnection,StatementStrings.Getpersonbylastname)
            .AddParameter("last_name",NpgsqlDbType.Varchar).Prepare();
        _GetPeopleStmt = PreparedStatement.Create(DbConnection, StatementStrings.Listpeople).Prepare();
        _GetEmployeesStmt =  PreparedStatement.Create(DbConnection, StatementStrings.Listemployees)
            .AddParameter("is_active", NpgsqlDbType.Boolean).Prepare();
        
        _FindCostAllStmt = PreparedStatement.Create(DbConnection, StatementStrings.PlannedActualCostAll).Prepare();
        
        _FindCostStmt = PreparedStatement.Create(DbConnection, StatementStrings.PlannedActualCost)
            .AddParameter("course_instance", NpgsqlDbType.Varchar).Prepare();
        
        _UpdateStudentCount = PreparedStatement.Create(DbConnection, StatementStrings.UpdateStudentCount)
            .AddParameter("new_num_students",NpgsqlDbType.Integer)
            .AddParameter("course_instance", NpgsqlDbType.Varchar).Prepare();
        
        _FindCourseActivityStmt = PreparedStatement.Create(DbConnection, StatementStrings.GetTeachingActivityOfCourse)
            .AddParameter("course_instance", NpgsqlDbType.Varchar).Prepare();
        
        _FindTeacherAllocationStmt = PreparedStatement.Create(DbConnection, StatementStrings.GetAllocationsOfTeacher)
            .AddParameter("first_name", NpgsqlDbType.Varchar)
            .AddParameter("last_name", NpgsqlDbType.Varchar).Prepare();
        
        _ReadInstanceId =  PreparedStatement.Create(DbConnection, StatementStrings.ReadInstanceId)
            .AddParameter("course_instance", NpgsqlDbType.Varchar).Prepare();
        
        _CreateTeacherAllocationStmt = PreparedStatement.Create(DbConnection, StatementStrings.AllocateTeachingActivity)
            .AddParameter("first_name",  NpgsqlDbType.Varchar).AddParameter("last_name", NpgsqlDbType.Varchar)
            .AddParameter("course_instance", NpgsqlDbType.Varchar).AddParameter("teaching_activity", NpgsqlDbType.Varchar)
            .AddParameter("amount_hours", NpgsqlDbType.Integer).Prepare();

        _DeleteTeacherAllocationStmt = PreparedStatement.Create(DbConnection, StatementStrings.DeallocateTeachingLoad)
            .AddParameter("first_name", NpgsqlDbType.Varchar).AddParameter("last_name", NpgsqlDbType.Varchar)
            .AddParameter("course_instance", NpgsqlDbType.Varchar)
            .AddParameter("teaching_activity", NpgsqlDbType.Varchar).Prepare();
        
        _CreateTeachingActivityStmt = PreparedStatement.Create(DbConnection, StatementStrings.AddTeachingActivity)
            .AddParameter("new_activity", NpgsqlDbType.Varchar)
            .AddParameter("factor", NpgsqlDbType.Numeric).Prepare();
        
        _CreateCourseAllocationStmt = PreparedStatement.Create(DbConnection, StatementStrings.AllocateTeachingActivity)
            .AddParameter("course_instance", NpgsqlDbType.Varchar)
            .AddParameter("hours",  NpgsqlDbType.Integer).AddParameter("activity_name", NpgsqlDbType.Varchar).Prepare();
    }


    /// <summary>
    /// returns planend and allocated costs for ALL COURSES
    /// </summary>
    /// <returns></returns>
    public List<CostDTO> FindAllPlannedAllocatedCost()
    {
        List<CostDTO> result = new List<CostDTO>();
        try
        {
            using var reader = _FindCostAllStmt.ExecuteReader(Transaction);
            while (reader.Read())
            {
                var course_code =  reader.GetString(0);
                var course_instance = reader.GetString(1);
                var period = reader.GetFieldValue<PeriodENUM>(2);
                var study_year = reader.GetString(3);
                var num_students = reader.GetInt32(4);
                var planned_cost = reader.GetDouble(5);
                var actual_cost = reader.GetDouble(6);
                result.Add(new CostDTO(course_code,course_instance, period,study_year,num_students,planned_cost,actual_cost));
                    
                
                
            }
            return result;
        }
        catch (Exception e)
        {
            
            throw;
        }
    }

    public CostDTO FindPlannedAllocatedCost(string ci_input)
    {
        CostDTO result;
        try
        {
            using var reader = _FindCostStmt.WithParameter("course_instance", ci_input).ExecuteReader(Transaction);
            reader.Read();
            
                var course_code =  reader.GetString(0);
                var course_instance = reader.GetString(1);
                var period = reader.GetFieldValue<PeriodENUM>(2);
                var study_year = reader.GetString(3);
                var num_students = reader.GetInt32(4);
                var planned_cost = reader.GetDouble(5);
                var actual_cost = reader.GetDouble(6);
                result = new CostDTO(course_code,course_instance, period,study_year,num_students,planned_cost,actual_cost);
                    
            
            return result;
        }
        catch (Exception e)
        {
            
            throw;
        }
    }

    public int UpdateStudentCount(int student_count, string ci_input)
    {
        try
        {
            return _UpdateStudentCount.WithParameter("new_num_students", student_count).WithParameter("course_instance", ci_input).ExecuteNonQuery(Transaction);
        }
        catch (Exception e)
        {
            
            throw;
        }
    }

    public int CreateTeacherAllocation(string fn, string ln, string ci_input, string activity_name, int hours)
    {
        try
        {
            return _CreateTeacherAllocationStmt.WithParameter("first_name", fn).WithParameter("last_name", ln)
                .WithParameter("course_instance", ci_input).WithParameter("teaching_activity", activity_name)
                .WithParameter("amount_hours", hours).ExecuteNonQuery(Transaction);
        }
        catch (Exception e)
        {
            
            throw;
        }
    }

    public int DeleteTeacherAllocation(string fn, string ln, string ci_input, string activity_name)
    {
        try
        {
            return _DeleteTeacherAllocationStmt.WithParameter("first_name", fn).WithParameter("last_name", ln)
                .WithParameter("course_instance", ci_input).WithParameter("teaching_activity", activity_name)
                .ExecuteNonQuery(Transaction);
        }
        catch (Exception e)
        {
            
            throw;
        }
    }

    public int CreateTeachingActivity(string new_activity, double factor)
    {
        try
        {
            return _CreateTeachingActivityStmt.WithParameter("new_activity", new_activity).WithParameter("factor", factor).ExecuteNonQuery(Transaction);
        }
        catch (Exception e)
        {
        
            throw;
        }
    }

    public int CreateCourseAllocation(string ci_input, int planned_hours, string activity_name)
    {
        try
        {
            return _CreateCourseAllocationStmt.WithParameter("course_instance", ci_input)
                .WithParameter("hours", planned_hours)
                .WithParameter("activity_name", activity_name)
                .ExecuteNonQuery(Transaction);
        }
        catch (Exception e)
        {
          
            throw;
        }
    }
    
    

    public string ReadInstanceIdLock(string ci_input)
    {
        string result;
        try
        {
            using var reader = _ReadInstanceId.WithParameter("course_instance", ci_input).ExecuteReader(Transaction);
            result = reader.GetString(0);
            return result;
        }
        catch (Exception e)
        {
            throw;
        }
    }

    /// <summary>
    /// gets all teaching activities of a course and displays them
    /// </summary>
    /// <param name="ci_input"></param>
    /// <returns></returns>
    public List<CourseActivityDTO> FindCourseActivity(string ci_input)
    {
        List<CourseActivityDTO> result = new List<CourseActivityDTO>();
        try
        {
            using var reader = _FindCourseActivityStmt.WithParameter("course_instance", ci_input).ExecuteReader(Transaction);
            while (reader.Read())
            {
                var course_instance = reader.GetString(0);
                var course_code =  reader.GetString(1);
                var course_name = reader.GetString(2);
                var activity_name = reader.GetString(3);
                result.Add(new CourseActivityDTO(course_instance,course_code, course_name, activity_name));
                
            }
            return result;
        }
        catch (Exception e)
        {
            
            throw;
        }
    }

    public List<TeacherAllocationDTO> FindTeacherActivity(string fn, string ln)
    {
        List<TeacherAllocationDTO> result = new List<TeacherAllocationDTO>();
        try
        {
            using var reader = _FindTeacherAllocationStmt.WithParameter("first_name", fn)
                .WithParameter("last_name", ln).ExecuteReader(Transaction);
            while (reader.Read())
            {
                var emp_name = reader.GetString(0);
                var  course_code = reader.GetString(1);
                var course_instance = reader.GetString(2);
                var period = reader.GetFieldValue<PeriodENUM>(3);
                var activity_name = reader.GetString(4);
                var allocated_hours = reader.GetInt32(5);
                result.Add(new TeacherAllocationDTO(emp_name, course_code, course_instance, period, activity_name, allocated_hours));
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
/// <param name="is_active"></param>
/// <returns></returns>
    public List<Employee> GetEmployees(bool? is_active=true)
    {
        List<Employee> result = new List<Employee>();
        try
        {
            using var reader = _GetEmployeesStmt.WithParameter("is_active", is_active).ExecuteReader(Transaction);
            while (reader.Read())
            {
                result.Add(new Employee
                    {
                        Id = reader.GetInt32(reader.GetOrdinal("id")),
                        EmploymentId = reader.GetInt32(reader.GetOrdinal("employment_id")),
                        JobTitleId = reader.GetInt32(reader.GetOrdinal("job_title_id")),
                        PersonId = reader.GetInt32(reader.GetOrdinal("person_id")),
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
    

    public int GetPersonId(string lastName)
    {
       return _getPersonStmt.WithParameter("last_name", lastName).ExecuteScalar<int>(Transaction);
    }

    //todo: move col names to constants?
    public List<Person> GetPeople()
    {
        List<Person> result = [];
        using var reader = _GetPeopleStmt.ExecuteReader(Transaction);
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
        _getPersonStmt.Dispose();
        _GetPeopleStmt.Dispose();
        _GetEmployeesStmt.Dispose();
        _transaction?.Dispose();
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