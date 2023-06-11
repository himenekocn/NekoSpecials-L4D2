
#define PLUGIN_CONFIG "Neko_KillHud_binhooks"

#define CKillHud_FriendlyFire 1
#define CKillHud_KillSpecials 2
#define CKillHud_KillTank 3
#define CKillHud_AllKill 4
#define CKillHud_HudStyle 5
#define CKillHud_AllowBot 6
#define CKillHud_Show 7
#define CKillHud_CStyleFriendXY 8
#define CKillHud_CStyleSpecialsXY 9
#define CKillHud_CStyleTankXY 10
#define CKillHud_CStyleAllKillXY 11
#define CKillHud_StyleChatDelay 12
#define CKillHud_AllKillStyle2 13
#define Cvar_Max 14

int MENU_TIME = 60;

int Kill_Infected[MAXPLAYERS+1], Friendly_Fire[MAXPLAYERS+1], Friendly_Hurt[MAXPLAYERS+1], Kill_Zombie[MAXPLAYERS+1], DmgToTank[MAXPLAYERS+1], Kill_AllZombie, Kill_AllInfected, StyleChatDelay, Kill_AllZombieGO, Kill_AllInfectedGO;

bool TankAlive , HudRunning, IsMapTransition;

char CorePath[PLATFORM_MAX_PATH];

ConVar NCvar[Cvar_Max];

Menu N_MenuHudMenu[MAXPLAYERS+1];