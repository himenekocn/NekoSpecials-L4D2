#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>
#include <dhooks>
#include <left4dhooks>
#include <binhooks>
#include <neko/nekotools>
#include <neko/nekonative>
#include "nhud/globals.sp"

public Plugin myinfo =
{
	name		= "Neko Kill Status HUD",
	description = "Neko Kill Status Hud Base on Binhooks!",
	author		= "Neko Channel & Mr Cheng",
	version		= PLUGIN_VERSION,
	url			= "https://himeneko.cn/nekospecials"
	//请勿修改插件信息！
};

public void OnPluginStart()
{
	AutoExecConfig_SetFile(PLUGIN_CONFIG);

	NCvar[CKillHud_FriendlyFire]	 = AutoExecConfig_CreateConVar("KillHud_FriendlyFire", "1", "[0=关|1=开]禁用/启用友伤统计显示", _, true, 0.0, true, 1.0);
	NCvar[CKillHud_KillSpecials]	 = AutoExecConfig_CreateConVar("KillHud_KillSpecials", "1", "[0=关|1=开]禁用/启用击杀特感统计显示", _, true, 0.0, true, 1.0);
	NCvar[CKillHud_KillTank]		 = AutoExecConfig_CreateConVar("KillHud_KillTank", "1", "[0=关|1=开]禁用/启用对坦克统计显示", _, true, 0.0, true, 1.0);
	NCvar[CKillHud_AllowBot]		 = AutoExecConfig_CreateConVar("KillHud_AllowBot", "1", "[0=关|1=开]禁用/启用Bot算进排名中", _, true, 0.0, true, 1.0);
	NCvar[CKillHud_AllKill]			 = AutoExecConfig_CreateConVar("KillHud_AllKill", "1", "[0=关|1=开]禁用/启用其他统计显示", _, true, 0.0, true, 1.0);
	NCvar[CKillHud_Show]			 = AutoExecConfig_CreateConVar("KillHud_Show", "1", "[0=开局|1=出安全区]后显示HUD", _, true, 0.0, true, 1.0);
	NCvar[CKillHud_ShowMorePlayer]	 = AutoExecConfig_CreateConVar("KillHud_ShowMorePlayer", "0", "[0=关|1=开]禁用/启用显示更多玩家", _, true, 0.0, true, 1.0);
	NCvar[CKillHud_ShowTankWitch]	 = AutoExecConfig_CreateConVar("KillHud_ShowTankWitch", "0", "[0=关|1=开]禁用/启用显示坦克与女巫击杀", _, true, 0.0, true, 1.0);
	NCvar[CKillHud_AllKillStyle2]	 = AutoExecConfig_CreateConVar("KillHud_AllKillStyle2", "0", "[0=章节|1=地图]0为右下角或聊天栏显示每章节总击杀数/1为显示地图总击杀数", _, true, 0.0, true, 1.0);

	NCvar[CKillHud_HudStyle]		 = AutoExecConfig_CreateConVar("KillHud_HudStyle", "2", "Hud风格[0=关|1=样式1|2=样式2|3=自定义样式|4=聊天栏输出]", _, true, 0.0, true, 4.0);
	NCvar[CKillHud_CStyleFriendXY]	 = AutoExecConfig_CreateConVar("KillHud_CStyleFriendXY", "0.2 0.0", "自定义Hud位置[友伤][坐标最大值为1.0,对应分别为x轴与y轴]", FCVAR_NOTIFY);
	NCvar[CKillHud_CStyleSpecialsXY] = AutoExecConfig_CreateConVar("KillHud_CStyleSpecialsXY", "0.0 0.0", "自定义Hud位置[击杀][坐标最大值为1.0,对应分别为x轴与y轴]", FCVAR_NOTIFY);
	NCvar[CKillHud_CStyleTankXY]	 = AutoExecConfig_CreateConVar("KillHud_CStyleTankXY", "0.0 0.3", "自定义Hud位置[坦克][坐标最大值为1.0,对应分别为x轴与y轴]", FCVAR_NOTIFY);
	NCvar[CKillHud_CStyleAllKillXY]	 = AutoExecConfig_CreateConVar("KillHud_CStyleAllKillXY", "0.73 0.9", "自定义Hud位置[其他][坐标最大值为1.0,对应分别为x轴与y轴]", FCVAR_NOTIFY);

	NCvar[CKillHud_StyleChatDelay]	 = AutoExecConfig_CreateConVar("KillHud_StyleChatDelay", "30", "样式4聊天框循环输出延迟", _, true, 10.0, true, 120.0);

	AutoExecConfig_OnceExec();

	BuildPath(Path_SM, CorePath, sizeof(CorePath), "data/nekocustom.cfg");
	if (!FileExists(CorePath))
		CreateConfigFire();

	HookEventEx("round_start", Event_Round_Start);
	HookEventEx("round_end", Event_Round_End);
	HookEventEx("finale_win", Event_Round_End);
	HookEventEx("mission_lost", Event_Round_End);
	HookEventEx("map_transition", Event_Round_End);
	HookEventEx("player_death", Event_PlayerDeath);
	HookEventEx("infected_death", Event_infectedDeath);
	HookEventEx("player_hurt", Event_PlayerHurt, EventHookMode_Pre);
	HookEventEx("tank_spawn", Event_TankSpawn);
	HookEventEx("tank_killed", Event_TankDeath);
	HookEventEx("witch_killed", Event_WitchDeath);
	HookEventEx("player_disconnect", OnPlayerDisconnect, EventHookMode_Pre);
	HookEventEx("map_transition", Event_MapTransition);

	RegAdminCmd("sm_nhud", OpenHUDMenu, ADMFLAG_ROOT, "打开HUD管理员菜单");
	RegAdminCmd("sm_hudmenu", OpenHUDMenu, ADMFLAG_ROOT, "打开HUD管理员菜单");
	RegAdminCmd("sm_reloadhudconfig", ReloadHUDConfig, ADMFLAG_ROOT, "重载HUD配置文件");
	RegAdminCmd("sm_updatehudconfig", UpdateHUDConfig, ADMFLAG_ROOT, "写入HUD配置文件");
	RegAdminCmd("sm_resethudconfig", ReSetHUDConfig, ADMFLAG_ROOT, "重置HUD配置文件");
}

#include "nhud/native.sp"
#include "nhud/event.sp"
#include "nhud/menu.sp"
#include "nhud/main.sp"
#include "nhud/tank.sp"

void CreateConfigFire()
{
	Handle WriteConfig = OpenFile(CorePath, "w");
	if(WriteConfig == INVALID_HANDLE)
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
	return NCvar[CKillHud_HudStyle].IntValue;
}