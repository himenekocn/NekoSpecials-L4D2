#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <left4dhooks>
#include <neko/nekotools>
#include <neko/nekonative>

#define PLUGIN_CONFIG "Neko_ServerName"

#define SPECIALS_AVAILABLE()	(GetFeatureStatus(FeatureType_Native, "NekoSpecials_GetSpecialsNum") == FeatureStatus_Available)

char CorePath[PLATFORM_MAX_PATH], ServerNameFormat[256];

float GetMapMaxFlow, ServerName_UpdateTime;

int RoundFailCounts;

bool ServerName_AutoUpdate, ServerName_ShowTimeSeconds;

ConVar CServerName_UpdateTime, CServerName_AutoUpdate, CServerName_ShowTimeSeconds;

GlobalForward N_Forward_OnChangeServerName;

public Plugin myinfo =
{
	name = "Neko ServerName",
	description = "Neko ServerName",
	author = "Neko Channel",
	version = PLUGIN_VERSION,
	url = "https://himeneko.cn/nekospecials"
	//请勿修改插件信息！
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("nekoservername");

	CreateNative("NekoServerName_PlHandle", 			NekoServerName_REPlHandle);
	
	N_Forward_OnChangeServerName = new GlobalForward("NekoServerName_OnChangeServerName", ET_Event);

	MarkNativeAsOptional("NekoSpecials_GetSpecialsNum");
	MarkNativeAsOptional("NekoSpecials_GetSpecialsTime");
	MarkNativeAsOptional("NekoSpecials_OnSetSpecialsNum");
	MarkNativeAsOptional("NekoSpecials_OnSetSpecialsTime");
	
	return APLRes_Success;
}

public any NekoServerName_REPlHandle(Handle plugin, int numParams)
{
	return GetMyHandle();
}

public void OnPluginStart()
{
	AutoExecConfig_SetFile(PLUGIN_CONFIG);
	AutoExecConfig_SetCreateFile(true);	//不需要生成文件请改为false

	CServerName_AutoUpdate = AutoExecConfig_CreateConVar("ServerName_AutoUpdate", "1", "[0=关|1=开]禁用/启用自动更新服务器名字功能[显示路程需要打开]", _, true, 0.0, true, 1.0);
	CServerName_UpdateTime = AutoExecConfig_CreateConVar("ServerName_UpdateTime", "15", "服务器名字自动更新延迟", _, true, 1.0, true, 120.0);
	CServerName_ShowTimeSeconds = AutoExecConfig_CreateConVar("ServerName_ShowTimeSeconds", "1", "[0=关|1=开]禁用/启用计时显秒", _, true, 0.0, true, 1.0);
	
	AutoExecConfig_OnceExec();
	
	CServerName_AutoUpdate.AddChangeHook(CvarsChanged);
	CServerName_UpdateTime.AddChangeHook(CvarsChanged);
	CServerName_ShowTimeSeconds.AddChangeHook(CvarsChanged);
	
	GetCvarsValues();
	
	BuildPath(Path_SM, CorePath, sizeof(CorePath), "data/nekocustom.cfg");
	if (!FileExists(CorePath))
		SetFailState("[Neko] The Custom file does not exist: %s", CorePath);
	
	HookEvent("mission_lost", mission_lost, EventHookMode_Pre);
	
	RegAdminCmd("sm_updateservername", StartNekoUpdate, ADMFLAG_ROOT, "执行服务器名字更新");
}

public Action StartNekoUpdate(int client, int args)
{
	SetServerName();
	return Plugin_Continue;
}

public void CvarsChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	GetCvarsValues();
}

void GetCvarsValues()
{
	ServerName_AutoUpdate = CServerName_AutoUpdate.BoolValue;
	ServerName_UpdateTime = CServerName_UpdateTime.FloatValue;
	ServerName_ShowTimeSeconds = CServerName_ShowTimeSeconds.BoolValue;
}

public void OnMapStart()
{
	StartCatchTime();
}

public void OnConfigsExecuted()
{
	GetServerName(ServerNameFormat, sizeof(ServerNameFormat));
	
	RoundFailCounts = 0;
	GetMapMaxFlow = L4D2Direct_GetMapMaxFlowDistance();
	
	SetServerName();
	
	if(ServerName_AutoUpdate)
		CreateTimer(ServerName_UpdateTime, Update_HostName, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public void mission_lost(Event event, const char[] name, bool dontBroadcast)
{
	RoundFailCounts++;
}

public Action NekoSpecials_OnSetSpecialsNum()
{
	SetServerName();
	return Plugin_Continue;
}

public Action NekoSpecials_OnSetSpecialsTime()
{
	SetServerName();
	return Plugin_Continue;
}

public Action Update_HostName(Handle timer)
{
	SetServerName();
	return Plugin_Continue;
}

void SetServerName()
{
	char ServerPort[6], ServerName[256], snum[64], stime[64], restartcount[64], maptime[64];
	
	FindConVar("hostport").GetString(ServerPort, sizeof(ServerPort));
	
	Format(ServerName, sizeof(ServerName), ServerNameFormat);
	
	IntToString(RoundFailCounts, restartcount, sizeof(restartcount));
	
	if(SPECIALS_AVAILABLE())
	{
		IntToString(NekoSpecials_GetSpecialsNum(), snum, sizeof(snum));
		IntToString(NekoSpecials_GetSpecialsTime(), stime, sizeof(stime));
		ReplaceString(ServerName, sizeof(ServerName), "{specials}", snum, false);
		ReplaceString(ServerName, sizeof(ServerName), "{times}", stime, false);
	}
	
	ReplaceString(ServerName, sizeof(ServerName), "{servernum}", ServerPort[4], false);
	ReplaceString(ServerName, sizeof(ServerName), "{restartcount}", restartcount, false);
	
	if(L4D_HasAnySurvivorLeftSafeArea())
	{
		int OneSurvivor;
		
		float fHighestFlow = IsValidSurvivor((OneSurvivor = L4D_GetHighestFlowSurvivor())) ? L4D2Direct_GetFlowDistance(OneSurvivor) : L4D2_GetFurthestSurvivorFlow();
		
		if(fHighestFlow)
			fHighestFlow = fHighestFlow / GetMapMaxFlow * 100;
		
		char playflow[64];
		Format(playflow, sizeof(playflow), "%d%%", RoundToNearest(fHighestFlow));
		
		ReplaceString(ServerName, sizeof(ServerName), "{flow}", playflow);
	}
	else
	{
		ReplaceString(ServerName, sizeof(ServerName), "{flow}", "0%");
	}
	
	GetRunMapTime(maptime, sizeof(maptime));
	
	ReplaceString(ServerName, sizeof(ServerName), "{maptime}", maptime, false);
	
	FindConVar("hostname").SetString(ServerName, true, false);
	
	Call_StartForward(N_Forward_OnChangeServerName);
	Call_Finish(N_Forward_OnChangeServerName);
}

stock void GetServerName(char[] buffer, int maxlength)
{
	KeyValues kvSettings = new KeyValues("Settings");
	kvSettings.ImportFromFile(CorePath);
	kvSettings.Rewind();
	kvSettings.GetString("ServerNameFormat", buffer, maxlength);
	delete kvSettings;
}

stock void GetRunMapTime(char[] sTime, int maxlength)
{
	if(ServerName_ShowTimeSeconds)
		FormatEx(sTime, maxlength, "[计时:%sm:%ss]", GetNowTime_Minutes(), GetNowTime_Seconds());
	else
		FormatEx(sTime, maxlength, "[计时:%sm]", GetNowTime_Minutes());
}