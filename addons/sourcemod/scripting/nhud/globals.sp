
#define PLUGIN_CONFIG			  "Neko_KillHud_binhooks"

#define CKillHud_FriendlyFire	  1
#define CKillHud_KillSpecials	  2
#define CKillHud_KillTank		  3
#define CKillHud_AllKill		  4
#define CKillHud_HudStyle		  5
#define CKillHud_AllowBot		  6
#define CKillHud_Show			  7
#define CKillHud_CStyleFriendXY	  8
#define CKillHud_CStyleSpecialsXY 9
#define CKillHud_CStyleTankXY	  10
#define CKillHud_CStyleAllKillXY  11
#define CKillHud_StyleChatDelay	  12
#define CKillHud_AllKillStyle2	  13
#define CKillHud_ShowMorePlayer	  14
#define CKillHud_ShowTankWitch	  15
#define Cvar_Max				  16

int MENU_TIME = 60;

enum struct ClientState
{
	int	 Kill_Infected;
	int	 Friendly_Fire;
	int	 Friendly_Hurt;
	int	 Kill_Zombie;
	int	 DmgToTank;

	void Reset()
	{
		this.Kill_Infected = 0;
		this.Friendly_Fire = 0;
		this.Friendly_Hurt = 0;
		this.Kill_Zombie   = 0;
		this.DmgToTank	   = 0;
	}
}

ClientState Neko_ClientInfo[MAXPLAYERS + 1];

enum struct GlobalState
{
	int	 Kill_AllZombie;
	int	 Kill_AllInfected;
	int	 Kill_AllZombieGO;
	int	 Kill_AllInfectedGO;

	int	 Kill_AllTank;
	int	 Kill_AllWitch;
	int	 Kill_AllTankGO;
	int	 Kill_AllWitchGO;

	void Reset()
	{
		this.Kill_AllZombie	  = 0;
		this.Kill_AllInfected = 0; 
		this.Kill_AllTank	  = 0;
		this.Kill_AllWitch	  = 0;
	}

	void ResetGO()
	{
		this.Kill_AllZombieGO	= 0;
		this.Kill_AllInfectedGO = 0;
		this.Kill_AllTankGO		= 0;
		this.Kill_AllWitchGO	= 0;
	}
}

GlobalState Neko_GlobalState;

bool		TankAlive, HudRunning, IsMapTransition;

char   		HudStyleName[5][50] = { "关闭中", "样式1", "样式2", "自定义", "聊天栏" };

int			StyleChatDelay;

char		CorePath[PLATFORM_MAX_PATH];

ConVar		NCvar[Cvar_Max];

Menu		N_MenuHudMenu[MAXPLAYERS + 1];