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
    private PreparedStatement _listPeopleStmt;
    
    
    public DbContext(string connectionString)
    {
        DbConnection = new NpgsqlConnection(connectionString);
        DbConnection.Open();
        CreatePreparedStatements();
    }

    private void CreatePreparedStatements()
    {
        _getPersonStmt = PreparedStatement.Create(DbConnection,StatementStrings.Getpersonbylastname)
            .AddParameter("@last_name",NpgsqlDbType.Varchar).Prepare();
        _listPeopleStmt = PreparedStatement.Create(DbConnection, StatementStrings.Listpeople).Prepare();
    }

    public int GetPerson(string lastName)
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