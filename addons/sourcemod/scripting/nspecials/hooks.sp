public Action ChatListener(int client, const char[] command, int args)
{
	if(!IsValidClient(client) || IsFakeClient(client) || IsChatTrigger())
		return Plugin_Handled;
	
	char msg[128];
	
	GetCmdArgString(msg, sizeof(msg));
	StripQuotes(msg);
	
	if(WaitingForTgtime[client] || WaitingForTgnum[client] || WaitingForTgadd[client] || WaitingForPnum[client] || WaitingForPadd[client] || WaitingForTgCustom[client])
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
				PrintToChat(client, "\x05%s \x04输入的时间有误，请重试 \x03范围[3 - 180]", NEKOTAG);
			else
			{
				if(StrEqual(WaitingForTgTimeType[client], "tgtime"))
					CSpecial_Spawn_Time.SetInt(DD);
				else if(StrEqual(WaitingForTgTimeType[client], "tgtimeeasy"))
					CSpecial_Spawn_Time_Easy.SetInt(DD);
				else if(StrEqual(WaitingForTgTimeType[client], "tgtimenormal"))
					CSpecial_Spawn_Time_Normal.SetInt(DD);
				else if(StrEqual(WaitingForTgTimeType[client], "tgtimehard"))
					CSpecial_Spawn_Time_Hard.SetInt(DD);
				else if(StrEqual(WaitingForTgTimeType[client], "tgtimeexpert"))
					CSpecial_Spawn_Time_Impossible.SetInt(DD);
				
				CheckDifficulty();
			
				PrintToChat(client, "\x05%s \x04更改刷特时间为 \x03%i 秒", NEKOTAG, tgtime);
				cleanplayerwait(client);
			}
		}
		else if(WaitingForTgnum[client])
		{
			if(DD < 1 || DD > 32)
				PrintToChat(client, "\x05%s \x04输入的数量有误，请重试 \x03范围[1 - 32]", NEKOTAG);
			else
			{
				CSpecial_Num.SetInt(DD);
				SetMaxSpecialsCount();
				PrintToChat(client, "\x05%s \x04更改刷特初始数量为 \x03%i ", NEKOTAG, DD);
				InfectedTips();
				cleanplayerwait(client);
			}
		}
		else if(WaitingForTgadd[client])
		{
			if(DD < 0 || DD > 8)
				PrintToChat(client, "\x05%s \x04输入的数量有误，请重试 \x03范围[0 - 8]", NEKOTAG);
			else
			{
				CSpecial_AddNum.SetInt(DD);
				SetMaxSpecialsCount();
				PrintToChat(client, "\x05%s \x04更改刷特增加数量为 \x03%i ", NEKOTAG, DD);
				InfectedTips();
				cleanplayerwait(client);
			}
		}
		else if(WaitingForPnum[client])
		{
			if(DD < 1 || DD > 32)
				PrintToChat(client, "\x05%s \x04输入的数量有误，请重试 \x03范围[1 - 8]", NEKOTAG);
			else
			{
				CSpecial_PlayerNum.SetInt(DD);
				SetMaxSpecialsCount();
				PrintToChat(client, "\x05%s \x04更改初始玩家数量为 \x03%i ", NEKOTAG, DD);
				InfectedTips();
				cleanplayerwait(client);
			}
		}
		else if(WaitingForPadd[client])
		{
			if(DD < 1 || DD > 8)
				PrintToChat(client, "\x05%s \x04输入的数量有误，请重试 \x03范围[1 - 8]", NEKOTAG);
			else
			{
				CSpecial_PlayerAdd.SetInt(DD);
				SetMaxSpecialsCount();
				PrintToChat(client, "\x05%s \x04更改玩家增加数量为 \x03%i ", NEKOTAG, DD);
				InfectedTips();
				cleanplayerwait(client);
			}
		}
		else if(WaitingForTgCustom[client])
		{
			if(DD < 0 || DD > 32)
				PrintToChat(client, "\x05%s \x04输入的数量有误，请重试 \x03范围[0 - 32]", NEKOTAG);
			else
			{
				if(StrEqual(WaitingForTgCustomItem[client], "charger"))
				{
					CSpecial_Charger_Num.SetInt(DD);
					PrintToChat(client, "\x05%s \x04牛数量设置为 \x03%d", NEKOTAG, DD);
				}
				if(StrEqual(WaitingForTgCustomItem[client], "boomer"))
				{
					CSpecial_Boomer_Num.SetInt(DD);
					PrintToChat(client, "\x05%s \x04胖子数量设置为 \x03%d", NEKOTAG, DD);
				}
				if(StrEqual(WaitingForTgCustomItem[client], "spitter"))
				{
					CSpecial_Spitter_Num.SetInt(DD);
					PrintToChat(client, "\x05%s \x04口水数量设置为 \x03%d", NEKOTAG, DD);
				}
				if(StrEqual(WaitingForTgCustomItem[client], "smoker"))
				{
					CSpecial_Smoker_Num.SetInt(DD);
					PrintToChat(client, "\x05%s \x04舌头数量设置为 \x03%d", NEKOTAG, DD);
				}
				if(StrEqual(WaitingForTgCustomItem[client], "jockey"))
				{
					CSpecial_Jockey_Num.SetInt(DD);
					PrintToChat(client, "\x05%s \x04猴子数量设置为 \x03%d", NEKOTAG, DD);
				}
				if(StrEqual(WaitingForTgCustomItem[client], "hunter"))
				{
					CSpecial_Hunter_Num.SetInt(DD);
					PrintToChat(client, "\x05%s \x04猎人数量设置为 \x03%d", NEKOTAG, DD);
				}
				CSpecial_Default_Mode.SetInt(7);
				TgModeStartSet();
				if(Special_Show_Tips)
					ModeTips();
				if(Special_Random_Mode)
				{
					CSpecial_Random_Mode.SetInt(0);
					PrintToChat(client, "\x05%s \x04关闭了随机特感", NEKOTAG);
				}
				cleanplayerwait(client);
			}
		}
		SpecialMenuCustom(client).Display(client, MENU_TIME);
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

