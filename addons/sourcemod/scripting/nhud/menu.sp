

public Action OpenHUDMenu(int client, int args)
{
	HudMenu(client).Display(client, MENU_TIME);
	return Plugin_Continue;
}

public Action ReloadHUDConfig(int client, int args)
{
	AutoExecConfig_OnceExec();
	return Plugin_Continue;
}

public Action ReSetHUDConfig(int client, int args)
{
	UpdateConfigFile(true);
	return Plugin_Continue;
}

public Action UpdateHUDConfig(int client, int args)
{
	UpdateConfigFile(false);
	return Plugin_Continue;
}

public Menu HudMenu(int client)
{
	N_MenuHudMenu[client] = new Menu(HudMenuHandler);
	char line[1024];

	Format(line, sizeof(line), "+|NS|+  HUD菜单\n选择一项更改");
	N_MenuHudMenu[client].SetTitle(line);

	Format(line, sizeof(line), "插件状态 [%s]", HudStyleName[NCvar[CKillHud_HudStyle].IntValue]);
	N_MenuHudMenu[client].AddItem("hudstyle", line);

	if (NCvar[CKillHud_FriendlyFire].BoolValue)
		Format(line, sizeof(line), "友伤统计 [开]");
	else
		Format(line, sizeof(line), "友伤统计 [关]");
	N_MenuHudMenu[client].AddItem("hudfriend", line);

	if (NCvar[CKillHud_AllowBot].BoolValue)
		Format(line, sizeof(line), "统计人机 [开]");
	else
		Format(line, sizeof(line), "统计人机 [关]");
	N_MenuHudMenu[client].AddItem("hudallowbot", line);

	if (NCvar[CKillHud_KillSpecials].BoolValue)
		Format(line, sizeof(line), "击杀统计 [开]");
	else
		Format(line, sizeof(line), "击杀统计 [关]");
	N_MenuHudMenu[client].AddItem("hudsp", line);

	if (NCvar[CKillHud_HudStyle].IntValue == 1 || NCvar[CKillHud_HudStyle].IntValue == 2 || NCvar[CKillHud_HudStyle].IntValue == 3)
	{
		if (NCvar[CKillHud_ShowMorePlayer].BoolValue)
			Format(line, sizeof(line), "显示更多玩家 [开]");
		else
			Format(line, sizeof(line), "显示更多玩家 [关]");
		N_MenuHudMenu[client].AddItem("hudmoreplayer", line);
	}

	if (NCvar[CKillHud_ShowTankWitch].BoolValue)
		Format(line, sizeof(line), "显示坦克女巫 [开]");
	else
		Format(line, sizeof(line), "显示坦克女巫 [关]");
	N_MenuHudMenu[client].AddItem("hudmorekill", line);

	if (NCvar[CKillHud_KillTank].BoolValue)
		Format(line, sizeof(line), "坦克伤害统计 [开]");
	else
		Format(line, sizeof(line), "坦克伤害统计 [关]");
	N_MenuHudMenu[client].AddItem("hudtank", line);

	if (NCvar[CKillHud_AllKill].BoolValue)
		Format(line, sizeof(line), "其他统计显示 [开]");
	else
		Format(line, sizeof(line), "其他统计显示 [关]");
	N_MenuHudMenu[client].AddItem("hudother", line);

	if (!NCvar[CKillHud_AllKillStyle2].BoolValue)
		Format(line, sizeof(line), "击杀总数显示 [章节]");
	else
		Format(line, sizeof(line), "击杀总数显示 [更多]");
	N_MenuHudMenu[client].AddItem("hudotherstyle", line);

	if (!NCvar[CKillHud_Show].BoolValue)
		Format(line, sizeof(line), "显示HUD [开局]");
	else
		Format(line, sizeof(line), "显示HUD [出安全区]");
	N_MenuHudMenu[client].AddItem("hudshow", line);

	Format(line, sizeof(line), "重载配置文件");
	N_MenuHudMenu[client].AddItem("hudreload", line);

	Format(line, sizeof(line), "写入配置文件");
	N_MenuHudMenu[client].AddItem("hudwr", line);

	Format(line, sizeof(line), "重置配置文件");
	N_MenuHudMenu[client].AddItem("hudreset", line);

	Format(line, sizeof(line), "具体如何设置请查看CFG\n或插件说明\n插件版本:%s", PLUGIN_VERSION);
	N_MenuHudMenu[client].AddItem("info", line, ITEMDRAW_DISABLED);

	N_MenuHudMenu[client].ExitBackButton = true;
	return N_MenuHudMenu[client];
}

