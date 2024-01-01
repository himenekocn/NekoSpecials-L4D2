

public Menu SpecialMenu(int client)
{
	N_ClientMenu[client].N_MenuSpecialMenu = new Menu(SpecialMenuHandler);
	char line[2048];

	if (NCvar[CSpecial_PluginStatus].BoolValue)
		Format(line, sizeof(line), "+|NS|+ 特感菜单\n刷特进程[%s]\n特感数量[%d] 刷特时间[%d]", !GetSpecialRunning() ? "未开始" : "已开始", GetSpecialMax(), GetSpecialRespawnInterval());
	else
		Format(line, sizeof(line), "+|NS|+ 特感菜单\n插件关闭");

	N_ClientMenu[client].N_MenuSpecialMenu.SetTitle(line);

	Format(line, sizeof(line), "插件目前状态 [%s]", !NCvar[CSpecial_PluginStatus].BoolValue ? "关" : "开");
	N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgstat", line);

	if (NCvar[CSpecial_PluginStatus].BoolValue)
	{
		Format(line, sizeof(line), "随机特感状态 [%s]", !NCvar[CSpecial_Random_Mode].BoolValue ? "关" : "开");
		N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgrandom", line);

		Format(line, sizeof(line), "快速反应状态 [%s]", !GetSpecialAssault() ? "关" : "开");
		N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgfast", line);

		Format(line, sizeof(line), "特感游戏模式 [%s]", SpecialName[NCvar[CSpecial_Default_Mode].IntValue]);
		N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgmode", line);

		Format(line, sizeof(line), "特感刷新模式 [%s]", SpawnModeName[GetSpecialSpawnMode()]);
		N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgspawn", line);

		if (GetSpecialSpawnMode() != 0)
		{
			Format(line, sizeof(line), "刷特子模式 [%d]", NCvar[CSpecial_IsModeInNormal].IntValue);
			N_ClientMenu[client].N_MenuSpecialMenu.AddItem("ismodenormal", line);
		}

		Format(line, sizeof(line), "全局刷特时间 [%ds]", NCvar[CSpecial_Spawn_Time].IntValue);
		if (!NCvar[CSpecial_Spawn_Time_DifficultyChange].BoolValue)
			N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgtime", line);
		else
			N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgtime", line, ITEMDRAW_DISABLED);

		Format(line, sizeof(line), "初始刷特数量 [%d]", NCvar[CSpecial_Num].IntValue);
		N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgnum", line);

		Format(line, sizeof(line), "进人增加数量 [%d]", NCvar[CSpecial_AddNum].IntValue);
		N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgadd", line);

		Format(line, sizeof(line), "初始玩家数量 [%d]", NCvar[CSpecial_PlayerNum].IntValue);
		N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgpnum", line);

		Format(line, sizeof(line), "玩家增加数量 [%d]", NCvar[CSpecial_PlayerAdd].IntValue);
		N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgpadd", line);

		Format(line, sizeof(line), "是否算入观察 [%s]", !NCvar[CSpecial_PlayerCountSpec].BoolValue ? "否" : "是");
		N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgpcspec", line);

		Format(line, sizeof(line), "不算死亡玩家 [%s]", !NCvar[CSpecial_Num_NotCul_Death].BoolValue ? "否" : "是");
		N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgnculdea", line);

		Format(line, sizeof(line), "克存活时刷特 [%s]", !NCvar[CSpecial_Spawn_Tank_Alive].BoolValue ? "否" : "是");
		N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgtanklive", line);

		if (!NCvar[CSpecial_Spawn_Tank_Alive].BoolValue)
		{
			Format(line, sizeof(line), "克存活禁止特感 (强力模式)");
			N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgtankprolive", line);
		}

		Format(line, sizeof(line), "踢出卡住特感 [%s]", !NCvar[CSpecial_AutoKill_StuckSpecials].BoolValue ? "否" : "是");
		N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgautokick", line);

		Format(line, sizeof(line), "根据难度改变刷特时间 [%s]", !NCvar[CSpecial_Spawn_Time_DifficultyChange].BoolValue ? "否" : "是");
		N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgautotime", line);

		if (NCvar[CSpecial_Spawn_Time_DifficultyChange].BoolValue)
		{
			Format(line, sizeof(line), "简单难度刷特时间 [%d]", NCvar[CSpecial_Spawn_Time_Easy].IntValue);
			N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgtimeeasy", line);

			Format(line, sizeof(line), "普通难度刷特时间 [%d]", NCvar[CSpecial_Spawn_Time_Normal].IntValue);
			N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgtimenormal", line);

			Format(line, sizeof(line), "高级难度刷特时间 [%d]", NCvar[CSpecial_Spawn_Time_Hard].IntValue);
			N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgtimehard", line);

			Format(line, sizeof(line), "专家难度刷特时间 [%d]", NCvar[CSpecial_Spawn_Time_Impossible].IntValue);
			N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgtimeexpert", line);
		}

		Format(line, sizeof(line), "特感种类数量 [默认模式]");
		N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgcustom", line);

		Format(line, sizeof(line), "特感刷新几率");
		N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgcustomweight", line);

		if (GetSpecialSpawnMode() > 1)
		{
			Format(line, sizeof(line), "特感刷新方位");
			N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgcustomdirchance", line);

			Format(line, sizeof(line), "特感刷新区域");
			N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgcustomspawnarea", line);

			Format(line, sizeof(line), "特感刷新最大距离");
			N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgcustommaxdis", line);

			Format(line, sizeof(line), "特感刷新最小距离");
			N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgcustommindis", line);
		}
		else
		{
			Format(line, sizeof(line), "特感刷新最大距离 [%d]", GetSpecialSpawnMaxDis_());
			N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgcustommaxdisnor", line);

			Format(line, sizeof(line), "特感刷新最小距离 [%d]", GetSpecialSpawnMinDis_());
			N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgcustommindisnor", line);

			Format(line, sizeof(line), "游戏预设特感刷新最大距离");
			N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgcustommaxdisreset", line);

			Format(line, sizeof(line), "游戏预设特感刷新最小距离");
			N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgcustommindisreset", line);
		}

		Format(line, sizeof(line), "显示插件提示 [%s]", !NCvar[CSpecial_Show_Tips].BoolValue ? "否" : "是");
		N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgtips", line);

		Format(line, sizeof(line), "使用聊天框提示 [%s]", !NCvar[CSpecial_Show_Tips_Chat].BoolValue ? "否" : "是");
		N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgtipschat", line);
	}

	Format(line, sizeof(line), "重载配置文件");
	N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgreload", line);

	Format(line, sizeof(line), "写入配置文件");
	N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgfilewr", line);

	Format(line, sizeof(line), "重置配置文件");
	N_ClientMenu[client].N_MenuSpecialMenu.AddItem("tgreset", line);

	Format(line, sizeof(line), "具体如何设置请查看CFG\n或插件说明\n插件版本:%s", PLUGIN_VERSION);
	N_ClientMenu[client].N_MenuSpecialMenu.AddItem("info", line, ITEMDRAW_DISABLED);

	N_ClientMenu[client].N_MenuSpecialMenu.ExitBackButton = true;
	return N_ClientMenu[client].N_MenuSpecialMenu;
}

