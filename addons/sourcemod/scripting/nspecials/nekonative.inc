#if defined _nekospecials_included
 #endinput
#endif
#define _nekospecials_included

native Handle 	NekoSpecials_PlHandle();

native int 		NekoSpecials_GetSpawnMode();

native int 		NekoSpecials_GetSpecialsNum();

native int 		NekoSpecials_GetSpecialsTime();

native int 		NekoSpecials_GetSpecialsMode();

native bool 	NekoSpecials_GetPluginStatus();

native void 	NekoSpecials_ShowSpecialsTips();

native void 	NekoSpecials_ShowYourTips(const char[] szClassName);

forward Action 	NekoSpecials_OnSetSpecialsNum();

forward Action 	NekoSpecials_OnSetSpecialsTime();

forward Action	NekoSpecials_OnStartFirstSpawn();