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
#define PARALLAX_VIS_LAYER_BELOW -10000
#define PARALLAX_LAYER_CENTER         0
#define PARALLAX_VIS_LAYER_ABOVE  10000

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
#define ABOVE_GAME_PLANE -2

#define BLACKNESS_PLANE 0 // To keep from conflicts with SEE_BLACKNESS internals

// todo: kill these too because frankly, fuck off.
// Plating
#define PLATING_PLANE FLOOR_PLANE
#define DISPOSAL_LAYER 2.1
#define PIPES_LAYER    2.2
#define WIRES_LAYER    2.3
#define ATMOS_LAYER    2.4 // Pipe-like atmos machinery that goes on the floor, like filters.
#define ABOVE_UTILITY  2.5 // Above stuff like pipes and wires.

// Turfs themselves, most flooring
#define TURF_PLANE FLOOR_PLANE
#define WATER_FLOOR_LAYER   2.0  // The 'bottom' of water tiles.
#define BUILTIN_DECAL_LAYER 2.01 // For floors that automatically add decal overlays.
#define MAPPER_DECAL_LAYER  2.02 //For intentionally placed floor decal overlays.
#define UNDERWATER_LAYER    2.5  //Anything on this layer will render under the water layer.
//! Turf/Obj layer boundary
#define WATER_LAYER         3.0  //Layer for water overlays.
#define ABOVE_TURF_LAYER    3.1  //Snow and wallmounted/floormounted equipment

// todo: kill all these useless goddamn arbitrary planes and unify things to 3-5 of turf, floor, obj, mob, there is no excuse for this utter charade.
#define DECAL_PLANE FLOOR_PLANE

// Obj planes
#define OBJ_PLANE GAME_PLANE
#define DEBRIS_LAYER       2.4  // Cleanable debris.
#define STAIRS_LAYER       2.5  // Layer for stairs.
#define CATWALK_LAYER      2.51 // Layer for catwalks.
#define HIDING_LAYER       2.6  // Layer at which mobs hide to be under things like tables.
#define DOOR_OPEN_LAYER    2.7  // Under all objects if opened. 2.7 due to tables being at 2.6
#define TABLE_LAYER        2.8  // Just under stuff that wants to be slightly below common objects.
#define PROJECTILE_HIT_THRESHOLD_LAYER 2.8
#define UNDER_JUNK_LAYER   2.9  // Things that want to be slightly below common objects.
//! Turf/Obj layer boundary
#define ABOVE_JUNK_LAYER   3.1  // Things that want to be slightly above common objects.
#define DOOR_CLOSED_LAYER  3.1  // Doors when closed.
#define WINDOW_LAYER       3.2  // Windows.
#define ON_WINDOW_LAYER    3.3  // Ontop of a window.
#define ABOVE_WINDOW_LAYER 3.4  // Above full tile windows so wall items are clickable.
#define MID_LANDMARK_LAYER 3.5

// Mob planes
#define MOB_PLANE GAME_PLANE
#define BELOW_MOB_LAYER 3.9
//! Obj/Mob layer boundary
#define ABOVE_MOB_LAYER 4.1

// Invisible things plane
#define CLOAKED_PLANE -3 //TODO: This shouldn't be a plane.

// Top plane (in the sense that it's the highest in 'the world' and not a UI element)
#define ABOVE_PLANE ABOVE_GAME_PLANE

////////////////////////////////////////////////////////////////////////////////////////
///BYOND's default value for plane, the "base plane"
#define PLANE_WORLD BLACKNESS_PLANE
#define HUD_LAYER    20 // Above lighting, but below obfuscation. For in-game HUD effects (whereas SCREEN_LAYER is for abstract/OOC things like inventory slots).
#define SCREEN_LAYER 22 // Mob HUD/effects layer.

// Status Indicators that show over mobs' heads when certain things like stuns affect them.
#define PLANE_STATUS 2

// Lighting on planets
#define PLANE_PLANETLIGHTING 4

// Where the lighting (and darkness) lives (ignoring all other higher planes)
#define LIGHTING_PLANE 5
#define LIGHTBULB_LAYER      0
#define LIGHTING_LAYER       1
#define ABOVE_LIGHTING_LAYER 2

// For glowy eyes etc. that shouldn't be affected by darkness
#define ABOVE_LIGHTING_PLANE 6
#define EYE_GLOW_LAYER         1
#define BEAM_PROJECTILE_LAYER  2
#define SUPERMATTER_WALL_LAYER 3

#define SONAR_PLANE 8

///Spooooooooky ghooooooosts
#define PLANE_GHOSTS 10

///The AI eye lives here
#define PLANE_AI_EYE 11

///Stuff seen with mesons, like open ceilings. This is 30 for downstreams.
#define PLANE_MESONS 30

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
#define MOB_CAN_SEE_PLANE(M, P) (P <= PLANE_WORLD || (P in M.planes_visible) || P >= PLANE_PLAYER_HUD)
