#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <dhooks>
#include <left4dhooks>
#include <binhooks>
#include <neko/nekotools>
#include <neko/nekonative>
#include <nativevotes>

#define PLUGIN_CONFIG "Neko_VoteMenu"
#define NEKOTAG "[NS]"

#define CSpecial_Fast_Response 1
#define CSpecial_Spawn_Time 2
#define CSpecial_Random_Mode 3
#define CSpecial_Default_Mode 4
#define CSpecial_Show_Tips 5
#define CSpecial_Spawn_Tank_Alive 6
#define CSpecial_Num 7
#define CSpecial_AddNum 8
#define CSpecial_PlayerAdd 9
#define CSpecial_PlayerNum 10
#define CSpecial_Spawn_Mode 11
#define CSpecial_Boomer_Num 12
#define CSpecial_Smoker_Num 13
#define CSpecial_Charger_Num 14
#define CSpecial_Hunter_Num 15
#define CSpecial_Spitter_Num 16
#define CSpecial_Jockey_Num 17
#define CSpecial_AutoKill_StuckTank 18
#define CSpecial_LeftPoint_SpawnTime 19
#define CSpecial_PluginStatus 20
#define CSpecial_Show_Tips_Chat 21
#define CSpecial_PlayerCountSpec 22
#define CSpecial_CanCloseDirector 23
#define CGame_Difficulty 24
#define CSpecial_Spawn_Time_DifficultyChange 25
#define CSpecial_Spawn_Time_Easy 26
#define CSpecial_Spawn_Time_Normal 27
#define CSpecial_Spawn_Time_Hard 28
#define CSpecial_Spawn_Time_Impossible 29
#define CSpecial_IsModeInNormal 30
#define CSpecial_Boomer_Spawn_Weight 31
#define CSpecial_Smoker_Spawn_Weight 32
#define CSpecial_Charger_Spawn_Weight 33
#define CSpecial_Hunter_Spawn_Weight 34
#define CSpecial_Spitter_Spawn_Weight 35
#define CSpecial_Jockey_Spawn_Weight 36
#define CSpecial_Boomer_Spawn_DirChance 37
#define CSpecial_Smoker_Spawn_DirChance 38
#define CSpecial_Charger_Spawn_DirChance 39
#define CSpecial_Hunter_Spawn_DirChance 40
#define CSpecial_Spitter_Spawn_DirChance 41
#define CSpecial_Jockey_Spawn_DirChance 42
#define CSpecial_Boomer_Spawn_Area 43
#define CSpecial_Smoker_Spawn_Area 44
#define CSpecial_Charger_Spawn_Area 45
#define CSpecial_Hunter_Spawn_Area 46
#define CSpecial_Spitter_Spawn_Area 47
#define CSpecial_Jockey_Spawn_Area 48
#define CSpecial_Boomer_Spawn_MaxDis 49
#define CSpecial_Smoker_Spawn_MaxDis 50
#define CSpecial_Charger_Spawn_MaxDis 51
#define CSpecial_Hunter_Spawn_MaxDis 52
#define CSpecial_Spitter_Spawn_MaxDis 53
#define CSpecial_Jockey_Spawn_MaxDis 54
#define CSpecial_Boomer_Spawn_MinDis 55
#define CSpecial_Smoker_Spawn_MinDis 56
#define CSpecial_Charger_Spawn_MinDis 57
#define CSpecial_Hunter_Spawn_MinDis 58
#define CSpecial_Spitter_Spawn_MinDis 59
#define CSpecial_Jockey_Spawn_MinDis 60
#define CSpecial_Spawn_MaxDis 61
#define CSpecial_Spawn_MinDis 62
#define CSpecial_Num_NotCul_Death 63
#define CSpecial_Spawn_Tank_Alive_Pro 64
#define GetCvar_Max 65

#define Neko_CanSwitch 1
#define Neko_SwitchStatus 2
#define Neko_SwitchNumber 3
#define Neko_SwitchTime 4
#define Neko_SwitchRandom 5
#define Neko_SwitchGameMode 6
#define Neko_SwitchSpawnMode 7
#define Neko_SwitchPlayerJoin 8
#define Neko_SwitchTankAlive 9
#define Neko_NeedResetNoPlayer 10
#define Neko_NeedResetTime 11
#define Cvar_Max 12

ConVar NCvar[Cvar_Max], GCvar[GetCvar_Max];

int MENU_TIME = 60;
int MenuPageItem[MAXPLAYERS+1], VoteMenuItemValue[MAXPLAYERS+1], AdminMenuPageItem[MAXPLAYERS+1];

char VoteMenuItems[MAXPLAYERS+1][512], WaitForVoteItems[MAXPLAYERS+1][512], SubMenuVoteItems[MAXPLAYERS+1][512];

bool BoolWaitForVoteItems[MAXPLAYERS+1];

Menu N_MenuVoteMenu[MAXPLAYERS+1], N_MenuAdminMenu[MAXPLAYERS+1];

