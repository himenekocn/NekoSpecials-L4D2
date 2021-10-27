public Action OpenSpecialMenu(int client, int args)
{
	SpecialMenu(client).Display(client, MENU_TIME);
}

public Action ReloadNTGConfig(int client, int args)
{
	AutoExecConfig_OnceExec();
	SetMaxSpecialsCount();
}

public Action SpecialVersionCMD(int client, int args)
{
	if(!IsClientBot(client))
	{
		PrintToChat(client, "\x05%s \x01Server Running On Version \x01=\x03Neko\x01=\x01 Auto Infected \x03 %s", NEKOTAG, PLUGIN_VERSION);
		if(!Special_PluginStatus)
			PrintToChat(client, "\x05%s \x04目前插件被关闭了", NEKOTAG);
		else
			PrintToChat(client, "\x05%s \x04目前插件开启中", NEKOTAG);
	}
}