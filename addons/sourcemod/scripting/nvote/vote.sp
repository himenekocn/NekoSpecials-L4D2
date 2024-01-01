void StartVoteYesNo(int client)
{
	if (!IsValidClient(client))
		return;

	if (!NativeVotes_IsNewVoteAllowed())
	{
		PrintToChat(client, "\x05%s \x04%d秒后才能开始投票", NEKOTAG, NativeVotes_CheckVoteDelay());
		return;
	}

	char buffer[512], sbuffer[512];

	if (StrEqual(VoteMenuItems[client], "tgstat"))
	{
		Format(buffer, sizeof buffer, "多特插件");
		Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_PluginStatus].BoolValue ? "开启" : "关闭");
	}
	if (StrEqual(VoteMenuItems[client], "tgrandom"))
	{
		Format(buffer, sizeof buffer, "随机特感");
		Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_Random_Mode].BoolValue ? "开启" : "关闭");
	}
	if (StrEqual(VoteMenuItems[client], "tgtanklive"))
	{
		Format(buffer, sizeof buffer, "坦克存活时刷新特感");
		Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_Spawn_Tank_Alive].BoolValue ? "开启" : "关闭");
	}
	if (StrEqual(VoteMenuItems[client], "tgtime"))
	{
		Format(buffer, sizeof buffer, "刷特时间为");
		Format(sbuffer, sizeof sbuffer, "%d s", VoteMenuItemValue[client]);
	}
	if (StrEqual(VoteMenuItems[client], "tgnum"))
	{
		Format(buffer, sizeof buffer, "初始刷特数量为");
		Format(sbuffer, sizeof sbuffer, "%d 特", VoteMenuItemValue[client]);
	}
	if (StrEqual(VoteMenuItems[client], "tgadd"))
	{
		Format(buffer, sizeof buffer, "进人增加数量为");
		Format(sbuffer, sizeof sbuffer, "%d 特", VoteMenuItemValue[client]);
	}
	if (StrEqual(VoteMenuItems[client], "tgpnum"))
	{
		Format(buffer, sizeof buffer, "初始玩家数量为");
		Format(sbuffer, sizeof sbuffer, "%d 人", VoteMenuItemValue[client]);
	}
	if (StrEqual(VoteMenuItems[client], "tgpadd"))
	{
		Format(buffer, sizeof buffer, "玩家增加数量为");
		Format(sbuffer, sizeof sbuffer, "%d 人", VoteMenuItemValue[client]);
	}
	if (StrEqual(VoteMenuItems[client], "tgmode"))
	{
		Format(sbuffer, sizeof(sbuffer), "%s", SpecialName[StringToInt(SubMenuVoteItems[client])]);
		Format(buffer, sizeof buffer, "游戏模式为");
	}
	if (StrEqual(VoteMenuItems[client], "tgspawn"))
	{
		Format(sbuffer, sizeof(sbuffer), "%s", SpawnModeName[StringToInt(SubMenuVoteItems[client])]);
		Format(buffer, sizeof buffer, "刷特模式为");
	}

	NativeVote vote = new NativeVote(VoteYesNoH, NativeVotesType_Custom_YesNo);
	vote.Initiator	= client;
	vote.SetDetails("投票%s %s", buffer, sbuffer);
	vote.DisplayVoteToAll(15);
}

