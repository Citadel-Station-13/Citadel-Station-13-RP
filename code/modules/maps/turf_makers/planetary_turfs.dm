////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Turf Makers consolidated list. TODO, remap everything using turfs that simply take the atmos id set by the planet ///
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////
/////////// CLASS H PLANET /////////////////////
////////////////////////////////////////////////
#define DESERT_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_CLASSH
#define DESERT_TURF_CREATE(x)	x/classh/initial_gas_mix=ATMOSPHERE_ID_DESERT

DESERT_TURF_CREATE(/turf/simulated/wall/planetary)
DESERT_TURF_CREATE(/turf/simulated/wall)
DESERT_TURF_CREATE(/turf/simulated/wall/sandstone)
DESERT_TURF_CREATE(/turf/simulated/wall/sandstonediamond)
DESERT_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand/desert)
DESERT_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand/dirt)
DESERT_TURF_CREATE(/turf/simulated/floor/wood)
DESERT_TURF_CREATE(/turf/simulated/floor/tiled)
DESERT_TURF_CREATE(/turf/simulated/floor)
DESERT_TURF_CREATE(/turf/simulated/floor/water)
DESERT_TURF_CREATE(/turf/simulated/floor/water/deep)
DESERT_TURF_CREATE(/turf/simulated/floor/water/shoreline)
DESERT_TURF_CREATE(/turf/simulated/floor/water/shoreline/corner)
DESERT_TURF_CREATE(/turf/simulated/mineral)
DESERT_TURF_CREATE(/turf/simulated/mineral/ignore_mapgen)
DESERT_TURF_CREATE(/turf/simulated/mineral/floor)
DESERT_TURF_CREATE(/turf/simulated/mineral/floor/ignore_mapgen)


////////////////////////////////////////////////
/////////// CLASS G PLANET /////////////////////
////////////////////////////////////////////////
#define MININGPLANET_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_MININGPLANET
#define MININGPLANET_TURF_CREATE(x)	x/classg/initial_gas_mix=ATMOSPHERE_ID_MININGPLANET

MININGPLANET_TURF_CREATE(/turf/simulated/wall)
MININGPLANET_TURF_CREATE(/turf/simulated/mineral/triumph)
MININGPLANET_TURF_CREATE(/turf/simulated/mineral/rich/triumph)
MININGPLANET_TURF_CREATE(/turf/simulated/mineral/floor)
MININGPLANET_TURF_CREATE(/turf/simulated/mineral/floor/ignore_cavegen)
MININGPLANET_TURF_CREATE(/turf/unsimulated/mineral)

////////////////////////////////////////////////
/////////// CLASS M PLANET /////////////////////
////////////////////////////////////////////////
#define GAIA_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_GAIA
#define GAIA_TURF_CREATE(x)	x/classm/initial_gas_mix=ATMOSPHERE_ID_GAIA

GAIA_TURF_CREATE(/turf/simulated/wall/planetary/gaia)

GAIA_TURF_CREATE(/turf/simulated/wall)
GAIA_TURF_CREATE(/turf/simulated/wall/sandstone)
GAIA_TURF_CREATE(/turf/simulated/wall/sandstonediamond)
GAIA_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand)
GAIA_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand/desert)
GAIA_TURF_CREATE(/turf/simulated/floor/outdoors/grass)
GAIA_TURF_CREATE(/turf/simulated/floor/wood)
GAIA_TURF_CREATE(/turf/simulated/floor/tiled)
GAIA_TURF_CREATE(/turf/simulated/floor)
GAIA_TURF_CREATE(/turf/simulated/floor/water)
GAIA_TURF_CREATE(/turf/simulated/floor/water/deep)
GAIA_TURF_CREATE(/turf/simulated/floor/water/shoreline)
GAIA_TURF_CREATE(/turf/simulated/floor/water/shoreline/corner)
GAIA_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand)
GAIA_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
GAIA_TURF_CREATE(/turf/simulated/mineral)
GAIA_TURF_CREATE(/turf/simulated/mineral/ignore_mapgen)
GAIA_TURF_CREATE(/turf/simulated/mineral/floor)
GAIA_TURF_CREATE(/turf/simulated/mineral/floor/ignore_mapgen)

//Exterior Turfs for weather effects.
/turf/simulated/floor/tiled/classm/outdoors
	outdoors = TRUE

/turf/simulated/floor/wood/classm/outdoors
	outdoors = TRUE


////////////////////////////////////////////////
/////////// CLASS P PLANET /////////////////////
////////////////////////////////////////////////
#define FROZEN_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_FROZEN
#define FROZEN_TURF_CREATE(x)	x/classp/initial_gas_mix=ATMOSPHERE_ID_FROZEN

FROZEN_TURF_CREATE(/turf/simulated/wall/planetary/frozen)

