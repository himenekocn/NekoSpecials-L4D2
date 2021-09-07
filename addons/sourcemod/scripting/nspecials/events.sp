public Action OnRoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	if(Special_Random_Mode)
		Special_Default_Mode = GetRandomInt(1, 7);
	else
		Special_Default_Mode = CSpecial_Default_Mode.IntValue;

	IsPlayerLeftCP = false;
	SetIsLoadASI(false);
	TgModeStartSet();
	CreateTimer(0.1, PlayerLeftStart, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public Action player_team(Event event, const char[] name, bool dontBroadcast)
{
	CreateTimer(0.1, Timer_SetMaxSpecialsCount, _, TIMER_FLAG_NO_MAPCHANGE);
}

public void OnPlayerDisconnect(Event hEvent, const char[] sName, bool bDontBroadcast)
{
	int client = GetClientOfUserId(hEvent.GetInt("userid"));
	if(IsValidClient(client))
	{
		if(IsFakeClient(client))
		{
			if(Special_PluginStatus && IsPlayerLeftCP)
			{
				if(IsPlayerTank(client))
					CreateTimer(0.5, Timer_DelayDeath);
			}
			else
				SetIsLoadASI(false);
		}
		else
		{
			N_MenuSpecialMenu[client] = null;
			N_SpecialMenuCustom[client] = null;
			CreateTimer(0.1, Timer_SetMaxSpecialsCount, _, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

public Action OnRoundEnd(Event hEvent, const char[] sName, bool bDontBroadcast)
{
	IsPlayerLeftCP = false;
	SetIsLoadASI(false);
}

public Action OnPlayerStuck(int client)
{
	if(IsValidClient(client) && IsPlayerAlive(client) && GetClientTeam(client) == 3 && IsFakeClient(client))
	{
		if(!Special_AutoKill_StuckTank)
		{
			if(!IsPlayerTank(client))
				KickClient(client, "Infected Stuck");
		}
		else
			KickClient(client, "Infected Stuck");
	}
	return Plugin_Continue;
}

public Action OnTankDeath(Handle event, const char[] name, bool dontBroadcast)
{
	if(Special_PluginStatus)
		CreateTimer(0.1, Timer_DelayDeath);
	else
		SetIsLoadASI(false);
}

public Action Timer_DelayDeath(Handle hTimer, any UserID)
{
	if(L4D2_IsTankInPlay() && !Special_Spawn_Tank_Alive)
		SetIsLoadASI(false);
	else
		SetIsLoadASI(true);
}

public Action OnPlayerDeath(Event hEvent, const char[] sName, bool bDontBroadcast )
{
	int client = GetClientOfUserId(hEvent.GetInt( "userid" ));
	if (IsValidClient(client) && IsFakeClient(client) && GetClientTeam(client) == 3)
		RequestFrame(Timer_KickBot, GetClientUserId(client));
}

public Action OnTankSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt( "userid" ));
	if(IsValidClient(client) && GetClientTeam(client) == 3 && !Special_Spawn_Tank_Alive)
		SetIsLoadASI(false);
	else
		SetIsLoadASI(true);
	return Plugin_Continue;
}