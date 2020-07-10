/*
COMPILE OPTIONS
*/

#pragma semicolon 1
#pragma newdecls required

/*
INCLUDES
*/

#include <sourcemod>
#include <lololib>

/*
PLUGIN INFO
*/

public Plugin myinfo = 
{
	name			= "Event Database",
	author			= "Flexlolo",
	description		= "Log connect events to database",
	version			= "1.0.0",
	url				= "github.com/Flexlolo/"
}

/*
GLOBAL VARIABLES
*/

ConVar g_h_cConfigured;
ConVar g_h_cServerID;
ConVar g_h_cServerName;

/*
EXTRA INCLUDES
*/

#include "edb/database.sp"
#include "edb/server.sp"
#include "edb/event_connect.sp"
#include "edb/event_name.sp"

/*
NATIVES AND FORWARDS
*/

public void OnPluginStart()
{
	// Forwards
	g_hDB_Initialized = CreateForward(ET_Ignore);
	AddToForward(g_hDB_Initialized, GetMyHandle(), DB_Initialized);

	// ConVar
	g_h_cConfigured = CreateConVar("sm_edb_configured", 	"0", 	"Prevention of launching plugin with default convars. (Set to 1)", 	FCVAR_PROTECTED);
	g_h_cServerID 	= CreateConVar("sm_edb_server_id", 		"1", 	"Server ID in database (int)", 										FCVAR_PROTECTED);
	g_h_cServerName = CreateConVar("sm_edb_server_name", 	"???", 	"Server name in database", 											FCVAR_PROTECTED);

	AutoExecConfig(true, "edb");
}

public void OnConfigsExecuted()
{
	if (!g_h_cConfigured.IntValue)
	{
		SetFailState("edb.cfg is not configured.");
	}

	DB_Connect();
}

public void DB_Initialized()
{
	Server_Register();

	HookEvent("player_connect", 		Event_Connect, 		EventHookMode_Pre);
	HookEvent("player_changename", 		Event_Name, 		EventHookMode_Post);
}