public Plugin myinfo =
{
	name = "Neko Vote Menu",
	description = "Neko Specials Vote Menu",
	author = "Neko Channel",
	version = PLUGIN_VERSION,
	url = "https://himeneko.cn/nekospecials"
	//请勿修改插件信息！
};

public void OnPluginStart()
{
	AutoExecConfig_SetFile(PLUGIN_CONFIG);
	AutoExecConfig_SetCreateFile(true);	//不需要生成文件请改为false

	NCvar[Neko_CanSwitch] = 			AutoExecConfig_CreateConVar("Neko_CanSwitch", "0", "[0=关|1=开]全局投票开关", _, true, 0.0, true, 1.0);
	NCvar[Neko_SwitchStatus] = 			AutoExecConfig_CreateConVar("Neko_SwitchStatus", "0", "[0=关|1=开]玩家是否能投票更改插件状态", _, true, 0.0, true, 1.0);
	NCvar[Neko_SwitchNumber] = 			AutoExecConfig_CreateConVar("Neko_SwitchNumber", "0", "[0=关|1=开]玩家是否能投票更改特感数量", _, true, 0.0, true, 1.0);
	NCvar[Neko_SwitchTime] = 			AutoExecConfig_CreateConVar("Neko_SwitchTime", "0", "[0=关|1=开]玩家是否能投票更改刷特时间", _, true, 0.0, true, 1.0);
	NCvar[Neko_SwitchRandom] = 			AutoExecConfig_CreateConVar("Neko_SwitchRandom", "0", "[0=关|1=开]玩家是否能投票开关随机特感", _, true, 0.0, true, 1.0);
	NCvar[Neko_SwitchGameMode] = 		AutoExecConfig_CreateConVar("Neko_SwitchGameMode", "0", "[0=关|1=开]玩家是否能投票更改插件特感模式", _, true, 0.0, true, 1.0);
	NCvar[Neko_SwitchSpawnMode] = 		AutoExecConfig_CreateConVar("Neko_SwitchSpawnMode", "0", "[0=关|1=开]玩家是否能投票更改插件刷特模式", _, true, 0.0, true, 1.0);
	NCvar[Neko_SwitchPlayerJoin] = 		AutoExecConfig_CreateConVar("Neko_SwitchPlayerJoin", "0", "[0=关|1=开]玩家是否能投票设置根据玩家加入数量变动特感数量功能", _, true, 0.0, true, 1.0);
	NCvar[Neko_SwitchTankAlive] = 		AutoExecConfig_CreateConVar("Neko_SwitchTankAlive", "0", "[0=关|1=开]玩家是否能开关坦克存活时依旧刷特功能", _, true, 0.0, true, 1.0);
	NCvar[Neko_NeedResetNoPlayer] =		AutoExecConfig_CreateConVar("Neko_NeedResetNoPlayer", "0", "[0=关|1=开]全部玩家离开游戏后自动重置特感数据", _, true, 0.0, true, 1.0);
	NCvar[Neko_NeedResetTime] =			AutoExecConfig_CreateConVar("Neko_NeedResetTime", "10", "全部玩家离开游戏多少秒后自动重置");

	AutoExecConfig_OnceExec();

	HookEventEx("player_disconnect", 	Event_PlayerDisconnect, 	EventHookMode_Pre);

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
	for(int i=1;i < GetCvar_Max;i++)
	{
		if(i == CGame_Difficulty)
			continue;

		GCvar[i] = NekoSpecials_GetConVar(i);
	}
}

public any NekoVote_REPlHandle(Handle plugin, int numParams)
{
	return GetMyHandle();
}

public any NekoVote_REVoteStatus(Handle plugin, int numParams)
{
	return NCvar[Neko_CanSwitch].BoolValue;
}

public Action Event_PlayerDisconnect(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (!IsValidClient(client) || IsFakeClient(client))
		return Plugin_Continue;
	
	if (!RealPlayerExist(client) && NCvar[Neko_NeedResetNoPlayer].BoolValue)
		CreateTimer(float(NCvar[Neko_NeedResetTime].IntValue), Timer_CheckPlayers);

	return Plugin_Continue;
}

public Action Timer_CheckPlayers(Handle timer, any UserId)
{
	if (!RealPlayerExist())
	{
		NekoSpecials_ReLoadAllConfig();
		LogMessage("[NekoVote] Reset Specials Config!");
	}
	return Plugin_Stop;
}

stock bool RealPlayerExist(int Exclude = 0)
{
	for (int client = 1; client < MaxClients; client++)
	{
		if (client != Exclude && IsClientConnected(client))
			if (!IsFakeClient(client))
				return true;
	}
	return false;
}

public Action OpenVoteMenu(int client, int args)
{
	NekoVoteMenu(client).Display(client, MENU_TIME);
	return Plugin_Continue;
}

public Action OpenVoteAdminMenu(int client, int args)
{
	NekoVoteAdminMenu(client).Display(client, MENU_TIME);
	return Plugin_Continue;
}

