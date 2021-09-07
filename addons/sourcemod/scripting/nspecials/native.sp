
void CheckDifficulty()
{
	if(Special_Spawn_Time_DifficultyChange)
	{
		char NowDifficulty[64];
		CGame_Difficulty.GetString(NowDifficulty, sizeof(NowDifficulty));

		if(strcmp(NowDifficulty, "Easy") == 0)
		{
			tgtime = Special_Spawn_Time_Easy;
		}
		else if(strcmp(NowDifficulty, "Normal") == 0)
		{
			tgtime = Special_Spawn_Time_Normal;
		}
		else if(strcmp(NowDifficulty, "Hard") == 0)
		{
			tgtime = Special_Spawn_Time_Hard;
		}
		else if(strcmp(NowDifficulty, "Impossible") == 0)
		{
			tgtime = Special_Spawn_Time_Impossible;
		}
	}
	else
	{
		tgtime = Special_Spawn_Time;
	}
	
	SetSpecialRespawnInterval(tgtime);
	
	Call_StartForward(N_Forward_OnSetSpecialsTime);
	Call_Finish();
	
	InfectedTips();
}

void SetAISpawnInit()
{
	SetSpecialInfectedAssault(Special_Fast_Response);

	SetIsModeSpawnSpecial(Special_Spawn_Mode);
	
	SetIsOnInferno(Special_Inferno);
	
	if(Special_CanCloseDirector)
	{
		if(Special_Spawn_Mode == 0)
			FindConVar("director_no_specials").SetInt(0, true, false);
		else
			FindConVar("director_no_specials").SetInt(1, true, false);
	}
}

void SwitchRandom(int client)
{
	if(Special_Random_Mode)
	{
		PrintToChat(client, "\x05%s \x04关闭了随机特感", NEKOTAG);
		CSpecial_Random_Mode.SetInt(0);
		Special_Default_Mode = CSpecial_Default_Mode.IntValue;
	}
	else
	{
		PrintToChat(client, "\x05%s \x04开启了随机特感", NEKOTAG);
		CSpecial_Random_Mode.SetInt(1);
		Special_Default_Mode = GetRandomInt(1, 7);
	}
	if(Special_Show_Tips)
		ModeTips();
	TgModeStartSet();
}

void SwitchPlugin(int client)
{
	if(Special_PluginStatus)
	{
		PrintToChat(client, "\x05%s \x04关闭了NS特感插件", NEKOTAG);
		CSpecial_PluginStatus.SetInt(0);
		SetIsLoadASI(false);
		if(Special_CanCloseDirector)
			FindConVar("director_no_specials").SetInt(1, true, false);
	}
	else
	{
		PrintToChat(client, "\x05%s \x04开启了NS特感插件", NEKOTAG);
		CSpecial_PluginStatus.SetInt(1);
		SetIsLoadASI(true);
		if(Special_CanCloseDirector)
		{
			if(Special_Spawn_Mode == 0)
				FindConVar("director_no_specials").SetInt(0, true, false);
			else
				FindConVar("director_no_specials").SetInt(1, true, false);
		}
	}
}

void TgModeStartSet()
{
	CheckDifficulty();
	//SetIsModeSpawnSpecialInNormal(Special_IsModeInNormal);
	
	switch(Special_Default_Mode)
	{
		case 1:
		{
			SetHunterLimit(31);
			SetChargerLimit(0);
			SetJockeyLimit(0);
			SetSpitterLimit(0);
			SetBoomerLimit(0);
			SetSmokerLimit(0);
		}
		case 2:
		{
			SetHunterLimit(0);
			SetChargerLimit(31);
			SetJockeyLimit(0);
			SetSpitterLimit(0);
			SetBoomerLimit(0);
			SetSmokerLimit(0);
		}
		case 3:
		{
			SetHunterLimit(0);
			SetChargerLimit(0);
			SetJockeyLimit(31);
			SetSpitterLimit(0);
			SetBoomerLimit(0);
			SetSmokerLimit(0);
		}
		case 4:
		{
			SetHunterLimit(0);
			SetChargerLimit(0);
			SetJockeyLimit(0);
			SetSpitterLimit(31);
			SetBoomerLimit(0);
			SetSmokerLimit(0);
		}
		case 5:
		{
			SetHunterLimit(0);
			SetChargerLimit(0);
			SetJockeyLimit(0);
			SetSpitterLimit(0);
			SetBoomerLimit(31);
			SetSmokerLimit(0);
		}
		case 6:
		{
			SetHunterLimit(0);
			SetChargerLimit(0);
			SetJockeyLimit(0);
			SetSpitterLimit(0);
			SetBoomerLimit(0);
			SetSmokerLimit(31);
		}
		default:
		{
			SetHunterLimit(Special_Hunter_Num);
			SetChargerLimit(Special_Charger_Num);
			SetJockeyLimit(Special_Jockey_Num);
			SetSpitterLimit(Special_Spitter_Num);
			SetBoomerLimit(Special_Boomer_Num);
			SetSmokerLimit(Special_Smoker_Num);
		}
	}
	
	SetMaxSpecialsCount(false);
}

