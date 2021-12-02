public Action ChatListener(int client, const char[] command, int args)
{
	if(!IsValidClient(client) || IsFakeClient(client) || IsChatTrigger())
		return Plugin_Handled;
	
	char msg[128];
	
	GetCmdArgString(msg, sizeof(msg));
	StripQuotes(msg);
	
	if(WaitingForTgtime[client] || WaitingForTgnum[client] || WaitingForTgadd[client] || WaitingForPnum[client] || WaitingForPadd[client] || WaitingForTgCustom[client] || WaitingForTgCustomWeight[client] || WaitingForTgCustomDirChance[client] || WaitingForTgCustomMaxDis[client] || WaitingForTgCustomMinDis[client] || WaitingForTgCustomMaxDisNor[client] || WaitingForTgCustomMinDisNor[client])
	{
		int DD;

		if (StrEqual(msg, "!cancel"))
		{
			PrintToChat(client, "\x05%s \x04本次操作取消", NEKOTAG);
			cleanplayerwait(client);
			return Plugin_Handled;
		}
		
		if(!IsInteger(msg))
		{
			PrintToChat(client, "\x05%s \x04输入有误 \x03请检查", NEKOTAG);
			return Plugin_Handled;
		}
		else
		{
			DD = StringToInt(msg);
		}
	
		if(WaitingForTgtime[client])
		{
			if(DD < 3 || DD > 180)
			{
				PrintToChat(client, "\x05%s \x04输入的时间有误，请重试 \x03范围[3 - 180]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				if(StrEqual(WaitingForTgTimeType[client], "tgtime"))
					NCvar[CSpecial_Spawn_Time].SetInt(DD);
				else if(StrEqual(WaitingForTgTimeType[client], "tgtimeeasy"))
					NCvar[CSpecial_Spawn_Time_Easy].SetInt(DD);
				else if(StrEqual(WaitingForTgTimeType[client], "tgtimenormal"))
					NCvar[CSpecial_Spawn_Time_Normal].SetInt(DD);
				else if(StrEqual(WaitingForTgTimeType[client], "tgtimehard"))
					NCvar[CSpecial_Spawn_Time_Hard].SetInt(DD);
				else if(StrEqual(WaitingForTgTimeType[client], "tgtimeexpert"))
					NCvar[CSpecial_Spawn_Time_Impossible].SetInt(DD);
			
				PrintToChat(client, "\x05%s \x04更改刷特时间为 \x03%i 秒", NEKOTAG, GetSpecialRespawnInterval());
			}
		}
		else if(WaitingForTgnum[client])
		{
			if(DD < 1 || DD > 32)
			{
				PrintToChat(client, "\x05%s \x04输入的数量有误，请重试 \x03范围[1 - 32]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				NCvar[CSpecial_Num].SetInt(DD);
				PrintToChat(client, "\x05%s \x04更改刷特初始数量为 \x03%i ", NEKOTAG, DD);
			}
		}
		else if(WaitingForTgadd[client])
		{
			if(DD < 0 || DD > 8)
			{
				PrintToChat(client, "\x05%s \x04输入的数量有误，请重试 \x03范围[0 - 8]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				NCvar[CSpecial_AddNum].SetInt(DD);
				PrintToChat(client, "\x05%s \x04更改刷特增加数量为 \x03%i ", NEKOTAG, DD);
			}
		}
		else if(WaitingForPnum[client])
		{
			if(DD < 1 || DD > 32)
			{
				PrintToChat(client, "\x05%s \x04输入的数量有误，请重试 \x03范围[1 - 8]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				NCvar[CSpecial_PlayerNum].SetInt(DD);
				PrintToChat(client, "\x05%s \x04更改初始玩家数量为 \x03%i ", NEKOTAG, DD);
			}
		}
		else if(WaitingForPadd[client])
		{
			if(DD < 1 || DD > 8)
			{
				PrintToChat(client, "\x05%s \x04输入的数量有误，请重试 \x03范围[1 - 8]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				NCvar[CSpecial_PlayerAdd].SetInt(DD);
				PrintToChat(client, "\x05%s \x04更改玩家增加数量为 \x03%i ", NEKOTAG, DD);
			}
		}
		else if(WaitingForTgCustom[client])
		{
			if(DD < 0 || DD > 32)
			{
				PrintToChat(client, "\x05%s \x04输入的数量有误，请重试 \x03范围[0 - 32]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				char SpecialName[128];
				if(StrEqual(WaitingForTgCustomItem[client], "charger"))
				{
					NCvar[CSpecial_Charger_Num].SetInt(DD);
					SpecialName = "牛子";
				}
				if(StrEqual(WaitingForTgCustomItem[client], "boomer"))
				{
					NCvar[CSpecial_Boomer_Num].SetInt(DD);
					SpecialName = "胖子";
				}
				if(StrEqual(WaitingForTgCustomItem[client], "spitter"))
				{
					NCvar[CSpecial_Spitter_Num].SetInt(DD);
					SpecialName = "口水";
				}
				if(StrEqual(WaitingForTgCustomItem[client], "smoker"))
				{
					NCvar[CSpecial_Smoker_Num].SetInt(DD);
					SpecialName = "舌头";
				}
				if(StrEqual(WaitingForTgCustomItem[client], "jockey"))
				{
					NCvar[CSpecial_Jockey_Num].SetInt(DD);
					SpecialName = "猴子";
				}
				if(StrEqual(WaitingForTgCustomItem[client], "hunter"))
				{
					NCvar[CSpecial_Hunter_Num].SetInt(DD);
					SpecialName = "猎人";
				}
				PrintToChat(client, "\x05%s \x04%s数量设置为 \x03%d", NEKOTAG, SpecialName, DD);
				NCvar[CSpecial_Default_Mode].SetInt(7);

				if(NCvar[CSpecial_Show_Tips].BoolValue)
					ModeTips();
				if(NCvar[CSpecial_Random_Mode].BoolValue)
				{
					NCvar[CSpecial_Random_Mode].SetBool(false);
					PrintToChat(client, "\x05%s \x04关闭了随机特感", NEKOTAG);
				}
			}
		}
		else if(WaitingForTgCustomWeight[client])
		{
			if(DD < 1 || DD > 100)
			{
				PrintToChat(client, "\x05%s \x04输入的概率有误，请重试 \x03范围[1 - 100]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				char SpecialName[128];
				if(StrEqual(WaitingForTgCustomWeightItem[client], "charger"))
				{
					NCvar[CSpecial_Charger_Spawn_Weight].SetInt(DD);
					SpecialName = "牛子";
				}
				if(StrEqual(WaitingForTgCustomWeightItem[client], "boomer"))
				{
					NCvar[CSpecial_Boomer_Spawn_Weight].SetInt(DD);
					SpecialName = "胖子";
				}
				if(StrEqual(WaitingForTgCustomWeightItem[client], "spitter"))
				{
					NCvar[CSpecial_Spitter_Spawn_Weight].SetInt(DD);
					SpecialName = "口水";
				}
				if(StrEqual(WaitingForTgCustomWeightItem[client], "smoker"))
				{
					NCvar[CSpecial_Smoker_Spawn_Weight].SetInt(DD);
					SpecialName = "舌头";
				}
				if(StrEqual(WaitingForTgCustomWeightItem[client], "jockey"))
				{
					NCvar[CSpecial_Jockey_Spawn_Weight].SetInt(DD);
					SpecialName = "猴子";
				}
				if(StrEqual(WaitingForTgCustomWeightItem[client], "hunter"))
				{
					NCvar[CSpecial_Hunter_Spawn_Weight].SetInt(DD);
					SpecialName = "猎人";
				}
				PrintToChat(client, "\x05%s \x04%s刷新概率设置为 \x03%d", NEKOTAG, SpecialName, DD);
			}
		}
		else if(WaitingForTgCustomDirChance[client])
		{
			if(DD < 1 || DD > 100)
			{
				PrintToChat(client, "\x05%s \x04输入的概率有误，请重试 \x03范围[1 - 100]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				char SpecialName[128];
				if(StrEqual(WaitingForTgCustomDirChanceItem[client], "charger"))
				{
					NCvar[CSpecial_Charger_Spawn_DirChance].SetInt(DD);
					SpecialName = "牛子";
				}
				if(StrEqual(WaitingForTgCustomDirChanceItem[client], "boomer"))
				{
					NCvar[CSpecial_Boomer_Spawn_DirChance].SetInt(DD);
					SpecialName = "胖子";
				}
				if(StrEqual(WaitingForTgCustomDirChanceItem[client], "spitter"))
				{
					NCvar[CSpecial_Spitter_Spawn_DirChance].SetInt(DD);
					SpecialName = "口水";
				}
				if(StrEqual(WaitingForTgCustomDirChanceItem[client], "smoker"))
				{
					NCvar[CSpecial_Smoker_Spawn_DirChance].SetInt(DD);
					SpecialName = "舌头";
				}
				if(StrEqual(WaitingForTgCustomDirChanceItem[client], "jockey"))
				{
					NCvar[CSpecial_Jockey_Spawn_DirChance].SetInt(DD);
					SpecialName = "猴子";
				}
				if(StrEqual(WaitingForTgCustomDirChanceItem[client], "hunter"))
				{
					NCvar[CSpecial_Hunter_Spawn_DirChance].SetInt(DD);
					SpecialName = "猎人";
				}
				PrintToChat(client, "\x05%s \x04%s刷新方位百分比设置为 \x03%d", NEKOTAG, SpecialName, DD);
			}
		}
		else if(WaitingForTgCustomMaxDis[client])
		{
			if(DD < 1)
			{
				PrintToChat(client, "\x05%s \x04输入的数值有误，请重试 \x03范围[不能小于1，不要小于最小距离]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				char SpecialName[128];
				if(StrEqual(WaitingForTgCustomMaxDisItem[client], "charger"))
				{
					NCvar[CSpecial_Charger_Spawn_MaxDis].SetInt(DD);
					SpecialName = "牛子";
				}
				if(StrEqual(WaitingForTgCustomMaxDisItem[client], "boomer"))
				{
					NCvar[CSpecial_Boomer_Spawn_MaxDis].SetInt(DD);
					SpecialName = "胖子";
				}
				if(StrEqual(WaitingForTgCustomMaxDisItem[client], "spitter"))
				{
					NCvar[CSpecial_Spitter_Spawn_MaxDis].SetInt(DD);
					SpecialName = "口水";
				}
				if(StrEqual(WaitingForTgCustomMaxDisItem[client], "smoker"))
				{
					NCvar[CSpecial_Smoker_Spawn_MaxDis].SetInt(DD);
					SpecialName = "舌头";
				}
				if(StrEqual(WaitingForTgCustomMaxDisItem[client], "jockey"))
				{
					NCvar[CSpecial_Jockey_Spawn_MaxDis].SetInt(DD);
					SpecialName = "猴子";
				}
				if(StrEqual(WaitingForTgCustomMaxDisItem[client], "hunter"))
				{
					NCvar[CSpecial_Hunter_Spawn_MaxDis].SetInt(DD);
					SpecialName = "猎人";
				}
				PrintToChat(client, "\x05%s \x04%s刷新最大距离设置为 \x03%d", NEKOTAG, SpecialName, DD);
			}
		}
		else if(WaitingForTgCustomMinDis[client])
		{
			if(DD < 1)
			{
				PrintToChat(client, "\x05%s \x04输入的数值有误，请重试 \x03范围[不能小于1，不要超过最大距离]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				char SpecialName[128];
				if(StrEqual(WaitingForTgCustomMinDisItem[client], "charger"))
				{
					NCvar[CSpecial_Charger_Spawn_MinDis].SetInt(DD);
					SpecialName = "牛子";
				}
				if(StrEqual(WaitingForTgCustomMinDisItem[client], "boomer"))
				{
					NCvar[CSpecial_Boomer_Spawn_MinDis].SetInt(DD);
					SpecialName = "胖子";
				}
				if(StrEqual(WaitingForTgCustomMinDisItem[client], "spitter"))
				{
					NCvar[CSpecial_Spitter_Spawn_MinDis].SetInt(DD);
					SpecialName = "口水";
				}
				if(StrEqual(WaitingForTgCustomMinDisItem[client], "smoker"))
				{
					NCvar[CSpecial_Smoker_Spawn_MinDis].SetInt(DD);
					SpecialName = "舌头";
				}
				if(StrEqual(WaitingForTgCustomMinDisItem[client], "jockey"))
				{
					NCvar[CSpecial_Jockey_Spawn_MinDis].SetInt(DD);
					SpecialName = "猴子";
				}
				if(StrEqual(WaitingForTgCustomMinDisItem[client], "hunter"))
				{
					NCvar[CSpecial_Hunter_Spawn_MinDis].SetInt(DD);
					SpecialName = "猎人";
				}
				PrintToChat(client, "\x05%s \x04%s刷新最小距离设置为 \x03%d", NEKOTAG, SpecialName, DD);
				cleanplayerwait(client);
			}
		}
		else if(WaitingForTgCustomMaxDisNor[client])
		{
			if(DD < 1)
			{
				PrintToChat(client, "\x05%s \x04输入的数值有误，请重试 \x03范围[不能小于1，不要小于最小距离]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				NCvar[CSpecial_Spawn_MaxDis].SetInt(DD);
				PrintToChat(client, "\x05%s \x04全特感刷新最小距离设置为 \x03%d", NEKOTAG, DD);
			}
		}
		else if(WaitingForTgCustomMinDisNor[client])
		{
			if(DD < 1)
			{
				PrintToChat(client, "\x05%s \x04输入的数值有误，请重试 \x03范围[不能小于1，不要超过最大距离]", NEKOTAG);
				return Plugin_Continue;
			}
			else
			{
				NCvar[CSpecial_Spawn_MinDis].SetInt(DD);
				PrintToChat(client, "\x05%s \x04全特感刷新最小距离设置为 \x03%d", NEKOTAG, DD);
			}
		}
		
		if(WaitingForTgCustom[client])
			SpecialMenuCustom(client).Display(client, MENU_TIME);
		else if(WaitingForTgCustomWeight[client])
			SpecialMenuCustomWeight(client).Display(client, MENU_TIME);
		else if(WaitingForTgCustomDirChance[client])
			SpecialMenuCustomDirChance(client).Display(client, MENU_TIME);
		else if(WaitingForTgCustomMaxDis[client])
			SpecialMenuCustomMaxDis(client).Display(client, MENU_TIME);
		else if(WaitingForTgCustomMinDis[client])
			SpecialMenuCustomMinDis(client).Display(client, MENU_TIME);
		else
			SpecialMenu(client).DisplayAt(client, MenuPageItem[client], MENU_TIME);

		cleanplayerwait(client);

		return Plugin_Handled;
	}
	return Plugin_Continue;
}