public Action OnClientSayCommand(int client, const char[] command, const char[] args)
{
	static char voteCommands[][] = {"tgvote",".tgvote","!TGVOTE","TGVOTE",".TGVOTE"};

	for (int i = 0; i < sizeof(voteCommands); i++)
	{ 
		if (strcmp(args[0], voteCommands[i], false) == 0)
		{
			NekoVoteMenu(client).Display(client, MENU_TIME);
			break;
		}
	}

	return Plugin_Continue;
}

public Menu NekoVoteAdminMenu(int client)
{
	if(!IsValidClient(client))
		return null;
	
	N_MenuAdminMenu[client] = new Menu(AdminMenuHandler);

	char line[2048];

	Format(line, sizeof(line), "+|NS|+ 投票管理菜单\n控制玩家的权限\n选择一项切换");
	N_MenuAdminMenu[client].SetTitle(line);

	Format(line, sizeof(line), "投票插件状态 [%s]", !NCvar[Neko_CanSwitch].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swplu", line);

	Format(line, sizeof(line), "投票多特开关 [%s]", !NCvar[Neko_SwitchStatus].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swstat", line);

	Format(line, sizeof(line), "投票特感数量 [%s]", !NCvar[Neko_SwitchNumber].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swnum", line);

	Format(line, sizeof(line), "投票刷新时间 [%s]", !NCvar[Neko_SwitchTime].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swtime", line);

	Format(line, sizeof(line), "投票随机特感 [%s]", !NCvar[Neko_SwitchRandom].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swrandom", line);

	Format(line, sizeof(line), "投票游戏模式 [%s]", !NCvar[Neko_SwitchGameMode].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swgm", line);

	Format(line, sizeof(line), "投票刷新模式 [%s]", !NCvar[Neko_SwitchSpawnMode].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swsm", line);

	Format(line, sizeof(line), "投票玩家进出增加数量 [%s]", !NCvar[Neko_SwitchPlayerJoin].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swpj", line);

	Format(line, sizeof(line), "投票坦克存活刷特状态 [%s]", !NCvar[Neko_SwitchTankAlive].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swtank", line);

	Format(line, sizeof(line), "无人自动重置特感配置 [%s]", !NCvar[Neko_NeedResetNoPlayer].BoolValue ? "关" : "开");
	N_MenuAdminMenu[client].AddItem("swtreload", line);

	Format(line, sizeof(line), "重载配置文件");
	N_MenuAdminMenu[client].AddItem("swreload", line);

	Format(line, sizeof(line), "写入配置文件");
	N_MenuAdminMenu[client].AddItem("swfilewr", line);

	Format(line, sizeof(line), "重置配置文件");
	N_MenuAdminMenu[client].AddItem("swreset", line);

	Format(line, sizeof(line), "具体如何设置请查看CFG\n或插件说明\n插件版本:%s", PLUGIN_VERSION);
	N_MenuAdminMenu[client].AddItem("info", line, ITEMDRAW_DISABLED);

	N_MenuAdminMenu[client].ExitBackButton = true;

	return N_MenuAdminMenu[client];
}

public int AdminMenuHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			if(IsValidClient(client))
			{
				char items[50];
				AdminMenuPageItem[client] = GetMenuSelectionPosition();
				N_MenuAdminMenu[client] = null;
				menu.GetItem(selection, items, sizeof(items));
				if(StrEqual(items, "swplu"))
					NCvar[Neko_CanSwitch].SetBool(!NCvar[Neko_CanSwitch].BoolValue);
				if(StrEqual(items, "swstat"))
					NCvar[Neko_SwitchStatus].SetBool(!NCvar[Neko_SwitchStatus].BoolValue);
				if(StrEqual(items, "swnum"))
					NCvar[Neko_SwitchNumber].SetBool(!NCvar[Neko_SwitchNumber].BoolValue);
				if(StrEqual(items, "swtime"))
					NCvar[Neko_SwitchTime].SetBool(!NCvar[Neko_SwitchTime].BoolValue);
				if(StrEqual(items, "swrandom"))
					NCvar[Neko_SwitchRandom].SetBool(!NCvar[Neko_SwitchRandom].BoolValue);
				if(StrEqual(items, "swgm"))
					NCvar[Neko_SwitchGameMode].SetBool(!NCvar[Neko_SwitchGameMode].BoolValue);
				if(StrEqual(items, "swsm"))
					NCvar[Neko_SwitchSpawnMode].SetBool(!NCvar[Neko_SwitchSpawnMode].BoolValue);
				if(StrEqual(items, "swpj"))
					NCvar[Neko_SwitchPlayerJoin].SetBool(!NCvar[Neko_SwitchPlayerJoin].BoolValue);
				if(StrEqual(items, "swtank"))
					NCvar[Neko_SwitchTankAlive].SetBool(!NCvar[Neko_SwitchTankAlive].BoolValue);
				if(StrEqual(items, "swreload"))
					AutoExecConfig_OnceExec();
				if(StrEqual(items, "swfilewr"))
					UpdateConfigFile(false);
				if(StrEqual(items, "swreset"))
					UpdateConfigFile(true);
				if(StrEqual(items, "swtreload"))
					NCvar[Neko_NeedResetNoPlayer].SetBool(!NCvar[Neko_NeedResetNoPlayer].BoolValue);

				for (int i = 1; i <= MaxClients; i++)
					N_MenuVoteMenu[i] = null;

				CreateTimer(0.1, Timer_ReloadAdminMenu, GetClientUserId(client));
			}
		}
		case MenuAction_End:
		{
			delete menu;
			if(IsValidClient(client))
				N_MenuAdminMenu[client] = null;
		}
	}
	return 0;
}

void UpdateConfigFile(bool NeedReset)
{
	AutoExecConfig_DeleteConfig();

	for(int i = 1;i < Cvar_Max;i++)
		AutoExecConfig_UpdateToConfig(NCvar[i], NeedReset);

	AutoExecConfig_OnceExec();
}

public Menu NekoVoteMenu(int client)
{
	if(!IsValidClient(client))
		return null;
	
	N_MenuVoteMenu[client] = new Menu(VoteMenuHandler);

	char line[2048];
	int itemsflags = ITEMDRAW_DEFAULT;

	if(GCvar[CSpecial_PluginStatus].BoolValue)
		Format(line, sizeof(line), "+|NS|+ 特感玩家菜单\n刷特进程[%s]\n特感数量[%d] 刷特时间[%d]", !GetSpecialRunning() ? "未开始" : "已开始", NekoSpecials_GetSpecialsNum(), NekoSpecials_GetSpecialsTime());
	else
		Format(line, sizeof(line), "+|NS|+ 特感玩家菜单\n插件已关闭");
	N_MenuVoteMenu[client].SetTitle(line);

	if(!NCvar[Neko_CanSwitch].BoolValue)
		itemsflags = ITEMDRAW_DISABLED;

	Format(line, sizeof(line), "插件目前状态 [%s]", !GCvar[CSpecial_PluginStatus].BoolValue ? "关" : "开");
	N_MenuVoteMenu[client].AddItem("tgstat", line, !NCvar[Neko_SwitchStatus].BoolValue ? ITEMDRAW_DISABLED : itemsflags);

	if(GCvar[CSpecial_PluginStatus].BoolValue)
	{
		Format(line, sizeof(line), "全局刷特时间 [%ds]", GCvar[CSpecial_Spawn_Time].IntValue);
		if(!GCvar[CSpecial_Spawn_Time_DifficultyChange].BoolValue)
			N_MenuVoteMenu[client].AddItem("tgtime", line, !NCvar[Neko_SwitchTime].BoolValue ? ITEMDRAW_DISABLED : itemsflags);
		else
			N_MenuVoteMenu[client].AddItem("tgtime", line, ITEMDRAW_DISABLED);
	
		Format(line, sizeof(line), "初始刷特数量 [%d]", GCvar[CSpecial_Num].IntValue);
		N_MenuVoteMenu[client].AddItem("tgnum", line, !NCvar[Neko_SwitchNumber].BoolValue ? ITEMDRAW_DISABLED : itemsflags);
	
		Format(line, sizeof(line), "进人增加数量 [%d]", GCvar[CSpecial_AddNum].IntValue);
		N_MenuVoteMenu[client].AddItem("tgadd", line, !NCvar[Neko_SwitchNumber].BoolValue ? ITEMDRAW_DISABLED : itemsflags);

		Format(line, sizeof(line), "初始玩家数量 [%d]", GCvar[CSpecial_PlayerNum].IntValue);
		N_MenuVoteMenu[client].AddItem("tgpnum", line, !NCvar[Neko_SwitchPlayerJoin].BoolValue ? ITEMDRAW_DISABLED : itemsflags);
	
		Format(line, sizeof(line), "玩家增加数量 [%d]", GCvar[CSpecial_PlayerAdd].IntValue);
		N_MenuVoteMenu[client].AddItem("tgpadd", line, !NCvar[Neko_SwitchPlayerJoin].BoolValue ? ITEMDRAW_DISABLED : itemsflags);

		Format(line, sizeof(line), "克活着时刷新 [%s]", !GCvar[CSpecial_Spawn_Tank_Alive].BoolValue ? "否" : "是");
		N_MenuVoteMenu[client].AddItem("tgtanklive", line, !NCvar[Neko_SwitchTankAlive].BoolValue ? ITEMDRAW_DISABLED : itemsflags);

		char nowmode[64], spawnmode[64];

		switch(GCvar[CSpecial_Default_Mode].IntValue)
		{
			case 1: Format(nowmode, sizeof(nowmode), "猎人");
			case 2: Format(nowmode, sizeof(nowmode), "牛子");
			case 3: Format(nowmode, sizeof(nowmode), "猴子");
			case 4: Format(nowmode, sizeof(nowmode), "口水");
			case 5: Format(nowmode, sizeof(nowmode), "胖子");
			case 6: Format(nowmode, sizeof(nowmode), "舌头");
			default: Format(nowmode, sizeof(nowmode), "默认");
		}
		Format(line, sizeof(line), "特感游戏模式 [%s]", nowmode);
		N_MenuVoteMenu[client].AddItem("tgmode", line, !NCvar[Neko_SwitchGameMode].BoolValue ? ITEMDRAW_DISABLED : itemsflags);

		switch(NekoSpecials_GetSpawnMode())
		{
			case 0: Format(spawnmode, sizeof(spawnmode), "引擎");
			case 1: Format(spawnmode, sizeof(spawnmode), "普通");
			case 2: Format(spawnmode, sizeof(spawnmode), "噩梦");
			case 3: Format(spawnmode, sizeof(spawnmode), "地狱");
		}
		Format(line, sizeof(line), "特感刷新模式 [%s]", spawnmode);
		N_MenuVoteMenu[client].AddItem("tgspawn", line, !NCvar[Neko_SwitchSpawnMode].BoolValue ? ITEMDRAW_DISABLED : itemsflags);

		Format(line, sizeof(line), "随机特感状态 [%s]", !GCvar[CSpecial_Random_Mode].BoolValue ? "关" : "开");
		N_MenuVoteMenu[client].AddItem("tgrandom", line, !NCvar[Neko_SwitchRandom].BoolValue ? ITEMDRAW_DISABLED : itemsflags);
	}

	N_MenuVoteMenu[client].ExitBackButton = true;

	return N_MenuVoteMenu[client];
}

public int VoteMenuHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			if(IsValidClient(client))
			{
				if (!NativeVotes_IsNewVoteAllowed())
				{
					PrintToChat(client, "\x05%s \x04%d秒后才能开始投票", NEKOTAG, NativeVotes_CheckVoteDelay());
					return 0;
				}

				char items[50];
				MenuPageItem[client] = GetMenuSelectionPosition();
				cleanplayerwait(client);
				N_MenuVoteMenu[client] = null;
				menu.GetItem(selection, items, sizeof(items));
				bool NeedOpenMenu = true;

				if(StrEqual(items, "tgstat") || StrEqual(items, "tgrandom") || StrEqual(items, "tgtanklive"))
				{
					VoteMenuItems[client] = items;
					StartVoteYesNo(client);
				}
				if(StrEqual(items, "tgmode"))
				{
					SpecialMenuMode(client);
					NeedOpenMenu = false;
				}
				if(StrEqual(items, "tgspawn"))
				{
					SpecialMenuSpawn(client);
					NeedOpenMenu = false;
				}
				if(StrEqual(items, "tgtime") || StrEqual(items, "tgnum") || StrEqual(items, "tgadd") || StrEqual(items, "tgpnum") || StrEqual(items, "tgpadd"))
				{
					int DDMax, DDMin;
					char FChar[128];

					if(StrEqual(items, "tgtime"))
					{
						DDMax = 180;
						DDMin = 3;
						Format(FChar, sizeof FChar, "刷特时间");
					}
					else if(StrEqual(items, "tgnum"))
					{
						DDMax = 32;
						DDMin = 1;
						Format(FChar, sizeof FChar, "初始刷特数量");
					}
					else if(StrEqual(items, "tgadd"))
					{
						DDMax = 8;
						DDMin = 0;
						Format(FChar, sizeof FChar, "进人增加数量");
					}
					else if(StrEqual(items, "tgpnum"))
					{
						DDMax = 32;
						DDMin = 1;
						Format(FChar, sizeof FChar, "初始玩家数量");
					}
					else if(StrEqual(items, "tgpadd"))
					{
						DDMax = 8;
						DDMin = 1;
						Format(FChar, sizeof FChar, "玩家增加数量");
					}
					PrintToChat(client, "\x05%s \x04请在聊天栏输入你需要投票%s的数值 \x03范围[%d - %d]", NEKOTAG, FChar, DDMin, DDMax);
					WaitForVoteItems[client] = items;
					BoolWaitForVoteItems[client] = true;
				}
				if(NeedOpenMenu)
					CreateTimer(0.2, Timer_ReloadMenu, GetClientUserId(client));
			}
		}
		case MenuAction_End:
		{
			delete menu;
			if(IsValidClient(client))
				N_MenuVoteMenu[client] = null;
		}
	}

	return 0;
}

public Action SpecialMenuMode(int client)
{
	Menu menu = new Menu(SpecialMenuModeHandler);
	char line[1024];
	
	Format(line, sizeof(line), "+|NS|+ 选择特感模式\n选择一个模式");
	menu.SetTitle(line);
	
	Format(line, sizeof(line), "默认模式");
	menu.AddItem("7", line);
	Format(line, sizeof(line), "猎人模式");
	menu.AddItem("1", line);
	Format(line, sizeof(line), "牛子模式");
	menu.AddItem("2", line);
	Format(line, sizeof(line), "猴子模式");
	menu.AddItem("3", line);
	Format(line, sizeof(line), "口水模式");
	menu.AddItem("4", line);
	Format(line, sizeof(line), "胖子模式");
	menu.AddItem("5", line);
	Format(line, sizeof(line), "舌头模式");
	menu.AddItem("6", line);
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME);
	return Plugin_Handled;
}

public int SpecialMenuModeHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			if(IsValidClient(client))
			{
				char items[50];
				menu.GetItem(selection, items, sizeof(items));
				SubMenuVoteItems[client] = items;
				VoteMenuItems[client] = "tgmode";
				StartVoteYesNo(client);
			}
		}
		case MenuAction_Cancel:
		{
			if(IsValidClient(client) && selection == MenuCancel_ExitBack)
				NekoVoteMenu(client).DisplayAt(client, MenuPageItem[client], MENU_TIME);
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
	return 0;
}

public Action SpecialMenuSpawn(int client)
{
	Menu menu = new Menu(SpecialMenuSpawnHandler);
	char line[1024];
	
	Format(line, sizeof(line), "+|NS|+ 选择刷特模式\n选择一个模式");
	menu.SetTitle(line);
	
	Format(line, sizeof(line), "引擎刷特");
	menu.AddItem("0", line);
	Format(line, sizeof(line), "普通刷特");
	menu.AddItem("1", line);
	Format(line, sizeof(line), "噩梦刷特");
	menu.AddItem("2", line);
	Format(line, sizeof(line), "地狱刷特");
	menu.AddItem("3", line);
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME);
	return Plugin_Handled;
}

