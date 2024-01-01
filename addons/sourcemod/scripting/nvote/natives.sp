

public Action Event_PlayerDisconnect(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (!IsValidClient(client) || IsFakeClient(client))
		return Plugin_Continue;

	if (!RealPlayerExist(client) && NCvar[Neko_NeedResetNoPlayer].BoolValue)
		CreateTimer(float(NCvar[Neko_NeedResetTime].IntValue), Timer_CheckPlayers);

	return Plugin_Continue;
}

void UpdateConfigFile(bool NeedReset)
{
	AutoExecConfig_DeleteConfig();

	for (int i = 1; i < Cvar_Max; i++)
		AutoExecConfig_UpdateToConfig(NCvar[i], NeedReset);

	AutoExecConfig_OnceExec();
}

stock bool RealPlayerExist(int Exclude = 0)
{
	for (int client = 1; client < MaxClients; client++)
	{
		if (client != Exclude && IsClientConnected(client))
			if (!IsFakeClient(client))
				return true;
	}
	return false;
}

public Action OpenVoteMenu(int client, int args)
{
	NekoVoteMenu(client).Display(client, MENU_TIME);
	return Plugin_Continue;
}

public Action OpenVoteAdminMenu(int client, int args)
{
	NekoVoteAdminMenu(client).Display(client, MENU_TIME);
	return Plugin_Continue;
}

void cleanplayerwait(int client)
{
	BoolWaitForVoteItems[client] = false;
}

void cleanplayerchar(int client)
{
	VoteMenuItemValue[client] = 0;
	VoteMenuItems[client]	  = NULL_STRING;
	WaitForVoteItems[client]  = NULL_STRING;
	SubMenuVoteItems[client]  = NULL_STRING;
}