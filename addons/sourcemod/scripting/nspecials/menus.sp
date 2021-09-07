public Menu SpecialMenu(int client)
{
	N_MenuSpecialMenu[client] = new Menu(SpecialMenuHandler);
	char line[1024];
	
	if(Special_PluginStatus)
	{
		Format(line, sizeof(line), "|NS| 特感菜单\n特感数量[%d] 刷特时间[%d]", tgnum, tgtime);
		N_MenuSpecialMenu[client].SetTitle(line);
	}
	else
	{
		Format(line, sizeof(line), "|NS| 特感菜单\n插件已关闭");
		N_MenuSpecialMenu[client].SetTitle(line);
	}
	
	if(!Special_PluginStatus)
	{
		Format(line, sizeof(line), "插件状态 [关]");
		N_MenuSpecialMenu[client].AddItem("tgstat", line);
	}
	else
	{
		Format(line, sizeof(line), "插件状态 [开]");
		N_MenuSpecialMenu[client].AddItem("tgstat", line);

		if(Special_Random_Mode)
			Format(line, sizeof(line), "随机特感 [开]");
		else
			Format(line, sizeof(line), "随机特感 [关]");
		N_MenuSpecialMenu[client].AddItem("tgrandom", line);
		
		char nowmode[64], spawnmode[64];
		
		switch(Special_Default_Mode)
		{
			case 1: Format(nowmode, sizeof(nowmode), "猎人");
			case 2: Format(nowmode, sizeof(nowmode), "牛");
			case 3: Format(nowmode, sizeof(nowmode), "猴子");
			case 4: Format(nowmode, sizeof(nowmode), "口水");
			case 5: Format(nowmode, sizeof(nowmode), "胖子");
			case 6: Format(nowmode, sizeof(nowmode), "舌头");
			default: Format(nowmode, sizeof(nowmode), "默认");
		}
		Format(line, sizeof(line), "现在模式 [%s]", nowmode);
		N_MenuSpecialMenu[client].AddItem("tgmode", line);
		
		switch(Special_Spawn_Mode)
		{
			case 0: Format(spawnmode, sizeof(spawnmode), "引擎");
			case 1: Format(spawnmode, sizeof(spawnmode), "普通");
			case 2: Format(spawnmode, sizeof(spawnmode), "噩梦");
			case 3: Format(spawnmode, sizeof(spawnmode), "地狱");
		}
		Format(line, sizeof(line), "刷特模式 [%s]", spawnmode);
		N_MenuSpecialMenu[client].AddItem("tgspawn", line);
		
		Format(line, sizeof(line), "全局刷特时间 [%ds]", Special_Spawn_Time);
		if(!Special_Spawn_Time_DifficultyChange)
		{
			N_MenuSpecialMenu[client].AddItem("tgtime", line);
		}
		else
		{
			N_MenuSpecialMenu[client].AddItem("tgtime", line, ITEMDRAW_DISABLED);
		}
	
		Format(line, sizeof(line), "初始刷特数量 [%d]", Special_Num);
		N_MenuSpecialMenu[client].AddItem("tgnum", line);
	
		Format(line, sizeof(line), "进人增加数量 [%d]", Special_AddNum);
		N_MenuSpecialMenu[client].AddItem("tgadd", line);
		
		Format(line, sizeof(line), "初始玩家数量 [%d]", Special_PlayerNum);
		N_MenuSpecialMenu[client].AddItem("tgpnum", line);
	
		Format(line, sizeof(line), "玩家增加数量 [%d]", Special_PlayerAdd);
		N_MenuSpecialMenu[client].AddItem("tgpadd", line);
		
		if(Special_PlayerCountSpec)
			Format(line, sizeof(line), "是否算入观察 [是]");
		else
			Format(line, sizeof(line), "是否算入观察 [否]");
		N_MenuSpecialMenu[client].AddItem("tgpcspec", line);
		
		if(Special_Spawn_Tank_Alive)
			Format(line, sizeof(line), "克活着时刷新 [是]");
		else
			Format(line, sizeof(line), "克活着时刷新 [否]");
		N_MenuSpecialMenu[client].AddItem("tgtanklive", line);
		/*
		if(Special_Spawn_Mode == 1)
		{
			char ismode[64];
			switch(Special_IsModeInNormal)
			{
				case 1: Format(ismode, sizeof(ismode), "1");
				case 2: Format(ismode, sizeof(ismode), "2");
			}
			Format(line, sizeof(line), "普通刷特子模式 [%s]", ismode);
			N_MenuSpecialMenu[client].AddItem("ismodenormal", line);
		}
		*/
		if(Special_Spawn_Time_DifficultyChange)
		{
			Format(line, sizeof(line), "根据难度改变刷特时间 [是]");
			N_MenuSpecialMenu[client].AddItem("tgautotime", line);
			
			Format(line, sizeof(line), "简单难度刷特时间 [%d]", Special_Spawn_Time_Easy);
			N_MenuSpecialMenu[client].AddItem("tgtimeeasy", line);
			
			Format(line, sizeof(line), "普通难度刷特时间 [%d]", Special_Spawn_Time_Normal);
			N_MenuSpecialMenu[client].AddItem("tgtimenormal", line);
			
			Format(line, sizeof(line), "高级难度刷特时间 [%d]", Special_Spawn_Time_Hard);
			N_MenuSpecialMenu[client].AddItem("tgtimehard", line);
			
			Format(line, sizeof(line), "专家难度刷特时间 [%d]", Special_Spawn_Time_Impossible);
			N_MenuSpecialMenu[client].AddItem("tgtimeexpert", line);
		}
		else
		{
			Format(line, sizeof(line), "根据难度改变刷特时间 [否]");
			N_MenuSpecialMenu[client].AddItem("tgautotime", line);
		}
			
		if(Special_Show_Tips)
			Format(line, sizeof(line), "显示插件提示 [是]");
		else
			Format(line, sizeof(line), "显示插件提示 [否]");
		N_MenuSpecialMenu[client].AddItem("tgtips", line);
		
		Format(line, sizeof(line), "自定义特感 [默认模式]");
		N_MenuSpecialMenu[client].AddItem("tgcustom", line);
	}
	
	Format(line, sizeof(line), "重载配置文件");
	N_MenuSpecialMenu[client].AddItem("tgreload", line);
	
	Format(line, sizeof(line), "具体如何设置请查看CFG或者插件的说明");
	N_MenuSpecialMenu[client].AddItem("info", line, ITEMDRAW_DISABLED);
	
	N_MenuSpecialMenu[client].ExitBackButton = true;
	return N_MenuSpecialMenu[client];
}

