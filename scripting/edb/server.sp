stock void Server_Register()
{
	char server_name[128];
	g_h_cServerName.GetString(server_name, sizeof(server_name));

	char query[1024];
	g_hDB.Format(query, sizeof(query), 
		"INSERT IGNORE INTO servers \
		(server_id, server_name) \
		VALUES (%d, '%s')",
		g_h_cServerID.IntValue, server_name);

	g_hDB.Query(DB_Query_CB, query);
}