public Action RefreshHUD(Handle timer)
{
	if(!HudRunning)
		return Plugin_Stop;

	if(KillHud_HudStyle <= 3 && KillHud_HudStyle > 0)
	{
		char ReadPlayerName[MAX_NAME_LENGTH], leftline[256], leftline1[256], rightline[256], rightline1[256];
		ArrayList PlayerKillNum = new ArrayList(256, 0);
		ArrayList PlayerFriendlyFire = new ArrayList(256, 0);
		
		for (int i = 1; i <= MaxClients; i++)
		{
			if(IsValidClient(i) && IsAllowBot(i, KillHud_AllowBot) && (GetClientTeam(i) == 2 || GetClientTeam(i) == 1))
			{
				PlayerKillNum.Set(PlayerKillNum.Push(Kill_Infected[i]), i, 1);
				PlayerFriendlyFire.Set(PlayerFriendlyFire.Push(Friendly_Fire[i]), i, 1);
			}
		}
		PlayerKillNum.Sort(Sort_Descending, Sort_Integer);
		PlayerFriendlyFire.Sort(Sort_Descending, Sort_Integer);
		
		//left
		if(KillHud_KillSpecials)
		{
			GetHudTitle("KillHud_KillSpecialsTitle", leftline, sizeof(leftline));
			for (int i = 0; i < PlayerKillNum.Length; i++)
			{
				GetClientName(PlayerKillNum.Get(i, 1), ReadPlayerName, 22);
				if(i < 4)
				{
					Format(leftline1, sizeof(leftline1), "\n%d.%s %d只", i + 1, ReadPlayerName, PlayerKillNum.Get(i));
					Format(leftline, sizeof(leftline), "%s%s", leftline, leftline1);
				}
			}

			HUDSetLayout(HUD_FAR_LEFT, HUD_FLAG_ALIGN_LEFT|HUD_FLAG_NOBG|HUD_FLAG_COUNTDOWN_WARN, leftline);
		}
	
		//right
		if(KillHud_FriendlyFire)
		{
			GetHudTitle("KillHud_FriendlyFireTitle", rightline, sizeof(rightline));
			for (int i = 0; i < PlayerFriendlyFire.Length; i++)
			{
				GetClientName(PlayerFriendlyFire.Get(i, 1), ReadPlayerName, 22);
				if(i < 4)
				{
					Format(rightline1, sizeof(rightline1), "\n%d.%s %d", i + 1, ReadPlayerName, PlayerFriendlyFire.Get(i));
					Format(rightline, sizeof(rightline), "%s%s", rightline, rightline1);
				}
			}
			
			HUDSetLayout(HUD_FAR_RIGHT, HUD_FLAG_ALIGN_LEFT|HUD_FLAG_NOBG|HUD_FLAG_COUNTDOWN_WARN, rightline);
		}
	
		//Rightbottom
		if(KillHud_AllKill)
		{
			char btnrightline[256];
			Format(btnrightline, sizeof(btnrightline), "➣统计: %d特感 %d僵尸", Kill_AllInfected, Kill_AllZombie);
			HUDSetLayout(HUD_SCORE_1, HUD_FLAG_ALIGN_LEFT|HUD_FLAG_NOBG|HUD_FLAG_COUNTDOWN_WARN, btnrightline);
			
			Format(btnrightline, sizeof(btnrightline), "➣计时: %s", GetNowTime_Format());
			HUDSetLayout(HUD_SCORE_2, HUD_FLAG_ALIGN_LEFT|HUD_FLAG_NOBG|HUD_FLAG_COUNTDOWN_WARN, btnrightline);
		}
		delete PlayerKillNum;
		delete PlayerFriendlyFire;
		
		switch(KillHud_HudStyle)
		{
			case 1:
			{
				if(KillHud_KillSpecials)
					HUDPlace(HUD_FAR_LEFT, 0.0, 0.0, 1.0, 0.15);
				
				if(KillHud_FriendlyFire)
					HUDPlace(HUD_FAR_RIGHT, 0.8, 0.0, 1.0, 0.15);
				
				if(KillHud_AllKill)
				{
					HUDPlace(HUD_SCORE_1, 0.73, 0.86, 1.0, 0.03);
					HUDPlace(HUD_SCORE_2, 0.73, 0.89, 1.0, 0.03);
				}
			}
			case 2:
			{
				if(KillHud_KillSpecials)
					HUDPlace(HUD_FAR_LEFT, 0.0, 0.0, 1.0, 0.15);
				
				if(KillHud_FriendlyFire)
					HUDPlace(HUD_FAR_RIGHT, 0.2, 0.0, 1.0, 0.15);
				if(KillHud_AllKill)
				{
					HUDPlace(HUD_SCORE_1, 0.8, 0.05, 1.0, 0.03);
					HUDPlace(HUD_SCORE_2, 0.8, 0.08, 1.0, 0.03);
				}
			}
			case 3:
			{
				float xy[2];
				
				if(KillHud_KillSpecials)
				{
					GetHUDSide(KillHud_CStyleSpecialsXY, xy);
					HUDPlace(HUD_FAR_LEFT, xy[0], xy[1], 1.0, 0.15);
				}
				
				if(KillHud_FriendlyFire)
				{
					GetHUDSide(KillHud_CStyleFriendXY, xy);
					HUDPlace(HUD_FAR_RIGHT, xy[0], xy[1], 1.0, 0.15);
				}
				
				if(KillHud_AllKill)
				{
					GetHUDSide(KillHud_CStyleAllKillXY, xy);
					HUDPlace(HUD_SCORE_1, xy[0], xy[1], 1.0, 0.03);
					HUDPlace(HUD_SCORE_2, xy[0], xy[1]+0.03, 1.0, 0.03);
				}
			}
		}
	}
	else if(KillHud_HudStyle == 4)
	{
		if(StyleChatDelay < 0)
		{
			char PlayerName[MAX_NAME_LENGTH];
			ArrayList PlayerKillNum = new ArrayList(256, 0);
			ArrayList PlayerFriendlyFire = new ArrayList(256, 0);
			ArrayList PlayerFriendlyHurt = new ArrayList(256, 0);
			for (int i = 1; i <= MaxClients; i++)
			{
				if(IsValidClient(i) && IsAllowBot(i, KillHud_AllowBot) && (GetClientTeam(i) == 2 || GetClientTeam(i) == 1))
				{
					PlayerKillNum.Set(PlayerKillNum.Push(Kill_Infected[i]), i, 1);
					PlayerFriendlyFire.Set(PlayerFriendlyFire.Push(Friendly_Fire[i]), i, 1);
					PlayerFriendlyHurt.Set(PlayerFriendlyHurt.Push(Friendly_Hurt[i]), i, 1);
				}
			}

			PlayerKillNum.Sort(Sort_Descending, Sort_Integer);
			PlayerFriendlyFire.Sort(Sort_Descending, Sort_Integer);
			PlayerFriendlyHurt.Sort(Sort_Descending, Sort_Integer);
			
			PrintToChatAll("\x05[\x03排行榜 - Rank\x05] \x04本局计时: \x03%s", GetNowTime_Format());
			for (int i = 0; i < PlayerKillNum.Length; i++)
			{
				if(i < 4)
				{
					GetClientName(PlayerKillNum.Get(i, 1), PlayerName, 22);
					PrintToChatAll("\x05[\x03#%d\x05]: \x04特感 \x03%d \x04 僵尸 \x03%d \x04友伤 \x03%d \x01| \x04ID \x01%s", i + 1, PlayerKillNum.Get(i), Kill_Zombie[i], Friendly_Fire[i], PlayerName);
				}
			}

			char PlayerNames[MAX_NAME_LENGTH];
			GetClientName(PlayerFriendlyFire.Get(0, 1), PlayerName, 22);
			GetClientName(PlayerFriendlyHurt.Get(0, 1), PlayerNames, 22);
			PrintToChatAll("\x05[\x03MVP\x05]: \x01%s \x04 造成友伤 \x03%d \x01| %s \x04 承受伤害 \x03%d", PlayerName, PlayerFriendlyFire.Get(0), PlayerNames, PlayerFriendlyHurt.Get(0));
			PrintToChatAll("\x05[\x03统计\x05]: \x03%d \x05特感 \x03%d \x05僵尸", Kill_AllInfected, Kill_AllZombie);
			
			delete PlayerKillNum;
			delete PlayerFriendlyFire;
			delete PlayerFriendlyHurt;
			StyleChatDelay = KillHud_StyleChatDelay;
		}
		else
		StyleChatDelay--;
	}
	return Plugin_Continue;
}