FROZEN_TURF_CREATE(/turf/simulated/wall)
FROZEN_TURF_CREATE(/turf/simulated/wall/ironphoron)
FROZEN_TURF_CREATE(/turf/simulated/wall/snowbrick)
FROZEN_TURF_CREATE(/turf/simulated/floor)
FROZEN_TURF_CREATE(/turf/simulated/floor/bmarble)
FROZEN_TURF_CREATE(/turf/simulated/floor/crystal)
FROZEN_TURF_CREATE(/turf/simulated/floor/gold)
FROZEN_TURF_CREATE(/turf/simulated/floor/phoron)
FROZEN_TURF_CREATE(/turf/simulated/floor/silver)
FROZEN_TURF_CREATE(/turf/simulated/floor/wmarble)
FROZEN_TURF_CREATE(/turf/simulated/floor/wood)
FROZEN_TURF_CREATE(/turf/simulated/floor/water/indoors)
FROZEN_TURF_CREATE(/turf/simulated/floor/old_tile/red)
FROZEN_TURF_CREATE(/turf/simulated/floor/old_tile/blue)
FROZEN_TURF_CREATE(/turf/simulated/floor/old_tile/green)
FROZEN_TURF_CREATE(/turf/simulated/floor/outdoors/ice)
FROZEN_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
FROZEN_TURF_CREATE(/turf/simulated/floor/outdoors/grass/heavy/interior)
FROZEN_TURF_CREATE(/turf/simulated/floor/outdoors/mud)
FROZEN_TURF_CREATE(/turf/simulated/floor/outdoors/shelfice)
FROZEN_TURF_CREATE(/turf/simulated/floor/carpet/purcarpet)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/bmarble)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/crystal)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/gold)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/phoron)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/plating)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/silver)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/wmarble)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/wood)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/delayed/bmarble)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/delayed/crystal)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/delayed/gold)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/delayed/phoron)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/delayed/plating)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/delayed/silver)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/delayed/wmarble)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/delayed/wood)
FROZEN_TURF_CREATE(/turf/simulated/shuttle/floor)
FROZEN_TURF_CREATE(/turf/simulated/shuttle/floor/black)
FROZEN_TURF_CREATE(/turf/simulated/shuttle/floor/purple)
FROZEN_TURF_CREATE(/turf/simulated/shuttle/floor/red)
FROZEN_TURF_CREATE(/turf/simulated/shuttle/floor/yellow)
FROZEN_TURF_CREATE(/turf/simulated/mineral)
FROZEN_TURF_CREATE(/turf/simulated/mineral/cave)
FROZEN_TURF_CREATE(/turf/simulated/mineral/ignore_mapgen)
FROZEN_TURF_CREATE(/turf/simulated/mineral/floor)
FROZEN_TURF_CREATE(/turf/simulated/mineral/floor/ignore_mapgen)

//Exterior Turfs for weather effects.
/turf/simulated/floor/classp/outdoors
	outdoors = TRUE

/turf/simulated/floor/wood/classp/outdoors
	outdoors = TRUE

/turf/simulated/floor/outdoors/snow/classp/no_tree
	tree_chance = 0
	deadtree_chance = 0

/turf/simulated/floor/old_tile/red/outdoors
	outdoors = TRUE

/turf/simulated/floor/old_tile/blue/outdoors
	outdoors = TRUE

/turf/simulated/floor/old_tile/green/outdoors
	outdoors = TRUE

/turf/simulated/floor/outdoors/mud/classp/indoors
	outdoors = FALSE

/turf/simulated/floor/outdoors/ice/classp/indoors
	outdoors = FALSE

/turf/simulated/floor/water/acid/classp/indoors
	outdoors = FALSE

/turf/simulated/floor/water/acid/deep/classp/indoors
	outdoors = FALSE

////////////////////////////////////////////////
/////////// CLASS D PLANET /////////////////////
////////////////////////////////////////////////
#define CLASSD_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_CLASSD
#define CLASSD_TURF_CREATE(x)	x/classd/initial_gas_mix=ATMOSPHERE_ID_CLASSD;x/classd/color="#eaa17c"

CLASSD_TURF_CREATE(/turf/simulated/wall/planetary)
CLASSD_TURF_CREATE(/turf/simulated/wall)
CLASSD_TURF_CREATE(/turf/simulated/floor)
CLASSD_TURF_CREATE(/turf/simulated/floor/reinforced)
CLASSD_TURF_CREATE(/turf/simulated/floor/tiled)
CLASSD_TURF_CREATE(/turf/simulated/floor/tiled/steel_dirty)
CLASSD_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
CLASSD_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)
CLASSD_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand/dirt)
CLASSD_TURF_CREATE(/turf/simulated/mineral)
CLASSD_TURF_CREATE(/turf/simulated/mineral/floor)
CLASSD_TURF_CREATE(/turf/simulated/mineral/ignore_mapgen)
CLASSD_TURF_CREATE(/turf/simulated/mineral/floor/ignore_mapgen)
CLASSD_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)