public int SpecialMenuHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			if(IsValidClient(client))
			{
				char items[30];
				N_MenuSpecialMenu[client] = null;
				
				cleanplayerwait(client);
				menu.GetItem(selection, items, sizeof(items));
				
				bool NeedOpenMenu = true;
				
				if(StrEqual(items, "tgstat"))
				{
					SwitchPlugin(client);
				}
				if(StrEqual(items, "tgrandom"))
				{
					SwitchRandom(client);
				}
				if(StrEqual(items, "tgmode"))
				{
					SpecialMenuMode(client);
					NeedOpenMenu = false;
				}
				if(StrEqual(items, "tgspawn"))
				{
					SpecialMenuSpawn(client);
					NeedOpenMenu = false;
				}
				if(StrContains(items, "tgtime", false) != -1)
				{
					WaitingForTgtime[client] = true;
					WaitingForTgTimeType[client] = items;
					PrintToChat(client, "\x05%s \x04请在聊天框输入你想设置的时间 \x03范围[3 - 120]", NEKOTAG);
					PrintToChat(client, "\x05%s \x04输入 \x03!cancel \x04即可取消这次操作", NEKOTAG);
				}
				if(StrEqual(items, "tgnum"))
				{
					WaitingForTgnum[client] = true;
					PrintToChat(client, "\x05%s \x04请在聊天框输入你想设置的初始特感数量 \x03范围[1 - 32]", NEKOTAG);
					PrintToChat(client, "\x05%s \x04输入 \x03!cancel \x04即可取消这次操作", NEKOTAG);
				}
				if(StrEqual(items, "tgadd"))
				{
					WaitingForTgadd[client] = true;
					PrintToChat(client, "\x05%s \x04请在聊天框输入你想设置的增加数量 \x03范围[0 - 8]", NEKOTAG);
					PrintToChat(client, "\x05%s \x04输入 \x03!cancel \x04即可取消这次操作", NEKOTAG);
				}
				if(StrEqual(items, "tgpnum"))
				{
					WaitingForPnum[client] = true;
					PrintToChat(client, "\x05%s \x04请在聊天框输入你想设置的初始玩家数量 \x03范围[1 - 32]", NEKOTAG);
					PrintToChat(client, "\x05%s \x04输入 \x03!cancel \x04即可取消这次操作", NEKOTAG);
				}
				if(StrEqual(items, "tgpadd"))
				{
					WaitingForPadd[client] = true;
					PrintToChat(client, "\x05%s \x04请在聊天框输入你想设置的玩家增加数量 \x03范围[0 - 8]", NEKOTAG);
					PrintToChat(client, "\x05%s \x04输入 \x03!cancel \x04即可取消这次操作", NEKOTAG);
				}
				if(StrEqual(items, "tgcustom"))
				{
					SpecialMenuCustom(client).Display(client, MENU_TIME);
					NeedOpenMenu = false;
				}
				if(StrEqual(items, "tgreload"))
				{
					AutoExecConfig_OnceExec();
					SetMaxSpecialsCount();
				}
				if(StrEqual(items, "tgpcspec"))
				{
					if(CSpecial_PlayerCountSpec.BoolValue)
						CSpecial_PlayerCountSpec.SetBool(false);
					else
						CSpecial_PlayerCountSpec.SetBool(true);
					SetMaxSpecialsCount();
				}
				if(StrEqual(items, "tgtanklive"))
				{
					if(CSpecial_Spawn_Tank_Alive.BoolValue)
						CSpecial_Spawn_Tank_Alive.SetBool(false);
					else
						CSpecial_Spawn_Tank_Alive.SetBool(true);
				}
				if(StrEqual(items, "tgtips"))
				{
					if(CSpecial_Show_Tips.BoolValue)
						CSpecial_Show_Tips.SetBool(false);
					else
						CSpecial_Show_Tips.SetBool(true);
				}
				if(StrEqual(items, "tgautotime"))
				{
					if(CSpecial_Spawn_Time_DifficultyChange.BoolValue)
						CSpecial_Spawn_Time_DifficultyChange.SetBool(false);
					else
						CSpecial_Spawn_Time_DifficultyChange.SetBool(true);
					CheckDifficulty();
				}
				/*
				if(StrEqual(items, "ismodenormal"))
				{
					if(Special_IsModeInNormal == 1)
						CSpecial_IsModeInNormal.SetInt(2);
					else
						CSpecial_IsModeInNormal.SetInt(1);
					TgModeStartSet();
					if(Special_Show_Tips)
						ModeTips();
				}
				*/
				if(NeedOpenMenu)
					SpecialMenu(client).Display(client, MENU_TIME);
			}
		}
		case MenuAction_End:
		{
			delete menu;
			if(IsValidClient(client))
				N_MenuSpecialMenu[client] = null;
		}
	}
}

