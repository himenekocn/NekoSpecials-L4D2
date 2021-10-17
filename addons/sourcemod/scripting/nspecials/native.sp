
void CheckDifficulty(bool ShowTips = true)
{
	if(Special_Spawn_Time_DifficultyChange)
	{
		char NowDifficulty[64];
		CGame_Difficulty.GetString(NowDifficulty, sizeof(NowDifficulty));

		if(strcmp(NowDifficulty, "Easy") == 0)
		{
			SetSpecialRespawnInterval(Special_Spawn_Time_Easy);
		}
		else if(strcmp(NowDifficulty, "Normal") == 0)
		{
			SetSpecialRespawnInterval(Special_Spawn_Time_Normal);
		}
		else if(strcmp(NowDifficulty, "Hard") == 0)
		{
			SetSpecialRespawnInterval(Special_Spawn_Time_Hard);
		}
		else if(strcmp(NowDifficulty, "Impossible") == 0)
		{
			SetSpecialRespawnInterval(Special_Spawn_Time_Impossible);
		}
	}
	else
	{
		SetSpecialRespawnInterval(Special_Spawn_Time);
	}

	Call_StartForward(N_Forward_OnSetSpecialsTime);
	Call_Finish();
	
	if(ShowTips)
		InfectedTips();
}

