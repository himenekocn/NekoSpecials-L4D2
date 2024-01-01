

public Action ChatListener(int client, const char[] command, int args)
{
	if (!IsValidClient(client) || IsFakeClient(client) || IsChatTrigger())
		return Plugin_Continue;

	char msg[128];

	GetCmdArgString(msg, sizeof(msg));
	StripQuotes(msg);

	if (N_ClientItem[client].InWait())
	{
		int GetValue;

		if (StrEqual(msg, "!cancel"))
		{
			PrintToChat(client, "\x05%s \x04本次操作取消", NEKOTAG);
			N_ClientItem[client].Reset();
			return Plugin_Continue;
		}

		if (!IsInteger(msg))
		{
			PrintToChat(client, "\x05%s \x04输入有误 \x03请检查", NEKOTAG);
			return Plugin_Continue;
		}
		else
			GetValue = StringToInt(msg);

		if (N_ClientItem[client].WaitingForTgtime)
		{
			if (GetValue < 3 || GetValue > 180)
			{
				PrintToChat(client, "\x05%s \x04输入的时间有误，请重试 \x03范围[3 - 180]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				if (StrEqual(N_ClientItem[client].WaitingForTgTimeType, "tgtime"))
					NCvar[CSpecial_Spawn_Time].SetInt(GetValue);
				else if (StrEqual(N_ClientItem[client].WaitingForTgTimeType, "tgtimeeasy"))
					NCvar[CSpecial_Spawn_Time_Easy].SetInt(GetValue);
				else if (StrEqual(N_ClientItem[client].WaitingForTgTimeType, "tgtimenormal"))
					NCvar[CSpecial_Spawn_Time_Normal].SetInt(GetValue);
				else if (StrEqual(N_ClientItem[client].WaitingForTgTimeType, "tgtimehard"))
					NCvar[CSpecial_Spawn_Time_Hard].SetInt(GetValue);
				else if (StrEqual(N_ClientItem[client].WaitingForTgTimeType, "tgtimeexpert"))
					NCvar[CSpecial_Spawn_Time_Impossible].SetInt(GetValue);

				PrintToChat(client, "\x05%s \x04更改刷特时间为 \x03%i 秒", NEKOTAG, GetSpecialRespawnInterval());
			}
		}
		else if (N_ClientItem[client].WaitingForTgnum)
		{
			if (GetValue < 1 || GetValue > 32)
			{
				PrintToChat(client, "\x05%s \x04输入的数量有误，请重试 \x03范围[1 - 32]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				NCvar[CSpecial_Num].SetInt(GetValue);
				PrintToChat(client, "\x05%s \x04更改刷特初始数量为 \x03%i ", NEKOTAG, GetValue);
			}
		}
		else if (N_ClientItem[client].WaitingForTgadd)
		{
			if (GetValue < 0 || GetValue > 8)
			{
				PrintToChat(client, "\x05%s \x04输入的数量有误，请重试 \x03范围[0 - 8]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				NCvar[CSpecial_AddNum].SetInt(GetValue);
				PrintToChat(client, "\x05%s \x04更改刷特增加数量为 \x03%i ", NEKOTAG, GetValue);
			}
		}
		else if (N_ClientItem[client].WaitingForPnum)
		{
			if (GetValue < 1 || GetValue > 32)
			{
				PrintToChat(client, "\x05%s \x04输入的数量有误，请重试 \x03范围[1 - 8]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				NCvar[CSpecial_PlayerNum].SetInt(GetValue);
				PrintToChat(client, "\x05%s \x04更改初始玩家数量为 \x03%i ", NEKOTAG, GetValue);
			}
		}
		else if (N_ClientItem[client].WaitingForPadd)
		{
			if (GetValue < 1 || GetValue > 8)
			{
				PrintToChat(client, "\x05%s \x04输入的数量有误，请重试 \x03范围[1 - 8]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				NCvar[CSpecial_PlayerAdd].SetInt(GetValue);
				PrintToChat(client, "\x05%s \x04更改玩家增加数量为 \x03%i ", NEKOTAG, GetValue);
			}
		}
		else if (N_ClientItem[client].WaitingForTgCustom)
		{
			if (GetValue < 0 || GetValue > 32)
			{
				PrintToChat(client, "\x05%s \x04输入的数量有误，请重试 \x03范围[0 - 32]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				switch (StringToInt(N_ClientItem[client].WaitingForTgCustomItem))
				{
					case 1: NCvar[CSpecial_Charger_Num].SetInt(GetValue);
					case 2: NCvar[CSpecial_Boomer_Num].SetInt(GetValue);
					case 3: NCvar[CSpecial_Spitter_Num].SetInt(GetValue);
					case 4: NCvar[CSpecial_Smoker_Num].SetInt(GetValue);
					case 5: NCvar[CSpecial_Jockey_Num].SetInt(GetValue);
					case 6: NCvar[CSpecial_Hunter_Num].SetInt(GetValue);
				}

				PrintToChat(client, "\x05%s \x04%s数量设置为 \x03%d", NEKOTAG, SpecialName[StringToInt(N_ClientItem[client].WaitingForTgCustomItem)], GetValue);
				NCvar[CSpecial_Default_Mode].SetInt(7);

				if (NCvar[CSpecial_Show_Tips].BoolValue)
					ModeTips();
				if (NCvar[CSpecial_Random_Mode].BoolValue)
				{
					NCvar[CSpecial_Random_Mode].SetBool(false);
					PrintToChat(client, "\x05%s \x04关闭了随机特感", NEKOTAG);
				}
			}
		}
		else if (N_ClientItem[client].WaitingForTgCustomWeight)
		{
			if (GetValue < 1 || GetValue > 100)
			{
				PrintToChat(client, "\x05%s \x04输入的概率有误，请重试 \x03范围[1 - 100]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				switch (StringToInt(N_ClientItem[client].WaitingForTgCustomWeightItem))
				{
					case 1: NCvar[CSpecial_Charger_Spawn_Weight].SetInt(GetValue);
					case 2: NCvar[CSpecial_Boomer_Spawn_Weight].SetInt(GetValue);
					case 3: NCvar[CSpecial_Spitter_Spawn_Weight].SetInt(GetValue);
					case 4: NCvar[CSpecial_Smoker_Spawn_Weight].SetInt(GetValue);
					case 5: NCvar[CSpecial_Jockey_Spawn_Weight].SetInt(GetValue);
					case 6: NCvar[CSpecial_Hunter_Spawn_Weight].SetInt(GetValue);
				}

				PrintToChat(client, "\x05%s \x04%s刷新概率设置为 \x03%d", NEKOTAG, SpecialName[StringToInt(N_ClientItem[client].WaitingForTgCustomWeightItem)], GetValue);
			}
		}
		else if (N_ClientItem[client].WaitingForTgCustomDirChance)
		{
			if (GetValue < 1 || GetValue > 100)
			{
				PrintToChat(client, "\x05%s \x04输入的概率有误，请重试 \x03范围[1 - 100]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				switch (StringToInt(N_ClientItem[client].WaitingForTgCustomDirChanceItem))
				{
					case 1: NCvar[CSpecial_Charger_Spawn_DirChance].SetInt(GetValue);
					case 2: NCvar[CSpecial_Boomer_Spawn_DirChance].SetInt(GetValue);
					case 3: NCvar[CSpecial_Spitter_Spawn_DirChance].SetInt(GetValue);
					case 4: NCvar[CSpecial_Smoker_Spawn_DirChance].SetInt(GetValue);
					case 5: NCvar[CSpecial_Jockey_Spawn_DirChance].SetInt(GetValue);
					case 6: NCvar[CSpecial_Hunter_Spawn_DirChance].SetInt(GetValue);
				}
				PrintToChat(client, "\x05%s \x04%s刷新方位百分比设置为 \x03%d", NEKOTAG, SpecialName[StringToInt(N_ClientItem[client].WaitingForTgCustomDirChanceItem)], GetValue);
			}
		}
		else if (N_ClientItem[client].WaitingForTgCustomMaxDis)
		{
			if (GetValue < 1)
			{
				PrintToChat(client, "\x05%s \x04输入的数值有误，请重试 \x03范围[不能小于1，不要小于最小距离]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				switch (StringToInt(N_ClientItem[client].WaitingForTgCustomMaxDisItem))
				{
					case 1: NCvar[CSpecial_Charger_Spawn_MaxDis].SetInt(GetValue);
					case 2: NCvar[CSpecial_Boomer_Spawn_MaxDis].SetInt(GetValue);
					case 3: NCvar[CSpecial_Spitter_Spawn_MaxDis].SetInt(GetValue);
					case 4: NCvar[CSpecial_Smoker_Spawn_MaxDis].SetInt(GetValue);
					case 5: NCvar[CSpecial_Jockey_Spawn_MaxDis].SetInt(GetValue);
					case 6: NCvar[CSpecial_Hunter_Spawn_MaxDis].SetInt(GetValue);
				}
				PrintToChat(client, "\x05%s \x04%s刷新最大距离设置为 \x03%d", NEKOTAG, SpecialName[StringToInt(N_ClientItem[client].WaitingForTgCustomMaxDisItem)], GetValue);
			}
		}
		else if (N_ClientItem[client].WaitingForTgCustomMinDis)
		{
			if (GetValue < 1)
			{
				PrintToChat(client, "\x05%s \x04输入的数值有误，请重试 \x03范围[不能小于1，不要超过最大距离]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				switch (StringToInt(N_ClientItem[client].WaitingForTgCustomMinDisItem))
				{
					case 1: NCvar[CSpecial_Charger_Spawn_MinDis].SetInt(GetValue);
					case 2: NCvar[CSpecial_Boomer_Spawn_MinDis].SetInt(GetValue);
					case 3: NCvar[CSpecial_Spitter_Spawn_MinDis].SetInt(GetValue);
					case 4: NCvar[CSpecial_Smoker_Spawn_MinDis].SetInt(GetValue);
					case 5: NCvar[CSpecial_Jockey_Spawn_MinDis].SetInt(GetValue);
					case 6: NCvar[CSpecial_Hunter_Spawn_MinDis].SetInt(GetValue);
				}
				PrintToChat(client, "\x05%s \x04%s刷新最小距离设置为 \x03%d", NEKOTAG, SpecialName[StringToInt(N_ClientItem[client].WaitingForTgCustomMinDisItem)], GetValue);
			}
		}
		else if (N_ClientItem[client].WaitingForTgCustomMaxDisNor)
		{
			if (GetValue < 1)
			{
				PrintToChat(client, "\x05%s \x04输入的数值有误，请重试 \x03范围[不能小于1，不要小于最小距离]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				NCvar[CSpecial_Spawn_MaxDis].SetInt(GetValue);
				PrintToChat(client, "\x05%s \x04全特感刷新最小距离设置为 \x03%d", NEKOTAG, GetValue);
			}
		}
		else if (N_ClientItem[client].WaitingForTgCustomMinDisNor)
		{
			if (GetValue < 1)
			{
				PrintToChat(client, "\x05%s \x04输入的数值有误，请重试 \x03范围[不能小于1，不要超过最大距离]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				NCvar[CSpecial_Spawn_MinDis].SetInt(GetValue);
				PrintToChat(client, "\x05%s \x04全特感刷新最小距离设置为 \x03%d", NEKOTAG, GetValue);
			}
		}

		N_ClientItem[client].Reset();
		N_ClientMenu[client].Reset();

		if (N_ClientItem[client].WaitingForTgCustom)
			SpecialMenuCustom(client).Display(client, MENU_TIME);
		else if (N_ClientItem[client].WaitingForTgCustomWeight)
			SpecialMenuCustomWeight(client).Display(client, MENU_TIME);
		else if (N_ClientItem[client].WaitingForTgCustomDirChance)
			SpecialMenuCustomDirChance(client).Display(client, MENU_TIME);
		else if (N_ClientItem[client].WaitingForTgCustomMaxDis)
			SpecialMenuCustomMaxDis(client).Display(client, MENU_TIME);
		else if (N_ClientItem[client].WaitingForTgCustomMinDis)
			SpecialMenuCustomMinDis(client).Display(client, MENU_TIME);
		else
			SpecialMenu(client).DisplayAt(client, N_ClientMenu[client].MenuPageItem, MENU_TIME);

		return Plugin_Continue;
	}
	return Plugin_Continue;
}
