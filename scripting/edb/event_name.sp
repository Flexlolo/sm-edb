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

	char query[1024];
	g_hDB.Format(query, sizeof(query), 
		"INSERT INTO event_name \
		(server_id, timestamp, steam_id, ip, player_name, player_name_new) \
		VALUES ('%d', '%d', '%s', '%s', '%s')", 
		g_h_cServerID.IntValue, timestamp, steam_id, ip, player_name, player_name_new);

	g_hDB.Query(DB_Query_CB, query);

	return Plugin_Continue;
}