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
    private PreparedStatement _listPeopleStmt;
    private PreparedStatement _listemployeesStmt;

    private PreparedStatement _FindCostAllStmt;
    private PreparedStatement _FindCostStmt;

    private PreparedStatement _UpdateStudentCount;
    
    
    
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
        _listPeopleStmt = PreparedStatement.Create(DbConnection, StatementStrings.Listpeople).Prepare();
        _listemployeesStmt =  PreparedStatement.Create(DbConnection, StatementStrings.Listemployees)
            .AddParameter("is_active", NpgsqlDbType.Boolean).Prepare();
        
        _FindCostAllStmt = PreparedStatement.Create(DbConnection, StatementStrings.PlannedActualCostAll).Prepare();
        
        _FindCostStmt = PreparedStatement.Create(DbConnection, StatementStrings.PlannedActualCost)
            .AddParameter("course_instance", NpgsqlDbType.Varchar).Prepare();
        
        _UpdateStudentCount = PreparedStatement.Create(DbConnection, StatementStrings.UpdateStudentCount)
            .AddParameter("new_num_students",NpgsqlDbType.Integer)
            .AddParameter("course_instance", NpgsqlDbType.Varchar).Prepare();
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
            using var reader = _listemployeesStmt.WithParameter("is_active", is_active).ExecuteReader(Transaction);
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
        using var reader = _listPeopleStmt.ExecuteReader(Transaction);
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
        _listPeopleStmt.Dispose();
        _listemployeesStmt.Dispose();
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