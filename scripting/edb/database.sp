Database g_hDB;

Handle g_hDB_Initialized;
bool g_bDB_Initialized;

#define DB_STEPS 3
int g_iDB_Steps;

char g_sDB_Initialize_Query[][] = 
{
	"CREATE TABLE IF NOT EXISTS servers (server_id INT, server_name TEXT, PRIMARY KEY (server_id))",
	"CREATE TABLE IF NOT EXISTS event_connect (id INTEGER AUTO_INCREMENT, server_id INT, timestamp INT, steam_id VARCHAR(32), ip VARCHAR(32), player_name VARCHAR(32), PRIMARY KEY (id))",
	"CREATE TABLE IF NOT EXISTS event_name (id INTEGER AUTO_INCREMENT, server_id INT, timestamp INT, steam_id VARCHAR(32), ip VARCHAR(32), player_name VARCHAR(32), player_name_new VARCHAR(32), PRIMARY KEY (id))"
};

stock bool DB_Connect()
{
	Database.Connect(DB_Connect_CB, "edb");
}

public void DB_Connect_CB(Database db, const char[] error, any data)
{
	if (db == null || error[0])
	{
		LogError(error);
		SetFailState(error);
	}

	g_hDB = db;
	DB_Init();
}

stock void DB_Init()
{
	for (int i; i < sizeof(g_sDB_Initialize_Query); i++)
	{
		g_hDB.Query(DB_Init_CB, g_sDB_Initialize_Query[i]);
	}
}

public void DB_Init_CB(Database db, DBResultSet results, const char[] error, any data)
{
	if (db != null)
	{
		g_iDB_Steps++;
		g_bDB_Initialized = (g_iDB_Steps == DB_STEPS);

		if (g_bDB_Initialized)
		{
			Call_StartForward(g_hDB_Initialized);
			Call_Finish();
		}
	}
}

public void DB_Query_CB(Database db, DBResultSet results, const char[] error, any data)
{
	if (db == null) LogError(error);	
}