#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <dhooks>
#include <left4dhooks>
#include <binhooks>
#include <ns>
#include "nspecials/nekonative.inc"

#define PLUGIN_CONFIG "Neko_Specials_binhooks"
#define NEKOTAG "[NS]"

int MENU_TIME = 60;

int MenuPageItem[MAXPLAYERS+1], Special_Spawn_Time, Special_Default_Mode, Special_Num, Special_AddNum, Special_Spawn_Mode, Special_Boomer_Num, Special_Smoker_Num, Special_Charger_Num, Special_Hunter_Num, Special_Spitter_Num, Special_Jockey_Num, Special_PlayerAdd, Special_PlayerNum, Special_Spawn_Time_Easy, Special_Spawn_Time_Normal, Special_Spawn_Time_Hard, Special_Spawn_Time_Impossible, Special_IsModeInNormal, Special_Boomer_Spawn_Weight, Special_Smoker_Spawn_Weight, Special_Charger_Spawn_Weight, Special_Hunter_Spawn_Weight, Special_Spitter_Spawn_Weight, Special_Jockey_Spawn_Weight, Special_Boomer_Spawn_DirChance, Special_Smoker_Spawn_DirChance, Special_Charger_Spawn_DirChance, Special_Hunter_Spawn_DirChance, Special_Spitter_Spawn_DirChance, Special_Jockey_Spawn_DirChance, Special_Boomer_Spawn_MaxDis, Special_Smoker_Spawn_MaxDis, Special_Charger_Spawn_MaxDis, Special_Hunter_Spawn_MaxDis, Special_Spitter_Spawn_MaxDis, Special_Jockey_Spawn_MaxDis, Special_Boomer_Spawn_MinDis, Special_Smoker_Spawn_MinDis, Special_Charger_Spawn_MinDis, Special_Hunter_Spawn_MinDis, Special_Spitter_Spawn_MinDis, Special_Jockey_Spawn_MinDis, Special_Spawn_MinDis, Special_Spawn_MaxDis;

float Special_LeftPoint_SpawnTime;

bool WaitingForTgtime[MAXPLAYERS+1], WaitingForTgnum[MAXPLAYERS+1], WaitingForTgadd[MAXPLAYERS+1], WaitingForTgCustom[MAXPLAYERS+1], WaitingForTgCustomWeight[MAXPLAYERS+1], WaitingForTgCustomDirChance[MAXPLAYERS+1], WaitingForPadd[MAXPLAYERS+1], WaitingForPnum[MAXPLAYERS+1], WaitingForTgCustomMaxDis[MAXPLAYERS+1], WaitingForTgCustomMinDis[MAXPLAYERS+1], WaitingForTgCustomMaxDisNor[MAXPLAYERS+1], WaitingForTgCustomMinDisNor[MAXPLAYERS+1], IsPlayerLeftCP, Special_Fast_Response, Special_Show_Tips, Special_Spawn_Tank_Alive, Special_Random_Mode, Special_AutoKill_StuckTank, Special_PluginStatus, Special_Show_Tips_Chat, Special_PlayerCountSpec, Special_CanCloseDirector, Special_Spawn_Time_DifficultyChange, Special_Boomer_Spawn_Area, Special_Smoker_Spawn_Area, Special_Charger_Spawn_Area, Special_Hunter_Spawn_Area, Special_Spitter_Spawn_Area, Special_Jockey_Spawn_Area, Special_Num_NotCul_Death, Special_Spawn_Tank_Alive_Pro;

char WaitingForTgCustomItem[MAXPLAYERS+1][50], WaitingForTgTimeType[MAXPLAYERS+1][50], WaitingForTgCustomWeightItem[MAXPLAYERS+1][50], WaitingForTgCustomDirChanceItem[MAXPLAYERS+1][50], WaitingForTgCustomMinDisItem[MAXPLAYERS+1][50], WaitingForTgCustomMaxDisItem[MAXPLAYERS+1][50];

