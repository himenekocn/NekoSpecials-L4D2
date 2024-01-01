#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <dhooks>
#include <left4dhooks>
#include <binhooks>
#include <neko/nekotools>
#include <neko/nekonative>
#include <nativevotes>
#include "nvote/globals.sp"

#define PLUGIN_CONFIG "Neko_VoteMenu"
#define NEKOTAG		  "[NS]"

public Plugin myinfo =
{
	name		= "Neko Vote Menu",
	description = "Neko Specials Vote Menu",
	author		= "Neko Channel",
	version		= PLUGIN_VERSION,
	url			= "https://himeneko.cn/nekospecials"
	//请勿修改插件信息！
};

public void OnPluginStart()
{
	AutoExecConfig_SetFile(PLUGIN_CONFIG);
	AutoExecConfig_SetCreateFile(true);	   //不需要生成文件请改为false

	NCvar[Neko_CanSwitch]		  = AutoExecConfig_CreateConVar("Neko_CanSwitch", "0", "[0=关|1=开]全局投票开关", _, true, 0.0, true, 1.0);
	NCvar[Neko_SwitchStatus]	  = AutoExecConfig_CreateConVar("Neko_SwitchStatus", "0", "[0=关|1=开]玩家是否能投票更改插件状态", _, true, 0.0, true, 1.0);
	NCvar[Neko_SwitchNumber]	  = AutoExecConfig_CreateConVar("Neko_SwitchNumber", "0", "[0=关|1=开]玩家是否能投票更改特感数量", _, true, 0.0, true, 1.0);
	NCvar[Neko_SwitchTime]		  = AutoExecConfig_CreateConVar("Neko_SwitchTime", "0", "[0=关|1=开]玩家是否能投票更改刷特时间", _, true, 0.0, true, 1.0);
	NCvar[Neko_SwitchRandom]	  = AutoExecConfig_CreateConVar("Neko_SwitchRandom", "0", "[0=关|1=开]玩家是否能投票开关随机特感", _, true, 0.0, true, 1.0);
	NCvar[Neko_SwitchGameMode]	  = AutoExecConfig_CreateConVar("Neko_SwitchGameMode", "0", "[0=关|1=开]玩家是否能投票更改插件特感模式", _, true, 0.0, true, 1.0);
	NCvar[Neko_SwitchSpawnMode]	  = AutoExecConfig_CreateConVar("Neko_SwitchSpawnMode", "0", "[0=关|1=开]玩家是否能投票更改插件刷特模式", _, true, 0.0, true, 1.0);
	NCvar[Neko_SwitchPlayerJoin]  = AutoExecConfig_CreateConVar("Neko_SwitchPlayerJoin", "0", "[0=关|1=开]玩家是否能投票设置根据玩家加入数量变动特感数量功能", _, true, 0.0, true, 1.0);
	NCvar[Neko_SwitchTankAlive]	  = AutoExecConfig_CreateConVar("Neko_SwitchTankAlive", "0", "[0=关|1=开]玩家是否能开关坦克存活时依旧刷特功能", _, true, 0.0, true, 1.0);
	NCvar[Neko_NeedResetNoPlayer] = AutoExecConfig_CreateConVar("Neko_NeedResetNoPlayer", "0", "[0=关|1=开]全部玩家离开游戏后自动重置特感数据", _, true, 0.0, true, 1.0);
	NCvar[Neko_NeedResetTime]	  = AutoExecConfig_CreateConVar("Neko_NeedResetTime", "10", "全部玩家离开游戏多少秒后自动重置");

	AutoExecConfig_OnceExec();

	HookEventEx("player_disconnect", Event_PlayerDisconnect, EventHookMode_Pre);

	AddCommandListener(ChatListener, "say");
	AddCommandListener(ChatListener, "say2");
	AddCommandListener(ChatListener, "say_team");

	RegConsoleCmd("sm_tgvote", OpenVoteMenu, "打开特感投票菜单");

	RegAdminCmd("sm_tgvoteadmin", OpenVoteAdminMenu, ADMFLAG_ROOT, "打开管理员投票控制菜单");
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("nekovote");
	CreateNative("NekoVote_PlHandle", NekoVote_REPlHandle);
	CreateNative("NekoVote_VoteStatus", NekoVote_REVoteStatus);

	return APLRes_Success;
}

public void OnConfigsExecuted()
{
	for (int i = 1; i < GetCvar_Max; i++)
	{
		if (i == CGame_Difficulty)
			continue;

		GCvar[i] = NekoSpecials_GetConVar(i);
	}
}

#include "nvote/natives.sp"
#include "nvote/api.sp"
#include "nvote/hooks.sp"
#include "nvote/timers.sp"
#include "nvote/adminmenus.sp"
#include "nvote/menus.sp"
#include "nvote/vote.sp"
