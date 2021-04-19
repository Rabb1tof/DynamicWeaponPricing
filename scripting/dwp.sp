#include <sourcemod> // @ version 1.10 build 6502
#include <cstrike>

#pragma newdecls required
#pragma semicolon 1

#define VERS_PLUGIN "1.0"

#define DEBUG 0 // ? set 1 only if need dev-mode (more logs, tests, etc...)

public Plugin myinfo =
{
	author = "Rabb1t (Discord: Rabb1t#4578)",
	name = "[Dynamic Weapon Pricing] Core",
	version = VERS_PLUGIN,
	description = "The plugin allows you to download a server of the dynamic cost of weapons, depending on the frequency of purchase.",
	url = "https://discord.gg/gpK9k8f https://t.me/rabb1tof"
	
}

/**
*?    Global variables  
**/
Database g_hDb;

/**
*?    Includes  
**/
#include "dwp/UTIL.sp"
#include "dwp/Database.sp"

public void OnPluginStart()
{
	InitDb();
}

public Action CS_OnGetWeaponPrice(int client, const char[] weapon, int& price)
{

}