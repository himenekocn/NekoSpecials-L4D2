public Action KillTankHUD(Handle timer)
{
	if(NCvar[CKillHud_HudStyle].IntValue < 4 && NCvar[CKillHud_HudStyle].IntValue > 0)
	{
		if(HUDSlotIsUsed(HUD_MID_BOX))
			RemoveHUD(HUD_MID_BOX);

		char ReadPlayerName[MAX_NAME_LENGTH], tankline[256], tankline2[256];
		ArrayList PlayerTankDMG = new ArrayList(256, 0);
		
		for (int i = 1; i <= MaxClients; i++)
			if(IsValidClient(i) && IsAllowBot(i, NCvar[CKillHud_AllowBot].BoolValue) && (GetClientTeam(i) == 2 || GetClientTeam(i) == 1))
				PlayerTankDMG.Set(PlayerTankDMG.Push(Neko_ClientInfo[i].DmgToTank), i, 1);
			
		PlayerTankDMG.Sort(Sort_Descending, Sort_Integer);
	
		//right
		GetHudTitle("KillHud_KillTankTitle", tankline, sizeof(tankline));
		for (int i = 0; i < PlayerTankDMG.Length; i++)
		{
			GetClientName(PlayerTankDMG.Get(i, 1), ReadPlayerName, 22);
			if(i < 4)
			{
				Format(tankline2, sizeof(tankline2), "\n%d.%s %d", i+1, ReadPlayerName, PlayerTankDMG.Get(i));
				Format(tankline, sizeof(tankline), "%s%s", tankline, tankline2);
			}
		}
		HUDSetLayout(HUD_MID_BOX, HUD_FLAG_ALIGN_LEFT|HUD_FLAG_NOBG|HUD_FLAG_COUNTDOWN_WARN, tankline);
		if(NCvar[CKillHud_HudStyle].IntValue == 3)
		{
			float xy[2];
			char GetCharValue[12];
			NCvar[CKillHud_CStyleTankXY].GetString(GetCharValue, sizeof GetCharValue);
			GetHUDSide(GetCharValue, xy);
			HUDPlace(HUD_MID_BOX, xy[0], xy[1], 1.0, 0.15);
		}
		else
			HUDPlace(HUD_MID_BOX, 0.0, 0.3, 1.0, 0.15);
		CreateTimer(5.0, Delay_KilltankHUD);
		delete PlayerTankDMG;
	}
	else if(NCvar[CKillHud_HudStyle].IntValue == 4 && NCvar[CKillHud_HudStyle].IntValue > 0)
	{
		char ReadPlayerName[MAX_NAME_LENGTH];
		ArrayList PlayerTankDMG = new ArrayList(256, 0);
		for (int i = 1; i <= MaxClients; i++)
		{
			if(IsValidClient(i) && IsAllowBot(i, NCvar[CKillHud_AllowBot].BoolValue) && (GetClientTeam(i) == 2 || GetClientTeam(i) == 1))
			{
				int anum = PlayerTankDMG.Push(Neko_ClientInfo[i].DmgToTank);
				PlayerTankDMG.Set(anum, i, 1);
			}
		}
		PlayerTankDMG.Sort(Sort_Descending, Sort_Integer);
		PrintToChatAll("\x05[\x03排行榜 - 坦克击杀\x05]");
		for (int i = 0; i < PlayerTankDMG.Length; i++)
		{
			if(i < 4)
			{
				GetClientName(PlayerTankDMG.Get(i, 1), ReadPlayerName, 22);
				PrintToChatAll("\x05[\x03#%d\x05]: \x04伤害 \x03%d \x01| \x04ID \x01%s", i + 1, PlayerTankDMG.Get(i), ReadPlayerName);
			}
		}
		CreateTimer(5.0, Delay_KilltankHUD);
		delete PlayerTankDMG;
	}
	
	return Plugin_Continue;
}

public Action Delay_KilltankHUD(Handle timer)
{
	if(HUDSlotIsUsed(HUD_MID_BOX))
		RemoveHUD(HUD_MID_BOX);
	for (int i = 1; i <= MaxClients; i++)
		Neko_ClientInfo[i].DmgToTank = 0;
	return Plugin_Continue;
}

public Action Event_TankSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt( "userid" ));
	if(IsValidClient(client) && GetClientTeam(client) == 3)
		TankAlive = true;
	return Plugin_Continue;
}

public Action Event_WitchDeath(Handle event, const char[] name, bool dontBroadcast)
{
	Neko_GlobalState.Kill_AllWitch++;
	Neko_GlobalState.Kill_AllWitchGO++;
	return Plugin_Continue;
}

public Action Event_TankDeath(Handle event, const char[] name, bool dontBroadcast)
{
	CreateTimer(0.5, Timer_DelayDeath);
	Neko_GlobalState.Kill_AllTank++;
	Neko_GlobalState.Kill_AllTankGO++;
	return Plugin_Continue;
}