ConVar CSpecial_Fast_Response, CSpecial_Spawn_Time, CSpecial_Random_Mode, CSpecial_Default_Mode, CSpecial_Show_Tips, CSpecial_Spawn_Tank_Alive, CSpecial_Num, CSpecial_AddNum, CSpecial_PlayerAdd, CSpecial_PlayerNum, CSpecial_Spawn_Mode, CSpecial_Boomer_Num, CSpecial_Smoker_Num, CSpecial_Charger_Num, CSpecial_Hunter_Num, CSpecial_Spitter_Num, CSpecial_Jockey_Num, CSpecial_AutoKill_StuckTank, CSpecial_LeftPoint_SpawnTime, CSpecial_PluginStatus, CSpecial_Show_Tips_Chat, CSpecial_PlayerCountSpec, CSpecial_CanCloseDirector, CGame_Difficulty, CSpecial_Spawn_Time_DifficultyChange, CSpecial_Spawn_Time_Easy, CSpecial_Spawn_Time_Normal, CSpecial_Spawn_Time_Hard, CSpecial_Spawn_Time_Impossible, CSpecial_IsModeInNormal, CSpecial_Boomer_Spawn_Weight, CSpecial_Smoker_Spawn_Weight, CSpecial_Charger_Spawn_Weight, CSpecial_Hunter_Spawn_Weight, CSpecial_Spitter_Spawn_Weight, CSpecial_Jockey_Spawn_Weight, CSpecial_Boomer_Spawn_DirChance, CSpecial_Smoker_Spawn_DirChance, CSpecial_Charger_Spawn_DirChance, CSpecial_Hunter_Spawn_DirChance, CSpecial_Spitter_Spawn_DirChance, CSpecial_Jockey_Spawn_DirChance, CSpecial_Boomer_Spawn_Area, CSpecial_Smoker_Spawn_Area, CSpecial_Charger_Spawn_Area, CSpecial_Hunter_Spawn_Area, CSpecial_Spitter_Spawn_Area, CSpecial_Jockey_Spawn_Area, CSpecial_Boomer_Spawn_MaxDis, CSpecial_Smoker_Spawn_MaxDis, CSpecial_Charger_Spawn_MaxDis, CSpecial_Hunter_Spawn_MaxDis, CSpecial_Spitter_Spawn_MaxDis, CSpecial_Jockey_Spawn_MaxDis, CSpecial_Boomer_Spawn_MinDis, CSpecial_Smoker_Spawn_MinDis, CSpecial_Charger_Spawn_MinDis, CSpecial_Hunter_Spawn_MinDis, CSpecial_Spitter_Spawn_MinDis, CSpecial_Jockey_Spawn_MinDis, CSpecial_Spawn_MaxDis, CSpecial_Spawn_MinDis, CSpecial_Num_NotCul_Death, CSpecial_Spawn_Tank_Alive_Pro;

Menu N_MenuSpecialMenu[MAXPLAYERS+1], N_SpecialMenuCustom[MAXPLAYERS+1], N_SpecialMenuCustomWeight[MAXPLAYERS+1], N_SpecialMenuCustomDirChance[MAXPLAYERS+1], N_SpecialMenuCustomSpawnArea[MAXPLAYERS+1], N_SpecialMenuCustomMaxDis[MAXPLAYERS+1], N_SpecialMenuCustomMinDis[MAXPLAYERS+1];

GlobalForward N_Forward_OnSetSpecialsNum, N_Forward_OnSetSpecialsTime, N_Forward_OnStartFirstSpawn;

public Plugin myinfo =
{
	name = "Neko Specials Spawner",
	description = "Neko Specials Spawner Base on Binhooks",
	author = "Neko Channel & Mr Cheng",
	version = PLUGIN_VERSION,
	url = "http://himeneko.cn"
	//请勿修改插件信息！
};

