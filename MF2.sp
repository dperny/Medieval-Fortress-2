#include <sourcemod>
#include <tf2_stocks>
#include <sdktools>
 
public Plugin:myinfo =
{
	name = "Medieval Fortress",
	author = "DPErny",
	description = "TF2 with a Medieval Theme",
	version = "2.0",
	url = "ubercharged.net"
};
 
 //Variables
new bool:IsPluginActive = false;
 
public OnPluginStart()
{
	RegAdminCmd("sm_mf_enable", command_Enable, ADMFLAG_CHANGEMAP);
	RegAdminCmd("sm_mf_disable", command_Disable, ADMFLAG_CHANGEMAP);
}

public OnMapStart ()
{
	if(IsPluginActive == false)
	{
		new String:mapname[64];
		GetCurrentMap(mapname, sizeof(mapname));
		if(StrContains(mapname,"mf_", false) != -1)
		{
			funct_Enable();
		}
	}
}
	
public OnMapEnd ()
{
	if(IsPluginActive == true)
	{
		funct_Disable();
	}
}

public Action:command_Enable(client, args)
{
	ServerCommand("mp_restartround");
	funct_Enable();
}

public Action:command_Disable(client, args)
{
	ServerCommand("mp_restartround");
	funct_Disable();
}

funct_Enable()
{
	HookEvent ("post_inventory_application", Event_playerspawn);
	IsPluginActive = true;
}

funct_Disable()
{
	UnhookEvent ("post_inventory_application", Event_playerspawn);
	IsPluginActive = false;
}

public Event_playerspawn (Handle:eventi, const String:name [], bool:dontBrodcast)
{
	new player = GetEventInt(eventi, "userid");
	new client = GetClientOfUserId(player);
	new TFClassType:class = TF2_GetPlayerClass(client);
	
	switch (class)
	{
		case TFClass_Sniper:
		{
			Weaponcheck_Sniper(client);
		}

		case TFClass_DemoMan:
		{
			Weaponcheck_Demo(client);
		}

		case TFClass_Heavy:
		{
			Weaponcheck_Heavy(client);
		}
	
		case TFClass_Soldier:
		{
			Weaponcheck_Soldier (client);
		}

		default:
		{
			CreateTimer(0.1, SetSniper, client);
		}
	}
}

public Action:SetSniper (Handle:timer, any:client)
{
	TF2_SetPlayerClass(client, TFClass_Sniper);
	PrintCenterText(client, "The allowed classes in Medieval Fortress are Sniper, Demo, Soldier, and Heavy");
	TF2_RespawnPlayer(client);
	return Plugin_Continue;
}


Weaponcheck_Sniper(client)
{
	new Weaponi = GetPlayerWeaponSlot (client, 0);
	new Weaponii = GetPlayerWeaponSlot (client, 1);

	if(GetEntProp(Weaponi, Prop_Send, "m_iEntityQuality") != 3)
	{
		TF2_RemoveWeaponSlot(client, 0);
	}

	if(GetEntProp(Weaponii, Prop_Send, "m_iEntityQuality") != 3)
	{
		TF2_RemoveWeaponSlot(client, 1);
	}
}

Weaponcheck_Demo(client)
{
	TF2_RemoveWeaponSlot(client, 1);
	
	new weaponi = GetPlayerWeaponSlot (client, 0);
	if (GetEntProp(weaponi, Prop_Send, "m_iItemDefinitionIndex") != 1)
	{
		TF2_RemoveWeaponSlot(client, 0);
	}
}

Weaponcheck_Heavy(client)
{
	TF2_RemoveWeaponSlot(client, 0);
	
	new weaponii = GetPlayerWeaponSlot (client, 1);

	if(GetEntProp(weaponii, Prop_Send, "m_iEntityQuality") != 3)
	{
		TF2_RemoveWeaponSlot(client, 1);
	}
}

Weaponcheck_Soldier(client)
{
	TF2_RemoveWeaponSlot(client, 0);
	 
	new weaponii = GetPlayerWeaponSlot (client, 1);
	if(GetEntProp(weaponii, Prop_Send, "m_iEntityQuality") != 3)
	{
		TF2_RemoveWeaponSlot(client, 1);
	}
}
	