public int SpecialMenuHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			if (IsValidClient(client))
			{
				N_ClientItem[client].Reset();
				N_ClientMenu[client].MenuPageItem = GetMenuSelectionPosition();

				char items[50];
				menu.GetItem(selection, items, sizeof(items));

				bool NeedOpenMenu = true;

				if (StrEqual(items, "tgstat"))
				{
					SwitchPlugin(client);
				}
				if (StrEqual(items, "tgrandom"))
				{
					SwitchRandom(client);
				}
				if (StrEqual(items, "tgmode"))
				{
					SpecialMenuMode(client);
					NeedOpenMenu = false;
				}
				if (StrEqual(items, "tgspawn"))
				{
					SpecialMenuSpawn(client);
					NeedOpenMenu = false;
				}
				if (StrContains(items, "tgtime", false) != -1)
				{
					N_ClientItem[client].WaitingForTgtime	  = true;
					N_ClientItem[client].WaitingForTgTimeType = items;
					PrintToChat(client, "\x05%s \x04请在聊天框输入你想设置的时间 \x03范围[3 - 120]", NEKOTAG);
					PrintToChat(client, "\x05%s \x04输入 \x03!cancel \x04即可取消这次操作", NEKOTAG);
				}
				if (StrEqual(items, "tgnum"))
				{
					N_ClientItem[client].WaitingForTgnum = true;
					PrintToChat(client, "\x05%s \x04请在聊天框输入你想设置的初始特感数量 \x03范围[1 - 32]", NEKOTAG);
					PrintToChat(client, "\x05%s \x04输入 \x03!cancel \x04即可取消这次操作", NEKOTAG);
				}
				if (StrEqual(items, "tgadd"))
				{
					N_ClientItem[client].WaitingForTgadd = true;
					PrintToChat(client, "\x05%s \x04请在聊天框输入你想设置的增加数量 \x03范围[0 - 8]", NEKOTAG);
					PrintToChat(client, "\x05%s \x04输入 \x03!cancel \x04即可取消这次操作", NEKOTAG);
				}
				if (StrEqual(items, "tgpnum"))
				{
					N_ClientItem[client].WaitingForPnum = true;
					PrintToChat(client, "\x05%s \x04请在聊天框输入你想设置的初始玩家数量 \x03范围[1 - 32]", NEKOTAG);
					PrintToChat(client, "\x05%s \x04输入 \x03!cancel \x04即可取消这次操作", NEKOTAG);
				}
				if (StrEqual(items, "tgpadd"))
				{
					N_ClientItem[client].WaitingForPadd = true;
					PrintToChat(client, "\x05%s \x04请在聊天框输入你想设置的玩家增加数量 \x03范围[0 - 8]", NEKOTAG);
					PrintToChat(client, "\x05%s \x04输入 \x03!cancel \x04即可取消这次操作", NEKOTAG);
				}
				if (StrEqual(items, "tgcustom"))
				{
					SpecialMenuCustom(client).Display(client, MENU_TIME);
					NeedOpenMenu = false;
				}
				if (StrEqual(items, "tgcustomweight"))
				{
					SpecialMenuCustomWeight(client).Display(client, MENU_TIME);
					NeedOpenMenu = false;
				}
				if (StrEqual(items, "tgcustomdirchance"))
				{
					SpecialMenuCustomDirChance(client).Display(client, MENU_TIME);
					NeedOpenMenu = false;
				}
				if (StrEqual(items, "tgcustomspawnarea"))
				{
					SpecialMenuCustomSpawnArea(client).Display(client, MENU_TIME);
					NeedOpenMenu = false;
				}
				if (StrEqual(items, "tgcustommaxdisnor"))
				{
					N_ClientItem[client].WaitingForTgCustomMaxDisNor = true;
					PrintToChat(client, "\x05%s \x04请在聊天框输入你想设置最大距离 \x03范围[不能小于1，不要小于最小距离]", NEKOTAG);
					PrintToChat(client, "\x05%s \x04输入 \x03!cancel \x04即可取消这次操作", NEKOTAG);
				}
				if (StrEqual(items, "tgcustommindisnor"))
				{
					N_ClientItem[client].WaitingForTgCustomMinDisNor = true;
					PrintToChat(client, "\x05%s \x04请在聊天框输入你想设置最小距离 \x03范围[不能小于1，不要超过最大距离]", NEKOTAG);
					PrintToChat(client, "\x05%s \x04输入 \x03!cancel \x04即可取消这次操作", NEKOTAG);
				}
				if (StrEqual(items, "tgcustommaxdisreset"))
				{
					SetSpecialSpawnMaxDis_default();
				}
				if (StrEqual(items, "tgcustommindisreset"))
				{
					SetSpecialSpawnMinDis_default();
				}
				if (StrEqual(items, "tgcustommaxdis"))
				{
					SpecialMenuCustomMaxDis(client).Display(client, MENU_TIME);
					NeedOpenMenu = false;
				}
				if (StrEqual(items, "tgcustommindis"))
				{
					SpecialMenuCustomMinDis(client).Display(client, MENU_TIME);
					NeedOpenMenu = false;
				}
				if (StrEqual(items, "tgreload"))
				{
					AutoExecConfig_OnceExec();
					SetMaxSpecialsCount();
				}
				if (StrEqual(items, "tgfast"))
					NCvar[CSpecial_Fast_Response].SetBool(!NCvar[CSpecial_Fast_Response].BoolValue);
				if (StrEqual(items, "tgpcspec"))
					NCvar[CSpecial_PlayerCountSpec].SetBool(!NCvar[CSpecial_PlayerCountSpec].BoolValue);
				if (StrEqual(items, "tgnculdea"))
					NCvar[CSpecial_Num_NotCul_Death].SetBool(!NCvar[CSpecial_Num_NotCul_Death].BoolValue);
				if (StrEqual(items, "tgtanklive"))
					NCvar[CSpecial_Spawn_Tank_Alive].SetBool(!NCvar[CSpecial_Spawn_Tank_Alive].BoolValue);
				if (StrEqual(items, "tgtankprolive"))
					NCvar[CSpecial_Spawn_Tank_Alive_Pro].SetBool(!NCvar[CSpecial_Spawn_Tank_Alive_Pro].BoolValue);
				if (StrEqual(items, "tgautokick"))
					NCvar[CSpecial_AutoKill_StuckSpecials].SetBool(!NCvar[CSpecial_AutoKill_StuckSpecials].BoolValue);
				if (StrEqual(items, "tgtips"))
					NCvar[CSpecial_Show_Tips].SetBool(!NCvar[CSpecial_Show_Tips].BoolValue);
				if (StrEqual(items, "tgtipschat"))
					NCvar[CSpecial_Show_Tips_Chat].SetBool(!NCvar[CSpecial_Show_Tips_Chat].BoolValue);
				if (StrEqual(items, "tgautotime"))
					NCvar[CSpecial_Spawn_Time_DifficultyChange].SetBool(!NCvar[CSpecial_Spawn_Time_DifficultyChange].BoolValue);
				if (StrEqual(items, "ismodenormal"))
				{
					if (NCvar[CSpecial_IsModeInNormal].IntValue == 1)
						NCvar[CSpecial_IsModeInNormal].SetInt(2);
					else
						NCvar[CSpecial_IsModeInNormal].SetInt(1);
					if (NCvar[CSpecial_Show_Tips].BoolValue)
						ModeTips();
				}
				if (StrEqual(items, "tgfilewr"))
					UpdateConfigFile(false);
				if (StrEqual(items, "tgreset"))
					UpdateConfigFile(true);
				if (NeedOpenMenu)
					CreateTimer(0.2, Timer_ReloadMenu, GetClientUserId(client));
			}
		}
		case MenuAction_End:
		{
			delete menu;
			if (IsValidClient(client))
				N_ClientMenu[client].Reset();
		}
	}
	return 0;
}

