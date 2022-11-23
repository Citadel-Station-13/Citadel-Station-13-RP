////////////////////////////////////////////////////////////////////////////////////////
//! For easy recordkeeping; this is a byond define
// #define FLOAT_LAYER -1
// #define AREA_LAYER   1
// #define TURF_LAYER   2
// #define OBJ_LAYER    3
// #define MOB_LAYER    4
// #define FLY_LAYER    5
////////////////////////////////////////////////////////////////////////////////////////

/**
 *! Defines for atom layers and planes
 *! KEEP THESE IN A NICE ACSCENDING ORDER, PLEASE
 */

// TODO: UNFUCK PLANES. HALF OF THESE HAVE NO REASON TO EXIST. WHOEVER ADDED THEM IS AN IDIOT!
// TODO: Layers still need to be linear regardless of plane. stuff like projectiles DO CARE.

//! NEVER HAVE ANYTHING BELOW THIS PLANE ADJUST IF YOU NEED MORE SPACE
#define LOWEST_EVER_PLANE -100

#define CLICKCATCHER_PLANE -80

#define SPACE_PLANE    -31
#define PARALLAX_PLANE -30
#define PARALLAX_VIS_LAYER_BELOW -100
#define PARALLAX_LAYER_CENTER       0
#define PARALLAX_VIS_LAYER_ABOVE  100

// For the Looking Glass holodecks
#define PLANE_LOOKINGGLASS     -28
#define PLANE_LOOKINGGLASS_IMG -27

//OPENSPACE_PLANE reserves all planes between OPENSPACE_PLANE_START and OPENSPACE_PLANE_END inclusive
///turf/simulated/open will use OPENSPACE_PLANE + z (Valid z's being 2 thru 17)
#define OPENSPACE_PLANE       -26
#define OPENSPACE_PLANE_START -25
#define OPENSPACE_PLANE_END   -10
#define OVER_OPENSPACE_PLANE  -9

#define FLOOR_PLANE      -8
#define GAME_PLANE       -7
#define GAME_PLANE_UPPER -5
// Slightly above the game plane but does not catch mouse clicks. Useful for certain visuals that should be clicked through, like seethrough trees
#define SEETHROUGH_PLANE -3
#define ABOVE_GAME_PLANE -2

#define BLACKNESS_PLANE 0 // To keep from conflicts with SEE_BLACKNESS internals

#define AREA_PLANE  2
#define GHOST_PLANE 4

//! FLOOR_PLANE (-8) layers
#define PLATING_LAYER               1
//ABOVE PLATING
// #define HOLOMAP_LAYER               1.01
#define DECAL_PLATING_LAYER         1.02
#define DISPOSALS_PIPE_LAYER        1.03
#define LATTICE_LAYER               1.04
// #define PIPE_LAYER                  1.05
// #define WIRE_LAYER                  1.06
// #define WIRE_TERMINAL_LAYER         1.07
#define ABOVE_WIRE_LAYER            1.08
//TURF PLANE
//TURF_LAYER = 2
#define TURF_DETAIL_LAYER           2.01
#define TURF_SHADOW_LAYER           2.02
//ABOVE TURF
#define DECAL_LAYER                 2.03  // Base layer for decals.
#define DECAL_OVERLAY_LAYER         2.031 // Secondary layer for decals.
#define ABOVE_TILE_LAYER            2.05
#define EXPOSED_PIPE_LAYER          2.06
#define EXPOSED_WIRE_LAYER          2.07
#define EXPOSED_WIRE_TERMINAL_LAYER 2.08
#define CATWALK_LAYER               2.09
#define ABOVE_CATWALK_LAYER         2.10
#define ATMOS_LAYER                 2.35 // Pipe-like atmos machinery that goes on the floor, like filters.
#define GAS_SCRUBBER_LAYER          2.46
#define GAS_PIPE_VISIBLE_LAYER      2.47 //layer = initial(layer) + piping_layer / 1000 in atmospherics/update_icon() to determine order of pipe overlap
#define GAS_FILTER_LAYER            2.48
#define GAS_PUMP_LAYER              2.49
#define LOW_OBJ_LAYER               2.5
#define UNDERWATER_LAYER            2.51 // Anything on this layer will render under the water layer.
#define BELOW_TURF_LAYER            2.6  // Below the turf layer, for things like the floor plating frame's icon. //! Which doesn't exist yet, but it will. @Zandario :)
//? Turf/Obj layer boundary
#define ABOVE_TURF_LAYER            3.1  //Snow and wallmounted/floormounted equipment