/turf/simulated/floor/outdoors/classd
	name = "irradiated sand"
	desc = "It literally glows in the dark."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"
	outdoors = 1
	color = "#eaa17c"
	base_icon_state = "asteroid"
	initial_gas_mix = ATMOSPHERE_ID_CLASSD
	baseturfs = /turf/simulated/mineral/floor/classd
	initial_flooring = /singleton/flooring/outdoors/classd

///Indoor usage turfs with Class D's Atmos. Unaffected by weather etc (Important because radioactive fallout will happen on a regular basis!)
/turf/simulated/floor/classd/indoors
	color = "#eaa17c"
	initial_gas_mix = ATMOSPHERE_ID_CLASSD
	outdoors = FALSE

/turf/simulated/mineral/classd/indoors
	color = "#eaa17c"
	initial_gas_mix = ATMOSPHERE_ID_CLASSD
	outdoors = FALSE

/turf/simulated/mineral/floor/classd/indoors
	color = "#eaa17c"
	initial_gas_mix = ATMOSPHERE_ID_CLASSD
	outdoors = FALSE

/turf/simulated/floor/tiled/classd/indoors
	color = "#eaa17c"
	initial_gas_mix = ATMOSPHERE_ID_CLASSD
	outdoors = FALSE

/turf/simulated/wall/classd/indoors
	color = "#eaa17c"
	initial_gas_mix = ATMOSPHERE_ID_CLASSD
	outdoors = FALSE

// Unused Turfs (For now)
/*
/turf/simulated/floor/reinforced/classd_indoors
	color = "#eaa17c"
	initial_gas_mix = ATMOSPHERE_ID_CLASSD
	outdoors = FALSE
*/


////////////////////////////////////////////////
///////////  VIRGO 2	   /////////////////////
////////////////////////////////////////////////
#define VIRGO2_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_VIRGO2
#define VIRGO2_TURF_CREATE(x)	x/virgo2/initial_gas_mix=ATMOSPHERE_ID_VIRGO2;x/virgo2/color="#eacd7c"

VIRGO2_TURF_CREATE(/turf/unsimulated/wall/planetary)
VIRGO2_TURF_CREATE(/turf/simulated/wall)
VIRGO2_TURF_CREATE(/turf/simulated/floor/plating)
VIRGO2_TURF_CREATE(/turf/simulated/floor/bluegrid)
VIRGO2_TURF_CREATE(/turf/simulated/floor/tiled/techfloor)
VIRGO2_TURF_CREATE(/turf/simulated/mineral)
VIRGO2_TURF_CREATE(/turf/simulated/mineral/ignore_mapgen)
VIRGO2_TURF_CREATE(/turf/simulated/mineral/floor)
VIRGO2_TURF_CREATE(/turf/simulated/mineral/floor/ignore_mapgen)

VIRGO2_TURF_CREATE(/turf/simulated/mineral/ignore_mapgen)
VIRGO2_TURF_CREATE(/turf/simulated/mineral/floor)
VIRGO2_TURF_CREATE(/turf/simulated/mineral/floor/ignore_mapgen)
/turf/simulated/floor/sky/virgo2_sky
	name = "virgo 2 atmosphere"
	desc = "Be careful where you step!"
	color = "#eacd7c"
	initial_gas_mix = ATMOSPHERE_ID_VIRGO2

/turf/simulated/floor/sky/virgo2_sky/Initialize(mapload)
	skyfall_levels = list(z+1)
	. = ..()

/turf/simulated/shuttle/wall/voidcraft/green/virgo2
	initial_gas_mix = ATMOSPHERE_ID_VIRGO2
	color = "#eacd7c"

/turf/simulated/shuttle/wall/voidcraft/green/virgo2/nocol
	color = null

/turf/simulated/mineral/virgo2/make_ore()
	if(mineral)
		return

	var/mineral_name = pickweight(list(MAT_MARBLE = 5, MAT_URANIUM = 5, MAT_PLATINUM = 5, MAT_HEMATITE = 5, MAT_CARBON = 5, MAT_DIAMOND = 5, MAT_GOLD = 5, MAT_SILVER = 5, MAT_LEAD = 5, MAT_VERDANTIUM = 5))

	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		UpdateMineral()




////////////////////////////////////////////////
/////////// LAVALAND 	   /////////////////////
////////////////////////////////////////////////
#define LAVALAND_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_LAVALAND
#define LAVALAND_TURF_CREATE(x)	x/lavaland/initial_gas_mix=ATMOSPHERE_ID_LAVALAND

