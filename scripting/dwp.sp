#include <sourcemod> // @ version 1.10 build 6502
#include <cstrike>

#pragma newdecls required
#pragma semicolon 		1

#define VERS_PLUGIN 	"1.0"

#define DEBUG 			0 // ? set 1 only if need dev-mode (more logs, tests, etc...)
#define MAX_WEAPONS 	100

public Plugin myinfo =
{
	author = "Rabb1t (Discord: Rabb1t#4578)",
	name = "[Dynamic Weapon Pricing] Core",
	version = VERS_PLUGIN,
	description = "The plugin allows you to download a server of the dynamic cost of weapons, depending on the frequency of purchase.",
	url = "https://discord.gg/gpK9k8f https://t.me/rabb1tof"
	
}

enum struct Weapon {
	int price;
    char name[64]; 

	void Clear()
	{
			this.name = "";
			this.price = 0;
	}
}

/**
*?    Global variables  
**/
Weapon 		g_wWeapons[MAX_WEAPONS];
Database 	g_hDb;

/**
*?    Includes  
**/
#include "dwp/Cvars.sp"
#include "dwp/UTIL.sp"
#include "dwp/Database.sp"

public void OnPluginStart()
{
	InitDb();
	InitConVars();
}

public Action CS_OnGetWeaponPrice(int client, const char[] weapon, int& price)
{
	bool IsFound = false;
	for(int i = 0; i < MAX_WEAPONS; ++i)
	{
		if(!strcmp(g_wWeapons[i].name, weapon))
		{
			price = g_wWeapons[i].price;

			ChangePrice(weapon, price);
			IsFound = true;
			return Plugin_Handled;
		}
	}

	if(!IsFound)
	{
		AddWeaponToDb(weapon, price);
		return Plugin_Continue;
	}
	
	return Plugin_Continue;
}