public Action SpecialMenuMode(int client)
{
	Menu menu = new Menu(SpecialMenuModeHandler);
	char line[1024];

	Format(line, sizeof(line), "+|NS|+ 选择特感模式\n选择一个模式");
	menu.SetTitle(line);

	Format(line, sizeof(line), "默认模式");
	menu.AddItem("7", line);
	Format(line, sizeof(line), "牛子模式");
	menu.AddItem("1", line);
	Format(line, sizeof(line), "胖子模式");
	menu.AddItem("2", line);
	Format(line, sizeof(line), "口水模式");
	menu.AddItem("3", line);
	Format(line, sizeof(line), "舌头模式");
	menu.AddItem("4", line);
	Format(line, sizeof(line), "猴子模式");
	menu.AddItem("5", line);
	Format(line, sizeof(line), "猎人模式");
	menu.AddItem("6", line);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME);
	return Plugin_Handled;
}

public int SpecialMenuModeHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			if (IsValidClient(client))
			{
				N_ClientMenu[client].Reset();
				char items[30];
				menu.GetItem(selection, items, sizeof(items));
				NCvar[CSpecial_Default_Mode].SetInt(StringToInt(items, sizeof(items)));

				if (NCvar[CSpecial_Show_Tips].BoolValue)
					ModeTips();

				if (NCvar[CSpecial_Random_Mode].BoolValue)
				{
					NCvar[CSpecial_Random_Mode].SetBool(false);
					PrintToChat(client, "\x05%s \x04关闭了随机特感", NEKOTAG);
				}
				SpecialMenu(client).DisplayAt(client, N_ClientMenu[client].MenuPageItem, MENU_TIME);
			}
		}
		case MenuAction_Cancel:
		{
			if (IsValidClient(client) && selection == MenuCancel_ExitBack)
			{
				N_ClientMenu[client].Reset();
				SpecialMenu(client).DisplayAt(client, N_ClientMenu[client].MenuPageItem, MENU_TIME);
			}
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
	return 0;
}

