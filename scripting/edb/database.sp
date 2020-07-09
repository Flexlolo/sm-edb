Handle g_hDB;
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
	if (g_hDB != null)
	{
		lolo_CloseHandle(g_hDB);
	}

	char error[256];

	g_hDB = SQL_Connect("edb", true, error, sizeof(error));

	if (g_hDB == null)
	{
		LogError(error);
		lolo_CloseHandle(g_hDB);
		return false;
	}

	return true;
}

stock void DB_Initialize()
{
	if (!DB_Connect())
	{
		SetFailState("Unable to connect to DB.");
	}
	
	for (int i; i < sizeof(g_sDB_Initialize_Query); i++)
	{
		SQL_TQuery(g_hDB, DB_Initialize_CB, g_sDB_Initialize_Query[i]);
	}
}

public void DB_Initialize_CB(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError(error);
	}
	else
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

public void DB_Empty_Callback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null) LogError(error);
}