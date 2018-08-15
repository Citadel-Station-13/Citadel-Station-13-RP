// You probably don't want to tick this file yet.

#if !defined(USING_MAP_DATUM)

	#include "southern_cross_citadel_areas.dm"
	#include "southern_cross_citadel_defines.dm"
	#include "southern_cross_citadel_jobs.dm"
	#include "southern_cross_citadel_elevator.dm"
	#include "southern_cross_citadel_presets.dm"
	#include "southern_cross_citadel_shuttles.dm"

	#include "shuttles/crew_shuttles.dm"
	#include "shuttles/heist.dm"
	#include "shuttles/merc.dm"
	#include "shuttles/ninja.dm"
	#include "shuttles/ert.dm"

	#include "loadout/loadout_accessories.dm"
	#include "loadout/loadout_head.dm"
	#include "loadout/loadout_suit.dm"
	#include "loadout/loadout_uniform.dm"

	#include "datums/supplypacks/munitions.dm"
	#include "items/encryptionkey_sc.dm"
	#include "items/headset_sc.dm"
	#include "items/clothing/sc_suit.dm"
	#include "items/clothing/sc_under.dm"
	#include "items/clothing/sc_accessory.dm"
	#include "job/outfits.dm"
	#include "structures/closets/engineering.dm"
	#include "structures/closets/medical.dm"
	#include "structures/closets/misc.dm"
	#include "structures/closets/research.dm"
	#include "structures/closets/security.dm"
	#include "turfs/outdoors.dm"

	#include "southern_cross_citadel-1.dmm"
	#include "southern_cross_citadel-2.dmm"
	#include "southern_cross_citadel-3.dmm"
	#include "southern_cross_citadel-4.dmm"
	#include "southern_cross_citadel-5.dmm"
	#include "southern_cross_citadel-6.dmm"
	#include "southern_cross_citadel-7.dmm"
	#include "southern_cross_citadel-8.dmm"

	#define USING_MAP_DATUM /datum/map/southern_cross_citadel

	// todo: map.dmm-s here

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Southern Cross

#endif