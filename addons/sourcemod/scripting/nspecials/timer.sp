public Action Timer_DelaySpawnInfected(Handle hTimer)
{
	SetSpecialRunning(NCvar[CSpecial_PluginStatus].BoolValue);
	
	Call_StartForward(N_Forward_OnStartFirstSpawn);
	Call_Finish();

	return Plugin_Stop;
}

public Action PlayerLeftStart(Handle Timer)
{
	if(L4D_HasAnySurvivorLeftSafeArea())
	{
		IsPlayerLeftCP = true;
		CreateTimer(NCvar[CSpecial_LeftPoint_SpawnTime].FloatValue, Timer_DelaySpawnInfected);
		InfectedTips();
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action Timer_ReloadMenu(Handle timer, any client) 
{
	client = GetClientOfUserId(client);
	if (IsValidClient(client))
		SpecialMenu(client).DisplayAt(client, MenuPageItem[client], MENU_TIME);
	return Plugin_Continue;
}

public Action Timer_SetMaxSpecialsCount(Handle timer) 
{
	SetMaxSpecialsCount();
	return Plugin_Stop;
}

public Action ShowTipsTimer(Handle timer) 
{
	InfectedTips();
	return Plugin_Stop;
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
		KickClient(client);

	return Plugin_Stop;
}

public Action KillHUDShow(Handle timer)
{
	if(HUDSlotIsUsed(HUD_MID_TOP))
		RemoveHUD(HUD_MID_TOP);
	return Plugin_Stop;
}