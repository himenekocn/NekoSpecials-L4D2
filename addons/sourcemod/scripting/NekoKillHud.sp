#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>
#include <dhooks>
#include <left4dhooks>
#include <binhooks/binhooks_HUD>
#include <binhooks/binhooks_Other>
#include <ns>

#define PLUGIN_VERSION "6.00NS-KillHud"
#define PLUGIN_CONFIG "Neko_KillHud_binhooks"

int MENU_TIME = 60;

int Kill_Infected[MAXPLAYERS+1], Friendly_Fire[MAXPLAYERS+1], Friendly_Hurt[MAXPLAYERS+1], Kill_Zombie[MAXPLAYERS+1], DmgToTank[MAXPLAYERS+1], Kill_AllZombie, Kill_AllInfected, StyleChatDelay, KillHud_StyleChatDelay, KillHud_HudStyle;

bool TankAlive , HudRunning;
bool KillHud_FriendlyFire, KillHud_KillSpecials, KillHud_KillTank, KillHud_AllKill, KillHud_AllowBot, KillHud_Show;

char CorePath[PLATFORM_MAX_PATH], KillHud_CStyleFriendXY[12], KillHud_CStyleSpecialsXY[12], KillHud_CStyleTankXY[12], KillHud_CStyleAllKillXY[12];

ConVar CKillHud_FriendlyFire, CKillHud_KillSpecials, CKillHud_KillTank, CKillHud_AllKill, CKillHud_HudStyle, CKillHud_AllowBot, CKillHud_Show, CKillHud_CStyleFriendXY, CKillHud_CStyleSpecialsXY, CKillHud_CStyleTankXY, CKillHud_CStyleAllKillXY, CKillHud_StyleChatDelay;

Menu N_MenuHudMenu[MAXPLAYERS+1];

public Plugin myinfo =
{
	name = "Neko Kill Status HUD",
	description = "Neko Kill Status Hud Base on Binhooks!",
	author = "Neko Channel & Mr Cheng",
	version = PLUGIN_VERSION,
	url = "https://himeneko.cn"
	//请勿修改插件信息！
};

public void OnPluginStart()
{
	AutoExecConfig_SetFile(PLUGIN_CONFIG);
	AutoExecConfig_SetCreateFile(true);	//不需要生成文件请改为false
	
	CKillHud_FriendlyFire = AutoExecConfig_CreateConVar("KillHud_FriendlyFire", "1", "[0=关|1=开]禁用/启用友伤统计显示", _, true, 0.0, true, 1.0);
	CKillHud_KillSpecials = AutoExecConfig_CreateConVar("KillHud_KillSpecials", "1", "[0=关|1=开]禁用/启用击杀特感统计显示", _, true, 0.0, true, 1.0);
	CKillHud_KillTank = AutoExecConfig_CreateConVar("KillHud_KillTank", "1", "[0=关|1=开]禁用/启用对坦克统计显示", _, true, 0.0, true, 1.0);
	CKillHud_AllowBot = AutoExecConfig_CreateConVar("KillHud_AllowBot", "1", "[0=关|1=开]禁用/启用Bot算进排名中", _, true, 0.0, true, 1.0);
	CKillHud_AllKill = AutoExecConfig_CreateConVar("KillHud_AllKill", "1", "[0=关|1=开]禁用/启用其他统计显示", _, true, 0.0, true, 1.0);
	CKillHud_Show = AutoExecConfig_CreateConVar("KillHud_Show", "1", "[0=开局|1=出安全区]后显示HUD", _, true, 0.0, true, 1.0);
	
	CKillHud_HudStyle = AutoExecConfig_CreateConVar("KillHud_HudStyle", "2", "Hud风格[0=关|1=样式1|2=样式2|3=自定义样式|4=聊天栏输出]", _, true, 0.0, true, 4.0);
	CKillHud_CStyleFriendXY = AutoExecConfig_CreateConVar("KillHud_CStyleFriendXY", "0.2 0.0", "自定义Hud位置[友伤][坐标最大值为1.0,对应分别为x轴与y轴]", FCVAR_NOTIFY);
	CKillHud_CStyleSpecialsXY = AutoExecConfig_CreateConVar("KillHud_CStyleSpecialsXY", "0.0 0.0", "自定义Hud位置[击杀][坐标最大值为1.0,对应分别为x轴与y轴]", FCVAR_NOTIFY);
	CKillHud_CStyleTankXY = AutoExecConfig_CreateConVar("KillHud_CStyleTankXY", "0.0 0.3", "自定义Hud位置[坦克][坐标最大值为1.0,对应分别为x轴与y轴]", FCVAR_NOTIFY);
	CKillHud_CStyleAllKillXY = AutoExecConfig_CreateConVar("KillHud_CStyleAllKillXY", "0.73 0.9", "自定义Hud位置[其他][坐标最大值为1.0,对应分别为x轴与y轴]", FCVAR_NOTIFY);
	
	CKillHud_StyleChatDelay = AutoExecConfig_CreateConVar("KillHud_StyleChatDelay", "30", "样式4聊天框循环输出延迟", _, true, 10.0, true, 120.0);
	
	AutoExecConfig_OnceExec();
	
	SetCvarHook();
	GetCvarsValues();
	
	BuildPath(Path_SM, CorePath, sizeof(CorePath), "data/nekocustom.cfg");
	if (!FileExists(CorePath))
		SetFailState("[Neko] The Custom file does not exist: %s", CorePath);
	
	HookEvent("round_start",Event_Round_Start);
	HookEvent("round_end",Event_Round_End);
	HookEvent("finale_win",Event_Round_End);
	HookEvent("mission_lost",Event_Round_End);
	HookEvent("map_transition",Event_Round_End);
	HookEvent("player_death",Event_PlayerDeath);
	HookEvent("infected_death",Event_infectedDeath);
	HookEvent("player_hurt", Event_PlayerHurt, EventHookMode_Pre);
	HookEvent("tank_spawn", Event_TankSpawn);
	HookEvent("tank_killed", Event_TankDeath);
	HookEvent("player_disconnect", OnPlayerDisconnect, EventHookMode_Pre);
	
	RegAdminCmd("sm_nhud", OpenHUDMenu, ADMFLAG_ROOT, "hud菜单");
	RegAdminCmd("sm_reloadhugconfig", ReloadHUDConfig, ADMFLAG_ROOT, "重载HUD配置文件");
}

