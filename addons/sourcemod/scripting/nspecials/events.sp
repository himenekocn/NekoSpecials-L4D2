public Action OnRoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	IsPlayerLeftCP = false;
	SetSpecialRunning(false);
	TgModeStartSet();
	CreateTimer(0.1, PlayerLeftStart, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Continue;
}

public Action player_team(Event event, const char[] name, bool dontBroadcast)
{
	CreateTimer(0.1, Timer_SetMaxSpecialsCount, _, TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Continue;
}

public void OnPlayerDisconnect(Event hEvent, const char[] sName, bool bDontBroadcast)
{
	int client = GetClientOfUserId(hEvent.GetInt("userid"));
	if(IsValidClient(client))
	{
		if(IsFakeClient(client))
		{
			if(NCvar[CSpecial_PluginStatus].BoolValue && IsPlayerLeftCP)
			{
				if(IsPlayerTank(client))
					CreateTimer(0.5, Timer_DelayDeath);
			}
			else
				SetSpecialRunning(false);
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
	SetSpecialRunning(false);
	return Plugin_Continue;
}

public Action OnPlayerStuck(int client)
{
	if(IsValidClient(client) && IsPlayerAlive(client) && GetClientTeam(client) == 3 && IsFakeClient(client))
	{
		if(!NCvar[CSpecial_AutoKill_StuckTank].BoolValue)
		{
			if(!IsPlayerTank(client))
				KickClient(client, "Infected Stuck");
		}
		else
			KickClient(client, "Infected Stuck");
	}
	return Plugin_Continue;
}

public Action BinHook_OnSpawnSpecial()
{
	if(!NCvar[CSpecial_Spawn_Tank_Alive].BoolValue && NCvar[CSpecial_Spawn_Tank_Alive_Pro].BoolValue)
	{
		if(L4D2_IsTankInPlay())
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if(!IsClientInGame(i))
					continue;
			
				if(GetClientTeam(i) != 3)
					continue;
			
				if(IsPlayerTank(i))
					continue;

				if(!IsFakeClient(i))
					continue;
		
				KickClient(i, "Infected Not Allow Spawn");
			}
		}
	}

	if(NCvar[CSpecial_Random_Mode].BoolValue)
		TgModeStartSet();

	return Plugin_Continue;
}

public Action OnTankDeath(Handle event, const char[] name, bool dontBroadcast)
{
	if(NCvar[CSpecial_PluginStatus].BoolValue)
		CreateTimer(0.2, Timer_DelayDeath);
	else
		SetSpecialRunning(false);

	return Plugin_Continue;
}

public Action Timer_DelayDeath(Handle hTimer)
{
	if(L4D2_IsTankInPlay() && !NCvar[CSpecial_Spawn_Tank_Alive].BoolValue)
		SetSpecialRunning(false);
	else
		SetSpecialRunning(true);

	return Plugin_Continue;
}

public Action OnPlayerDeath(Event hEvent, const char[] sName, bool bDontBroadcast )
{
	int client = GetClientOfUserId(hEvent.GetInt( "userid" ));
	if (IsValidClient(client) && IsFakeClient(client) && GetClientTeam(client) == 3)
		RequestFrame(Timer_KickBot, GetClientUserId(client));

	if (IsValidClient(client) && GetClientTeam(client) == 2 && NCvar[CSpecial_Num_NotCul_Death].BoolValue)
		SetMaxSpecialsCount();

	return Plugin_Continue;
}

public Action OnPlayerSpawn(Event hEvent, const char[] sName, bool bDontBroadcast )
{
	int client = GetClientOfUserId(hEvent.GetInt( "userid" ));

	if (IsValidClient(client) && GetClientTeam(client) == 2 && NCvar[CSpecial_Num_NotCul_Death].BoolValue)
		SetMaxSpecialsCount();
	
	return Plugin_Continue;
}

public Action OnTankSpawn(Event event, const char[] name, bool dontBroadcast)
{
	if(!NCvar[CSpecial_Spawn_Tank_Alive].BoolValue)
		SetSpecialRunning(false);
	else
		SetSpecialRunning(true);

	return Plugin_Continue;
}