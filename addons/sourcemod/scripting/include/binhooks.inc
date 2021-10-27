#if defined _binhooks_included_
	#endinput
#endif
#define _binhooks_included_

#include <binhooks/binhooks_HUD>
#include <binhooks/binhooks_Special>
#include <binhooks/binhooks_Other>

/**
 * Do not edit below this line!
 */
public Extension __ems_hud = 
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