public void OnPluginStart()
{
	AutoExecConfig_SetFile(PLUGIN_CONFIG);
	AutoExecConfig_SetCreateFile(true);	//不需要生成文件请改为false
	
	CSpecial_PluginStatus = AutoExecConfig_CreateConVar("Special_PluginStatus", "1", "[0=关|1=开]禁用/启用刷特[禁用后插件将不会刷出特感，若Special_CanCloseDirector为打开状态，将会一只特感都不会刷出]", _, true, 0.0, true, 1.0);
	CSpecial_Fast_Response = AutoExecConfig_CreateConVar("Special_Fast_Response", "1", "[0=关|1=开]禁用/启用更快的特殊感染反应[建议开着就好]", _, true, 0.0, true, 1.0);
	CSpecial_CanCloseDirector = AutoExecConfig_CreateConVar("Special_CanCloseDirector", "0", "[0=关|1=开]是否插件控制导演系统开关[若刷不出坦克请关掉此选项，此选项能让单一特感刷新模式时防止其他类型的特感刷出来，如果发现开了单一特感类型刷新时会出现其他特感，请开启，开启后请配合boss_spawn插件食用]", _, true, 0.0, true, 1.0);
	
	CSpecial_LeftPoint_SpawnTime = AutoExecConfig_CreateConVar("Special_LeftPoint_SpawnTime", "5.0", "离开安全区域后多久刷特[默认5.0秒]", _, true, 0.1, true, 120.0);
	CSpecial_Spawn_Time = AutoExecConfig_CreateConVar("Special_Spawn_Time", "28", "全局特感刷新时间间隔[3-180]", _, true, 3.0, true, 180.0);
	CSpecial_Spawn_Time_DifficultyChange = AutoExecConfig_CreateConVar("Special_Spawn_Time_DifficultyChange", "0", "[0=关|1=开]禁用/启用根据游戏难度改变刷特时间[启用后-全局特感刷新时间间隔-将不会生效]", _, true, 0.0, true, 1.0);
	CSpecial_Spawn_Time_Easy = AutoExecConfig_CreateConVar("Special_Spawn_Time_Easy", "25", "简单难度特感刷新时间间隔[3-180]", _, true, 3.0, true, 180.0);
	CSpecial_Spawn_Time_Normal = AutoExecConfig_CreateConVar("Special_Spawn_Time_Normal", "20", "普通难度特感刷新时间间隔[3-180]", _, true, 3.0, true, 180.0);
	CSpecial_Spawn_Time_Hard = AutoExecConfig_CreateConVar("Special_Spawn_Time_Hard", "15", "高级难度特感刷新时间间隔[3-180]", _, true, 3.0, true, 180.0);
	CSpecial_Spawn_Time_Impossible = AutoExecConfig_CreateConVar("Special_Spawn_Time_Impossible", "10", "专家难度特感刷新时间间隔[3-180]", _, true, 3.0, true, 180.0);

	CSpecial_Num = AutoExecConfig_CreateConVar("Special_Num", "4", "特感初始的刷新数量[1-32]", _, true, 1.0, true, 32.0);
	CSpecial_AddNum = AutoExecConfig_CreateConVar("Special_AddNum", "1", "特感每次进人增加数量[0-8][前提请设置Special_PlayerAdd]", _, true, 0.0, true, 8.0);
	CSpecial_PlayerNum = AutoExecConfig_CreateConVar("Special_PlayerNum", "4", "玩家初始计算人数[1-32][意思为从第几个玩家开始，来增加特感数量，低于或等于这个数值则按Special_Num的数量刷特，如果不会弄就不需要改这个]", _, true, 1.0, true, 32.0);
	CSpecial_PlayerAdd = AutoExecConfig_CreateConVar("Special_PlayerAdd", "1", "玩家增加数量[1-8][玩家每进几个人，才增加Special_AddNum数量的特感，Special_AddNum不为0才生效]", _, true, 1.0, true, 8.0);
	CSpecial_PlayerCountSpec = AutoExecConfig_CreateConVar("Special_PlayerCountSpec", "0", "[0=关|1=开]计算玩家人数时，是否把旁观者也算进去[这个会把旁观者也算进去，非常不建议打开!]", _, true, 0.0, true, 1.0);
	CSpecial_Num_NotCul_Death = AutoExecConfig_CreateConVar("Special_Num_NotCul_Death", "0", "[0=关|1=开]计算玩家人数时，不把死亡玩家也算进去[这个不会把死亡玩家也算进去，非常不建议打开!]", _, true, 0.0, true, 1.0);

	CSpecial_Random_Mode = AutoExecConfig_CreateConVar("Special_Random_Mode", "0", "[0=关|1=开]启用随机特感[开启后会随机Special_Default_Mode中包含的模式，仅供娱乐]", _, true, 0.0, true, 1.0);
	CSpecial_Default_Mode = AutoExecConfig_CreateConVar("Special_Default_Mode", "7", "指定刷新模式(当随机特感关闭生效)[1=全猎人|2=全牛|3=全猴子|4=全口水|5=全胖子|6=全舌头|7=默认][默认模式为全部特感类型都会刷新，其他为单一类型刷新]", _, true, 1.0, true, 8.0);
	CSpecial_Spawn_Mode = AutoExecConfig_CreateConVar("Special_Spawn_Mode", "1", "[0=引擎|1=普通|2=噩梦|3=地狱]特感生成方式[引擎就是游戏自带的导演系统，普通是插件默认选项比较适合普通玩家，噩梦与地狱适合大佬游玩，地狱是最高难度，噩梦与地狱刷特位置会比较近]", _, true, 0.0, true, 3.0);
	CSpecial_IsModeInNormal = AutoExecConfig_CreateConVar("Special_IsModeInNormal", "1", "[1=模式1(默认)|2=模式2]在Special_Spawn_Mode的普通、噩梦、地狱模式下有效的子模式,只有1和2可选，具体说明请看插件的说明书。", _, true, 1.0, true, 2.0);
	
	CSpecial_Spawn_Tank_Alive = AutoExecConfig_CreateConVar("Special_Spawn_Tank_Alive", "1", "[0=关|1=开]特感是否在坦克活着时刷新", _, true, 0.0, true, 1.0);
	CSpecial_Spawn_Tank_Alive_Pro = AutoExecConfig_CreateConVar("Special_Spawn_Tank_Alive_Pro", "0", "[0=关|1=开]当坦克活着时，特感强制在刷新的时候被踢出[开启后可试图修复CSpecial_Spawn_Tank_Alive关闭后坦克存活依旧刷特问题]", _, true, 0.0, true, 1.0);
	CSpecial_AutoKill_StuckTank = AutoExecConfig_CreateConVar("Special_AutoKill_StuckTank", "0", "[0=关|1=开]自动处死卡住的坦克[有防卡插件可以关闭]", _, true, 0.0, true, 1.0);
	
	CSpecial_Show_Tips = AutoExecConfig_CreateConVar("Special_Show_Tips", "1", "[0=关|1=开]显示特感数量改变提示", _, true, 0.0, true, 1.0);
	CSpecial_Show_Tips_Chat = AutoExecConfig_CreateConVar("Special_Show_Tips_Chat", "0", "[0=关|1=开]将特感改变提示变为聊天框输出，关闭就使用HUD显示", _, true, 0.0, true, 1.0);
	
	CSpecial_Boomer_Num = AutoExecConfig_CreateConVar("Special_Boomer_Num", "4", "Boomer最大刷新数量[当指定默认刷新模式时生效]", _, true, 0.0, true, 32.0);
	CSpecial_Smoker_Num = AutoExecConfig_CreateConVar("Special_Smoker_Num", "4", "Smoker最大刷新数量[当指定默认刷新模式时生效]", _, true, 0.0, true, 32.0);
	CSpecial_Charger_Num = AutoExecConfig_CreateConVar("Special_Charger_Num", "4", "Charger最大刷新数量[当指定默认刷新模式时生效]", _, true, 0.0, true, 32.0);
	CSpecial_Hunter_Num = AutoExecConfig_CreateConVar("Special_Hunter_Num", "4", "Hunter最大刷新数量[当指定默认刷新模式时生效]", _, true, 0.0, true, 32.0);
	CSpecial_Spitter_Num = AutoExecConfig_CreateConVar("Special_Spitter_Num", "4", "Spitter最大刷新数量[当指定默认刷新模式时生效]", _, true, 0.0, true, 32.0);
	CSpecial_Jockey_Num = AutoExecConfig_CreateConVar("Special_Jockey_Num", "4", "Jockey最大刷新数量[当指定默认刷新模式时生效]", _, true, 0.0, true, 32.0);

	CSpecial_Boomer_Spawn_Weight = AutoExecConfig_CreateConVar("Special_Boomer_Spawn_Weight", "50", "Boomer刷新概率[范围1-100|当其他特感也设置了数量时生效]", _, true, 1.0, true, 100.0);
	CSpecial_Smoker_Spawn_Weight = AutoExecConfig_CreateConVar("Special_Smoker_Spawn_Weight", "50", "Smoker刷新概率[范围1-100|当其他特感也设置了数量时生效]", _, true, 1.0, true, 100.0);
	CSpecial_Charger_Spawn_Weight = AutoExecConfig_CreateConVar("Special_Charger_Spawn_Weight", "50", "Charger刷新概率[范围1-100|当其他特感也设置了数量时生效]", _, true, 1.0, true, 100.0);
	CSpecial_Hunter_Spawn_Weight = AutoExecConfig_CreateConVar("Special_Hunter_Spawn_Weight", "50", "Hunter刷新概率[范围1-100|当其他特感也设置了数量时生效]", _, true, 1.0, true, 100.0);
	CSpecial_Spitter_Spawn_Weight = AutoExecConfig_CreateConVar("Special_Spitter_Spawn_Weight", "50", "Spitter刷新概率[范围1-100|当其他特感也设置了数量时生效]", _, true, 1.0, true, 100.0);
	CSpecial_Jockey_Spawn_Weight = AutoExecConfig_CreateConVar("Special_Jockey_Spawn_Weight", "50", "Jockey刷新概率[范围1-100|当其他特感也设置了数量时生效]", _, true, 1.0, true, 100.0);

	CSpecial_Boomer_Spawn_DirChance = AutoExecConfig_CreateConVar("Special_Boomer_Spawn_DirChance", "50", "Boomer刷新方位概率，数值越大越容易刷在前方，数值越小越容易刷在后方[范围1-100|仅梦魇和炼狱模式有效]", _, true, 1.0, true, 100.0);
	CSpecial_Smoker_Spawn_DirChance = AutoExecConfig_CreateConVar("Special_Smoker_Spawn_DirChance", "50", "Smoker刷新方位概率，数值越大越容易刷在前方，数值越小越容易刷在后方[范围1-100|仅梦魇和炼狱模式有效]", _, true, 1.0, true, 100.0);
	CSpecial_Charger_Spawn_DirChance = AutoExecConfig_CreateConVar("Special_Charger_Spawn_DirChance", "50", "Charger刷新方位概率，数值越大越容易刷在前方，数值越小越容易刷在后方[范围1-100|仅梦魇和炼狱模式有效]", _, true, 1.0, true, 100.0);
	CSpecial_Hunter_Spawn_DirChance = AutoExecConfig_CreateConVar("Special_Hunter_Spawn_DirChance", "50", "Hunter刷新方位概率，数值越大越容易刷在前方，数值越小越容易刷在后方[范围1-100|仅梦魇和炼狱模式有效]", _, true, 1.0, true, 100.0);
	CSpecial_Spitter_Spawn_DirChance = AutoExecConfig_CreateConVar("Special_Spitter_Spawn_DirChance", "50", "Spitter刷新方位概率，数值越大越容易刷在前方，数值越小越容易刷在后方[范围1-100|仅梦魇和炼狱模式有效]", _, true, 1.0, true, 100.0);
	CSpecial_Jockey_Spawn_DirChance = AutoExecConfig_CreateConVar("Special_Jockey_Spawn_DirChance", "50", "Jockey刷新方位概率，数值越大越容易刷在前方，数值越小越容易刷在后方[范围1-100|仅梦魇和炼狱模式有效]", _, true, 1.0, true, 100.0);
	
	CSpecial_Boomer_Spawn_Area = AutoExecConfig_CreateConVar("Special_Boomer_Spawn_Area", "1", "Boomer刷新区域，0为产生在官方区域，1为产生在任何区域[仅梦魇和炼狱模式有效]", _, true, 0.0, true, 1.0);
	CSpecial_Smoker_Spawn_Area = AutoExecConfig_CreateConVar("Special_Smoker_Spawn_Area", "1", "Smoker刷新区域，0为产生在官方区域，1为产生在任何区域[仅梦魇和炼狱模式有效]", _, true, 0.0, true, 1.0);
	CSpecial_Charger_Spawn_Area = AutoExecConfig_CreateConVar("Special_Charger_Spawn_Area", "1", "Charger刷新区域，0为产生在官方区域，1为产生在任何区域[仅梦魇和炼狱模式有效]", _, true, 0.0, true, 1.0);
	CSpecial_Hunter_Spawn_Area = AutoExecConfig_CreateConVar("Special_Hunter_Spawn_Area", "1", "Hunter刷新区域，0为产生在官方区域，1为产生在任何区域[仅梦魇和炼狱模式有效]", _, true, 0.0, true, 1.0);
	CSpecial_Spitter_Spawn_Area = AutoExecConfig_CreateConVar("Special_Spitter_Spawn_Area", "1", "Spitter刷新区域，0为产生在官方区域，1为产生在任何区域[仅梦魇和炼狱模式有效]", _, true, 0.0, true, 1.0);
	CSpecial_Jockey_Spawn_Area = AutoExecConfig_CreateConVar("Special_Jockey_Spawn_Area", "1", "Jockey刷新区域，0为产生在官方区域，1为产生在任何区域[仅梦魇和炼狱模式有效]", _, true, 0.0, true, 1.0);

	CSpecial_Boomer_Spawn_MaxDis = AutoExecConfig_CreateConVar("Special_Boomer_Spawn_MaxDis", "2000", "Boomer刷新最大距离[范围不能小于1|仅梦魇和炼狱模式有效]", _, true, 1.0, false);
	CSpecial_Smoker_Spawn_MaxDis = AutoExecConfig_CreateConVar("Special_Smoker_Spawn_MaxDis", "2000", "Smoker刷新最大距离[范围不能小于1|仅梦魇和炼狱模式有效]", _, true, 1.0, false);
	CSpecial_Charger_Spawn_MaxDis = AutoExecConfig_CreateConVar("Special_Charger_Spawn_MaxDis", "2000", "Charger刷新最大距离[范围不能小于1|仅梦魇和炼狱模式有效]", _, true, 1.0, false);
	CSpecial_Hunter_Spawn_MaxDis = AutoExecConfig_CreateConVar("Special_Hunter_Spawn_MaxDis", "2000", "Hunter刷新最大距离[范围不能小于1|仅梦魇和炼狱模式有效]", _, true, 1.0, false);
	CSpecial_Spitter_Spawn_MaxDis = AutoExecConfig_CreateConVar("Special_Spitter_Spawn_MaxDis", "2000", "Spitter刷新最大距离[范围不能小于1|仅梦魇和炼狱模式有效]", _, true, 1.0, false);
	CSpecial_Jockey_Spawn_MaxDis = AutoExecConfig_CreateConVar("Special_Jockey_Spawn_MaxDis", "2000", "Jockey刷新最大距离[范围不能小于1|仅梦魇和炼狱模式有效]", _, true, 1.0, false);

	CSpecial_Boomer_Spawn_MinDis = AutoExecConfig_CreateConVar("Special_Boomer_Spawn_MinDis", "32", "Boomer刷新最小距离[范围不能小于1|仅梦魇和炼狱模式有效]", _, true, 1.0, false);
	CSpecial_Smoker_Spawn_MinDis = AutoExecConfig_CreateConVar("Special_Smoker_Spawn_MinDis", "32", "Smoker刷新最小距离[范围不能小于1|仅梦魇和炼狱模式有效]", _, true, 1.0, false);
	CSpecial_Charger_Spawn_MinDis = AutoExecConfig_CreateConVar("Special_Charger_Spawn_MinDis", "32", "Charger刷新最小距离[范围不能小于1|仅梦魇和炼狱模式有效]", _, true, 1.0, false);
	CSpecial_Hunter_Spawn_MinDis = AutoExecConfig_CreateConVar("Special_Hunter_Spawn_MinDis", "32", "Hunter刷新最小距离[范围不能小于1|仅梦魇和炼狱模式有效]", _, true, 1.0, false);
	CSpecial_Spitter_Spawn_MinDis = AutoExecConfig_CreateConVar("Special_Spitter_Spawn_MinDis", "32", "Spitter刷新最小距离[范围不能小于1|仅梦魇和炼狱模式有效]", _, true, 1.0, false);
	CSpecial_Jockey_Spawn_MinDis = AutoExecConfig_CreateConVar("Special_Jockey_Spawn_MinDis", "32", "Jockey刷新最小距离[范围不能小于1|仅梦魇和炼狱模式有效]", _, true, 1.0, false);

	CSpecial_Spawn_MaxDis = AutoExecConfig_CreateConVar("Special_Spawn_MaxDis", "2000", "全部特感刷新最大距离[范围不能小于1|仅引擎和普通模式有效]", _, true, 1.0, false);
	CSpecial_Spawn_MinDis = AutoExecConfig_CreateConVar("Special_Spawn_MinDis", "32", "全部特感刷新最小距离[范围不能小于1|仅引擎和普通模式有效]", _, true, 1.0, false);
	
	CGame_Difficulty = FindConVar("z_difficulty");

	AutoExecConfig_OnceExec();
	
	HookEvent("round_start", OnRoundStart);
	HookEvent("tank_spawn", OnTankSpawn);
	HookEvent("tank_killed", OnTankDeath);
	HookEvent("player_death", OnPlayerDeath);
	HookEvent("player_spawn", OnPlayerSpawn);
	HookEvent("mission_lost",OnRoundEnd);
	HookEvent("round_end", OnRoundEnd);
	HookEvent("player_team", player_team);
	HookEvent("player_disconnect", OnPlayerDisconnect, EventHookMode_Pre);	
	
	SetCvarHook();
	GetCvarsValues();
	SetAISpawnInit();
	
	AddCommandListener(ChatListener, "say");
	AddCommandListener(ChatListener, "say2");
	AddCommandListener(ChatListener, "say_team");
	
	RegAdminCmd("sm_ntg", OpenSpecialMenu, ADMFLAG_ROOT, "打开管理员特感菜单");
	RegAdminCmd("sm_ntgversion", SpecialVersionCMD, ADMFLAG_ROOT, "Neko多特版本&状态查询");
	RegAdminCmd("sm_reloadntgconfig", ReloadNTGConfig, ADMFLAG_ROOT, "重载多特配置文件");
}