void ModeTips()
{
	char tips[256];
	
	switch(Special_Default_Mode)
	{
		case 1: Format(tips, sizeof(tips), "猎人模式");
		case 2: Format(tips, sizeof(tips), "牛模式");
		case 3: Format(tips, sizeof(tips), "猴子模式");
		case 4: Format(tips, sizeof(tips), "口水模式");
		case 5: Format(tips, sizeof(tips), "胖子模式");
		case 6: Format(tips, sizeof(tips), "舌头模式");
		default: Format(tips, sizeof(tips), "默认模式");
	}
	
	PrintToChatAll("\x05%s \x04现在是\x03 %s", NEKOTAG, tips);
}

void InfectedTips()
{	
	if(!IsMapRunning() || !Special_PluginStatus || !Special_Show_Tips)
		return;

	char tips[256];
	
	switch(Special_Default_Mode)
	{
		case 1: Format(tips, sizeof(tips), "猎人模式，");
		case 2: Format(tips, sizeof(tips), "牛模式，");
		case 3: Format(tips, sizeof(tips), "猴子模式，");
		case 4: Format(tips, sizeof(tips), "口水模式，");
		case 5: Format(tips, sizeof(tips), "胖子模式，");
		case 6: Format(tips, sizeof(tips), "舌头模式，");
	}
	
	if(!Special_Show_Tips_Chat)
	{
		Format(tips, sizeof(tips), "%s特感数量为 %d 特，刷新时间 %d", tips, tgnum, tgtime);
		HUDShowMsg(tips);
	}
	else
	{
		Format(tips, sizeof(tips), "%s特感数量为 \x03%d \x04特，刷新时间 \x03%d", tips, tgnum, tgtime);
		PrintToChatAll("\x05%s \x04%s", NEKOTAG, tips);
	}
}

void SetMaxSpecialsCount(bool ShowTips = true)
{
	int Player_count;
	
	int oldtgnum = tgnum;
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if(!IsClientInGame(i))
			continue;
			
		if(GetClientTeam(i) == 2)
			++Player_count;
			
		if(Special_PlayerCountSpec)
			if(GetClientTeam(i) == 1 && !IsClientIdle(i))
				++Player_count;
	}
	
	if(Player_count > Special_PlayerNum)
		tgnum = Special_AddNum * RoundToFloor(float((Player_count - Special_PlayerNum)/Special_PlayerAdd)) + Special_Num;
	else
		tgnum = Special_Num;
	
	if(tgnum > 32)
		tgnum = 32;
	
	SetMaxSpecials(tgnum);

	if(ShowTips && Special_AddNum > 0 && 0 < Special_Default_Mode && (oldtgnum != tgnum))
		CreateTimer(0.5, ShowTipsTimer);
	
	Call_StartForward(N_Forward_OnSetSpecialsNum);
	Call_Finish();
}

void cleanplayerwait(int client)
{
	WaitingForTgtime[client] = false;
	WaitingForTgnum[client] = false;
	WaitingForTgadd[client] = false;
	WaitingForTgCustom[client] = false;
	WaitingForPadd[client] = false;
	WaitingForPnum[client] = false;
}

stock void HUDShowMsg(char[] Message)
{
	if(HUDSlotIsUsed(HUD_MID_TOP))
		RemoveHUD(HUD_MID_TOP);
	HUDSetLayout(HUD_MID_TOP, HUD_FLAG_ALIGN_LEFT|HUD_FLAG_BLINK|HUD_FLAG_COUNTDOWN_WARN, Message);
	HUDPlace(HUD_MID_TOP, 0.2, 0.02, 0.6, 0.05);
	CreateTimer(5.0, KillHUDShow);
}