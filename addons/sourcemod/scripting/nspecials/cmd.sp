public Action OpenSpecialMenu(int client, int args)
{
	SpecialMenu(client).Display(client, MENU_TIME);
	return Plugin_Continue;
}

public Action ReloadNTGConfig(int client, int args)
{
	AutoExecConfig_OnceExec();
	SetMaxSpecialsCount();
	return Plugin_Continue;
}

public Action ReSetNTGConfig(int client, int args)
{
	UpdateConfigFile(true);
	return Plugin_Continue;
}

public Action UpdateNTGConfig(int client, int args)
{
	UpdateConfigFile(false);
	return Plugin_Continue;
}

public Action SpecialVersionCMD(int client, int args)
{
	if(!IsClientBot(client))
	{
		PrintToChat(client, "\x05%s \x01服务器正在运行 \x01=\x03Neko\x01=\x01 Auto Infected \x03 %s", NEKOTAG, PLUGIN_VERSION);
		if(!NCvar[CSpecial_PluginStatus].BoolValue)
			PrintToChat(client, "\x05%s \x04目前插件被关闭了", NEKOTAG);
		else
			PrintToChat(client, "\x05%s \x04目前插件开启中", NEKOTAG);
	}
	return Plugin_Continue;
}