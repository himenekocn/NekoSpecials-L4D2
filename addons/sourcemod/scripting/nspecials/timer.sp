public Action Timer_DelaySpawnInfected(Handle hTimer)
{
	SetSpecialRunning(Special_PluginStatus);
	
	Call_StartForward(N_Forward_OnStartFirstSpawn);
	Call_Finish();
}

public Action PlayerLeftStart(Handle Timer)
{
	if(L4D_HasAnySurvivorLeftSafeArea())
	{
		IsPlayerLeftCP = true;
		CreateTimer(Special_LeftPoint_SpawnTime, Timer_DelaySpawnInfected);
		InfectedTips();
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action Timer_SetMaxSpecialsCount(Handle timer) 
{
	SetMaxSpecialsCount();
}

public Action ShowTipsTimer(Handle timer) 
{
	InfectedTips();
}

public void Timer_KickBot(any client) 
{
	client = GetClientOfUserId(client);
	if (IsValidClient(client) && IsFakeClient(client) && !IsClientInKickQueue(client))
	{
		if(GetEntProp(client, Prop_Send, "m_zombieClass") != 4)
			KickClient(client);
		else
			CreateTimer(10.0, Timer_DelaySpitterDeath, GetClientUserId(client));
	}
}

public Action Timer_DelaySpitterDeath(Handle timer, any client) 
{
	client = GetClientOfUserId(client);
	if (IsValidClient(client) && IsFakeClient(client) && !IsClientInKickQueue(client))
	{
		KickClient(client);
	}
}

public Action KillHUDShow(Handle timer)
{
	if(HUDSlotIsUsed(HUD_MID_TOP))
		RemoveHUD(HUD_MID_TOP);
}