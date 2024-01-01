void CreateHud()
{
	if(NCvar[CKillHud_HudStyle].IntValue > 0 && (NCvar[CKillHud_FriendlyFire].BoolValue || NCvar[CKillHud_KillSpecials].BoolValue || NCvar[CKillHud_AllKill].BoolValue) && !HudRunning)
	{
		HudRunning = true;
		CreateTimer(1.0, RefreshHUD, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	}
}

stock void GetHUDSide(char[] sTemp, float xy[2])
{
	char xytemp[2][4];
	ExplodeString(sTemp, " ", xytemp, 2, 4);
	xy[0] = StringToFloat(xytemp[0]);
	xy[1] = StringToFloat(xytemp[1]);
	
	if((xy[0] > 1.0 || xy[0] < 0.0 || xy[1] > 1.0 || xy[1] < 0.0) && NCvar[CKillHud_HudStyle].IntValue == 3)
		LogError("自定义HUD位置超出范围");
}

stock void GetHudTitle(char[] name, char[] buffer, int maxlength)
{
	KeyValues kvSettings = new KeyValues("Settings");
	kvSettings.ImportFromFile(CorePath);
	kvSettings.Rewind();
	kvSettings.GetString(name, buffer, maxlength);
	delete kvSettings;
}

stock void Kill_Init()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		Neko_ClientInfo[i].Reset();
	}
	Neko_GlobalState.Reset();
}

void UpdateConfigFile(bool NeedReset)
{
	AutoExecConfig_DeleteConfig();

	for(int i = 1;i < Cvar_Max;i++)
	{
		AutoExecConfig_UpdateToConfig(NCvar[i], NeedReset);
	}

	AutoExecConfig_OnceExec();
}