#include "nhud/native.sp"
#include "nhud/event.sp"
#include "nhud/menu.sp"
#include "nhud/main.sp"
#include "nhud/tank.sp"
#include "nhud/nekonative.inc"

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("nekokillhud");
	
	CreateNative("NekoKillHud_PlHandle", NekoKillHud_REPlHandle);
	CreateNative("NekoKillHud_GetStatus", NekoKillHud_REGetStatus);
	CreateNative("NekoKillHud_GetStyle", NekoKillHud_REGetStyle);
	
	return APLRes_Success;
}

public any NekoKillHud_REPlHandle(Handle plugin, int numParams)
{
	return GetMyHandle();
}

public int NekoKillHud_REGetStatus(Handle plugin, int numParams)
{
	return HudRunning;
}

public int NekoKillHud_REGetStyle(Handle plugin, int numParams)
{
	return KillHud_HudStyle;
}

public void CvarsChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	GetCvarsValues();
}

void SetCvarHook()
{
	CKillHud_FriendlyFire.AddChangeHook(CvarsChanged);
	CKillHud_KillSpecials.AddChangeHook(CvarsChanged);
	CKillHud_KillTank.AddChangeHook(CvarsChanged);
	CKillHud_AllowBot.AddChangeHook(CvarsChanged);
	CKillHud_AllKill.AddChangeHook(CvarsChanged);
	CKillHud_Show.AddChangeHook(CvarsChanged);
	CKillHud_HudStyle.AddChangeHook(CvarsChanged);
	CKillHud_CStyleFriendXY.AddChangeHook(CvarsChanged);
	CKillHud_CStyleSpecialsXY.AddChangeHook(CvarsChanged);
	CKillHud_CStyleTankXY.AddChangeHook(CvarsChanged);
	CKillHud_CStyleAllKillXY.AddChangeHook(CvarsChanged);
	CKillHud_StyleChatDelay.AddChangeHook(CvarsChanged);
}

void GetCvarsValues()
{
	KillHud_FriendlyFire = CKillHud_FriendlyFire.BoolValue;
	KillHud_KillSpecials = CKillHud_KillSpecials.BoolValue;
	KillHud_KillTank = CKillHud_KillTank.BoolValue;
	KillHud_AllKill = CKillHud_AllKill.BoolValue;
	KillHud_HudStyle = CKillHud_HudStyle.IntValue;
	KillHud_AllowBot = CKillHud_AllowBot.BoolValue;
	KillHud_Show = CKillHud_Show.BoolValue;
	CKillHud_CStyleFriendXY.GetString(KillHud_CStyleFriendXY, sizeof(KillHud_CStyleFriendXY));
	CKillHud_CStyleSpecialsXY.GetString(KillHud_CStyleSpecialsXY, sizeof(KillHud_CStyleSpecialsXY));
	CKillHud_CStyleTankXY.GetString(KillHud_CStyleTankXY, sizeof(KillHud_CStyleTankXY));
	CKillHud_CStyleAllKillXY.GetString(KillHud_CStyleAllKillXY, sizeof(KillHud_CStyleAllKillXY));
	KillHud_StyleChatDelay = CKillHud_StyleChatDelay.IntValue;
}