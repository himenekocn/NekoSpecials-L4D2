void CreateHud()
{
	if(KillHud_HudStyle > 0 && (KillHud_FriendlyFire || KillHud_KillSpecials || KillHud_AllKill) && !HudRunning)
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
	
	if((xy[0] > 1.0 || xy[0] < 0.0 || xy[1] > 1.0 || xy[1] < 0.0) && KillHud_HudStyle == 3)
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
		Kill_Init_Client(i);
	}
	Kill_AllZombie = 0, Kill_AllInfected = 0;
}

stock void Kill_Init_Client(int client)
{
	Kill_Infected[client] = 0;
	Kill_Zombie[client] = 0;
	Friendly_Fire[client] = 0;
	DmgToTank[client] = 0;
	Friendly_Hurt[client] = 0;
}