LAVALAND_TURF_CREATE(/turf/simulated/shuttle/floor)
LAVALAND_TURF_CREATE(/turf/simulated/shuttle/wall)
LAVALAND_TURF_CREATE(/turf/simulated/wall)
LAVALAND_TURF_CREATE(/turf/simulated/wall/wood)
LAVALAND_TURF_CREATE(/turf/simulated/wall/sandstone)
LAVALAND_TURF_CREATE(/turf/simulated/wall/sandstonediamond)
LAVALAND_TURF_CREATE(/turf/simulated/wall/bone)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand/desert)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/grass)
LAVALAND_TURF_CREATE(/turf/simulated/floor/water)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/lava)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/lava/noblend)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/lava/indoors)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/lava/indoors/noblend)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors)
LAVALAND_TURF_CREATE(/turf/simulated/floor/water/deep)
LAVALAND_TURF_CREATE(/turf/simulated/floor/water/shoreline)
LAVALAND_TURF_CREATE(/turf/simulated/floor/water/shoreline/corner)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand/dirt)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)
LAVALAND_TURF_CREATE(/turf/simulated/floor/plating)
LAVALAND_TURF_CREATE(/turf/simulated/floor/wood)
LAVALAND_TURF_CREATE(/turf/simulated/floor/wood/broken)
LAVALAND_TURF_CREATE(/turf/simulated/floor/sandstone)
LAVALAND_TURF_CREATE(/turf/simulated/floor/bone)
LAVALAND_TURF_CREATE(/turf/simulated/floor/bone/engraved)
LAVALAND_TURF_CREATE(/turf/simulated/floor/tiled)
LAVALAND_TURF_CREATE(/turf/simulated/floor/tiled/old_tile)
LAVALAND_TURF_CREATE(/turf/simulated/floor/tiled/monotile)
LAVALAND_TURF_CREATE(/turf/simulated/floor/tiled/dark)
LAVALAND_TURF_CREATE(/turf/simulated/floor/tiled/steel_dirty)
LAVALAND_TURF_CREATE(/turf/simulated/floor/tiled/steel_grid)
LAVALAND_TURF_CREATE(/turf/simulated/floor)
LAVALAND_TURF_CREATE(/turf/simulated/floor/carpet)
LAVALAND_TURF_CREATE(/turf/simulated/floor/carpet/bcarpet)
LAVALAND_TURF_CREATE(/turf/simulated/floor/carpet/blucarpet)
LAVALAND_TURF_CREATE(/turf/simulated/floor/carpet/purcarpet)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/ignore_mapgen)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/floor)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/floor/cave)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/floor/ignore_mapgen)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/ignore_cavegen)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/triumph)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/rich/triumph)
LAVALAND_TURF_CREATE(/turf/simulated/floor/bluegrid)
LAVALAND_TURF_CREATE(/turf/simulated/floor/greengrid)
LAVALAND_TURF_CREATE(/turf/unsimulated/mineral/triumph)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/)


/turf/simulated/mineral/floor/lavaland
	outdoors = TRUE

//Cave doesnt make things indoor, its actually a variant that
//has an initial gas string of regular air mix. The turf creator overrides
//that gas mix though so this is effectively useless. Lava land was made though with this
//being default outdoors so I will leave it as is for now
/turf/simulated/mineral/floor/cave/lavaland
	outdoors = TRUE

/turf/simulated/mineral/floor/ignore_mapgen/lavaland
	outdoors = TRUE

///... why are is a TRIUMPH_TURF_CREATE turf being chewed through LAVALAND_TURF_CREATE I dont
/// know. This will need to be looked into at some point soon
/turf/simulated/mineral/triumph/lavaland
	outdoors = TRUE
	edge_blending_priority = 2

/turf/simulated/mineral/triumph/rich/lavaland
	outdoors = TRUE

/turf/simulated/mineral/rich/triumph/lavaland
	outdoors = TRUE
	edge_blending_priority = 2

// Lava Land turfs

/turf/simulated/floor/outdoors/lavaland
	name = "ash sand"
	desc = "Soft and ominous."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"
	outdoors = 1
	edge_blending_priority = 2
	base_icon_state = "asteroid"
	baseturfs = /turf/simulated/mineral/floor/lavaland
	initial_flooring = /singleton/flooring/outdoors/lavaland

/turf/simulated/floor/outdoors/lavaland/indoors //I know this path is confusing. Basically this is a way to simulate interior caverns that don't use mapgen for specific POIs.
	outdoors = 0

/turf/simulated/floor/tiled/steel_dirty/lavaland/exterior
	outdoors = 1

/turf/simulated/floor/water/lavaland/interior
	outdoors = 0

/turf/simulated/floor/outdoors/grass/lavaland/interior
	outdoors = 0

/turf/simulated/floor/outdoors/dirt/lavaland/interior
	outdoors = 0

// This is a special subtype of the thing that generates ores on a map
// It will generate more rich ores because of the lower numbers than the normal one
