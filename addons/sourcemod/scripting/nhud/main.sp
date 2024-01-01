

public Action RefreshHUD(Handle timer)
{
	if (!HudRunning)
		return Plugin_Stop;

	if (NCvar[CKillHud_HudStyle].IntValue <= 3 && NCvar[CKillHud_HudStyle].IntValue > 0)
	{
		char	  ReadPlayerName[MAX_NAME_LENGTH], leftline[1024], leftline1[1024], leftlinet[1024], leftlinet1[1024], rightline[1024], rightline1[1024], rightlinet[1024], rightlinet1[1024];
		ArrayList PlayerKillNum		 = new ArrayList(256, 0);
		ArrayList PlayerFriendlyFire = new ArrayList(256, 0);

		int		  PlayerCount, PlayerCounts, PlayerCountt;
		int		  PlayerLimit = 4;

		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i) && IsAllowBot(i, NCvar[CKillHud_AllowBot].BoolValue) && (GetClientTeam(i) == 2 || GetClientTeam(i) == 1))
			{
				PlayerCount++;
				PlayerKillNum.Set(PlayerKillNum.Push(Neko_ClientInfo[i].Kill_Infected), i, 1);
				PlayerFriendlyFire.Set(PlayerFriendlyFire.Push(Neko_ClientInfo[i].Friendly_Fire), i, 1);
			}
		}
		PlayerKillNum.Sort(Sort_Descending, Sort_Integer);
		PlayerFriendlyFire.Sort(Sort_Descending, Sort_Integer);

		if (NCvar[CKillHud_ShowMorePlayer].BoolValue)
			if (PlayerCount > 4)
				PlayerLimit = 8;

		// left
		if (NCvar[CKillHud_KillSpecials].BoolValue)
		{
			GetHudTitle("KillHud_KillSpecialsTitle", leftline, sizeof(leftline));
			for (int i = 0; i < PlayerKillNum.Length; i++)
			{
				GetClientName(PlayerKillNum.Get(i, 1), ReadPlayerName, 22);
				if (i < PlayerLimit)
				{
					if (i > 3 && NCvar[CKillHud_ShowMorePlayer].BoolValue)
					{
						PlayerCounts++;
						Format(leftlinet1, sizeof(leftlinet1), "\n%d.%s %d", i + 1, ReadPlayerName, PlayerKillNum.Get(i));
						Format(leftlinet, sizeof(leftlinet), "%s%s", leftlinet, leftlinet1);
					}
					else
					{
						Format(leftline1, sizeof(leftline1), "\n%d.%s %d", i + 1, ReadPlayerName, PlayerKillNum.Get(i));
						Format(leftline, sizeof(leftline), "%s%s", leftline, leftline1);
					}
				}
			}

			HUDSetLayout(HUD_FAR_LEFT, HUD_FLAG_ALIGN_LEFT | HUD_FLAG_NOBG | HUD_FLAG_COUNTDOWN_WARN, leftline);
			if (PlayerCount > 4 && NCvar[CKillHud_ShowMorePlayer].BoolValue)
				HUDSetLayout(HUD_LEFT_TOP, HUD_FLAG_ALIGN_LEFT | HUD_FLAG_NOBG | HUD_FLAG_COUNTDOWN_WARN, leftlinet);
		}

		// right
		if (NCvar[CKillHud_FriendlyFire].BoolValue)
		{
			GetHudTitle("KillHud_FriendlyFireTitle", rightline, sizeof(rightline));
			for (int i = 0; i < PlayerFriendlyFire.Length; i++)
			{
				GetClientName(PlayerFriendlyFire.Get(i, 1), ReadPlayerName, 22);
				if (i < PlayerLimit)
				{
					if (i > 3 && NCvar[CKillHud_ShowMorePlayer].BoolValue)
					{
						PlayerCountt++;
						Format(rightlinet1, sizeof(rightlinet1), "\n%d.%s %d", i + 1, ReadPlayerName, PlayerFriendlyFire.Get(i));
						Format(rightlinet, sizeof(rightlinet), "%s%s", rightlinet, rightlinet1);
					}
					else
					{
						Format(rightline1, sizeof(rightline1), "\n%d.%s %d", i + 1, ReadPlayerName, PlayerFriendlyFire.Get(i));
						Format(rightline, sizeof(rightline), "%s%s", rightline, rightline1);
					}
				}
			}

			HUDSetLayout(HUD_FAR_RIGHT, HUD_FLAG_ALIGN_LEFT | HUD_FLAG_NOBG | HUD_FLAG_COUNTDOWN_WARN, rightline);
			if (PlayerCount > 4 && NCvar[CKillHud_ShowMorePlayer].BoolValue)
				HUDSetLayout(HUD_RIGHT_TOP, HUD_FLAG_ALIGN_LEFT | HUD_FLAG_NOBG | HUD_FLAG_COUNTDOWN_WARN, rightlinet);
		}

		// Rightbottom
		if (NCvar[CKillHud_AllKill].BoolValue)
		{
			char btnrightline[1024];
			if (NCvar[CKillHud_ShowTankWitch].BoolValue)
				Format(btnrightline, sizeof(btnrightline), "➣章节: %d 特感 %d 丧尸 %d 女巫 %d 坦克", Neko_GlobalState.Kill_AllInfected, Neko_GlobalState.Kill_AllZombie, Neko_GlobalState.Kill_AllWitch, Neko_GlobalState.Kill_AllTank);
			else
				Format(btnrightline, sizeof(btnrightline), "➣章节: %d 特感 %d 丧尸", Neko_GlobalState.Kill_AllInfected, Neko_GlobalState.Kill_AllInfected);

			if (NCvar[CKillHud_AllKillStyle2].BoolValue)
			{
				if (NCvar[CKillHud_ShowTankWitch].BoolValue)
					Format(btnrightline, sizeof(btnrightline), "%s\n➣全局: %d 特感 %d 丧尸 %d 女巫 %d 坦克", btnrightline, Neko_GlobalState.Kill_AllInfectedGO, Neko_GlobalState.Kill_AllZombieGO, Neko_GlobalState.Kill_AllWitchGO, Neko_GlobalState.Kill_AllTankGO);
				else
					Format(btnrightline, sizeof(btnrightline), "%s\n➣全局: %d 特感 %d 丧尸", btnrightline, Neko_GlobalState.Kill_AllInfectedGO, Neko_GlobalState.Kill_AllZombieGO);
			}

			Format(btnrightline, sizeof(btnrightline), "%s\n➣计时: %s", btnrightline, GetNowTime_Format());
			HUDSetLayout(HUD_SCORE_1, HUD_FLAG_ALIGN_LEFT | HUD_FLAG_NOBG | HUD_FLAG_COUNTDOWN_WARN, btnrightline);
		}
		delete PlayerKillNum;
		delete PlayerFriendlyFire;

		int	  counttemp = PlayerCounts;
		float ExtendY	= 0.04;

		if (NCvar[CKillHud_ShowMorePlayer].BoolValue)
		{
			if (counttemp == 0)
				counttemp = PlayerCountt;

			switch (counttemp)
			{
				case 1: ExtendY = 0.04;
				case 2: ExtendY = 0.025;
				case 3: ExtendY = 0.012;
				case 4: ExtendY = 0.0;
				default: ExtendY = 0.04;
			}
		}
		
		if(PlayerLimit != 8)
		{
			if (HUDSlotIsUsed(HUD_LEFT_TOP))
				RemoveHUD(HUD_LEFT_TOP);
			if (HUDSlotIsUsed(HUD_RIGHT_TOP))
				RemoveHUD(HUD_RIGHT_TOP);
		}

		switch (NCvar[CKillHud_HudStyle].IntValue)
		{
			case 1:
			{
				if (NCvar[CKillHud_KillSpecials].BoolValue)
				{
					if (NCvar[CKillHud_ShowMorePlayer].BoolValue)
						HUDPlace(HUD_LEFT_TOP, 0.0, 0.104 - ExtendY, 1.0, 0.15);

					HUDPlace(HUD_FAR_LEFT, 0.0, 0.0, 1.0, 0.15);
				}

				if (NCvar[CKillHud_FriendlyFire].BoolValue)
				{
					if (NCvar[CKillHud_ShowMorePlayer].BoolValue)
						HUDPlace(HUD_RIGHT_TOP, 0.8, 0.104 - ExtendY, 1.0, 0.15);

					HUDPlace(HUD_FAR_RIGHT, 0.8, 0.0, 1.0, 0.15);
				}

				if (NCvar[CKillHud_AllKill].BoolValue)
				{
					if (NCvar[CKillHud_ShowTankWitch].BoolValue)
						HUDPlace(HUD_SCORE_1, 0.7, 0.86, 1.0, 0.08);
					else
						HUDPlace(HUD_SCORE_1, 0.8, 0.86, 1.0, 0.08);
				}
			}
			case 2:
			{
				if (NCvar[CKillHud_KillSpecials].BoolValue)
				{
					if (NCvar[CKillHud_ShowMorePlayer].BoolValue)
						HUDPlace(HUD_LEFT_TOP, 0.0, 0.104 - ExtendY, 1.0, 0.15);

					HUDPlace(HUD_FAR_LEFT, 0.0, 0.0, 1.0, 0.15);
				}

				if (NCvar[CKillHud_FriendlyFire].BoolValue)
				{
					if (NCvar[CKillHud_ShowMorePlayer].BoolValue)
						HUDPlace(HUD_RIGHT_TOP, 0.2, 0.104 - ExtendY, 1.0, 0.15);

					HUDPlace(HUD_FAR_RIGHT, 0.2, 0.0, 1.0, 0.15);
				}

				if (NCvar[CKillHud_AllKill].BoolValue)
				{
					if (NCvar[CKillHud_ShowTankWitch].BoolValue)
						HUDPlace(HUD_SCORE_1, 0.7, 0.03, 1.0, 0.08);
					else
						HUDPlace(HUD_SCORE_1, 0.8, 0.03, 1.0, 0.08);
				}
			}
			case 3:
			{
				float xy[2];
				char  GetCharValue[12];

				if (NCvar[CKillHud_KillSpecials].BoolValue)
				{
					NCvar[CKillHud_CStyleSpecialsXY].GetString(GetCharValue, sizeof GetCharValue);
					GetHUDSide(GetCharValue, xy);
					if (NCvar[CKillHud_ShowMorePlayer].BoolValue)
						HUDPlace(HUD_LEFT_TOP, xy[0], xy[1] + 0.104 - ExtendY, 1.0, 0.15);

					HUDPlace(HUD_FAR_LEFT, xy[0], xy[1], 1.0, 0.15);
				}

				if (NCvar[CKillHud_FriendlyFire].BoolValue)
				{
					NCvar[CKillHud_CStyleFriendXY].GetString(GetCharValue, sizeof GetCharValue);
					GetHUDSide(GetCharValue, xy);
					if (NCvar[CKillHud_ShowMorePlayer].BoolValue)
						HUDPlace(HUD_RIGHT_TOP, xy[0], xy[1] + 0.104 - ExtendY, 1.0, 0.15);

					HUDPlace(HUD_FAR_RIGHT, xy[0], xy[1], 1.0, 0.15);
				}

				if (NCvar[CKillHud_AllKill].BoolValue)
				{
					NCvar[CKillHud_CStyleAllKillXY].GetString(GetCharValue, sizeof GetCharValue);
					GetHUDSide(GetCharValue, xy);
					HUDPlace(HUD_SCORE_1, xy[0], xy[1], 1.0, 0.08);
				}
			}
		}
	}
	else if (NCvar[CKillHud_HudStyle].IntValue == 4)
	{
		if (StyleChatDelay < 0)
		{
			StyleChatDelay = NCvar[CKillHud_StyleChatDelay].IntValue;
			char	  PlayerName[MAX_NAME_LENGTH];
			ArrayList PlayerKillNum		 = new ArrayList(256, 0);
			ArrayList PlayerFriendlyFire = new ArrayList(256, 0);
			ArrayList PlayerFriendlyHurt = new ArrayList(256, 0);
			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && IsAllowBot(i, NCvar[CKillHud_AllowBot].BoolValue) && (GetClientTeam(i) == 2 || GetClientTeam(i) == 1))
				{
					PlayerKillNum.Set(PlayerKillNum.Push(Neko_ClientInfo[i].Kill_Infected), i, 1);
					PlayerFriendlyFire.Set(PlayerFriendlyFire.Push(Neko_ClientInfo[i].Friendly_Fire), i, 1);
					PlayerFriendlyHurt.Set(PlayerFriendlyHurt.Push(Neko_ClientInfo[i].Friendly_Hurt), i, 1);
				}
			}

			PlayerKillNum.Sort(Sort_Descending, Sort_Integer);
			PlayerFriendlyFire.Sort(Sort_Descending, Sort_Integer);
			PlayerFriendlyHurt.Sort(Sort_Descending, Sort_Integer);

			PrintToChatAll("\x05[\x03排行榜 - Rank\x05] \x04本局计时: \x03%s", GetNowTime_Format());
			if (PlayerKillNum.Length <= 0)
			{
				PrintToChatAll("\x05[\x03排行榜 - Rank\x05] \x03未检测有玩家在生还队伍");
				return Plugin_Continue;
			}

			for (int i = 0; i < PlayerKillNum.Length; i++)
			{
				if (i < 4)
				{
					GetClientName(PlayerKillNum.Get(i, 1), PlayerName, 22);
					PrintToChatAll("\x05[\x03#%d\x05]: \x04特感 \x03%d \x04 僵尸 \x03%d \x04友伤 \x03%d \x01| \x04ID \x01%s", i + 1, PlayerKillNum.Get(i), Neko_ClientInfo[PlayerKillNum.Get(i, 1)].Kill_Zombie, Neko_ClientInfo[PlayerKillNum.Get(i, 1)].Friendly_Fire, PlayerName);
				}
			}

			char PlayerNames[MAX_NAME_LENGTH];
			GetClientName(PlayerFriendlyFire.Get(0, 1), PlayerName, 22);
			GetClientName(PlayerFriendlyHurt.Get(0, 1), PlayerNames, 22);
			PrintToChatAll("\x05[\x03MVP\x05]: \x01%s \x04 造成友伤 \x03%d \x01| %s \x04 承受伤害 \x03%d", PlayerName, PlayerFriendlyFire.Get(0), PlayerNames, PlayerFriendlyHurt.Get(0));
			if (!NCvar[CKillHud_ShowTankWitch].BoolValue)
			{
				if (NCvar[CKillHud_AllKillStyle2].BoolValue)
					PrintToChatAll("\x05[\x03全局\x05]: \x03%d \x05特感 \x03%d \x05僵尸", Neko_GlobalState.Kill_AllInfectedGO, Neko_GlobalState.Kill_AllZombieGO);
				PrintToChatAll("\x05[\x03章节\x05]: \x03%d \x05特感 \x03%d \x05僵尸", Neko_GlobalState.Kill_AllInfected, Neko_GlobalState.Kill_AllZombie);
			}
			else
			{
				if (NCvar[CKillHud_AllKillStyle2].BoolValue)
					PrintToChatAll("\x05[\x03全局\x05]: \x03%d \x05特感 \x03%d \x05僵尸 \x03%d \x05女巫 \x03%d \x05坦克", Neko_GlobalState.Kill_AllInfectedGO, Neko_GlobalState.Kill_AllZombieGO, Neko_GlobalState.Kill_AllWitchGO, Neko_GlobalState.Kill_AllTankGO);
				PrintToChatAll("\x05[\x03章节\x05]: \x03%d \x05特感 \x03%d \x05僵尸 \x03%d \x05女巫 \x03%d \x05坦克", Neko_GlobalState.Kill_AllInfected, Neko_GlobalState.Kill_AllZombie, Neko_GlobalState.Kill_AllWitch, Neko_GlobalState.Kill_AllTank);
			}

			delete PlayerKillNum;
			delete PlayerFriendlyFire;
			delete PlayerFriendlyHurt;
		}
		else
			StyleChatDelay--;
	}
	return Plugin_Continue;
}