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
	description = "The plugin allows you to change the cost of weapons dynamically (depending on the frequency of purchase).",
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
#include "dwp/menus.sp"

public void OnPluginStart()
{
	InitDb();
	InitConVars();

	LoadTranslations("dwp.phrases");
	HookEvent("item_purchase", CSRules_Item_Purchase);
	RegAdminCmd("sm_dwp", Cmd_MainMenu, ADMFLAG_GENERIC);
}

// ? Event started when player buyed weapon
Action CSRules_Item_Purchase(Event event, const char[] name, bool dbc)
{
	char weapon[64];
	event.GetString("weapon", weapon, sizeof(weapon));
	PrintToServer("%s", weapon[7]);
	ChangePrice(weapon[7]);
}

//? Forward to get price of weapon
public Action CS_OnGetWeaponPrice(int client, const char[] weapon, int& price)
{
	//int newPrice;
	bool IsFound = false;
	for(int i = 0; i < MAX_WEAPONS; ++i)
	{
		if(!strcmp(g_wWeapons[i].name, weapon))
		{
			price = g_wWeapons[i].price;
			if(price > GetEntProp(client, Prop_Send, "m_iAccount"))
				return Plugin_Continue;

			//ChangePrice(weapon, newPrice);
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

Action Cmd_MainMenu(int client, int args)
{
    if(IsValidClient(client))
    {
        ShowMainMenu(client);
    }
}