#include "nspecials/native.sp"
#include "nspecials/cmd.sp"
#include "nspecials/hooks.sp"
#include "nspecials/menus.sp"
#include "nspecials/events.sp"
#include "nspecials/timer.sp"
#include "nspecials/api.sp"

public void OnConfigsExecuted()
{
	SetAISpawnInit();
	TgModeStartSet();
	UpdateSpawnWeight();
	UpdateSpawnDirChance();
	UpdateSpawnArea();
	UpdateSpawnDistance();

	for (int i = 1; i <= MaxClients; i++)
	{
		cleanplayerwait(i);
		MenuPageItem[i] = 0;
	}
}

public void OnMapEnd()
{
	SetSpecialRunning(false);
	IsPlayerLeftCP = false;
}

public void CvarsChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	GetCvarsValues();
}

public void DifficultyChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	CheckDifficulty();
}

void SetCvarHook()
{
	CSpecial_PluginStatus.AddChangeHook(CvarsChanged);
	CSpecial_Fast_Response.AddChangeHook(CvarsChanged);
	CSpecial_Spawn_Time.AddChangeHook(CvarsChanged);
	CSpecial_Num.AddChangeHook(CvarsChanged);
	CSpecial_AddNum.AddChangeHook(CvarsChanged);
	CSpecial_Random_Mode.AddChangeHook(CvarsChanged);
	CSpecial_Default_Mode.AddChangeHook(CvarsChanged);
	CSpecial_Spawn_Mode.AddChangeHook(CvarsChanged);
	CSpecial_Spawn_Tank_Alive.AddChangeHook(CvarsChanged);
	CSpecial_AutoKill_StuckTank.AddChangeHook(CvarsChanged);
	CSpecial_LeftPoint_SpawnTime.AddChangeHook(CvarsChanged);
	CSpecial_Show_Tips.AddChangeHook(CvarsChanged);
	CSpecial_Show_Tips_Chat.AddChangeHook(CvarsChanged);
	CSpecial_Boomer_Num.AddChangeHook(CvarsChanged);
	CSpecial_Smoker_Num.AddChangeHook(CvarsChanged);
	CSpecial_Charger_Num.AddChangeHook(CvarsChanged);
	CSpecial_Hunter_Num.AddChangeHook(CvarsChanged);
	CSpecial_Spitter_Num.AddChangeHook(CvarsChanged);
	CSpecial_Jockey_Num.AddChangeHook(CvarsChanged);
	CSpecial_PlayerNum.AddChangeHook(CvarsChanged);
	CSpecial_PlayerAdd.AddChangeHook(CvarsChanged);
	CSpecial_PlayerCountSpec.AddChangeHook(CvarsChanged);
	CSpecial_CanCloseDirector.AddChangeHook(CvarsChanged);
	
	CSpecial_Spawn_Time_DifficultyChange.AddChangeHook(CvarsChanged);
	CSpecial_Spawn_Time_Easy.AddChangeHook(CvarsChanged);
	CSpecial_Spawn_Time_Normal.AddChangeHook(CvarsChanged);
	CSpecial_Spawn_Time_Hard.AddChangeHook(CvarsChanged);
	CSpecial_Spawn_Time_Impossible.AddChangeHook(CvarsChanged);
	CSpecial_IsModeInNormal.AddChangeHook(CvarsChanged);
	CGame_Difficulty.AddChangeHook(DifficultyChanged);

	CSpecial_Boomer_Spawn_Weight.AddChangeHook(CvarsChanged);
	CSpecial_Smoker_Spawn_Weight.AddChangeHook(CvarsChanged);
	CSpecial_Charger_Spawn_Weight.AddChangeHook(CvarsChanged);
	CSpecial_Hunter_Spawn_Weight.AddChangeHook(CvarsChanged);
	CSpecial_Spitter_Spawn_Weight.AddChangeHook(CvarsChanged);
	CSpecial_Jockey_Spawn_Weight.AddChangeHook(CvarsChanged);

	CSpecial_Boomer_Spawn_DirChance.AddChangeHook(CvarsChanged);
	CSpecial_Smoker_Spawn_DirChance.AddChangeHook(CvarsChanged);
	CSpecial_Charger_Spawn_DirChance.AddChangeHook(CvarsChanged);
	CSpecial_Hunter_Spawn_DirChance.AddChangeHook(CvarsChanged);
	CSpecial_Spitter_Spawn_DirChance.AddChangeHook(CvarsChanged);
	CSpecial_Jockey_Spawn_DirChance.AddChangeHook(CvarsChanged);

	CSpecial_Boomer_Spawn_MaxDis.AddChangeHook(CvarsChanged);
	CSpecial_Smoker_Spawn_MaxDis.AddChangeHook(CvarsChanged);
	CSpecial_Charger_Spawn_MaxDis.AddChangeHook(CvarsChanged);
	CSpecial_Hunter_Spawn_MaxDis.AddChangeHook(CvarsChanged);
	CSpecial_Spitter_Spawn_MaxDis.AddChangeHook(CvarsChanged);
	CSpecial_Jockey_Spawn_MaxDis.AddChangeHook(CvarsChanged);

	CSpecial_Boomer_Spawn_MinDis.AddChangeHook(CvarsChanged);
	CSpecial_Smoker_Spawn_MinDis.AddChangeHook(CvarsChanged);
	CSpecial_Charger_Spawn_MinDis.AddChangeHook(CvarsChanged);
	CSpecial_Hunter_Spawn_MinDis.AddChangeHook(CvarsChanged);
	CSpecial_Spitter_Spawn_MinDis.AddChangeHook(CvarsChanged);
	CSpecial_Jockey_Spawn_MinDis.AddChangeHook(CvarsChanged);

	CSpecial_Charger_Spawn_Area.AddChangeHook(CvarsChanged);
	CSpecial_Boomer_Spawn_Area.AddChangeHook(CvarsChanged);
	CSpecial_Spitter_Spawn_Area.AddChangeHook(CvarsChanged);
	CSpecial_Smoker_Spawn_Area.AddChangeHook(CvarsChanged);
	CSpecial_Jockey_Spawn_Area.AddChangeHook(CvarsChanged);
	CSpecial_Hunter_Spawn_Area.AddChangeHook(CvarsChanged);

	CSpecial_Spawn_MaxDis.AddChangeHook(CvarsChanged);
	CSpecial_Spawn_MinDis.AddChangeHook(CvarsChanged);
	CSpecial_Num_NotCul_Death.AddChangeHook(CvarsChanged);
	CSpecial_Spawn_Tank_Alive_Pro.AddChangeHook(CvarsChanged);
}