public int SpecialMenuSpawnHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			if(IsValidClient(client))
			{
				char items[50];
				menu.GetItem(selection, items, sizeof(items));
				SubMenuVoteItems[client] = items;
				VoteMenuItems[client] = "tgspawn";
				StartVoteYesNo(client);
			}
		}
		case MenuAction_Cancel:
		{
			if(IsValidClient(client) && selection == MenuCancel_ExitBack)
				NekoVoteMenu(client).DisplayAt(client, MenuPageItem[client], MENU_TIME);
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
	return 0;
}

void StartVoteYesNo(int client)
{
	if(!IsValidClient(client))
		return;

	if (!NativeVotes_IsNewVoteAllowed())
	{
		PrintToChat(client, "\x05%s \x04%d秒后才能开始投票", NEKOTAG, NativeVotes_CheckVoteDelay());
		return;
	}

	char buffer[512], sbuffer[512];

	if(StrEqual(VoteMenuItems[client], "tgstat"))
	{
		Format(buffer, sizeof buffer, "多特插件");
		Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_PluginStatus].BoolValue ? "开启" : "关闭");
	}
	if(StrEqual(VoteMenuItems[client], "tgrandom"))
	{
		Format(buffer, sizeof buffer, "随机特感");
		Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_Random_Mode].BoolValue ? "开启" : "关闭");
	}
	if(StrEqual(VoteMenuItems[client], "tgtanklive"))
	{
		Format(buffer, sizeof buffer, "坦克存活时刷新特感");
		Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_Spawn_Tank_Alive].BoolValue ? "开启" : "关闭");
	}
	if(StrEqual(VoteMenuItems[client], "tgtime"))
	{
		Format(buffer, sizeof buffer, "刷特时间为");
		Format(sbuffer, sizeof sbuffer, "%ds", VoteMenuItemValue[client]);
	}
	if(StrEqual(VoteMenuItems[client], "tgnum"))
	{
		Format(buffer, sizeof buffer, "初始刷特数量为");
		Format(sbuffer, sizeof sbuffer, "%d特", VoteMenuItemValue[client]);
	}
	if(StrEqual(VoteMenuItems[client], "tgadd"))
	{
		Format(buffer, sizeof buffer, "进人增加数量为");
		Format(sbuffer, sizeof sbuffer, "%d特", VoteMenuItemValue[client]);
	}
	if(StrEqual(VoteMenuItems[client], "tgpnum"))
	{
		Format(buffer, sizeof buffer, "初始玩家数量为");
		Format(sbuffer, sizeof sbuffer, "%d人", VoteMenuItemValue[client]);
	}
	if(StrEqual(VoteMenuItems[client], "tgpadd"))
	{
		Format(buffer, sizeof buffer, "玩家增加数量为");
		Format(sbuffer, sizeof sbuffer, "%d人", VoteMenuItemValue[client]);
	}
	if(StrEqual(VoteMenuItems[client], "tgmode"))
	{
		switch(StringToInt(SubMenuVoteItems[client]))
		{
			case 1: Format(sbuffer, sizeof(sbuffer), "猎人");
			case 2: Format(sbuffer, sizeof(sbuffer), "牛子");
			case 3: Format(sbuffer, sizeof(sbuffer), "猴子");
			case 4: Format(sbuffer, sizeof(sbuffer), "口水");
			case 5: Format(sbuffer, sizeof(sbuffer), "胖子");
			case 6: Format(sbuffer, sizeof(sbuffer), "舌头");
			default: Format(sbuffer, sizeof(sbuffer), "默认");
		}
		Format(buffer, sizeof buffer, "游戏模式为");
	}
	if(StrEqual(VoteMenuItems[client], "tgspawn"))
	{
		switch(StringToInt(SubMenuVoteItems[client]))
		{
			case 0: Format(sbuffer, sizeof(sbuffer), "引擎");
			case 1: Format(sbuffer, sizeof(sbuffer), "普通");
			case 2: Format(sbuffer, sizeof(sbuffer), "噩梦");
			case 3: Format(sbuffer, sizeof(sbuffer), "地狱");
		}
		Format(buffer, sizeof buffer, "刷特模式为");
	}

	NativeVote vote = new NativeVote(VoteYesNoH, NativeVotesType_Custom_YesNo);
	vote.Initiator = client;
	vote.SetDetails("投票%s %s", buffer, sbuffer);
	vote.DisplayVoteToAll(15);
}

