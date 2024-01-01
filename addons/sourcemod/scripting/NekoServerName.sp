#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <left4dhooks>
#include <neko/nekotools>
#include <neko/nekonative>

#define PLUGIN_CONFIG		 "Neko_ServerName"

#define SPECIALS_AVAILABLE() (GetFeatureStatus(FeatureType_Native, "NekoSpecials_GetSpecialsNum") == FeatureStatus_Available)

char		  CorePath[PLATFORM_MAX_PATH], ServerNameFormat[256];

float		  GetMapMaxFlow;

int			  RoundFailCounts;

GlobalForward N_Forward_OnChangeServerName;

#define ServerName_AutoUpdate	   1
#define ServerName_UpdateTime	   2
#define ServerName_ShowTimeSeconds 3
#define Cvar_Max				   4

ConVar NCvar[Cvar_Max];

public Plugin myinfo =
{
	name		= "Neko ServerName",
	description = "Neko ServerName",
	author		= "Neko Channel",
	version		= PLUGIN_VERSION,
	url			= "https://himeneko.cn/nekospecials"
	//请勿修改插件信息！
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("nekoservername");

	CreateNative("NekoServerName_PlHandle", NekoServerName_REPlHandle);

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
	AutoExecConfig_SetCreateFile(true);	   //不需要生成文件请改为false

	NCvar[ServerName_AutoUpdate]	  = AutoExecConfig_CreateConVar("ServerName_AutoUpdate", "1", "[0=关|1=开]禁用/启用自动更新服务器名字功能[显示路程需要打开]", _, true, 0.0, true, 1.0);
	NCvar[ServerName_UpdateTime]	  = AutoExecConfig_CreateConVar("ServerName_UpdateTime", "15", "服务器名字自动更新延迟", _, true, 1.0, true, 120.0);
	NCvar[ServerName_ShowTimeSeconds] = AutoExecConfig_CreateConVar("ServerName_ShowTimeSeconds", "1", "[0=关|1=开]禁用/启用计时显秒", _, true, 0.0, true, 1.0);

	AutoExecConfig_OnceExec();

	BuildPath(Path_SM, CorePath, sizeof(CorePath), "data/nekocustom.cfg");
	if (!FileExists(CorePath))
		CreateConfigFire();

	HookEvent("mission_lost", mission_lost, EventHookMode_Pre);

	RegAdminCmd("sm_updateservername", StartNekoUpdate, ADMFLAG_ROOT, "执行服务器名字更新");
	RegAdminCmd("sm_host", StartNekoUpdate, ADMFLAG_ROOT, "执行服务器名字更新");
	RegAdminCmd("sm_hosts", StartNekoUpdate, ADMFLAG_ROOT, "执行服务器名字更新");
}

void CreateConfigFire()
{
	Handle WriteConfig = OpenFile(CorePath, "w");
	if (WriteConfig == INVALID_HANDLE)
		SetFailState("[Neko] 自定义配置文件创建失败: %s", CorePath);

	WriteFileLine(WriteConfig, "\"Settings\"");
	WriteFileLine(WriteConfig, "{");
	WriteFileLine(WriteConfig, "	\"KillHud_KillTankTitle\"			\"本次对Tank伤害\"");
	WriteFileLine(WriteConfig, "	\"KillHud_KillSpecialsTitle\"		\"击杀排行\"");
	WriteFileLine(WriteConfig, "	\"KillHud_FriendlyFireTitle\"		\"黑枪排行\"");
	WriteFileLine(WriteConfig, "	\"ServerNameFormat\"			\"XX多特{servernum}服[{specials}特{times}秒][重启:{restartcount}|路程:{flow}]{maptime}\"");
	WriteFileLine(WriteConfig, "}");

	WriteFileLine(WriteConfig, "//以下为自定义服务器名字能加入的参数，根据个人选择加入");
	WriteFileLine(WriteConfig, "//{servernum} 		服务器数字 服务器端口后缀 27015 的 5 就是你的服务器数字");
	WriteFileLine(WriteConfig, "//{specials} 		目前多特数量，需要搭配Neko多特插件");
	WriteFileLine(WriteConfig, "//{times} 			目前多特刷新时间，需要搭配Neko多特插件");
	WriteFileLine(WriteConfig, "//{restartcount} 	失败重启次数");
	WriteFileLine(WriteConfig, "//{flow} 			当前玩家的路程");
	WriteFileLine(WriteConfig, "//{maptime}			目前地图时间，自带格式，例如[计时:2m:10s]");

	delete WriteConfig;
}

public Action StartNekoUpdate(int client, int args)
{
	SetServerName();
	return Plugin_Continue;
}

public void OnMapStart()
{
	FindConVar("sv_hibernate_when_empty").SetInt(0);
	StartCatchTime();
}

public void OnConfigsExecuted()
{
	GetServerName(ServerNameFormat, sizeof(ServerNameFormat));

	RoundFailCounts = 0;
	GetMapMaxFlow	= L4D2Direct_GetMapMaxFlowDistance();

	SetServerName();

	if (NCvar[ServerName_AutoUpdate].BoolValue)
		CreateTimer(NCvar[ServerName_UpdateTime].FloatValue, Update_HostName, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
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

	if (SPECIALS_AVAILABLE())
	{
		IntToString(NekoSpecials_GetSpecialsNum(), snum, sizeof(snum));
		IntToString(NekoSpecials_GetSpecialsTime(), stime, sizeof(stime));
		ReplaceString(ServerName, sizeof(ServerName), "{specials}", snum, false);
		ReplaceString(ServerName, sizeof(ServerName), "{times}", stime, false);
	}

	if (IsNullString(ServerPort[4]))
		ReplaceString(ServerName, sizeof(ServerName), "{servernum}", ServerPort[3], false);
	else
		ReplaceString(ServerName, sizeof(ServerName), "{servernum}", ServerPort[4], false);

	ReplaceString(ServerName, sizeof(ServerName), "{restartcount}", restartcount, false);

	if (L4D_HasAnySurvivorLeftSafeArea())
	{
		int	  OneSurvivor;

		float fHighestFlow = IsValidSurvivor((OneSurvivor = L4D_GetHighestFlowSurvivor())) ? L4D2Direct_GetFlowDistance(OneSurvivor) : L4D2_GetFurthestSurvivorFlow();

		if (fHighestFlow)
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

	FindConVar("sv_hibernate_when_empty").SetInt(0);

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
	if (NCvar[ServerName_ShowTimeSeconds].BoolValue)
		FormatEx(sTime, maxlength, "[计时:%sm:%ss]", GetNowTime_Minutes(), GetNowTime_Seconds());
	else
		FormatEx(sTime, maxlength, "[计时:%sm]", GetNowTime_Minutes());
}