void GetCvarsValues()
{
	Special_PluginStatus = CSpecial_PluginStatus.BoolValue;
	Special_Fast_Response = CSpecial_Fast_Response.BoolValue;
	Special_Spawn_Time = CSpecial_Spawn_Time.IntValue;
	Special_Num = CSpecial_Num.IntValue;
	Special_AddNum = CSpecial_AddNum.IntValue;
	Special_Random_Mode = CSpecial_Random_Mode.BoolValue;
	Special_Default_Mode = CSpecial_Default_Mode.IntValue;
	Special_Spawn_Mode = CSpecial_Spawn_Mode.IntValue;
	Special_Spawn_Tank_Alive = CSpecial_Spawn_Tank_Alive.BoolValue;
	Special_Spawn_Tank_Alive_Pro = CSpecial_Spawn_Tank_Alive_Pro.BoolValue;
	Special_AutoKill_StuckTank = CSpecial_AutoKill_StuckTank.BoolValue;
	Special_LeftPoint_SpawnTime = CSpecial_LeftPoint_SpawnTime.FloatValue;
	Special_Show_Tips = CSpecial_Show_Tips.BoolValue;
	Special_Show_Tips_Chat = CSpecial_Show_Tips_Chat.BoolValue;
	Special_Boomer_Num = CSpecial_Boomer_Num.IntValue;
	Special_Smoker_Num = CSpecial_Smoker_Num.IntValue;
	Special_Charger_Num = CSpecial_Charger_Num.IntValue;
	Special_Hunter_Num = CSpecial_Hunter_Num.IntValue;
	Special_Spitter_Num = CSpecial_Spitter_Num.IntValue;
	Special_Jockey_Num = CSpecial_Jockey_Num.IntValue;
	Special_PlayerAdd = CSpecial_PlayerAdd.IntValue;
	Special_PlayerNum = CSpecial_PlayerNum.IntValue;
	Special_PlayerCountSpec = CSpecial_PlayerCountSpec.BoolValue;
	Special_Num_NotCul_Death = CSpecial_Num_NotCul_Death.BoolValue;
	Special_CanCloseDirector = CSpecial_CanCloseDirector.BoolValue;
	Special_Spawn_Time_DifficultyChange = CSpecial_Spawn_Time_DifficultyChange.BoolValue;
	Special_Spawn_Time_Easy = CSpecial_Spawn_Time_Easy.IntValue;
	Special_Spawn_Time_Normal = CSpecial_Spawn_Time_Normal.IntValue;
	Special_Spawn_Time_Hard = CSpecial_Spawn_Time_Hard.IntValue;
	Special_Spawn_Time_Impossible = CSpecial_Spawn_Time_Impossible.IntValue;
	Special_IsModeInNormal = CSpecial_IsModeInNormal.IntValue;

	Special_Boomer_Spawn_Weight = CSpecial_Boomer_Spawn_Weight.IntValue;
	Special_Smoker_Spawn_Weight = CSpecial_Smoker_Spawn_Weight.IntValue;
	Special_Charger_Spawn_Weight = CSpecial_Charger_Spawn_Weight.IntValue;
	Special_Hunter_Spawn_Weight = CSpecial_Hunter_Spawn_Weight.IntValue;
	Special_Spitter_Spawn_Weight = CSpecial_Spitter_Spawn_Weight.IntValue;
	Special_Jockey_Spawn_Weight = CSpecial_Jockey_Spawn_Weight.IntValue;

	Special_Boomer_Spawn_DirChance = CSpecial_Boomer_Spawn_DirChance.IntValue;
	Special_Smoker_Spawn_DirChance = CSpecial_Smoker_Spawn_DirChance.IntValue;
	Special_Charger_Spawn_DirChance = CSpecial_Charger_Spawn_DirChance.IntValue;
	Special_Hunter_Spawn_DirChance = CSpecial_Hunter_Spawn_DirChance.IntValue;
	Special_Spitter_Spawn_DirChance = CSpecial_Spitter_Spawn_DirChance.IntValue;
	Special_Jockey_Spawn_DirChance = CSpecial_Jockey_Spawn_DirChance.IntValue;

	Special_Boomer_Spawn_Area = CSpecial_Boomer_Spawn_Area.BoolValue;
	Special_Smoker_Spawn_Area = CSpecial_Smoker_Spawn_Area.BoolValue;
	Special_Charger_Spawn_Area = CSpecial_Charger_Spawn_Area.BoolValue;
	Special_Hunter_Spawn_Area = CSpecial_Hunter_Spawn_Area.BoolValue;
	Special_Spitter_Spawn_Area = CSpecial_Spitter_Spawn_Area.BoolValue;
	Special_Jockey_Spawn_Area = CSpecial_Jockey_Spawn_Area.BoolValue;

	Special_Boomer_Spawn_MaxDis = CSpecial_Boomer_Spawn_MaxDis.IntValue;
	Special_Smoker_Spawn_MaxDis = CSpecial_Smoker_Spawn_MaxDis.IntValue;
	Special_Charger_Spawn_MaxDis = CSpecial_Charger_Spawn_MaxDis.IntValue;
	Special_Hunter_Spawn_MaxDis = CSpecial_Hunter_Spawn_MaxDis.IntValue;
	Special_Spitter_Spawn_MaxDis = CSpecial_Spitter_Spawn_MaxDis.IntValue;
	Special_Jockey_Spawn_MaxDis = CSpecial_Jockey_Spawn_MaxDis.IntValue;

	Special_Boomer_Spawn_MinDis = CSpecial_Boomer_Spawn_MinDis.IntValue;
	Special_Smoker_Spawn_MinDis = CSpecial_Smoker_Spawn_MinDis.IntValue;
	Special_Charger_Spawn_MinDis = CSpecial_Charger_Spawn_MinDis.IntValue;
	Special_Hunter_Spawn_MinDis = CSpecial_Hunter_Spawn_MinDis.IntValue;
	Special_Spitter_Spawn_MinDis = CSpecial_Spitter_Spawn_MinDis.IntValue;
	Special_Jockey_Spawn_MinDis = CSpecial_Jockey_Spawn_MinDis.IntValue;

	Special_Spawn_MaxDis = CSpecial_Spawn_MaxDis.IntValue;
	Special_Spawn_MinDis = CSpecial_Spawn_MinDis.IntValue;

	RequestFrame(UpdateNekoAllSettings);
}