public int VoteYesNoH(NativeVote vote, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_End:
		{
			vote.Close();
		}
		
		case MenuAction_VoteCancel:
		{
			if (param1 == VoteCancel_NoVotes)
			{
				vote.DisplayFail(NativeVotesFail_NotEnoughVotes);
			}
			else
			{
				vote.DisplayFail(NativeVotesFail_Generic);
			}
		}
		
		case MenuAction_VoteEnd:
		{
			if (param1 == NATIVEVOTES_VOTE_NO)
			{
				vote.DisplayFail(NativeVotesFail_Loses);
			}
			else
			{
				char buffer[512], sbuffer[512], item[512];
				int client = vote.Initiator;
				item = VoteMenuItems[client];
				if(StrEqual(item, "tgstat"))
				{
					Format(buffer, sizeof buffer, "多特插件");
					Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_PluginStatus].BoolValue ? "开启" : "关闭");
					GCvar[CSpecial_PluginStatus].SetBool(!GCvar[CSpecial_PluginStatus].BoolValue);
				}
				if(StrEqual(item, "tgrandom"))
				{
					Format(buffer, sizeof buffer, "随机特感");
					Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_Random_Mode].BoolValue ? "开启" : "关闭");
					GCvar[CSpecial_Random_Mode].SetBool(!GCvar[CSpecial_Random_Mode].BoolValue);
				}
				if(StrEqual(item, "tgtanklive"))
				{
					Format(buffer, sizeof buffer, "坦克存活时刷新特感");
					Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_Spawn_Tank_Alive].BoolValue ? "开启" : "关闭");
					GCvar[CSpecial_Spawn_Tank_Alive].SetBool(!GCvar[CSpecial_Spawn_Tank_Alive].BoolValue);
				}
				if(StrEqual(item, "tgtime"))
				{
					Format(buffer, sizeof buffer, "刷特时间为");
					Format(sbuffer, sizeof sbuffer, "%ds", VoteMenuItemValue[client]);
					GCvar[CSpecial_Spawn_Time].SetInt(VoteMenuItemValue[client]);
				}
				if(StrEqual(item, "tgnum"))
				{
					Format(buffer, sizeof buffer, "初始刷特数量为");
					Format(sbuffer, sizeof sbuffer, "%d特", VoteMenuItemValue[client]);
					GCvar[CSpecial_Num].SetInt(VoteMenuItemValue[client]);
				}
				if(StrEqual(item, "tgadd"))
				{
					Format(buffer, sizeof buffer, "进人增加数量为");
					Format(sbuffer, sizeof sbuffer, "%d特", VoteMenuItemValue[client]);
					GCvar[CSpecial_AddNum].SetInt(VoteMenuItemValue[client]);
				}
				if(StrEqual(item, "tgpnum"))
				{
					Format(buffer, sizeof buffer, "初始玩家数量为");
					Format(sbuffer, sizeof sbuffer, "%d人", VoteMenuItemValue[client]);
					GCvar[CSpecial_PlayerNum].SetInt(VoteMenuItemValue[client]);
				}
				if(StrEqual(item, "tgpadd"))
				{
					Format(buffer, sizeof buffer, "玩家增加数量为");
					Format(sbuffer, sizeof sbuffer, "%d人", VoteMenuItemValue[client]);
					GCvar[CSpecial_PlayerAdd].SetInt(VoteMenuItemValue[client]);
				}
				if(StrEqual(item, "tgmode"))
				{
					switch(StringToInt(SubMenuVoteItems[client]))
					{
						case 1: Format(sbuffer, sizeof(sbuffer), "猎人");
						case 2: Format(sbuffer, sizeof(sbuffer), "牛子");
						case 3: Format(sbuffer, sizeof(sbuffer), "猴子");
						case 4: Format(sbuffer, sizeof(sbuffer), "口水");
						case 5: Format(sbuffer, sizeof(sbuffer), "胖子");
						case 6: Format(sbuffer, sizeof(sbuffer), "舌头");
						default: Format(sbuffer, sizeof(sbuffer), "默认");
					}
					Format(buffer, sizeof buffer, "游戏模式为");

					GCvar[CSpecial_Default_Mode].SetInt(StringToInt(SubMenuVoteItems[client]));

					if(GCvar[CSpecial_Show_Tips].BoolValue)
						NekoSpecials_ShowSpecialsModeTips();

					if(GCvar[CSpecial_Random_Mode].BoolValue)
					{
						GCvar[CSpecial_Random_Mode].SetBool(false);
						PrintToChatAll("\x05%s \x04关闭了随机特感", NEKOTAG);
					}
				}
				if(StrEqual(item, "tgspawn"))
				{
					switch(StringToInt(SubMenuVoteItems[client]))
					{
						case 0: Format(sbuffer, sizeof(sbuffer), "引擎");
						case 1: Format(sbuffer, sizeof(sbuffer), "普通");
						case 2: Format(sbuffer, sizeof(sbuffer), "噩梦");
						case 3: Format(sbuffer, sizeof(sbuffer), "地狱");
					}
					Format(buffer, sizeof buffer, "刷特模式为");

					GCvar[CSpecial_Spawn_Mode].SetInt(StringToInt(SubMenuVoteItems[client]));

					PrintToChatAll("\x05%s \x04特感刷新方式更改为 \x03%s刷特模式", NEKOTAG, sbuffer);
				}
				vote.DisplayPass("投票%s %s 通过!!!", buffer, sbuffer);

				cleanplayerchar(client);

				CreateTimer(0.2, Timer_ReloadMenu, GetClientUserId(client));
			}
		}
	}

	return 0;
}

