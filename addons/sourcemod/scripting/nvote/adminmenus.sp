public Menu NekoVoteAdminMenu(int client)
{
	if (!IsValidClient(client))
		return null;

	N_MenuAdminMenu[client] = new Menu(AdminMenuHandler);

	char line[2048];

	Format(line, sizeof(line), "+|NS|+ 投票管理菜单\n控制玩家的权限\n选择一项切换");
	N_MenuAdminMenu[client].SetTitle(line);

	Format(line, sizeof(line), "投票插件状态 [%s]", !NCvar[Neko_CanSwitch].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swplu", line);

	Format(line, sizeof(line), "投票多特开关 [%s]", !NCvar[Neko_SwitchStatus].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swstat", line);

	Format(line, sizeof(line), "投票特感数量 [%s]", !NCvar[Neko_SwitchNumber].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swnum", line);

	Format(line, sizeof(line), "投票刷新时间 [%s]", !NCvar[Neko_SwitchTime].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swtime", line);

	Format(line, sizeof(line), "投票随机特感 [%s]", !NCvar[Neko_SwitchRandom].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swrandom", line);

	Format(line, sizeof(line), "投票游戏模式 [%s]", !NCvar[Neko_SwitchGameMode].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swgm", line);

	Format(line, sizeof(line), "投票刷新模式 [%s]", !NCvar[Neko_SwitchSpawnMode].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swsm", line);

	Format(line, sizeof(line), "投票玩家进出增加数量 [%s]", !NCvar[Neko_SwitchPlayerJoin].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swpj", line);

	Format(line, sizeof(line), "投票坦克存活刷特状态 [%s]", !NCvar[Neko_SwitchTankAlive].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swtank", line);

	Format(line, sizeof(line), "无人自动重置特感配置 [%s]", !NCvar[Neko_NeedResetNoPlayer].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swtreload", line);

	Format(line, sizeof(line), "重载配置文件");
	N_MenuAdminMenu[client].AddItem("swreload", line);

	Format(line, sizeof(line), "写入配置文件");
	N_MenuAdminMenu[client].AddItem("swfilewr", line);

	Format(line, sizeof(line), "重置配置文件");
	N_MenuAdminMenu[client].AddItem("swreset", line);

	Format(line, sizeof(line), "具体如何设置请查看CFG\n或插件说明\n插件版本:%s", PLUGIN_VERSION);
	N_MenuAdminMenu[client].AddItem("info", line, ITEMDRAW_DISABLED);

	N_MenuAdminMenu[client].ExitBackButton = true;

	return N_MenuAdminMenu[client];
}

public int AdminMenuHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			if (IsValidClient(client))
			{
				char items[50];
				AdminMenuPageItem[client] = GetMenuSelectionPosition();
				N_MenuAdminMenu[client]	  = null;
				menu.GetItem(selection, items, sizeof(items));
				if (StrEqual(items, "swplu"))
					NCvar[Neko_CanSwitch].SetBool(!NCvar[Neko_CanSwitch].BoolValue);
				if (StrEqual(items, "swstat"))
					NCvar[Neko_SwitchStatus].SetBool(!NCvar[Neko_SwitchStatus].BoolValue);
				if (StrEqual(items, "swnum"))
					NCvar[Neko_SwitchNumber].SetBool(!NCvar[Neko_SwitchNumber].BoolValue);
				if (StrEqual(items, "swtime"))
					NCvar[Neko_SwitchTime].SetBool(!NCvar[Neko_SwitchTime].BoolValue);
				if (StrEqual(items, "swrandom"))
					NCvar[Neko_SwitchRandom].SetBool(!NCvar[Neko_SwitchRandom].BoolValue);
				if (StrEqual(items, "swgm"))
					NCvar[Neko_SwitchGameMode].SetBool(!NCvar[Neko_SwitchGameMode].BoolValue);
				if (StrEqual(items, "swsm"))
					NCvar[Neko_SwitchSpawnMode].SetBool(!NCvar[Neko_SwitchSpawnMode].BoolValue);
				if (StrEqual(items, "swpj"))
					NCvar[Neko_SwitchPlayerJoin].SetBool(!NCvar[Neko_SwitchPlayerJoin].BoolValue);
				if (StrEqual(items, "swtank"))
					NCvar[Neko_SwitchTankAlive].SetBool(!NCvar[Neko_SwitchTankAlive].BoolValue);
				if (StrEqual(items, "swreload"))
					AutoExecConfig_OnceExec();
				if (StrEqual(items, "swfilewr"))
					UpdateConfigFile(false);
				if (StrEqual(items, "swreset"))
					UpdateConfigFile(true);
				if (StrEqual(items, "swtreload"))
					NCvar[Neko_NeedResetNoPlayer].SetBool(!NCvar[Neko_NeedResetNoPlayer].BoolValue);

				for (int i = 1; i <= MaxClients; i++)
					N_MenuVoteMenu[i] = null;

				CreateTimer(0.1, Timer_ReloadAdminMenu, GetClientUserId(client));
			}
		}
		case MenuAction_End:
		{
			delete menu;
			if (IsValidClient(client))
				N_MenuAdminMenu[client] = null;
		}
	}
	return 0;
}