public Action SpecialMenuSpawn(int client)
{
	Menu menu = new Menu(SpecialMenuSpawnHandler);
	char line[1024];

	Format(line, sizeof(line), "+|NS|+ 选择刷特模式\n选择一个模式");
	menu.SetTitle(line);

	Format(line, sizeof(line), "引擎刷特");
	menu.AddItem("0", line);
	Format(line, sizeof(line), "普通刷特");
	menu.AddItem("1", line);
	Format(line, sizeof(line), "噩梦刷特");
	menu.AddItem("2", line);
	Format(line, sizeof(line), "地狱刷特");
	menu.AddItem("3", line);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME);
	return Plugin_Handled;
}

public int SpecialMenuSpawnHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			if (IsValidClient(client))
			{
				N_ClientMenu[client].Reset();
				char items[30];
				menu.GetItem(selection, items, sizeof(items));
				int ModeNum = StringToInt(items, sizeof(items));
				NCvar[CSpecial_Spawn_Mode].SetInt(ModeNum);
				SetSpecialSpawnMode(ModeNum);
				PrintToChatAll("\x05%s \x04特感刷新方式更改为 \x03%s刷特模式", NEKOTAG, SpawnModeName[ModeNum]);
				SpecialMenu(client).DisplayAt(client, N_ClientMenu[client].MenuPageItem, MENU_TIME);
			}
		}
		case MenuAction_Cancel:
		{
			if (IsValidClient(client) && selection == MenuCancel_ExitBack)
			{
				N_ClientMenu[client].Reset();
				SpecialMenu(client).DisplayAt(client, N_ClientMenu[client].MenuPageItem, MENU_TIME);
			}
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
	return 0;
}

