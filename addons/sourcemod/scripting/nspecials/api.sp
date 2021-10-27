public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("nekospecials");
	
	CreateNative("NekoSpecials_PlHandle", 			NekoSpecials_REPlHandle);
	CreateNative("NekoSpecials_GetSpawnMode", 		NekoSpecials_REGetSpawnMode);
	CreateNative("NekoSpecials_GetSpecialsNum", 	NekoSpecials_REGetSpecialsNum);
	CreateNative("NekoSpecials_GetSpecialsTime", 	NekoSpecials_REGetSpecialsTime);
	CreateNative("NekoSpecials_GetPluginStatus", 	NekoSpecials_REGetPluginStatus);
	CreateNative("NekoSpecials_GetSpecialsMode", 	NekoSpecials_REGetSpecialsMode);
	CreateNative("NekoSpecials_ShowSpecialsTips", 	NekoSpecials_REShowSpecialsTips);
	CreateNative("NekoSpecials_ShowYourTips", 		NekoSpecials_REShowYourTips);
	
	N_Forward_OnSetSpecialsNum = new GlobalForward("NekoSpecials_OnSetSpecialsNum", ET_Event);
	N_Forward_OnSetSpecialsTime = new GlobalForward("NekoSpecials_OnSetSpecialsTime", ET_Event);
	N_Forward_OnStartFirstSpawn = new GlobalForward("NekoSpecials_OnStartFirstSpawn", ET_Event);
	
	return APLRes_Success;
}

public any NekoSpecials_REShowSpecialsTips(Handle plugin, int numParams)
{
	InfectedTips();
}

public any NekoSpecials_REShowYourTips(Handle plugin, int numParams)
{
	char cshowtips[48];
	GetNativeString(1, cshowtips, sizeof(cshowtips));
	HUDShowMsg(cshowtips);
}

public int NekoSpecials_REGetSpawnMode(Handle plugin, int numParams)
{
	return GetSpecialSpawnMode();
}

public int NekoSpecials_REGetSpecialsMode(Handle plugin, int numParams)
{
	return Special_Default_Mode;
}

public int NekoSpecials_REGetPluginStatus(Handle plugin, int numParams)
{
	return Special_PluginStatus;
}

public int NekoSpecials_REGetSpecialsNum(Handle plugin, int numParams)
{
	return GetSpecialMax();
}

public int NekoSpecials_REGetSpecialsTime(Handle plugin, int numParams)
{
	return GetSpecialRespawnInterval();
}

public any NekoSpecials_REPlHandle(Handle plugin, int numParams)
{
	return GetMyHandle();
}