using Npgsql;
using NpgsqlTypes;

namespace DbCourse.Integration.Statements;

public class PreparedStatement(NpgsqlCommand command) :IDisposable
{
    public NpgsqlCommand Command { get; private set; } = command;
    
    public static PreparedStatement Create(NpgsqlConnection connection, string statementString)
    {
        var cmd = new NpgsqlCommand(statementString, connection);
        return new PreparedStatement(cmd);
    }

    public PreparedStatement AddParameter(string name, NpgsqlDbType type)
    {
        Command.Parameters.Add(name, type);
        return this;
    }

    public PreparedStatement Prepare()
    {
        Command.Prepare();
        return this;
    }
    public PreparedStatement WithParameter(string name, object value)
    {
        if (Command.Parameters.Contains(name))
        {
            Command.Parameters[name].Value = value ?? DBNull.Value;
        }
        else
        {
            Command.Parameters.AddWithValue(name, value ?? DBNull.Value);
            Prepare();
        }
        return this;
    }
    //dont think we need to clear but gotta check docs
    public T? ExecuteScalar<T>(NpgsqlTransaction? transaction = null)
    {
        Command.Transaction = transaction;
        try
        {
            var result = Command.ExecuteScalar();
            //todo: type safety? Convert.ChangeType() or should it return null
            return result is null ? default : (T)result;
        }
        finally
        {
           // Command.Parameters.Clear();
            Command.Transaction = null;
        }
    }
    //todo:might be too convoluted
    public NpgsqlDataReader ExecuteReader(NpgsqlTransaction? transaction = null)
    {
        Command.Transaction = transaction;
        try
        {
           return Command.ExecuteReader();
        }
        finally
        {
            //Command.Parameters.Clear();
            Command.Transaction = null;
        }
    }

    public int ExecuteNonQuery(NpgsqlTransaction? transaction = null)
    {
        Command.Transaction = transaction;
        try
        {
           
            var result = Command.ExecuteNonQuery();
            return result;
        }
        finally
        {
            //Command.Parameters.Clear();
            Command.Transaction = null;
        }
    }
    
    public PreparedStatement ClearParameters()
    {
        Command.Parameters.Clear();
        return this;
    }


    public void Dispose()
    {
        Command.Dispose();
    }
    
}