public Menu SpecialMenuCustomSpawnArea(int client)
{
	N_ClientMenu[client].N_SpecialMenuCustomSpawnArea = new Menu(SpecialMenuCustomSpawnAreaHandler);
	char line[1024];

	Format(line, sizeof(line), "+|NS|+ 更改特感刷新区域\n请选择一项切换\n仅在梦魇和炼狱模式有效");
	N_ClientMenu[client].N_SpecialMenuCustomSpawnArea.SetTitle(line);

	Format(line, sizeof(line), "牛子 目前区域[%s]", GetSpecialSpawnArea(CHARGER) ? "任何" : "官方");
	N_ClientMenu[client].N_SpecialMenuCustomSpawnArea.AddItem("1", line);
	Format(line, sizeof(line), "胖子 目前区域[%s]", GetSpecialSpawnArea(BOOMER) ? "任何" : "官方");
	N_ClientMenu[client].N_SpecialMenuCustomSpawnArea.AddItem("2", line);
	Format(line, sizeof(line), "口水 目前区域[%s]", GetSpecialSpawnArea(SPITTER) ? "任何" : "官方");
	N_ClientMenu[client].N_SpecialMenuCustomSpawnArea.AddItem("3", line);
	Format(line, sizeof(line), "舌头 目前区域[%s]", GetSpecialSpawnArea(SMOKER) ? "任何" : "官方");
	N_ClientMenu[client].N_SpecialMenuCustomSpawnArea.AddItem("4", line);
	Format(line, sizeof(line), "猴子 目前区域[%s]", GetSpecialSpawnArea(JOCKEY) ? "任何" : "官方");
	N_ClientMenu[client].N_SpecialMenuCustomSpawnArea.AddItem("5", line);
	Format(line, sizeof(line), "猎人 目前区域[%s]", GetSpecialSpawnArea(HUNTER) ? "任何" : "官方");
	N_ClientMenu[client].N_SpecialMenuCustomSpawnArea.AddItem("6", line);

	N_ClientMenu[client].N_SpecialMenuCustomSpawnArea.ExitBackButton = true;
	return N_ClientMenu[client].N_SpecialMenuCustomSpawnArea;
}

public int SpecialMenuCustomSpawnAreaHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			if (IsValidClient(client))
			{
				N_ClientMenu[client].Reset();
				char buffer[30];
				menu.GetItem(selection, buffer, sizeof(buffer));
				if (StrEqual(buffer, "1"))
					NCvar[CSpecial_Charger_Spawn_Area].SetBool(!NCvar[CSpecial_Charger_Spawn_Area].BoolValue);
				if (StrEqual(buffer, "2"))
					NCvar[CSpecial_Boomer_Spawn_Area].SetBool(!NCvar[CSpecial_Boomer_Spawn_Area].BoolValue);
				if (StrEqual(buffer, "3"))
					NCvar[CSpecial_Spitter_Spawn_Area].SetBool(!NCvar[CSpecial_Spitter_Spawn_Area].BoolValue);
				if (StrEqual(buffer, "4"))
					NCvar[CSpecial_Smoker_Spawn_Area].SetBool(!NCvar[CSpecial_Smoker_Spawn_Area].BoolValue);
				if (StrEqual(buffer, "5"))
					NCvar[CSpecial_Jockey_Spawn_Area].SetBool(!NCvar[CSpecial_Jockey_Spawn_Area].BoolValue);
				if (StrEqual(buffer, "6"))
					NCvar[CSpecial_Hunter_Spawn_Area].SetBool(!NCvar[CSpecial_Hunter_Spawn_Area].BoolValue);
				SpecialMenuCustomSpawnArea(client).Display(client, MENU_TIME);
			}
		}
		case MenuAction_Cancel:
		{
			if (IsValidClient(client) && selection == MenuCancel_ExitBack)
			{
				N_ClientMenu[client].Reset();
				SpecialMenu(client).DisplayAt(client, N_ClientMenu[client].MenuPageItem, MENU_TIME);
			}
		}
		case MenuAction_End:
		{
			delete menu;
			if (IsValidClient(client))
				N_ClientMenu[client].Reset();
		}
	}
	return 0;
}

public Menu SpecialMenuCustomDirChance(int client)
{
	N_ClientMenu[client].N_SpecialMenuCustomDirChance = new Menu(SpecialMenuCustomDirChanceHandler);
	char line[1024];

	Format(line, sizeof(line), "+|NS|+ 更改特感刷新方位概率\n请选择一项更改\n概率越高越容易刷在前方，概率越低越容易刷在后方");
	N_ClientMenu[client].N_SpecialMenuCustomDirChance.SetTitle(line);

	Format(line, sizeof(line), "牛子 目前概率[%d]", GetSpecialSpawnDirChance(CHARGER));
	N_ClientMenu[client].N_SpecialMenuCustomDirChance.AddItem("1", line);
	Format(line, sizeof(line), "胖子 目前概率[%d]", GetSpecialSpawnDirChance(BOOMER));
	N_ClientMenu[client].N_SpecialMenuCustomDirChance.AddItem("2", line);
	Format(line, sizeof(line), "口水 目前概率[%d]", GetSpecialSpawnDirChance(SPITTER));
	N_ClientMenu[client].N_SpecialMenuCustomDirChance.AddItem("3", line);
	Format(line, sizeof(line), "舌头 目前概率[%d]", GetSpecialSpawnDirChance(SMOKER));
	N_ClientMenu[client].N_SpecialMenuCustomDirChance.AddItem("4", line);
	Format(line, sizeof(line), "猴子 目前概率[%d]", GetSpecialSpawnDirChance(JOCKEY));
	N_ClientMenu[client].N_SpecialMenuCustomDirChance.AddItem("5", line);
	Format(line, sizeof(line), "猎人 目前概率[%d]", GetSpecialSpawnDirChance(HUNTER));
	N_ClientMenu[client].N_SpecialMenuCustomDirChance.AddItem("6", line);

	N_ClientMenu[client].N_SpecialMenuCustomDirChance.ExitBackButton = true;
	return N_ClientMenu[client].N_SpecialMenuCustomDirChance;
}

public int SpecialMenuCustomDirChanceHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			if (IsValidClient(client))
			{
				N_ClientMenu[client].Reset();
				N_ClientItem[client].Reset();
				char buffer[30];
				menu.GetItem(selection, buffer, sizeof(buffer));
				N_ClientItem[client].WaitingForTgCustomDirChanceItem = buffer;
				N_ClientItem[client].WaitingForTgCustomDirChance	 = true;
				N_ClientMenu[client].N_SpecialMenuCustomDirChance	 = null;
				PrintToChat(client, "\x05%s \x04请在聊天框输入你想设置的方位概率 \x03范围[1 - 100]", NEKOTAG);
				PrintToChat(client, "\x05%s \x04输入 \x03!cancel \x04即可取消这次操作", NEKOTAG);
				SpecialMenuCustomDirChance(client).Display(client, MENU_TIME);
			}
		}
		case MenuAction_Cancel:
		{
			if (IsValidClient(client) && selection == MenuCancel_ExitBack)
			{
				N_ClientMenu[client].Reset();
				SpecialMenu(client).DisplayAt(client, N_ClientMenu[client].MenuPageItem, MENU_TIME);
			}
		}
		case MenuAction_End:
		{
			delete menu;
			if (IsValidClient(client))
				N_ClientMenu[client].Reset();
		}
	}
	return 0;
}

public Menu SpecialMenuCustomWeight(int client)
{
	N_ClientMenu[client].N_SpecialMenuCustomWeight = new Menu(SpecialMenuCustomWeightHandler);
	char line[1024];

	Format(line, sizeof(line), "+|NS|+ 更改特感刷新概率\n请选择一项更改\n概率最高的刷新最多");
	N_ClientMenu[client].N_SpecialMenuCustomWeight.SetTitle(line);

	Format(line, sizeof(line), "牛子 目前概率[%d]", GetSpecialSpawnWeight(CHARGER));
	N_ClientMenu[client].N_SpecialMenuCustomWeight.AddItem("1", line);
	Format(line, sizeof(line), "胖子 目前概率[%d]", GetSpecialSpawnWeight(BOOMER));
	N_ClientMenu[client].N_SpecialMenuCustomWeight.AddItem("2", line);
	Format(line, sizeof(line), "口水 目前概率[%d]", GetSpecialSpawnWeight(SPITTER));
	N_ClientMenu[client].N_SpecialMenuCustomWeight.AddItem("3", line);
	Format(line, sizeof(line), "舌头 目前概率[%d]", GetSpecialSpawnWeight(SMOKER));
	N_ClientMenu[client].N_SpecialMenuCustomWeight.AddItem("4", line);
	Format(line, sizeof(line), "猴子 目前概率[%d]", GetSpecialSpawnWeight(JOCKEY));
	N_ClientMenu[client].N_SpecialMenuCustomWeight.AddItem("5", line);
	Format(line, sizeof(line), "猎人 目前概率[%d]", GetSpecialSpawnWeight(HUNTER));
	N_ClientMenu[client].N_SpecialMenuCustomWeight.AddItem("6", line);

	N_ClientMenu[client].N_SpecialMenuCustomWeight.ExitBackButton = true;
	return N_ClientMenu[client].N_SpecialMenuCustomWeight;
}

public int SpecialMenuCustomWeightHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			if (IsValidClient(client))
			{
				N_ClientMenu[client].Reset();
				N_ClientItem[client].Reset();
				char buffer[30];
				menu.GetItem(selection, buffer, sizeof(buffer));
				N_ClientItem[client].WaitingForTgCustomWeightItem = buffer;
				N_ClientItem[client].WaitingForTgCustomWeight	  = true;
				N_ClientMenu[client].N_SpecialMenuCustomWeight	  = null;
				PrintToChat(client, "\x05%s \x04请在聊天框输入你想设置的概率 \x03范围[1 - 100]", NEKOTAG);
				PrintToChat(client, "\x05%s \x04输入 \x03!cancel \x04即可取消这次操作", NEKOTAG);
				SpecialMenuCustomWeight(client).Display(client, MENU_TIME);
			}
		}
		case MenuAction_Cancel:
		{
			if (IsValidClient(client) && selection == MenuCancel_ExitBack)
			{
				N_ClientMenu[client].Reset();
				SpecialMenu(client).DisplayAt(client, N_ClientMenu[client].MenuPageItem, MENU_TIME);
			}
		}
		case MenuAction_End:
		{
			delete menu;
			if (IsValidClient(client))
				N_ClientMenu[client].Reset();
		}
	}
	return 0;
}

