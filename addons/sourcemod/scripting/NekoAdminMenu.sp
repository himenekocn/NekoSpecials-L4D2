#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <adminmenu>
#include "nadmin/nekonative.inc"
#include "nspecials/nekonative.inc"
#include "nhud/nekonative.inc"
#include <ns>

#define SPECIALS_AVAILABLE()	(GetFeatureStatus(FeatureType_Native, "NekoSpecials_GetSpecialsNum") == FeatureStatus_Available)
#define NKILLHUD_AVAILABLE()	(GetFeatureStatus(FeatureType_Native, "NekoKillHud_GetStatus") == FeatureStatus_Available)

TopMenu top_menu = null;
TopMenuObject obj_dmcommands, hud_menu, specials_menu;

public Plugin myinfo =
{
	name = "Neko Admin Menu",
	description = "Neko HUD%SPECIALS Admin Menu!",
	author = "Neko Channel",
	version = PLUGIN_VERSION,
	url = "http://himeneko.cn"
	//请勿修改插件信息！
};

public void OnPluginStart()
{
	if(LibraryExists("adminmenu") && ((top_menu = GetAdminTopMenu()) != null))
		OnAdminMenuReady(top_menu);
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("nekoadminmenu");
	
	CreateNative("NekoAdminMenu_PlHandle", NekoAdminMenu_REPlHandle);
	
	MarkNativeAsOptional("NekoSpecials_GetSpecialsNum");
	MarkNativeAsOptional("NekoSpecials_GetSpecialsTime");
	MarkNativeAsOptional("NekoSpecials_GetSpawnMode");
	MarkNativeAsOptional("NekoSpecials_GetSpecialsMode");
	MarkNativeAsOptional("NekoSpecials_GetPluginStatus");
	MarkNativeAsOptional("NekoKillHud_GetStatus");
	MarkNativeAsOptional("NekoKillHud_GetStyle");
	
	return APLRes_Success;
}

public any NekoAdminMenu_REPlHandle(Handle plugin, int numParams)
{
	return GetMyHandle();
}

public void OnLibraryRemoved(const char[] name)
{
	if(StrEqual(name, "adminmenu", false))
		top_menu = null;
}

public void OnAdminMenuReady(Handle aTopMenu) 
{
	TopMenu topmenu = TopMenu.FromHandle(aTopMenu);
	if (topmenu == top_menu && obj_dmcommands != INVALID_TOPMENUOBJECT) return;
	top_menu = topmenu;
	AddToTopMenu(topmenu, "nsmenu", TopMenuObject_Category, CategoryHandler, INVALID_TOPMENUOBJECT);
	
	TopMenuObject neko_menu = FindTopMenuCategory(top_menu, "nsmenu");
	if (neko_menu == INVALID_TOPMENUOBJECT) return;

	specials_menu = AddToTopMenu(top_menu, "sm_ntg", TopMenuObject_Item, AdminMenu_Neko, neko_menu, "sm_ntg", ADMFLAG_SLAY);
	hud_menu = AddToTopMenu(top_menu, "sm_nhud", TopMenuObject_Item, AdminMenu_Neko, neko_menu, "sm_nhud", ADMFLAG_SLAY);
}

public void CategoryHandler(TopMenu topmenu, TopMenuAction action, TopMenuObject object_id, int client, char[] buffer, int maxlength) 
{
	if (action == TopMenuAction_DisplayTitle)
		Format(buffer, maxlength, "+|NS|+ 功能菜单\n当前版本: %s", PLUGIN_VERSION);
	else if (action == TopMenuAction_DisplayOption)
		Format(buffer, maxlength, "+|NS|+ 功能菜单");
}
 
public void AdminMenu_Neko(TopMenu topmenu, TopMenuAction action, TopMenuObject object_id, int client, char[] buffer, int maxlength)
{
	if(action == TopMenuAction_DisplayOption)
	{
		if (object_id == specials_menu)
		{	
			if(SPECIALS_AVAILABLE())
			{
				if(NekoSpecials_GetPluginStatus())
				{
					char nowmode[64], spawnmode[64];
					
					switch(NekoSpecials_GetSpecialsMode())
					{
						case 1: Format(nowmode, sizeof(nowmode), "猎人");
						case 2: Format(nowmode, sizeof(nowmode), "牛");
						case 3: Format(nowmode, sizeof(nowmode), "猴子");
						case 4: Format(nowmode, sizeof(nowmode), "口水");
						case 5: Format(nowmode, sizeof(nowmode), "胖子");
						case 6: Format(nowmode, sizeof(nowmode), "舌头");
						default: Format(nowmode, sizeof(nowmode), "默认");
					}
		
					switch(NekoSpecials_GetSpawnMode())
					{
						case 0: Format(spawnmode, sizeof(spawnmode), "引擎");
						case 1: Format(spawnmode, sizeof(spawnmode), "普通");
						case 2: Format(spawnmode, sizeof(spawnmode), "噩梦");
						case 3: Format(spawnmode, sizeof(spawnmode), "地狱");
					
					}
					Format(buffer, maxlength, "多特调节设置\n特感数量 [%d]\n刷特时间 [%d]\n现在模式 [%s]\n刷特模式 [%s]", NekoSpecials_GetSpecialsNum(), NekoSpecials_GetSpecialsTime(), nowmode, spawnmode);
				}
				else
				{
					Format(buffer, maxlength, "多特调节设置\n插件状态 [已关闭]", NekoSpecials_GetSpecialsNum(), NekoSpecials_GetSpecialsTime());
				}
			}
			else
			{
				Format(buffer, maxlength, "多特模块未安装");
			}
		}
		else
		if (object_id == hud_menu)
		{
			if(NKILLHUD_AVAILABLE())
			{
				if(NekoKillHud_GetStyle() == 0)
				{
					Format(buffer, maxlength, "击杀统计设置\nHUD状态 [已关闭]");
				}
				else
				{
					char statuss[64], style[64];
					if(NekoKillHud_GetStatus())
						Format(statuss, sizeof(statuss), "运行中");
					else
						Format(statuss, sizeof(statuss), "未运行");
					
					switch(NekoKillHud_GetStyle())
					{
						case 1:Format(style, sizeof(style), "样式1");
						case 2:Format(style, sizeof(style), "样式2");
						case 3:Format(style, sizeof(style), "自定义");
						case 4:Format(style, sizeof(style), "聊天栏");
					}

					Format(buffer, maxlength, "击杀统计设置\nHUD状态 [%s]\nHUD样式 [%s]", statuss, style);
				}
			}
			else
				Format(buffer, maxlength, "HUD模块未安装");
		}
	}
	else if (action == TopMenuAction_SelectOption)
	{
		if (object_id == specials_menu)
			FakeClientCommand(client, "sm_ntg");
		else
		if (object_id == hud_menu)
			FakeClientCommand(client, "sm_nhud");
	}
}