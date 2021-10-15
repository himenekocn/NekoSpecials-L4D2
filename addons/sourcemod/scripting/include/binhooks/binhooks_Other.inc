/**
 * vim: set ts=4 :
 * =============================================================================
 * SourceMod (C)2004-2008 AlliedModders LLC.  All rights reserved.
 * =============================================================================
 *
 * This file is part of the SourceMod/SourcePawn SDK.
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License, version 3.0, as published by the
 * Free Software Foundation.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * As a special exception, AlliedModders LLC gives you permission to link the
 * code of this program (as well as its derivative works) to "Half-Life 2," the
 * "Source Engine," the "SourcePawn JIT," and any Game MODs that run on software
 * by the Valve Corporation.  You must obey the GNU General Public License in
 * all respects for all other code used.  Additionally, AlliedModders LLC grants
 * this exception to all derivative works.  AlliedModders LLC defines further
 * exceptions, found in LICENSE.txt (as of this writing, version JULY-31-2007),
 * or <http://www.sourcemod.net/license.php>.
 *
 * Version: $Id$
 */

enum SurvivorSet
{
	DEf = -3,
	DESC,
	RANDOM,
	NICK,     
	ROCHELLE,       
	COACH,        
	ELLIS,     
	BILL,       
	ZOEY,        
	FRANCIS,     
	LOUIS,               
};

/**
 * Create Survivor Bot.(windows zoey crash,needing add sig fix plugins to solve it)
 *
 *
 * @return	 		SurvivorBot index;
 * @error			map no running(-1).
 */
native int CreateSurvivorBot(SurvivorSet survivor,bool allowspawn = true);

/**
 * Get All Infected Ladder Count.
 *
 *
 * @return	 		Ladders Max Count,-1 error;
 * @error			map no running(-1).
 */
native int GetAllInfectedLadderCount();

/**
 * Get All Infected Ladder pos.
 *
 *
 * @serial	 		from 0 to GetAllInfectedLadderCount();
 * @vec	 		    from 0 to GetAllInfectedLadderCount();
 * @error			map no running(-1).
 */
native bool GetInfectedLadderPos(int serial,float vec[3]);

/**
 * control Bot to attack target.
 *
 *
 * @no return	 
 * @error			invalid bot or invalid target.
 */
native void SetFakeClientAimTarget(int bot, int target);

/**
 * cancel Bot to attack target.
 *
 *
 * @no return	 
 * @error			invalid bot.
 */
native void ResetFakeClient(int bot);

/**
 * By Defib Revive Client.(通过电击效果复活，但必须有尸体才能复活，有电击特效)
 *
 *
 * @no return	 
 * @error			invalid Client.
 */
native void ReviveClientByDefib(int client);

/**
 * Respawn Client.(任何时候皆可以复活，无尸体都可以，这是无签名版本，不会随着服务器更新而导致崩服)
 *
 *
 * @no return	 
 * @error			invalid Client.
 */
native void RespawnClient(int client);

/**
 * From Incap Revive Client.
 *
 *
 * @no return	 
 * @error			invalid Client.
 */
native void ReviveClientFromIncap(int client);

/**
 * whether Client Has Visible Threats.
 *
 *
 * @return	 		if Has Visible Threats for true,false otherwise;
 * @error			invalid cleint.
 */
stock bool IsClientHasVisibleThreats(int client)
{
	return HasEntProp(client, Prop_Send, "m_hasVisibleThreats") && !!GetEntProp(client, Prop_Send, "m_hasVisibleThreats");
}

/**
 * whether Has Any Client Recently Be Hurt.
 *
 *
 * @return	 		if Has Any Client Recently Be Hurt for true,false otherwise;
 * @error			no error.
 */
native bool HasAnyClientRecentlyBeHurt();

/**
 * whether Has Client Recently Be Hurt.
 *
 *
 * @return	 		if Has Any Client Recently Be Hurt for true,false otherwise;
 * @error			no error.
 */
native bool HasClientRecentlyBeHurt(int client);


/**
 * whether Client Has Mess Around.
 *
 *
 * @return	 		if Has Mess Around for true,false otherwise;
 * @error			no error.
 */
stock bool IsClientHasMessAround(int client)
{
	return !IsClientHasVisibleThreats(client) && !HasClientRecentlyBeHurt(client);
}

/**
 * whether Has Any Survivor Left Safe Area.
 *
 *
 * @return	 		if Has Any Survivor Left Safe Area for true,false otherwise;
 * @error			no error.
 */
native bool HasAnySurvivorLeftSafeArea();

/**
 * whether Has Any Survivor In Exit Checkpoint.
 *
 *
 * @return	 		if Any Survivor In Exit Checkpoint for true,false otherwise;
 * @error			no error.
 */
native bool IsAnySurvivorInExitCheckpoint();

/**
 * whether Has Any Survivor In Start Area.
 *
 *
 * @return	 		if Any Survivor In Start Area for true,false otherwise;
 * @error			no error.
 */
native bool IsAnySurvivorInStartArea();

/**
 * whether Client Be Held.
 *
 *
 * @return	 		if Client Be Held for true,false otherwise;
 * @error			no error.
 */