public Menu SpecialMenuCustom(int client)
{
	N_ClientMenu[client].N_SpecialMenuCustom = new Menu(SpecialMenuCustomHandler);
	char line[1024];

	Format(line, sizeof(line), "+|NS|+ 更改特感数量\n默认模式生效，选择一项更改");
	N_ClientMenu[client].N_SpecialMenuCustom.SetTitle(line);

	Format(line, sizeof(line), "牛子 目前数量[%d]", GetSpecialSpawnLimit(CHARGER));
	N_ClientMenu[client].N_SpecialMenuCustom.AddItem("1", line);
	Format(line, sizeof(line), "胖子 目前数量[%d]", GetSpecialSpawnLimit(BOOMER));
	N_ClientMenu[client].N_SpecialMenuCustom.AddItem("2", line);
	Format(line, sizeof(line), "口水 目前数量[%d]", GetSpecialSpawnLimit(SPITTER));
	N_ClientMenu[client].N_SpecialMenuCustom.AddItem("3", line);
	Format(line, sizeof(line), "舌头 目前数量[%d]", GetSpecialSpawnLimit(SMOKER));
	N_ClientMenu[client].N_SpecialMenuCustom.AddItem("4", line);
	Format(line, sizeof(line), "猴子 目前数量[%d]", GetSpecialSpawnLimit(JOCKEY));
	N_ClientMenu[client].N_SpecialMenuCustom.AddItem("5", line);
	Format(line, sizeof(line), "猎人 目前数量[%d]", GetSpecialSpawnLimit(HUNTER));
	N_ClientMenu[client].N_SpecialMenuCustom.AddItem("6", line);
	Format(line, sizeof(line), "玩家(包括bot)+特感最多32位置\n请合理分配");
	N_ClientMenu[client].N_SpecialMenuCustom.AddItem("tips", line, ITEMDRAW_DISABLED);

	N_ClientMenu[client].N_SpecialMenuCustom.ExitBackButton = true;
	return N_ClientMenu[client].N_SpecialMenuCustom;
}

public int SpecialMenuCustomHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			if (IsValidClient(client))
			{
				N_ClientMenu[client].Reset();
				N_ClientItem[client].Reset();
				char buffer[30];
				menu.GetItem(selection, buffer, sizeof(buffer));
				N_ClientItem[client].WaitingForTgCustomItem = buffer;
				N_ClientItem[client].WaitingForTgCustom		= true;
				N_ClientMenu[client].N_SpecialMenuCustom	= null;
				PrintToChat(client, "\x05%s \x04请在聊天框输入你想设置的数量 \x03范围[0 - 32]", NEKOTAG);
				PrintToChat(client, "\x05%s \x04输入 \x03!cancel \x04即可取消这次操作", NEKOTAG);
				SpecialMenuCustom(client).Display(client, MENU_TIME);
			}
		}
		case MenuAction_Cancel:
		{
			if (IsValidClient(client) && selection == MenuCancel_ExitBack)
			{
				N_ClientMenu[client].Reset();
				SpecialMenu(client).DisplayAt(client, N_ClientMenu[client].MenuPageItem, MENU_TIME);
			}
		}
		case MenuAction_End:
		{
			delete menu;
			if (IsValidClient(client))
				N_ClientMenu[client].Reset();
		}
	}
	return 0;
}

public Menu SpecialMenuCustomMaxDis(int client)
{
	N_ClientMenu[client].N_SpecialMenuCustomMaxDis = new Menu(SpecialMenuCustomMaxDisHandler);
	char line[1024];

	Format(line, sizeof(line), "+|NS|+ 更改特感刷新距离\n请选择一项更改\n梦魇地狱模式生效");
	N_ClientMenu[client].N_SpecialMenuCustomMaxDis.SetTitle(line);

	Format(line, sizeof(line), "牛子 目前最大距离[%d]", GetSpecialSpawnMaxDis(CHARGER));
	N_ClientMenu[client].N_SpecialMenuCustomMaxDis.AddItem("1", line);
	Format(line, sizeof(line), "胖子 目前最大距离[%d]", GetSpecialSpawnMaxDis(BOOMER));
	N_ClientMenu[client].N_SpecialMenuCustomMaxDis.AddItem("2", line);
	Format(line, sizeof(line), "口水 目前最大距离[%d]", GetSpecialSpawnMaxDis(SPITTER));
	N_ClientMenu[client].N_SpecialMenuCustomMaxDis.AddItem("3", line);
	Format(line, sizeof(line), "舌头 目前最大距离[%d]", GetSpecialSpawnMaxDis(SMOKER));
	N_ClientMenu[client].N_SpecialMenuCustomMaxDis.AddItem("4", line);
	Format(line, sizeof(line), "猴子 目前最大距离[%d]", GetSpecialSpawnMaxDis(JOCKEY));
	N_ClientMenu[client].N_SpecialMenuCustomMaxDis.AddItem("5", line);
	Format(line, sizeof(line), "猎人 目前最大距离[%d]", GetSpecialSpawnMaxDis(HUNTER));
	N_ClientMenu[client].N_SpecialMenuCustomMaxDis.AddItem("6", line);

	N_ClientMenu[client].N_SpecialMenuCustomMaxDis.ExitBackButton = true;
	return N_ClientMenu[client].N_SpecialMenuCustomMaxDis;
}

public int SpecialMenuCustomMaxDisHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			if (IsValidClient(client))
			{
				N_ClientMenu[client].Reset();
				N_ClientItem[client].Reset();
				char buffer[30];
				menu.GetItem(selection, buffer, sizeof(buffer));
				N_ClientItem[client].WaitingForTgCustomMaxDisItem = buffer;
				N_ClientItem[client].WaitingForTgCustomMaxDis	  = true;
				N_ClientMenu[client].N_SpecialMenuCustomMaxDis	  = null;
				PrintToChat(client, "\x05%s \x04请在聊天框输入你想设置的最大距离 \x03范围[不能小于1，不要小于最小距离", NEKOTAG);
				PrintToChat(client, "\x05%s \x04输入 \x03!cancel \x04即可取消这次操作", NEKOTAG);
				SpecialMenuCustomMaxDis(client).Display(client, MENU_TIME);
			}
		}
		case MenuAction_Cancel:
		{
			if (IsValidClient(client) && selection == MenuCancel_ExitBack)
			{
				N_ClientMenu[client].Reset();
				SpecialMenu(client).DisplayAt(client, N_ClientMenu[client].MenuPageItem, MENU_TIME);
			}
		}
		case MenuAction_End:
		{
			delete menu;
			if (IsValidClient(client))
				N_ClientMenu[client].Reset();
		}
	}
	return 0;
}

public Menu SpecialMenuCustomMinDis(int client)
{
	N_ClientMenu[client].N_SpecialMenuCustomMinDis = new Menu(SpecialMenuCustomMinDisHandler);
	char line[1024];

	Format(line, sizeof(line), "+|NS|+ 更改特感刷新距离\n请选择一项更改\n梦魇地狱模式生效");
	N_ClientMenu[client].N_SpecialMenuCustomMinDis.SetTitle(line);

	Format(line, sizeof(line), "牛子 目前最小距离[%d]", GetSpecialSpawnMinDis(CHARGER));
	N_ClientMenu[client].N_SpecialMenuCustomMinDis.AddItem("1", line);
	Format(line, sizeof(line), "胖子 目前最小距离[%d]", GetSpecialSpawnMinDis(BOOMER));
	N_ClientMenu[client].N_SpecialMenuCustomMinDis.AddItem("2", line);
	Format(line, sizeof(line), "口水 目前最小距离[%d]", GetSpecialSpawnMinDis(SPITTER));
	N_ClientMenu[client].N_SpecialMenuCustomMinDis.AddItem("3", line);
	Format(line, sizeof(line), "舌头 目前最小距离[%d]", GetSpecialSpawnMinDis(SMOKER));
	N_ClientMenu[client].N_SpecialMenuCustomMinDis.AddItem("4", line);
	Format(line, sizeof(line), "猴子 目前最小距离[%d]", GetSpecialSpawnMinDis(JOCKEY));
	N_ClientMenu[client].N_SpecialMenuCustomMinDis.AddItem("5", line);
	Format(line, sizeof(line), "猎人 目前最小距离[%d]", GetSpecialSpawnMinDis(HUNTER));
	N_ClientMenu[client].N_SpecialMenuCustomMinDis.AddItem("6", line);

	N_ClientMenu[client].N_SpecialMenuCustomMinDis.ExitBackButton = true;
	return N_ClientMenu[client].N_SpecialMenuCustomMinDis;
}

public int SpecialMenuCustomMinDisHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			if (IsValidClient(client))
			{
				N_ClientMenu[client].Reset();
				N_ClientItem[client].Reset();
				char buffer[30];
				menu.GetItem(selection, buffer, sizeof(buffer));
				N_ClientItem[client].WaitingForTgCustomMinDisItem = buffer;
				N_ClientItem[client].WaitingForTgCustomMinDis	  = true;
				N_ClientMenu[client].N_SpecialMenuCustomMinDis	  = null;
				PrintToChat(client, "\x05%s \x04请在聊天框输入你想设置的最小距离 \x03范围[不能小于1，不要超过最大距离]", NEKOTAG);
				PrintToChat(client, "\x05%s \x04输入 \x03!cancel \x04即可取消这次操作", NEKOTAG);
				SpecialMenuCustomMinDis(client).Display(client, MENU_TIME);
			}
		}
		case MenuAction_Cancel:
		{
			if (IsValidClient(client) && selection == MenuCancel_ExitBack)
			{
				N_ClientMenu[client].Reset();
				SpecialMenu(client).DisplayAt(client, N_ClientMenu[client].MenuPageItem, MENU_TIME);
			}
		}
		case MenuAction_End:
		{
			delete menu;
			if (IsValidClient(client))
				N_ClientMenu[client].Reset();
		}
	}
	return 0;
}