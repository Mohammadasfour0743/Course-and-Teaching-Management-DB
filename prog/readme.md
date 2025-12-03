Create a .env file in the same directory as the .csproj file and put this in:
`CONNECTION_STRING=Host=localhost;Database=<dbname>;Username=postgres;Password=<password>`

To add new commands just create a new class, implement `ICommand` and add the necessary parsing in `CommandHandler.ParseCommand()`.
From `ICommand` the `Controller` is available, that is where the logic goes, but db stuff like running queries should be done inside `DbContext`.

To add new queries in `DbContext` put the SQL code into `Integration/Statements/StatementStrings` as a constant, parameters can be added
by putting an `@` before them. Then create a new `PreparedStatement` object inside `DbContext.CreatePreparedStatements()`. If the statement
has parameters they need to be registered with `.AddParameter(param_name, param_type)`, types can be found in `NpgsqlDbType`. If that is done
call `.Prepare()` on it. After that the query can be used: `WithParameter(param_name, param_value`) sets the parameters,
`ExecuteScalar` returns the first col of first row, `ExecuteReader` return a stream of rows, `ExecuteNonQuery` is for `INSERT` or `UPDATE`, pass in `DbContext.Transaction`.
After `ClearParameters()` call `Prepare()` again. Don't forget to add the new statement to `DbContext.Dispose()`. 

There should be some error handling, but it is not done yet. If you want use `ArgumentOutOfRangeException` if the given value is too big/small/long/short etc., 
use `ArgumentNullException` for nulls, otherwise `InvalOperationException` might be needed too. Throw errors in `DbContext`, handle them in `Controller`
(rollback if needed), and make some kind of error message and throw it forward to `CommandHandler`.

If you make a new model it is a good idea to inherit from `IEquatable`, the IDE should generate the functions automatically. Also 
overload `ToString()` to make it easy to print.