void SetAISpawnInit()
{
	SetSpecialAssault(Special_Fast_Response);

	SetSpecialSpawnMode(Special_Spawn_Mode);
	
	if(Special_CanCloseDirector)
	{
		if(GetSpecialSpawnMode() == 0)
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
}

void SwitchPlugin(int client)
{
	if(Special_PluginStatus)
	{
		PrintToChat(client, "\x05%s \x04关闭了NS特感插件", NEKOTAG);
		CSpecial_PluginStatus.SetInt(0);
		SetSpecialRunning(false);
		if(Special_CanCloseDirector)
			FindConVar("director_no_specials").SetInt(1, true, false);
	}
	else
	{
		PrintToChat(client, "\x05%s \x04开启了NS特感插件", NEKOTAG);
		CSpecial_PluginStatus.SetInt(1);
		SetSpecialRunning(true);
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
	SetSpecialSpawnSubMode(Special_IsModeInNormal);
	
	switch(Special_Default_Mode)
	{
		case 1:
		{
			SetSpecialSpawnLimit(HUNTER, 31);
			SetSpecialSpawnLimit(SMOKER, 0);
			SetSpecialSpawnLimit(BOOMER, 0);
			SetSpecialSpawnLimit(SPITTER, 0);
			SetSpecialSpawnLimit(JOCKEY ,0);
			SetSpecialSpawnLimit(CHARGER, 0);
		}
		case 2:
		{
			SetSpecialSpawnLimit(HUNTER, 0);
			SetSpecialSpawnLimit(SMOKER, 0);
			SetSpecialSpawnLimit(BOOMER, 0);
			SetSpecialSpawnLimit(SPITTER, 0);
			SetSpecialSpawnLimit(JOCKEY ,0);
			SetSpecialSpawnLimit(CHARGER, 31);
		}
		case 3:
		{
			SetSpecialSpawnLimit(HUNTER, 0);
			SetSpecialSpawnLimit(SMOKER, 0);
			SetSpecialSpawnLimit(BOOMER, 0);
			SetSpecialSpawnLimit(SPITTER, 0);
			SetSpecialSpawnLimit(JOCKEY ,31);
			SetSpecialSpawnLimit(CHARGER, 0);
		}
		case 4:
		{
			SetSpecialSpawnLimit(HUNTER, 0);
			SetSpecialSpawnLimit(SMOKER, 0);
			SetSpecialSpawnLimit(BOOMER, 0);
			SetSpecialSpawnLimit(SPITTER, 31);
			SetSpecialSpawnLimit(JOCKEY ,0);
			SetSpecialSpawnLimit(CHARGER, 0);
		}
		case 5:
		{
			SetSpecialSpawnLimit(HUNTER, 0);
			SetSpecialSpawnLimit(SMOKER, 0);
			SetSpecialSpawnLimit(BOOMER, 31);
			SetSpecialSpawnLimit(SPITTER, 0);
			SetSpecialSpawnLimit(JOCKEY ,0);
			SetSpecialSpawnLimit(CHARGER, 0);
		}
		case 6:
		{
			SetSpecialSpawnLimit(HUNTER, 0);
			SetSpecialSpawnLimit(SMOKER, 31);
			SetSpecialSpawnLimit(BOOMER, 0);
			SetSpecialSpawnLimit(SPITTER, 0);
			SetSpecialSpawnLimit(JOCKEY ,0);
			SetSpecialSpawnLimit(CHARGER, 0);
		}
		default:
		{
			SetSpecialSpawnLimit(HUNTER, Special_Hunter_Num);
			SetSpecialSpawnLimit(CHARGER, Special_Charger_Num);
			SetSpecialSpawnLimit(JOCKEY, Special_Jockey_Num);
			SetSpecialSpawnLimit(SPITTER, Special_Spitter_Num);
			SetSpecialSpawnLimit(BOOMER, Special_Boomer_Num);
			SetSpecialSpawnLimit(SMOKER, Special_Smoker_Num);
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
		Format(tips, sizeof(tips), "%s特感数量为 %d 特，刷新时间 %d", tips, GetSpecialMax(), GetSpecialRespawnInterval());
		HUDShowMsg(tips);
	}
	else
	{
		Format(tips, sizeof(tips), "%s特感数量为 \x03%d \x04特，刷新时间 \x03%d", tips, GetSpecialMax(), GetSpecialRespawnInterval());
		PrintToChatAll("\x05%s \x04%s", NEKOTAG, tips);
	}
}

void SetMaxSpecialsCount(bool ShowTips = true)
{
	int Player_count;
	
	int oldtgnum = GetSpecialMax();
	
	int cultgnum = GetSpecialMax();
	
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
		cultgnum = Special_AddNum * RoundToFloor(float((Player_count - Special_PlayerNum)/Special_PlayerAdd)) + Special_Num;
	else
		cultgnum = Special_Num;
	
	if(cultgnum > 32)
		cultgnum = 32;
	
	SetSpecialMax(cultgnum);

	if(ShowTips && Special_AddNum > 0 && 0 < Special_Default_Mode && (oldtgnum != cultgnum))
		CreateTimer(0.5, ShowTipsTimer);
	
	Call_StartForward(N_Forward_OnSetSpecialsNum);
	Call_Finish();
}

void UpdateSpawnWeight()
{
	SetSpecialSpawnWeight(HUNTER, Special_Hunter_Spawn_Weight);
	SetSpecialSpawnWeight(SMOKER, Special_Smoker_Spawn_Weight);
	SetSpecialSpawnWeight(BOOMER, Special_Boomer_Spawn_Weight);
	SetSpecialSpawnWeight(SPITTER, Special_Spitter_Spawn_Weight);
	SetSpecialSpawnWeight(JOCKEY, Special_Jockey_Spawn_Weight);
	SetSpecialSpawnWeight(CHARGER, Special_Charger_Spawn_Weight);
}

void UpdateSpawnDirChance()
{
	SetSpecialSpawnDirChance(HUNTER, Special_Hunter_Spawn_DirChance);
	SetSpecialSpawnDirChance(SMOKER, Special_Smoker_Spawn_DirChance);
	SetSpecialSpawnDirChance(BOOMER, Special_Boomer_Spawn_DirChance);
	SetSpecialSpawnDirChance(SPITTER, Special_Spitter_Spawn_DirChance);
	SetSpecialSpawnDirChance(JOCKEY, Special_Jockey_Spawn_DirChance);
	SetSpecialSpawnDirChance(CHARGER, Special_Charger_Spawn_DirChance);
}

void UpdateSpawnArea()
{
	SetSpecialSpawnArea(HUNTER, Special_Hunter_Spawn_Area);
	SetSpecialSpawnArea(SMOKER, Special_Smoker_Spawn_Area);
	SetSpecialSpawnArea(BOOMER, Special_Boomer_Spawn_Area);
	SetSpecialSpawnArea(SPITTER, Special_Spitter_Spawn_Area);
	SetSpecialSpawnArea(JOCKEY, Special_Jockey_Spawn_Area);
	SetSpecialSpawnArea(CHARGER, Special_Charger_Spawn_Area);
}

void UpdateSpawnDistance()
{
	SetSpecialSpawnMaxDis(HUNTER, Special_Hunter_Spawn_MaxDis);
	SetSpecialSpawnMaxDis(SMOKER, Special_Smoker_Spawn_MaxDis);
	SetSpecialSpawnMaxDis(BOOMER, Special_Boomer_Spawn_MaxDis);
	SetSpecialSpawnMaxDis(SPITTER, Special_Spitter_Spawn_MaxDis);
	SetSpecialSpawnMaxDis(JOCKEY, Special_Jockey_Spawn_MaxDis);
	SetSpecialSpawnMaxDis(CHARGER, Special_Charger_Spawn_MaxDis);

	SetSpecialSpawnMinDis(HUNTER, Special_Hunter_Spawn_MinDis);
	SetSpecialSpawnMinDis(SMOKER, Special_Smoker_Spawn_MinDis);
	SetSpecialSpawnMinDis(BOOMER, Special_Boomer_Spawn_MinDis);
	SetSpecialSpawnMinDis(SPITTER, Special_Spitter_Spawn_MinDis);
	SetSpecialSpawnMinDis(JOCKEY, Special_Jockey_Spawn_MinDis);
	SetSpecialSpawnMinDis(CHARGER, Special_Charger_Spawn_MinDis);

	SetSpecialSpawnMaxDis_(Special_Spawn_MaxDis);
	SetSpecialSpawnMinDis_(Special_Spawn_MinDis);
}

void cleanplayerwait(int client)
{
	WaitingForTgtime[client] = false;
	WaitingForTgnum[client] = false;
	WaitingForTgadd[client] = false;
	WaitingForTgCustom[client] = false;
	WaitingForTgCustomWeight[client] = false;
	WaitingForTgCustomDirChance[client] = false;
	WaitingForTgCustomMaxDis[client] = false;
	WaitingForTgCustomMinDis[client] = false;
	WaitingForTgCustomMaxDisNor[client] = false;
	WaitingForTgCustomMinDisNor[client] = false;
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