public Action SpecialMenuMode(int client)
{
	Menu menu = new Menu(SpecialMenuModeHandler);
	char line[1024];
	
	Format(line, sizeof(line), "|NS| 选择特感模式\n选择一个模式");
	menu.SetTitle(line);
	
	Format(line, sizeof(line), "猎人模式");
	menu.AddItem("1", line);
	Format(line, sizeof(line), "牛模式");
	menu.AddItem("2", line);
	Format(line, sizeof(line), "猴子模式");
	menu.AddItem("3", line);
	Format(line, sizeof(line), "口水模式");
	menu.AddItem("4", line);
	Format(line, sizeof(line), "胖子模式");
	menu.AddItem("5", line);
	Format(line, sizeof(line), "舌头模式");
	menu.AddItem("6", line);
	Format(line, sizeof(line), "默认模式");
	menu.AddItem("7", line);
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME);
	return Plugin_Handled;
}

public int SpecialMenuModeHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			if(IsValidClient(client))
			{
				char items[30];
				menu.GetItem(selection, items, sizeof(items));
				int ModeNum = StringToInt(items, sizeof(items));
				CSpecial_Default_Mode.SetInt(ModeNum);
				TgModeStartSet();
				if(Special_Show_Tips)
					ModeTips();
				if(Special_Random_Mode)
				{
					CSpecial_Random_Mode.SetInt(0);
					PrintToChat(client, "\x05%s \x04关闭了随机特感", NEKOTAG);
				}
				SpecialMenu(client).Display(client, MENU_TIME);
			}
		}
		case MenuAction_Cancel:
		{
			if(IsValidClient(client) && selection == MenuCancel_ExitBack)
				SpecialMenu(client).Display(client, MENU_TIME);
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
}

