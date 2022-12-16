//! smoothing_flags bitflags
#define SMOOTH_CORNERS          (1<<0) /// Smoothing system in where adjacencies are calculated and used to build an image by mounting each corner at runtime.
#define SMOOTH_BITMASK          (1<<1) /// Smoothing system in where adjacencies are calculated and used to select a pre-baked icon_state, encoded by bitmasking.
#define SMOOTH_DIAGONAL_CORNERS (1<<2) /// Atom has diagonal corners, with underlays under them.
#define SMOOTH_BORDER           (1<<3) /// Atom will smooth with the borders of the map.
#define SMOOTH_QUEUED           (1<<4) /// Atom is currently queued to smooth.
#define SMOOTH_OBJ              (1<<5) /// Smooths with objects, and will thus need to scan turfs for contents.
#define SMOOTH_CUSTOM           (1<<6) /// Custom smoothing - citrp snowflake for floors. don't you dare use this with normal things unless you absolutely know what you're doing.

DEFINE_BITFIELD(smoothing_flags, list(
	"SMOOTH_CORNERS"          = SMOOTH_CORNERS,
	"SMOOTH_BITMASK"          = SMOOTH_BITMASK,
	"SMOOTH_DIAGONAL_CORNERS" = SMOOTH_DIAGONAL_CORNERS,
	"SMOOTH_BORDER"           = SMOOTH_BORDER,
	"SMOOTH_QUEUED"           = SMOOTH_QUEUED,
	"SMOOTH_OBJ"              = SMOOTH_OBJ,
	"SMOOTH_CUSTOM"           = SMOOTH_CUSTOM,
))


//! Smoothing Macros

/// Macro for checking if something is smooth.
#define IS_SMOOTH(A) (A.smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK|SMOOTH_CUSTOM))

#define QUEUE_SMOOTH(thing_to_queue) if(IS_SMOOTH(thing_to_queue)) {SSicon_smooth.add_to_queue(thing_to_queue)}

#define QUEUE_SMOOTH_NEIGHBORS(thing_to_queue) for(var/neighbor in orange(1, thing_to_queue)) {var/atom/atom_neighbor = neighbor; QUEUE_SMOOTH(atom_neighbor)}


//! Smoothing Internals

#define NORTH_JUNCTION     (1<<0) // NORTH
#define SOUTH_JUNCTION     (1<<1) // SOUTH
#define EAST_JUNCTION      (1<<2) // EAST
#define WEST_JUNCTION      (1<<3) // WEST
#define NORTHEAST_JUNCTION (1<<4)
#define SOUTHEAST_JUNCTION (1<<5)
#define SOUTHWEST_JUNCTION (1<<6)
#define NORTHWEST_JUNCTION (1<<7)

DEFINE_BITFIELD(smoothing_junction, list(
	"NORTH_JUNCTION"     = NORTH_JUNCTION,
	"SOUTH_JUNCTION"     = SOUTH_JUNCTION,
	"EAST_JUNCTION"      = EAST_JUNCTION,
	"WEST_JUNCTION"      = WEST_JUNCTION,
	"NORTHEAST_JUNCTION" = NORTHEAST_JUNCTION,
	"SOUTHEAST_JUNCTION" = SOUTHEAST_JUNCTION,
	"SOUTHWEST_JUNCTION" = SOUTHWEST_JUNCTION,
	"NORTHWEST_JUNCTION" = NORTHWEST_JUNCTION,
))


#define NO_ADJ_FOUND    0
#define ADJ_FOUND       1
#define NULLTURF_BORDER 2


#define DEFAULT_UNDERLAY_ICON 'icons/turf/floors.dmi'
#define DEFAULT_UNDERLAY_ICON_STATE "plating"

/**
 *! WARNING
 * I just want to say I just dumped these from DaedalusDock, please modify these as needed. @Zandario
 *
 *? NOTICE
 * If you change, update, or add to these, please add the ? to the comment.
 */

/**
 * # SMOOTHING GROUPS
 * Groups of things to smooth with.
 * * Contained in the `list/smoothing_groups` variable.
 * * Matched with the `list/canSmoothWith` variable to check whether smoothing is possible or not.
 */

