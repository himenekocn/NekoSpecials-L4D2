public Action OpenHUDMenu(int client, int args)
{
	HudMenu(client).Display(client, MENU_TIME);
}

public Action ReloadHUDConfig(int client, int args)
{
	AutoExecConfig_OnceExec();
}

public Menu HudMenu(int client)
{
	N_MenuHudMenu[client] = new Menu(HudMenuHandler);
	char line[1024], status[64];
	
	Format(line, sizeof(line), "|NS| HUD菜单\n选择一项更改");
	N_MenuHudMenu[client].SetTitle(line);
	
	switch(KillHud_HudStyle)
	{
		case 1:Format(status, sizeof(status), "样式1");
		case 2:Format(status, sizeof(status), "样式2");
		case 3:Format(status, sizeof(status), "自定义");
		case 4:Format(status, sizeof(status), "聊天栏");
		default :Format(status, sizeof(status), "关");
	}
	Format(line, sizeof(line), "插件状态 [%s]", status);
	N_MenuHudMenu[client].AddItem("hudstyle", line);
	
	if(KillHud_FriendlyFire)
		Format(line, sizeof(line), "友伤统计 [开]");
	else
		Format(line, sizeof(line), "友伤统计 [关]");
	N_MenuHudMenu[client].AddItem("hudfriend", line);
	
	if(KillHud_AllowBot)
		Format(line, sizeof(line), "统计人机 [开]");
	else
		Format(line, sizeof(line), "统计人机 [关]");
	N_MenuHudMenu[client].AddItem("hudallowbot", line);
	
	if(KillHud_KillSpecials)
		Format(line, sizeof(line), "击杀统计 [开]");
	else
		Format(line, sizeof(line), "击杀统计 [关]");
	N_MenuHudMenu[client].AddItem("hudsp", line);
	
	if(KillHud_KillTank)
		Format(line, sizeof(line), "坦克伤害统计 [开]");
	else
		Format(line, sizeof(line), "坦克伤害统计 [关]");
	N_MenuHudMenu[client].AddItem("hudtank", line);
	
	if(KillHud_AllKill)
		Format(line, sizeof(line), "其他统计显示 [开]");
	else
		Format(line, sizeof(line), "其他统计显示 [关]");
	N_MenuHudMenu[client].AddItem("hudother", line);
	
	if(!KillHud_Show)
		Format(line, sizeof(line), "显示HUD [开局]");
	else
		Format(line, sizeof(line), "显示HUD [出安全区]");
	N_MenuHudMenu[client].AddItem("hudshow", line);
	
	Format(line, sizeof(line), "重载配置文件");
	N_MenuHudMenu[client].AddItem("hudreload", line);
	
	N_MenuHudMenu[client].ExitBackButton = true;
	return N_MenuHudMenu[client];
}

public int HudMenuHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			if(IsValidClient(client))
			{
				char items[30];
				menu.GetItem(selection, items, sizeof(items));
				if(StrEqual(items, "hudstyle"))
					SwitchHud(1, client);
				if(StrEqual(items, "hudfriend"))
					SwitchHud(2, client);
				if(StrEqual(items, "hudsp"))
					SwitchHud(3, client);
				if(StrEqual(items, "hudtank"))
					SwitchHud(4, client);
				if(StrEqual(items, "hudother"))
					SwitchHud(5, client);
				if(StrEqual(items, "hudshow"))
					SwitchHud(6, client);
				if(StrEqual(items, "hudallowbot"))
					SwitchHud(7, client);
				if(StrEqual(items, "hudreload"))
					SwitchHud(8, client);
				N_MenuHudMenu[client] = null;
				HudMenu(client).Display(client, MENU_TIME);
			}
		}
		case MenuAction_End:
		{
			delete menu;
			if(IsValidClient(client))
				N_MenuHudMenu[client] = null;
		}
	}
}

void SwitchHud(int type, int client)
{
	if(type == 1)
	{
		if(KillHud_HudStyle == 1)
			CKillHud_HudStyle.SetInt(2);
		else if(KillHud_HudStyle == 2)
			CKillHud_HudStyle.SetInt(3);
		else if(KillHud_HudStyle == 3)
			CKillHud_HudStyle.SetInt(4);
		else if(KillHud_HudStyle == 4)
			CKillHud_HudStyle.SetInt(0);
		else if(KillHud_HudStyle == 0)
			CKillHud_HudStyle.SetInt(1);
	}
	else if(type == 2)
	{
		if(KillHud_FriendlyFire)
			CKillHud_FriendlyFire.SetInt(0);
		else
			CKillHud_FriendlyFire.SetInt(1);
	}
	else if(type == 3)
	{
		if(KillHud_KillSpecials)
			CKillHud_KillSpecials.SetInt(0);
		else
			CKillHud_KillSpecials.SetInt(1);
	}
	else if(type == 4)
	{
		if(KillHud_KillTank)
			CKillHud_KillTank.SetInt(0);
		else
			CKillHud_KillTank.SetInt(1);
	}
	else if(type == 5)
	{
		if(KillHud_AllKill)
			CKillHud_AllKill.SetInt(0);
		else
			CKillHud_AllKill.SetInt(1);
	}
	else if(type == 6)
	{
		if(KillHud_Show)
		{
			CKillHud_Show.SetInt(0);
			CreateHud();
		}
		else
			CKillHud_Show.SetInt(1);
	}
	else if(type == 7)
	{
		if(KillHud_AllowBot)
			CKillHud_AllowBot.SetInt(0);
		else
			CKillHud_AllowBot.SetInt(1);
	}
	else if(type == 8)
	{
		AutoExecConfig_OnceExec();
	}
	
	if(type < 9)
	{
		if(HUDSlotIsUsed(HUD_FAR_LEFT))
			RemoveHUD(HUD_FAR_LEFT);
		if(HUDSlotIsUsed(HUD_FAR_RIGHT))
			RemoveHUD(HUD_FAR_RIGHT);
		if(HUDSlotIsUsed(HUD_SCORE_1))
			RemoveHUD(HUD_SCORE_1);
		if(HUDSlotIsUsed(HUD_SCORE_2))
			RemoveHUD(HUD_SCORE_2);
		if(HUDSlotIsUsed(HUD_MID_BOX))
			RemoveHUD(HUD_MID_BOX);
	}
	HudMenu(client).Display(client, MENU_TIME);
}