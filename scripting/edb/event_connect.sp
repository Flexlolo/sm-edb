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

		char query[1024];
		g_hDB.Format(query, sizeof(query), 
			"INSERT INTO event_connect \
			(server_id, timestamp, steam_id, ip, player_name) \
			VALUES ('%d', '%d', '%s', '%s', '%s')", 
			g_h_cServerID.IntValue, timestamp, steam_id, ip, player_name);

		g_hDB.Query(DB_Query_CB, query);
	}

	return Plugin_Continue;
}