//! GAME_PLANE (-7) layers
#define DEBRIS_LAYER           2.4  // Cleanable debris.
#define STAIRS_LAYER           2.5  // Layer for stairs.
#define HIDING_LAYER           2.6  // Layer at which mobs hide to be under things like tables.
#define BELOW_DOOR_OPEN_LAYER  2.6
#define BLASTDOOR_OPEN_LAYER   2.65
#define DOOR_OPEN_LAYER        2.7  // Under all objects if opened. 2.7 due to tables being at 2.6
#define PROJECTILE_HIT_THRESHOLD_LAYER 2.75
#define TABLE_LAYER            2.8  // Just under stuff that wants to be slightly below common objects.
#define BELOW_OBJ_LAYER        2.9  // Things that want to be slightly below common objects.
//? Turf/Obj layer boundary
#define ABOVE_OBJ_LAYER        3.1  // Things that want to be slightly above common objects.
#define DOOR_CLOSED_LAYER      3.1  // Doors when closed.
#define CLOSED_FIREDOOR_LAYER  3.11
#define WINDOW_LAYER           3.2  // Windows.
#define BLASTDOOR_CLOSED_LAYER 3.3 // ABOVE WINDOWS AND DOORS
#define ABOVE_WINDOW_LAYER     3.4  // Above full tile windows so wall items are clickable.
#define SIGN_LAYER             3.4
#define BELOW_MOB_LAYER        3.9

//! GAME_PLANE_UPPER (-5) layers
#define ABOVE_MOB_LAYER     4.1
#define WALL_OBJ_LAYER      4.25
#define EDGED_TURF_LAYER    4.3
#define ON_EDGED_TURF_LAYER 4.35
#define SPACEVINE_LAYER     4.4
// #define LARGE_MOB_LAYER     4.5
// #define SPACEVINE_MOB_LAYER 4.6

// Invisible things plane
#define CLOAKED_PLANE -1 //TODO: This shouldn't be a plane.

//! ABOVE_GAME_PLANE (-2) layers
#define ABOVE_ALL_MOB_LAYER 4.7 // Intermediate layer used by both GAME_PLANE_FOV_HIDDEN and ABOVE_GAME_PLANE

////////////////////////////////////////////////////////////////////////////////////////

#define HUD_LAYER    20 // Above lighting, but below obfuscation. For in-game HUD effects (whereas SCREEN_LAYER is for abstract/OOC things like inventory slots).
#define SCREEN_LAYER 22 // Mob HUD/effects layer.

// Status Indicators that show over mobs' heads when certain things like stuns affect them.
#define PLANE_STATUS 5

// Lighting on planets
#define PLANE_PLANETLIGHTING 6

// Where the lighting (and darkness) lives (ignoring all other higher planes)
#define LIGHTING_PLANE 7
#define LIGHTBULB_LAYER      0
#define LIGHTING_LAYER       1
#define ABOVE_LIGHTING_LAYER 2

// For glowy eyes etc. that shouldn't be affected by darkness
#define ABOVE_LIGHTING_PLANE 8
#define EYE_GLOW_LAYER         1
#define BEAM_PROJECTILE_LAYER  2
#define SUPERMATTER_WALL_LAYER 3

#define SONAR_PLANE 10

///The AI eye lives here
#define PLANE_AI_EYE 20

///Stuff seen with mesons, like open ceilings. This is 30 for downstreams.
#define PLANE_MESONS 35

///Augmented-reality plane
#define PLANE_AUGMENTED 40

#define FULLSCREEN_PLANE 90
#define OBFUSCATION_LAYER 19.9
#define FLASH_LAYER       20
#define FULLSCREEN_LAYER  20.1
#define UI_DAMAGE_LAYER   20.2
#define BLIND_LAYER       20.3
#define CRIT_LAYER        20.4
#define CURSE_LAYER       20.5
#define FULLSCREEN_RENDER_TARGET "FULLSCREEN_PLANE"

//! Client UI HUD stuff
// The character's UI is on this plane
#define PLANE_PLAYER_HUD 95
#define LAYER_HUD_UNDER 1 // Under the HUD items
#define LAYER_HUD_BASE  2 // The HUD items themselves
#define LAYER_HUD_ITEM  3 // Things sitting on HUD items (largely irrelevant because PLANE_PLAYER_HUD_ITEMS)
#define LAYER_HUD_ABOVE 4 // Things that reside above items (highlights)

// Separate layer with which to apply colorblindness
#define PLANE_PLAYER_HUD_ITEMS 96

// Things above the player hud
#define PLANE_PLAYER_HUD_ABOVE 97

//////////////////////////

//Check if a mob can "logically" see an atom plane
#define MOB_CAN_SEE_PLANE(M, P) (P <= BLACKNESS_PLANE || (P in M.planes_visible) || P >= PLANE_PLAYER_HUD)
