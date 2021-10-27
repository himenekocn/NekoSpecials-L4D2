public void OnPlayerDisconnect(Event hEvent, const char[] sName, bool bDontBroadcast)
{
	int client = GetClientOfUserId(hEvent.GetInt( "userid" ));
	if(!client || (IsClientConnected(client) && !IsClientInGame(client))) return; 
	
	Kill_Init_Client(client);
	
	if(IsPlayerTank(client))
		CreateTimer(0.5, Timer_DelayDeath);
}

public void OnClientConnected(int client)
{
	Kill_Init_Client(client);
}

public void OnMapStart()
{
	HudRunning = false;
	StyleChatDelay = KillHud_StyleChatDelay;
	StartCatchTime();
}

public void OnMapEnd()
{
	HudRunning = false;
}

public Action Event_PlayerHurt(Event event, const char[] name, bool dontBroadcast)
{
	int victim = GetClientOfUserId(GetEventInt(event, "userid"));
	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	int damage = GetEventInt(event, "dmg_health");
		
	if (IsValidClient(victim) && IsValidClient(attacker) && victim != attacker && GetClientTeam(victim) == 2 && !IsFakeClient(attacker))
	{
		Friendly_Hurt[victim] += damage;
		Friendly_Fire[attacker] += damage;
	}
	
	if (TankAlive && IsPlayerTank(victim) && IsValidClient(attacker) && GetClientTeam(attacker) == 2 && !IsTankIncapacitated(victim))
		DmgToTank[attacker] += damage;
	
	return Plugin_Continue;
}

public Action Timer_DelayDeath(Handle hTimer)
{
	if(IsTankLive())
		TankAlive = true;
	else
	{
		TankAlive = false;
		if(KillHud_KillTank && KillHud_HudStyle > 0)
			CreateTimer(0.1, KillTankHUD);
	}
	return Plugin_Continue;
}

public Action Event_Round_Start(Event event, const char[] name, bool dontBroadcast)
{
	HudRunning = false;
	
	Kill_Init();
	
	CreateTimer(0.2, RoundStart, _, TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Continue;
}

public Action RoundStart(Handle Timer)
{
	if(KillHud_Show)
		CreateTimer(1.0, PlayerLeftStart, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	else
		CreateHud();
	return Plugin_Continue;
}

public Action PlayerLeftStart(Handle Timer)
{
	if(L4D_HasAnySurvivorLeftSafeArea())
	{
		CreateHud();
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action Event_Round_End(Event event, const char[] name, bool dontBroadcast)
{
	HudRunning = false;
	Kill_Init();
	return Plugin_Continue;
}

public Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int victim = GetClientOfUserId(event.GetInt( "userid" ));
	int attacker = GetClientOfUserId(event.GetInt( "attacker"));
	
	if(IsValidClient(victim) && GetClientTeam(victim) == 3 && !IsPlayerTank(victim) && IsValidClient(attacker) && GetClientTeam(attacker) == 2)
	{
		Kill_Infected[attacker] ++;
		Kill_AllInfected ++;
	}
	
	return Plugin_Continue;
}

public Action Event_infectedDeath(Event event, const char[] name, bool dontBroadcast)
{
	int attacker = GetClientOfUserId(event.GetInt( "attacker"));
	
	if(IsValidClient(attacker) && GetClientTeam(attacker) == 2)
	{
		Kill_AllZombie++;
		Kill_Zombie[attacker]++;
	}
	
	return Plugin_Continue;
}