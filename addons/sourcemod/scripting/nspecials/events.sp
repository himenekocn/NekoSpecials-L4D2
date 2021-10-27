public Action OnRoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	if(Special_Random_Mode)
		Special_Default_Mode = GetRandomInt(1, 7);
	else
		Special_Default_Mode = CSpecial_Default_Mode.IntValue;

	IsPlayerLeftCP = false;
	SetSpecialRunning(false);
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

public Action BinHook_OnSpawnSpecial()
{
	if(!Special_Spawn_Tank_Alive && Special_Spawn_Tank_Alive_Pro)
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

	return Plugin_Continue;
}

public Action OnTankDeath(Handle event, const char[] name, bool dontBroadcast)
{
	if(Special_PluginStatus)
	{
		CreateTimer(0.2, Timer_DelayDeath);
	}
	else
	{
		SetSpecialRunning(false);
	}
}

public Action Timer_DelayDeath(Handle hTimer)
{
	if(L4D2_IsTankInPlay() && !Special_Spawn_Tank_Alive)
	{
		SetSpecialRunning(false);
	}
	else
	{
		SetSpecialRunning(true);
	}
}

public Action OnPlayerDeath(Event hEvent, const char[] sName, bool bDontBroadcast )
{
	int client = GetClientOfUserId(hEvent.GetInt( "userid" ));
	if (IsValidClient(client) && IsFakeClient(client) && GetClientTeam(client) == 3)
		RequestFrame(Timer_KickBot, GetClientUserId(client));

	if (IsValidClient(client) && GetClientTeam(client) == 2 && Special_Num_NotCul_Death)
		SetMaxSpecialsCount();
}

public Action OnPlayerSpawn(Event hEvent, const char[] sName, bool bDontBroadcast )
{
	int client = GetClientOfUserId(hEvent.GetInt( "userid" ));

	if (IsValidClient(client) && GetClientTeam(client) == 2 && Special_Num_NotCul_Death)
		SetMaxSpecialsCount();
}

public Action OnTankSpawn(Event event, const char[] name, bool dontBroadcast)
{
	if(!Special_Spawn_Tank_Alive)
		SetSpecialRunning(false);
	else
		SetSpecialRunning(true);
	return Plugin_Continue;
}