// Not any different from the number itself, but kept this way in case someone wants to expand it by adding stuff before it.
#define S_TURF(num) (#num + ",")


/* /turf only */

#define SMOOTH_GROUP_TURF_OPEN                    S_TURF(0)  ///? /turf/simulated/floor
#define SMOOTH_GROUP_TURF_CHASM                   S_TURF(1)  // /turf/open/chasm, /turf/open/floor/fakepit
#define SMOOTH_GROUP_FLOOR_LAVA                   S_TURF(2)  ///? /turf/simulated/floor/outdoors/lava
#define SMOOTH_GROUP_FLOOR_TRANSPARENT_GLASS      S_TURF(3)  // /turf/open/floor/glass

#define SMOOTH_GROUP_OPEN_FLOOR                   S_TURF(4)  ///? /turf/simulated/floor

#define SMOOTH_GROUP_FLOOR_GRASS                  S_TURF(5)  ///? /turf/simulated/floor/outdoors/grass
#define SMOOTH_GROUP_FLOOR_ASH                    S_TURF(6)  // /turf/open/misc/ashplanet/ash
#define SMOOTH_GROUP_FLOOR_ASH_ROCKY              S_TURF(7)  // /turf/open/misc/ashplanet/rocky
#define SMOOTH_GROUP_FLOOR_SNOW                   S_TURF(8)  ///? /turf/simulated/floor/outdoors/snow
#define SMOOTH_GROUP_FLOOR_SNOWED                 S_TURF(9)  // /turf/open/floor/plating/snowed

#define SMOOTH_GROUP_CARPET                       S_TURF(10) ///? /turf/simulated/floor/carpet
#define SMOOTH_GROUP_CARPET_BLACK                 S_TURF(11) // /turf/open/floor/carpet/black
#define SMOOTH_GROUP_CARPET_BLUE                  S_TURF(12) // /turf/open/floor/carpet/blue
#define SMOOTH_GROUP_CARPET_CYAN                  S_TURF(13) // /turf/open/floor/carpet/cyan
#define SMOOTH_GROUP_CARPET_GREEN                 S_TURF(14) // /turf/open/floor/carpet/green
#define SMOOTH_GROUP_CARPET_ORANGE                S_TURF(15) // /turf/open/floor/carpet/orange
#define SMOOTH_GROUP_CARPET_PURPLE                S_TURF(16) // /turf/open/floor/carpet/purple
#define SMOOTH_GROUP_CARPET_RED                   S_TURF(17) // /turf/open/floor/carpet/red
#define SMOOTH_GROUP_CARPET_ROYAL_BLACK           S_TURF(18) // /turf/open/floor/carpet/royalblack
#define SMOOTH_GROUP_CARPET_ROYAL_BLUE            S_TURF(19) // /turf/open/floor/carpet/royalblue
#define SMOOTH_GROUP_CARPET_EXECUTIVE             S_TURF(20) // /turf/open/floor/carpet/executive
#define SMOOTH_GROUP_CARPET_STELLAR               S_TURF(21) // /turf/open/floor/carpet/stellar
#define SMOOTH_GROUP_CARPET_DONK                  S_TURF(22) // /turf/open/floor/carpet/donk

#define SMOOTH_GROUP_CLOSED_TURFS                 S_TURF(23) ///? /turf/simulated/wall
#define SMOOTH_GROUP_SURVIVAL_TITANIUM_WALLS      S_TURF(24) // /turf/closed/wall/mineral/titanium/survival
#define SMOOTH_GROUP_HOTEL_WALLS                  S_TURF(25) // /turf/closed/indestructible/hotelwall
#define SMOOTH_GROUP_MINERAL_WALLS                S_TURF(26) ///? /turf/simulated/mineral, /turf/unsimulated/mineral
#define SMOOTH_GROUP_BOSS_WALLS                   S_TURF(27) // /turf/closed/indestructible/riveted/boss

#define MAX_S_TURF 27 //!Always match this value with the one above it.



#define S_OBJ(num) ("-" + #num + ",")

/* /obj included */