public int VoteYesNoH(NativeVote vote, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_End:
		{
			vote.Close();
		}

		case MenuAction_VoteCancel:
		{
			if (param1 == VoteCancel_NoVotes)
			{
				vote.DisplayFail(NativeVotesFail_NotEnoughVotes);
			}
			else
			{
				vote.DisplayFail(NativeVotesFail_Generic);
			}
		}

		case MenuAction_VoteEnd:
		{
			if (param1 == NATIVEVOTES_VOTE_NO)
			{
				vote.DisplayFail(NativeVotesFail_Loses);
			}
			else
			{
				char buffer[512], sbuffer[512], item[512];
				int	 client = vote.Initiator;
				item		= VoteMenuItems[client];
				if (StrEqual(item, "tgstat"))
				{
					Format(buffer, sizeof buffer, "多特插件");
					Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_PluginStatus].BoolValue ? "开启" : "关闭");
					GCvar[CSpecial_PluginStatus].SetBool(!GCvar[CSpecial_PluginStatus].BoolValue);
				}
				if (StrEqual(item, "tgrandom"))
				{
					Format(buffer, sizeof buffer, "随机特感");
					Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_Random_Mode].BoolValue ? "开启" : "关闭");
					GCvar[CSpecial_Random_Mode].SetBool(!GCvar[CSpecial_Random_Mode].BoolValue);
				}
				if (StrEqual(item, "tgtanklive"))
				{
					Format(buffer, sizeof buffer, "坦克存活时刷新特感");
					Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_Spawn_Tank_Alive].BoolValue ? "开启" : "关闭");
					GCvar[CSpecial_Spawn_Tank_Alive].SetBool(!GCvar[CSpecial_Spawn_Tank_Alive].BoolValue);
				}
				if (StrEqual(item, "tgtime"))
				{
					Format(buffer, sizeof buffer, "刷特时间为");
					Format(sbuffer, sizeof sbuffer, "%d s", VoteMenuItemValue[client]);
					GCvar[CSpecial_Spawn_Time].SetInt(VoteMenuItemValue[client]);
				}
				if (StrEqual(item, "tgnum"))
				{
					Format(buffer, sizeof buffer, "初始刷特数量为");
					Format(sbuffer, sizeof sbuffer, "%d 特", VoteMenuItemValue[client]);
					GCvar[CSpecial_Num].SetInt(VoteMenuItemValue[client]);
				}
				if (StrEqual(item, "tgadd"))
				{
					Format(buffer, sizeof buffer, "进人增加数量为");
					Format(sbuffer, sizeof sbuffer, "%d 特", VoteMenuItemValue[client]);
					GCvar[CSpecial_AddNum].SetInt(VoteMenuItemValue[client]);
				}
				if (StrEqual(item, "tgpnum"))
				{
					Format(buffer, sizeof buffer, "初始玩家数量为");
					Format(sbuffer, sizeof sbuffer, "%d 人", VoteMenuItemValue[client]);
					GCvar[CSpecial_PlayerNum].SetInt(VoteMenuItemValue[client]);
				}
				if (StrEqual(item, "tgpadd"))
				{
					Format(buffer, sizeof buffer, "玩家增加数量为");
					Format(sbuffer, sizeof sbuffer, "%d 人", VoteMenuItemValue[client]);
					GCvar[CSpecial_PlayerAdd].SetInt(VoteMenuItemValue[client]);
				}
				if (StrEqual(item, "tgmode"))
				{
					Format(sbuffer, sizeof(sbuffer), "%s", SpecialName[StringToInt(SubMenuVoteItems[client])]);
					Format(buffer, sizeof buffer, "游戏模式为");

					GCvar[CSpecial_Default_Mode].SetInt(StringToInt(SubMenuVoteItems[client]));

					if (GCvar[CSpecial_Show_Tips].BoolValue)
						NekoSpecials_ShowSpecialsModeTips();

					if (GCvar[CSpecial_Random_Mode].BoolValue)
					{
						GCvar[CSpecial_Random_Mode].SetBool(false);
						PrintToChatAll("\x05%s \x04关闭了随机特感", NEKOTAG);
					}
				}
				if (StrEqual(item, "tgspawn"))
				{
					Format(sbuffer, sizeof(sbuffer), "%s", SpawnModeName[StringToInt(SubMenuVoteItems[client])]);
					Format(buffer, sizeof buffer, "刷特模式为");

					GCvar[CSpecial_Spawn_Mode].SetInt(StringToInt(SubMenuVoteItems[client]));

					PrintToChatAll("\x05%s \x04特感刷新方式更改为 \x03%s刷特模式", NEKOTAG, sbuffer);
				}
				vote.DisplayPass("投票%s %s 通过!!!", buffer, sbuffer);

				cleanplayerchar(client);

				CreateTimer(0.2, Timer_ReloadMenu, GetClientUserId(client));
			}
		}
	}

	return 0;
}