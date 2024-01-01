#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <binhooks>
#include <dhooks>
#include <left4dhooks>
#include <neko/nekotools>
#include <neko/nekonative>

public Action NekoSpecials_OnStartFirstSpawn()
{
	PrintToChatAll("Start First Spawn");
}