#define SMOOTH_GROUP_WALLS                        S_OBJ(1)  ///? /turf/simulated/wall
#define SMOOTH_GROUP_HIERO_WALL                   S_OBJ(2)  // /obj/effect/temp_visual/elite_tumor_wall, /obj/effect/temp_visual/hierophant/wall
#define SMOOTH_GROUP_SURVIVAL_TIANIUM_POD         S_OBJ(3)  // /turf/closed/wall/mineral/titanium/survival/pod, /obj/machinery/door/airlock/survival_pod, /obj/structure/window/reinforced/shuttle/survival_pod

#define SMOOTH_GROUP_PAPERFRAME                   S_OBJ(4) // /obj/structure/window/paperframe, /obj/structure/mineral_door/paperframe

#define SMOOTH_GROUP_WINDOW_FULLTILE              S_OBJ(5) ///? /obj/structure/window/basic/full
#define SMOOTH_GROUP_WINDOW_FULLTILE_BRONZE       S_OBJ(6) // /obj/structure/window/bronze/fulltile
#define SMOOTH_GROUP_WINDOW_FULLTILE_PLASTITANIUM S_OBJ(7) // /turf/closed/indestructible/opsglass, /obj/structure/window/reinforced/plasma/plastitanium
#define SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE      S_OBJ(8) ///? /obj/structure/window/shuttle

#define SMOOTH_GROUP_LATTICE                      S_OBJ(9) ///? /obj/structure/lattice
#define SMOOTH_GROUP_CATWALK                      S_OBJ(10) ///? /obj/structure/catwalk
#define SMOOTH_GROUP_GRILLE                       S_OBJ(11) ///? /obj/structure/grille
#define SMOOTH_GROUP_LOW_WALL                     S_OBJ(12) // /obj/structure/low_wall

#define SMOOTH_GROUP_AIRLOCK                      S_OBJ(13) ///? /obj/machinery/door/airlock
#define SMOOTH_GROUP_SHUTTERS_BLASTDOORS          S_OBJ(14) ///? /obj/machinery/door/blast

#define SMOOTH_GROUP_TABLES                       S_OBJ(15) ///? /obj/structure/table
#define SMOOTH_GROUP_WOOD_TABLES                  S_OBJ(16) ///? /obj/structure/table/woodentable // TOO MANY STUBS
#define SMOOTH_GROUP_FANCY_WOOD_TABLES            S_OBJ(17) // /obj/structure/table/wood/fancy
#define SMOOTH_GROUP_BRONZE_TABLES                S_OBJ(18) // /obj/structure/table/bronze
#define SMOOTH_GROUP_ABDUCTOR_TABLES              S_OBJ(19) // /obj/structure/table/abductor
#define SMOOTH_GROUP_GLASS_TABLES                 S_OBJ(20) ///? /obj/structure/table/glass

#define SMOOTH_GROUP_ALIEN_NEST                   S_OBJ(21) // /obj/structure/bed/nest
#define SMOOTH_GROUP_ALIEN_RESIN                  S_OBJ(22) // /obj/structure/alien/resin
#define SMOOTH_GROUP_ALIEN_WALLS                  S_OBJ(23) // /obj/structure/alien/resin/wall, /obj/structure/alien/resin/membrane
#define SMOOTH_GROUP_ALIEN_WEEDS                  S_OBJ(24) // /obj/structure/alien/weeds

#define SMOOTH_GROUP_SECURITY_BARRICADE           S_OBJ(25) // /obj/structure/barricade/security
#define SMOOTH_GROUP_SANDBAGS                     S_OBJ(26) ///? /obj/structure/sandbag

#define SMOOTH_GROUP_HEDGE_FLUFF                  S_OBJ(27) // /obj/structure/hedge

#define SMOOTH_GROUP_SHUTTLE_PARTS                S_OBJ(28) ///? /obj/structure/window/shuttle

#define SMOOTH_GROUP_CLEANABLE_DIRT               S_OBJ(29) // /obj/effect/decal/cleanable/dirt

#define SMOOTH_GROUP_INDUSTRIAL_LIFT              S_OBJ(30) // /obj/structure/industrial_lift

#define SMOOTH_GROUP_GAS_TANK                     S_OBJ(31)