stock bool IsClientHeld(int client)
{
	int jockey = GetEntPropEnt(client, Prop_Send, "m_jockeyAttacker");
	int charger = GetEntPropEnt(client, Prop_Send, "m_pummelAttacker");
	int hunter = GetEntPropEnt(client, Prop_Send, "m_pounceAttacker");
	int smoker = GetEntPropEnt(client, Prop_Send, "m_tongueOwner");
	if (jockey > 0 || charger > 0 || hunter > 0 || smoker > 0)
	{
		return true;
	}
	return false;
}

/**
 * whether Entity Be Biled.
 *
 *
 * @return	 		if Entity Be Biled for true,false otherwise;
 * @error			invalid entity.
 */
 
stock bool IsEntityBiled(int entity)
{
	float specialisbiled = GetEntPropFloat(entity, Prop_Send, "m_vomitFadeStart");
	if (specialisbiled != 0.0 && specialisbiled - GetGameTime() <= 5.0 && specialisbiled >= GetGameTime())
	{
		 return true;
	}
    return false;
} 

/**
 * Returns true if the current mode supports player controlled zombies.
 *
 *
 * @return	 		if mode supports for true,false otherwise;
 * @error			no error.
 */
 
native bool HasPlayerControlledZombies();

/**
 * Get Time Since Special Killed.
 *
 *
 * @return	 		Time value;
 * @error			invalid zombieType.
 */
native bool GetTimeSinceSpecialKilled(int zombieType);

/**
 * Get Client Alive Duration.
 *
 *
 * @return	 		Duration value;
 * @error			invalid client.
 */
native bool GetClientAliveDuration(int client);

/**
 * Get Averaged Survivor Speed.
 *
 *
 * @return	 		Survivor Speed;
 * @error			invalid cleint.
 */
native float GetAveragedSurvivorSpeed(int client);

/**
 * Get the distance between the lead and trailing survivors;
 *
 *
 * @return	 		Survivor distance;
 * @error			invalid cleint.
 */
native float GetAveragedSurvivorDis(int client);


/**
 * Get the navigation flow distance from the start to the survivors position averaged.
 *
 *
 * @return	 		distance;
 * @error			invalid cleint.
 */
native float GetAverageSurvivorFlowDis(int client);

/**
 * Returns the navigation flow distance from the start to the end of the level.
 *
 *
 * @return	 		distance;
 * @error			invalid cleint.
 */
native float GetMaxFlowDistance();

/**
 * @brief Starts the versus round, even if the survivors haven't left the safe room.
 * 
 * @error				invalid round.
 * @noreturn			
 */
native void ForceVersusStart();

/**
 * @brief Starts the survival round, even if the survivors haven't activated the radio.
 * 
 * @error				invalid round.
 * @noreturn			
 */
native void ForceSurvivalStart();

/**
 * @brief 	Starts the scavenge round, even if the setup timer hasn't elapsed.
 * 
 * @error				invalid round.
 * @noreturn			
 */
native void ForceScavengeStart();

/**
 * @brief Removes lobby reservation from a server
 * @remarks Sets the reservation cookie to 0,
 *			it is safe to call this even if it's unreserved.
 */
native void BinHook_LobbyUnreserve();

/**
 * @brief Returns whether or not a map is currently running.
 *
 * @return			True if a map is currently running, otherwise false.
 */
native bool IsMapRunning();

/**
 * @brief Returns whether or not a map is currently Intro.
 *
 * @return			True if a map is currently Intro, otherwise false.
 */
native bool IsMapInIntro();

/**
 * @brief pushing an entity in the given direction.
 * 
 * @error				invalid entity.
 * @noreturn			
 */
native void PushEntity(int entity, float vec[3]);

/**
 * @brief Spining an entity in the given direction.
 * 
 * @error				invalid entity.
 * @noreturn			
 */
native void SpinEntity(int entity, float vec[3]);

/**
 * Adds two Bign int or float string together.
 *
 * Note:  This is the same as the '+' operator.
 *
 * @param str1         First value.
 * @param str2         Second value.
 * @param strResult    str1 + str2.
 * @param maxlength    Maximum length of strResult buffer.
 * @return             if value>0 return 1;if value==0 return 0;if value<0 return -1.
 */
native int BignAdd(const char[] str1, const char[] str2, char[] strResult, int maxlength);

/**
 * Subtracts str2 from str1(int or float string).
 *
 * Note:  This is the same as the '-' operator.
 *
 * @param str1         First value.
 * @param str2         Second value.
 * @param strResult    str1 - str2.
 * @param maxlength    Maximum length of strResult buffer.
 * @return             if value>0 return 1;if value==0 return 0;if value<0 return -1.
 */
native int BignSub(const char[] str1, const char[] str2, char[] strResult, int maxlength);

/**
 * Called when the player or client  was stucked.
 *
 *
 * @return  Plugin_Continue or Plugin_Handled.
 * @error			invalid client or player isn't alive.
 */
forward Action OnPlayerStuck(int client);

/**
 * Called when the player or client manual freedom speaking.(检测玩家是否用了自由麦，hook检测，效率高)
 *
 *
 * @return  Plugin_Continue.
 * @error			invalid client.
 */
#pragma deprecated invaild.
forward Action OnPlayerVoice(int client);

/**
 * _________________Do not edit below this line!_______________________
 */
public Extension __ext_smsockes = 
{
	name = "BinHooks Extension",
	file = "BinHooks.ext",
#if defined AUTOLOAD_EXTENSIONS
	autoload = 1,
#else
	autoload = 0,
#endif
#if defined REQUIRE_EXTENSIONS
	required = 1,
#else
	required = 0,
#endif
};
