////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Turf Makers consolidated list. TODO, remap everything using turfs that simply take the atmos id set by the planet ///
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//!                                      FURTHER USAGE OF THIS FILE IS BANNED                                    !//
//  If you really need a planet subtype, no you fucking don't. I will write you a planetary color-grading system  //
//  if I need to. STOP SPAMMING SUBTYPES. ~silicons                                                               //

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
	initial_flooring = /datum/prototype/flooring/outdoors/classd

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

/turf/simulated/sky/virgo2_sky
	name = "virgo 2 atmosphere"
	desc = "Be careful where you step!"
	color = "#eacd7c"
	initial_gas_mix = ATMOSPHERE_ID_VIRGO2

/turf/simulated/sky/virgo2_sky/Initialize(mapload)
	skyfall_levels = list(z+1)
	. = ..()

/turf/simulated/shuttle/wall/voidcraft/green/virgo2
	initial_gas_mix = ATMOSPHERE_ID_VIRGO2
	color = "#eacd7c"

/turf/simulated/shuttle/wall/voidcraft/green/virgo2/nocol
	color = null

////////////////////////////////////////////////
/////////// LAVALAND 	   /////////////////////
////////////////////////////////////////////////

CREATE_STANDARD_TURFS(/turf/simulated/floor/outdoors/ash_sand)
/turf/simulated/floor/outdoors/ash_sand
	name = "ash sand"
	desc = "Soft and ominous."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"
	outdoors = 1
	edge_blending_priority = 2
	base_icon_state = "asteroid"
	baseturfs = /turf/simulated/mineral/floor
	initial_flooring = /datum/prototype/flooring/outdoors/lavaland

// This is a special subtype of the thing that generates ores on a map
// It will generate more rich ores because of the lower numbers than the normal one
