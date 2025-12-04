using DbCourse.Integration;
using DbCourse.Integration.Statements;
using DbCourse.View;
using DotNetEnv;
using Microsoft.Extensions.Configuration;

namespace DbCourse;

class Program
{
    static void Main(string[] args)
    {
        Console.OutputEncoding = System.Text.Encoding.UTF8;
       
        Env.Load("C:\\Users\\Mohammad Asfour\\Desktop\\Course-and-Teaching-Management-DB\\prog\\.env");
        string connectionString = Env.GetString("CONNECTION_STRING");
        if (string.IsNullOrWhiteSpace(connectionString))
        {
            Console.WriteLine("CONNECTION_STRING is missing");
            return;
        }
        
        using var dbContext = new DbContext(connectionString);
        var controller = new Controller.Controller(dbContext);

        CommandHandler cmdHandler = new CommandHandler(controller);
        try
        {
            cmdHandler.StartHandler();
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            
        }
    }
}