public int HudMenuHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			if (IsValidClient(client))
			{
				char items[50];
				menu.GetItem(selection, items, sizeof(items));
				if (StrEqual(items, "hudstyle"))
					SwitchHud(1, client);
				if (StrEqual(items, "hudfriend"))
					SwitchHud(2, client);
				if (StrEqual(items, "hudsp"))
					SwitchHud(3, client);
				if (StrEqual(items, "hudtank"))
					SwitchHud(4, client);
				if (StrEqual(items, "hudother"))
					SwitchHud(5, client);
				if (StrEqual(items, "hudshow"))
					SwitchHud(6, client);
				if (StrEqual(items, "hudallowbot"))
					SwitchHud(7, client);
				if (StrEqual(items, "hudreload"))
					SwitchHud(8, client);
				if (StrEqual(items, "hudwr"))
					SwitchHud(9, client);
				if (StrEqual(items, "hudreset"))
					SwitchHud(10, client);
				if (StrEqual(items, "hudotherstyle"))
					SwitchHud(11, client);
				if (StrEqual(items, "hudmoreplayer"))
					SwitchHud(12, client);
				if (StrEqual(items, "hudmorekill"))
					SwitchHud(13, client);
				N_MenuHudMenu[client] = null;
			}
		}
		case MenuAction_End:
		{
			delete menu;
			if (IsValidClient(client))
				N_MenuHudMenu[client] = null;
		}
	}
	return 0;
}

void SwitchHud(int type, int client)
{
	switch (type)
	{
		case 1:
		{
			switch (NCvar[CKillHud_HudStyle].IntValue)
			{
				case 1: NCvar[CKillHud_HudStyle].SetInt(2);
				case 2: NCvar[CKillHud_HudStyle].SetInt(3);
				case 3: NCvar[CKillHud_HudStyle].SetInt(4);
				case 4: NCvar[CKillHud_HudStyle].SetInt(0);
				case 0: NCvar[CKillHud_HudStyle].SetInt(1);
			}
		}
		case 2:
		{
			NCvar[CKillHud_FriendlyFire].SetBool(!NCvar[CKillHud_FriendlyFire].BoolValue);
		}
		case 3:
		{
			NCvar[CKillHud_KillSpecials].SetBool(!NCvar[CKillHud_KillSpecials].BoolValue);
		}
		case 4:
		{
			NCvar[CKillHud_KillTank].SetBool(!NCvar[CKillHud_KillTank].BoolValue);
		}
		case 5:
		{
			NCvar[CKillHud_AllKill].SetBool(!NCvar[CKillHud_AllKill].BoolValue);
		}
		case 6:
		{
			NCvar[CKillHud_Show].SetBool(!NCvar[CKillHud_Show].BoolValue);
			if (!NCvar[CKillHud_Show].BoolValue)
				CreateHud();
		}
		case 7:
		{
			NCvar[CKillHud_AllowBot].SetBool(!NCvar[CKillHud_AllowBot].BoolValue);
		}
		case 8: AutoExecConfig_OnceExec();
		case 9: UpdateConfigFile(false);
		case 10: UpdateConfigFile(true);
		case 11:
		{
			NCvar[CKillHud_AllKillStyle2].SetBool(!NCvar[CKillHud_AllKillStyle2].BoolValue);
		}
		case 12:
		{
			NCvar[CKillHud_ShowMorePlayer].SetBool(!NCvar[CKillHud_ShowMorePlayer].BoolValue);
		}
		case 13:
		{
			NCvar[CKillHud_ShowTankWitch].SetBool(!NCvar[CKillHud_ShowTankWitch].BoolValue);
		}
	}

	if (HUDSlotIsUsed(HUD_FAR_LEFT))
		RemoveHUD(HUD_FAR_LEFT);
	if (HUDSlotIsUsed(HUD_FAR_RIGHT))
		RemoveHUD(HUD_FAR_RIGHT);
	if (HUDSlotIsUsed(HUD_SCORE_1))
		RemoveHUD(HUD_SCORE_1);
	if (HUDSlotIsUsed(HUD_LEFT_TOP))
		RemoveHUD(HUD_LEFT_TOP);
	if (HUDSlotIsUsed(HUD_RIGHT_TOP))
		RemoveHUD(HUD_RIGHT_TOP);
	if (HUDSlotIsUsed(HUD_MID_BOX))
		RemoveHUD(HUD_MID_BOX);


	CreateTimer(0.2, Timer_ReloadMenu, GetClientUserId(client));
}

public Action Timer_ReloadMenu(Handle timer, any client)
{
	client = GetClientOfUserId(client);
	if (IsValidClient(client))
		HudMenu(client).Display(client, MENU_TIME);
	return Plugin_Stop;
}