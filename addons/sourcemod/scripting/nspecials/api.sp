

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("nekospecials");

	CreateNative("NekoSpecials_PlHandle", NekoSpecials_REPlHandle);
	CreateNative("NekoSpecials_GetSpawnMode", NekoSpecials_REGetSpawnMode);
	CreateNative("NekoSpecials_GetSpecialsNum", NekoSpecials_REGetSpecialsNum);
	CreateNative("NekoSpecials_GetSpecialsTime", NekoSpecials_REGetSpecialsTime);
	CreateNative("NekoSpecials_GetPluginStatus", NekoSpecials_REGetPluginStatus);
	CreateNative("NekoSpecials_GetSpecialsMode", NekoSpecials_REGetSpecialsMode);
	CreateNative("NekoSpecials_ShowSpecialsTips", NekoSpecials_REShowSpecialsTips);
	CreateNative("NekoSpecials_ShowYourTips", NekoSpecials_REShowYourTips);
	CreateNative("NekoSpecials_GetConVar", NekoSpecials_REGetConVar);
	CreateNative("NekoSpecials_ShowSpecialsModeTips", NekoSpecials_REShowSpecialsModeTips);
	CreateNative("NekoSpecials_ReLoadAllConfig", NekoSpecials_REReLoadAllConfig);

	N_Forward_OnSetSpecialsNum	= new GlobalForward("NekoSpecials_OnSetSpecialsNum", ET_Event);
	N_Forward_OnSetSpecialsTime = new GlobalForward("NekoSpecials_OnSetSpecialsTime", ET_Event);
	N_Forward_OnStartFirstSpawn = new GlobalForward("NekoSpecials_OnStartFirstSpawn", ET_Event);

	return APLRes_Success;
}

public any NekoSpecials_REReLoadAllConfig(Handle plugin, int numParams)
{
	AutoExecConfig_OnceExec();
	return 0;
}

public any NekoSpecials_REShowSpecialsTips(Handle plugin, int numParams)
{
	InfectedTips();
	return 0;
}

public any NekoSpecials_REShowSpecialsModeTips(Handle plugin, int numParams)
{
	ModeTips();
	return 0;
}

public any NekoSpecials_REShowYourTips(Handle plugin, int numParams)
{
	char cshowtips[48];
	GetNativeString(1, cshowtips, sizeof(cshowtips));
	HUDShowMsg(cshowtips);
	return 0;
}

public int NekoSpecials_REGetSpawnMode(Handle plugin, int numParams)
{
	return GetSpecialSpawnMode();
}

public int NekoSpecials_REGetSpecialsMode(Handle plugin, int numParams)
{
	return NCvar[CSpecial_Default_Mode].IntValue;
}

public int NekoSpecials_REGetPluginStatus(Handle plugin, int numParams)
{
	return NCvar[CSpecial_PluginStatus].BoolValue;
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

public any NekoSpecials_REGetConVar(Handle plugin, int numParams)
{
	return NCvar[GetNativeCell(1)];
}