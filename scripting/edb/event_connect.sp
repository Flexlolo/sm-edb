public Action Event_Connect(Handle event, const char[] name, bool dontBroadcast)
{
	char user_id[32];
	GetEventString(event, "userid", user_id, sizeof(user_id));

	char address[64];
	GetEventString(event, "address", address, sizeof(address));

	int size = StrContains(address, ":", true);

	// Is fake client?
	if (size > 0)
	{
		char steam_id[32];
		GetEventString(event, "networkid", steam_id, sizeof(steam_id));
		lolo_SteamID2(steam_id, sizeof(steam_id), steam_id);

		char[] ip = new char[size + 1];
		strcopy(ip, size + 1, address);

		char player_name[32];
		GetEventString(event, "name", player_name, sizeof(player_name));
		
		int timestamp = GetTime();

		Event_Connect_Insert(timestamp, steam_id, ip, player_name);
	}

	return Plugin_Continue;
}

public void Event_Connect_Insert(int timestamp, const char[] steam_id, const char[] ip, const char[] player_name)
{
	char steam_id_esc[65];
	char ip_esc[65];
	char player_name_esc[65];

	SQL_LockDatabase(g_hDB);
	SQL_EscapeString(g_hDB, steam_id, 			steam_id_esc, 			sizeof(steam_id_esc));
	SQL_EscapeString(g_hDB, ip, 				ip_esc, 				sizeof(ip_esc));
	SQL_EscapeString(g_hDB, player_name, 		player_name_esc, 		sizeof(player_name_esc));
	SQL_UnlockDatabase(g_hDB);

	char query[1024];
	Format(query, sizeof(query), 
		"INSERT INTO event_connect \
		(server_id, timestamp, steam_id, ip, player_name) \
		VALUES ('%d', '%d', '%s', '%s', '%s')", 
		g_h_cServerID.IntValue, timestamp, steam_id_esc, ip_esc, player_name_esc);

	SQL_TQuery(g_hDB, DB_Empty_Callback, query, 0);
}