public Action SpecialMenuSpawn(int client)
{
	Menu menu = new Menu(SpecialMenuSpawnHandler);
	char line[1024];
	
	Format(line, sizeof(line), "|NS| 选择刷特模式\n选择一个模式");
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
	switch(action)
	{
		case MenuAction_Select:
		{
			if(IsValidClient(client))
			{
				char items[30], mat[30];
				menu.GetItem(selection, items, sizeof(items));
				int ModeNum = StringToInt(items, sizeof(items));
				CSpecial_Spawn_Mode.SetInt(ModeNum);
				SetIsModeSpawnSpecial(ModeNum);
				switch(ModeNum)
				{
					case 0:Format(mat, sizeof(mat), "引擎");
					case 1:Format(mat, sizeof(mat), "普通");
					case 2:Format(mat, sizeof(mat), "噩梦");
					case 3:Format(mat, sizeof(mat), "地狱");
				}
				PrintToChatAll("\x05%s \x04特感刷新方式更改为 \x03%s刷特模式", NEKOTAG, mat);
				SpecialMenu(client).Display(client, MENU_TIME);
			}
		}
		case MenuAction_Cancel:
		{
			if(IsValidClient(client) && selection == MenuCancel_ExitBack)
				SpecialMenu(client).Display(client, MENU_TIME);
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
}

public Menu SpecialMenuCustom(int client)
{
	N_SpecialMenuCustom[client] = new Menu(SpecialMenuCustomHandler);
	char line[1024];
	
	Format(line, sizeof(line), "|NS| 更改特感数量\n默认模式生效，选择一项更改");
	N_SpecialMenuCustom[client].SetTitle(line);
	
	Format(line, sizeof(line), "牛子 目前数量[%d]", Special_Charger_Num);
	N_SpecialMenuCustom[client].AddItem("charger", line);
	Format(line, sizeof(line), "胖子 目前数量[%d]", Special_Boomer_Num);
	N_SpecialMenuCustom[client].AddItem("boomer", line);
	Format(line, sizeof(line), "口水 目前数量[%d]", Special_Spitter_Num);
	N_SpecialMenuCustom[client].AddItem("spitter", line);
	Format(line, sizeof(line), "舌头 目前数量[%d]", Special_Smoker_Num);
	N_SpecialMenuCustom[client].AddItem("smoker", line);
	Format(line, sizeof(line), "猴子 目前数量[%d]", Special_Jockey_Num);
	N_SpecialMenuCustom[client].AddItem("jockey", line);
	Format(line, sizeof(line), "猎人 目前数量[%d]", Special_Hunter_Num);
	N_SpecialMenuCustom[client].AddItem("hunter", line);
	Format(line, sizeof(line), "玩家(包括bot)+特感最多32位置\n请合理分配");
	N_SpecialMenuCustom[client].AddItem("tips", line, ITEMDRAW_DISABLED);
	
	N_SpecialMenuCustom[client].ExitBackButton = true;
	return N_SpecialMenuCustom[client];
}

public int SpecialMenuCustomHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			if(IsValidClient(client))
			{
				cleanplayerwait(client);
				char buffer[30];
				menu.GetItem(selection, buffer, sizeof(buffer));
				WaitingForTgCustomItem[client] = buffer;
				WaitingForTgCustom[client] = true;
				N_SpecialMenuCustom[client] = null;
				PrintToChat(client, "\x05%s \x04请在聊天框输入你想设置的数量 \x03范围[0 - 32]", NEKOTAG);
				PrintToChat(client, "\x05%s \x04输入 \x03!cancel \x04即可取消这次操作", NEKOTAG);
				SpecialMenuCustom(client).Display(client, MENU_TIME);
			}
		}
		case MenuAction_Cancel:
		{
			if(IsValidClient(client) && selection == MenuCancel_ExitBack)
				SpecialMenu(client).Display(client, MENU_TIME);
		}
		case MenuAction_End:
		{
			delete menu;
			if(IsValidClient(client))
				N_SpecialMenuCustom[client] = null;
		}
	}
}

