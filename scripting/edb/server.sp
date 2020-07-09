stock void Server_Register()
{
	char sServerName[128];
	g_h_cServerName.GetString(sServerName, sizeof(sServerName));

	char sServerName_Esc[256];

	SQL_LockDatabase(g_hDB);
	SQL_EscapeString(g_hDB, sServerName, sServerName_Esc, sizeof(sServerName_Esc));
	SQL_UnlockDatabase(g_hDB);

	char query[1024];
	Format(query, sizeof(query), "INSERT IGNORE INTO servers (server_id, server_name) VALUES (%d, '%s')", g_h_cServerID.IntValue, sServerName_Esc);

	SQL_TQuery(g_hDB, DB_Empty_Callback, query, 0);
}