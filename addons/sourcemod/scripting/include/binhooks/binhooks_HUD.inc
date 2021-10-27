/*
 *
 *
 Foreword:There is now a (fairly lo-fi, but functional) script controllable "HUD" for making simple text based UI's for your game modes. 
 This won't replace hand-editing .res files and other fanciness if you want to do graphics and tons of customization. 
 But for simple UI's of text boxes, numbers, and timers, it works pretty well. 
 *
 *
 */

enum SlotType
{
	HUD_LEFT_TOP = 0,     
	HUD_LEFT_BOT,       
	HUD_MID_TOP,        
	HUD_MID_BOT,     
	HUD_RIGHT_TOP,       
	HUD_RIGHT_BOT,        
	HUD_TICKER,     
	HUD_FAR_LEFT,       
	HUD_FAR_RIGHT,        
	HUD_MID_BOX,     
	HUD_SCORE_TITLE,       
	HUD_SCORE_1,        
	HUD_SCORE_2,     
	HUD_SCORE_3,       
	HUD_SCORE_4,            
};

enum CommandType
{
	TIMER_DISABLE = 0,     
	TIMER_COUNTUP,       
	TIMER_COUNTDOWN,        
	TIMER_STOP,   
	TIMER_SET, 
};

enum TimerType
{
	HUD_TIMER_TIMER0 = 0,     
	HUD_TIMER_TIMER1,       
	HUD_TIMER_TIMER2,        
	HUD_TIMER_TIMER3,     
};


/*a field for putting a custom system value (TIMER2, COOLDOWN, MAPNAME, etc) 
HUD_SPECIAL_TIMER0/TIMER1/TIMER2/TIMER3 - these are the 4 "system timers" - use these if you want smooth timing on client! 
HUD_SPECIAL_MAPNAME/MODENAME - shows the string for the current MapName or Game Mode Name 
HUD_SPECIAL_COOLDOWN - the special COOLDOWN timer - for the COOLDOWN stage type
HUD_SPECIAL_ROUNDTIME - the special ROUND timer
*/
enum SpecialType
{
	HUD_SPECIAL_TIMER0 = 0,     
	HUD_SPECIAL_TIMER1,       
	HUD_SPECIAL_TIMER2,        
	HUD_SPECIAL_TIMER3,     
	HUD_SPECIAL_COOLDOWN,       
	HUD_SPECIAL_ROUNDTIME,        
	HUD_SPECIAL_MAPNAME,     
	HUD_SPECIAL_MODENAME,           
};

// custom flags for background, time, alignment, which team, pre or postfix, etc
#define HUD_FLAG_PRESTR			(1<<0)	//do you want a string/value pair to start(pre) or end(post) with the static string (default is PRE) 
#define HUD_FLAG_POSTSTR 		(1<<1)	//ditto
#define HUD_FLAG_BEEP			(1<<2)	//Makes a countdown timer blink
#define HUD_FLAG_BLINK			(1<<3)  //do you want this field to be blinking 
#define HUD_FLAG_AS_TIME		(1<<4)	// to do..
#define HUD_FLAG_COUNTDOWN_WARN	(1<<5)	//auto blink when the timer gets under 10 seconds 
#define HUD_FLAG_NOBG	        (1<<6) //  dont draw the background box for this UI element 
#define HUD_FLAG_ALLOWNEGTIMER	(1<<7) //by default Timers stop on 0:00 to avoid briefly going negative over network, this keeps that from happening 
#define HUD_FLAG_ALIGN_LEFT		(1<<8) //Left justify this text
#define HUD_FLAG_ALIGN_CENTER		(1<<9) //Center justify this text
#define HUD_FLAG_ALIGN_RIGHT		(3<<8) // Right justify this text
#define HUD_FLAG_TEAM_SURVIVORS	(1<<10) //only show to the survivor team
#define HUD_FLAG_TEAM_INFECTED	(1<<11) //only show to the special infected team
#define HUD_FLAG_TEAM_MASK		(3<<10) // link HUD_FLAG_TEAM_SURVIVORS and  HUD_FLAG_TEAM_INFECTED 