public Action ChatListener(int client, const char[] command, int args)
{
	if(!IsValidClient(client) || IsFakeClient(client) || IsChatTrigger())
		return Plugin_Handled;
	
	char msg[128];
	
	GetCmdArgString(msg, sizeof(msg));
	StripQuotes(msg);

	if (!NativeVotes_IsNewVoteAllowed())
	{
		PrintToChat(client, "\x05%s \x04%d秒后才能开始投票", NEKOTAG, NativeVotes_CheckVoteDelay());
		cleanplayerwait(client);
		return Plugin_Handled;
	}

	if(BoolWaitForVoteItems[client])
	{
		int DD;

		if (StrEqual(msg, "!cancel"))
		{
			PrintToChat(client, "\x05%s \x04本次操作取消", NEKOTAG);
			cleanplayerwait(client);
			cleanplayerchar(client);
			return Plugin_Handled;
		}
		
		if(!IsInteger(msg))
		{
			PrintToChat(client, "\x05%s \x04输入有误 \x03请检查", NEKOTAG);
			return Plugin_Handled;
		}
		else
			DD = StringToInt(msg);

		int DDMax, DDMin;
		char FChar[128];

		if(StrEqual(WaitForVoteItems[client], "tgtime"))
		{
			DDMax = 180;
			DDMin = 3;
			Format(FChar, sizeof FChar, "刷特时间");
		}
		else if(StrEqual(WaitForVoteItems[client], "tgnum"))
		{
			DDMax = 32;
			DDMin = 1;
			Format(FChar, sizeof FChar, "初始刷特数量");
		}
		else if(StrEqual(WaitForVoteItems[client], "tgadd"))
		{
			DDMax = 8;
			DDMin = 0;
			Format(FChar, sizeof FChar, "进人增加数量");
		}
		else if(StrEqual(WaitForVoteItems[client], "tgpnum"))
		{
			DDMax = 32;
			DDMin = 1;
			Format(FChar, sizeof FChar, "初始玩家数量");
		}
		else if(StrEqual(WaitForVoteItems[client], "tgpadd"))
		{
			DDMax = 8;
			DDMin = 1;
			Format(FChar, sizeof FChar, "玩家增加数量");
		}

		if(DD < DDMin || DD > DDMax)
		{
			PrintToChat(client, "\x05%s \x04输入的%s有误，请重试 \x03范围[%d - %d]", NEKOTAG, FChar, DDMin, DDMax);
			return Plugin_Continue;
		}
		else
		{
			VoteMenuItems[client] = WaitForVoteItems[client];
			VoteMenuItemValue[client] = DD;
			StartVoteYesNo(client);
		}

		cleanplayerwait(client);

		return Plugin_Handled;
	}
	return Plugin_Continue;
}

void cleanplayerwait(int client)
{
	BoolWaitForVoteItems[client] = false;
}

void cleanplayerchar(int client)
{
	VoteMenuItemValue[client] = 0;
	VoteMenuItems[client] = "";
	WaitForVoteItems[client] = "";
	SubMenuVoteItems[client] = "";
}

public Action Timer_ReloadMenu(Handle timer, any client) 
{
	client = GetClientOfUserId(client);
	if (IsValidClient(client))
		NekoVoteMenu(client).DisplayAt(client, MenuPageItem[client], MENU_TIME);
	return Plugin_Continue;
}

public Action Timer_ReloadAdminMenu(Handle timer, any client) 
{
	client = GetClientOfUserId(client);
	if (IsValidClient(client))
		NekoVoteAdminMenu(client).DisplayAt(client, AdminMenuPageItem[client], MENU_TIME);
	return Plugin_Continue;
}