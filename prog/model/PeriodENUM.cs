using NpgsqlTypes;

namespace DbCourse.Model;

public enum PeriodENUM
{
[PgName("1")]
One = 1, 
[PgName("2")]
Two = 2,
[PgName("3")]
Three = 3,
[PgName("4")]
Four = 4,
}