/*
Passes a table that defines your in-game HUD to the engine. 
From there on, you can modify the table to cause changes. 
Though often you wont, you will instead use a dataval entry to define a simple lambda that 
returns the up-to-date value to the HUD system.
*/
/** 
 * Passes a table that defines your in-game HUD to the engine. 
 *
 * @param SlotType:slot			SlotType's slot.
 * @param flags			flags(HUD_FLAG_BLINK)..
 * @param dataval			used for data of destination string buffer.
 * @param ...			Variable number of format parameters.
 * @noreturn
 * @error				Invalid SlotType:slot or flags or null dataval.
 */
native void HUDSetLayout(SlotType slot, int flags, char[] dataval, any ...);

/** 
 * Passes a table that defines your in-game HUD to the engine. 
 *
 * @param SlotType:slot			SlotType's slot.
 * @param flags			flags(HUD_FLAG_BLINK)..
 * @param SpecialType:special			special(HUD_SPECIAL_TIMER0,HUD_SPECIAL_TIMER1 and so on).
 * @param staticstring			used for data of destination string buffer.
 * @param ...			Variable number of format parameters.
 * @noreturn
 * @error				Invalid SlotType:slot or flags or SpecialType:special.
 */
native void HUDSetLayout_Special(SlotType slot, int flags, SpecialType special, char[] staticstring, any ...);

/*
Manages the HUD timers. 
Valid command enumerations are: TIMER_DISABLE, TIMER_COUNTUP, TIMER_COUNTDOWN, TIMER_STOP, TIMER_SET 
*/
/** 
 * Manages the HUD timers..
 *
 * @param TimerType:timerid		timerid(HUD_SPECIAL_TIMER0,HUD_SPECIAL_TIMER1 and so on).
 * @param CommandType:command			command(TIMER_DISABLE,TIMER_COUNTUP and so on)..
 * @param timer			timerid value.
 * @noreturn
 * @error				Invalid SlotType:slot or CommandType:command or time<0.0.
 */
native void HUDManageTimers(TimerType timerid, CommandType command, float timer);


/**
 * Returns the TimerType:timerid.
 *
 * @param TimerType:timerid		timerid(HUD_SPECIAL_TIMER0,HUD_SPECIAL_TIMER1 and so on).
 * @return				timerid value.
 * @error				Invalid TimerType:timerid.
 */
native float HUDReadTimer(TimerType timerid);


/*Note:HUDPlace(slot,x,y,w,h): moves the given HUD slot to the XY position specified, with new W and H. 
This is for doing occasional highlight/make a point type things, 
or small changes to layout w/o having to build a new .res to put in a VPK.
We suspect if you want to do a super fancy HUD you will want to create your own hudscriptedmode.res file, 
just making sure to use the same element naming conventions so you can still talk to them from script. 
x,y,w,h are all 0.0-1.0 screen relative coordinates (actually, a bit smaller than the screen, but anyway). 
So a box near middle might be set as (0.4,0.45,0.2,0.1) or so.*/
/** 
 * Place a slot in game.
 *
 * @param SlotType:slot			SlotType's slot.
 * @param x_pos			screen x position.
 * @param x_pos			screen y position.
 * @param x_pos			screen slot width.
 * @param x_pos			screen slot height.
 * @noreturn
 * @error				Invalid SlotType:slot or not in 0.0-1.0.
 */
native void HUDPlace(SlotType slot, float x_pos, float y_pos, float width, float height);

/** 
 * Removes a slot from game.
 *
 * @param SlotType:slot			SlotType's slot.
 * @noreturn
 * @error				Invalid SlotType:slot.
 */
native void RemoveHUD(SlotType slot);

/**
 * Remove All slot from game.
 *
 * @noreturn				
 */
native void RemoveAllHUD();

/**
 * Returns if a Slot is Used
 *
 * @param SlotType:slot		SlotType's slot.
 * @return				True if a Slot is Used, false otherwise.
 * @error				Invalid SlotType:slot.
 */
native bool HUDSlotIsUsed(SlotType slot);


/**
 * Returns if a Hud is Loaded
 *
 * @return				True if a Hud is Loaded, false otherwise.
 * @error				no error.
 */
native bool IsHudLoaded();