#if !defined(USING_MAP_DATUM)

	#include "rift_defines.dm"
	#include "rift_turfs.dm"
	#include "rift_things.dm"
	#include "rift_areas.dm"
	#include "rift_areas2.dm"
	#include "rift_shuttle_defs.dm"
	#include "rift_shuttles.dm"
	#include "rift_telecomms.dm"
	#include "rift_lythios-43c.dm"

	#include "rift-01-underground2.dmm"
	#include "rift-02-underground1.dmm"
	#include "rift-03-surface1.dmm"
	#include "rift-04-surface2.dmm"

	#include "items/clothing/rft_suit.dm"
	#include "items/clothing/rft_hood.dm"
	#include "items/clothing/rft_under.dm"
	#include "items/clothing/rft_accessory.dm"
	#include "items/weapons/rft_weapons.dm"

	#define USING_MAP_DATUM /datum/map/rift

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Rift

#endif