public Action Event_Name(Handle event, const char[] name, bool dontBroadcast)
{
	int timestamp = GetTime();
	
	char user_id[32];
	GetEventString(event, "userid", user_id, sizeof(user_id));
	int client = GetClientOfUserId(StringToInt(user_id));

	if (!lolo_IsClientValid(client))
	{
		return Plugin_Continue;
	}

	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));

	char ip[32];
	GetClientIP(client, ip, sizeof(ip));

	char player_name[32];
	GetClientName(client, player_name, sizeof(player_name));

	char player_name_new[32];
	GetEventString(event, "newname", player_name_new, sizeof(player_name_new));

	Event_Name_Insert(timestamp, steam_id, ip, player_name, player_name_new);

	return Plugin_Continue;
}

public void Event_Name_Insert(int timestamp, const char[] steam_id, const char[] ip, const char[] player_name, const char[] player_name_new)
{
	char steam_id_esc[65];
	char ip_esc[65];
	char player_name_esc[65];
	char player_name_new_esc[65];

	SQL_LockDatabase(g_hDB);
	SQL_EscapeString(g_hDB, steam_id, 			steam_id_esc, 			sizeof(steam_id_esc));
	SQL_EscapeString(g_hDB, ip, 				ip_esc, 				sizeof(ip_esc));
	SQL_EscapeString(g_hDB, player_name, 		player_name_esc, 		sizeof(player_name_esc));
	SQL_EscapeString(g_hDB, player_name_new, 	player_name_new_esc, 	sizeof(player_name_new_esc));
	SQL_UnlockDatabase(g_hDB);

	char query[1024];
	Format(query, sizeof(query), 
		"INSERT INTO events_name \
		(server_id, timestamp, steam_id, ip, player_name, player_name_new) \
		VALUES ('%d', '%d', '%s', '%s', '%s', '%s')", 
		g_h_cServerID.IntValue, timestamp, steam_id_esc, ip_esc, player_name_esc, player_name_new_esc);

	SQL_TQuery(g_hDB, DB_Empty_Callback, query, 0);
}

