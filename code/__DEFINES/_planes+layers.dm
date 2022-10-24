/**
 * TODO: We plan to move over to a system similar to tg's rendering system. @Zandario
 * This file is a list of all preclaimed planes & layers
 *
 * All planes & layers should be given a value here instead of using a magic/arbitrary number.
 *
 * After fiddling with planes and layers for some time, I figured I may as well provide some documentation:
 *
 * What are planes?
 * * Think of Planes as a sort of layer for a layer - if plane X is a larger number than plane Y, the highest number for a layer in X will be below the lowest
 * * number for a layer in Y.
 * * Planes also have the added bonus of having planesmasters.
 *
 * What are Planesmasters?
 * * Planesmasters, when in the sight of a player, will have its appearance properties (for example, colour matrices, alpha, transform, etc)
 * * applied to all the other objects in the plane. This is all client sided.
 * * Usually you would want to add the planesmaster as an invisible image in the client's screen.
 *
 * What can I do with Planesmasters?
 * * You can: Make certain players not see an entire plane,
 * * Make an entire plane have a certain colour matrices,
 * * Make an entire plane transform in a certain way,
 * * Make players see a plane which is hidden to normal players - I intend to implement this with the antag HUDs for example.
 * * Planesmasters can be used as a neater way to deal with client images or potentially to do some neat things
 *
 * How do planes work?
 * * A plane can be any integer from -100 to 100. (If you want more, bug lummox.)
 * * All planes above 0, the 'base plane', are visible even when your character cannot 'see' them, for example, the HUD.
 * * All planes below 0, the 'base plane', are only visible when a character can see them.
 *
 * How do I add a plane?
 * * Think of where you want the plane to appear, look through the pre-existing planes and find where it is above and where it is below
 * * Slot it in in that place, and change the pre-existing planes, making sure no plane shares a number.
 * * Add a description with a comment as to what the plane does.
 *
 * How do I make something a planesmaster?
 * * Add the PLANE_MASTER appearance flag to the appearance_flags variable.
 *
 * What is the naming convention for planes or layers?
 * * Make sure to use the name of your object before the _LAYER or _PLANE, eg: [NAME_OF_YOUR_OBJECT HERE]_LAYER or [NAME_OF_YOUR_OBJECT HERE]_PLANE
 * * Also, as it's a define, it is standard practice to use capital letters for the variable so people know this.
 *
 */

// TODO: UNFUCK PLANES. HALF OF THESE HAVE NO REASON TO EXIST. WHOEVER ADDED THEM IS AN IDIOT!

//! todo: layers still need to be linear regardless of plane. stuff like projectiles DO CARE.

#warn Finish cleaning up planes and layers. This is a mess. @Zandario

/**
 *! ## SUB-TURF PLANES
 */

#define CLICKCATCHER_PLANE       -99
#define SPACE_PLANE              -95    // Reserved for use in space/parallax.
#define PARALLAX_PLANE           -90    // Reserved for use in space/parallax.
#define PARALLAX_VIS_LAYER_BELOW -10000 // Everything layering below.
#define PARALLAX_VIS_LAYER_ABOVE  10000 // Everything layering above.

#define PLANE_LOOKINGGLASS     -77 // For the Looking Glass holodecks.
#define PLANE_LOOKINGGLASS_IMG -76 // For the Looking Glass holodecks.

//! OPENSPACE_PLANE reserves all planes between OPENSPACE_PLANE_START and OPENSPACE_PLANE_END inclusive
///turf/simulated/open will use OPENSPACE_PLANE + z (Valid z's being 2 thru 17)
#define OPENSPACE_PLANE       -75
#define OPENSPACE_PLANE_START -73
#define OPENSPACE_PLANE_END   -58
#define OVER_OPENSPACE_PLANE  -57


/**
 *! ## TURF PLANES
 */

//! PLATING
#define PLATING_PLANE -44

#define ATMOS_LAYER    2.40 /// Pipe-like atmos machinery that goes on the floor, like filters.
#define ABOVE_UTILITY  2.50 /// Above stuff like pipes and wires.

//! TURF
//? Turfs themselves, most flooring.
#define TURF_PLANE -45

#define MID_TURF_LAYER           2.02
#define HIGH_TURF_LAYER          2.03
#define TURF_PLATING_DECAL_LAYER 2.031
#define TURF_DECAL_LAYER         2.039 //Makes turf decals appear in DM how they will look inworld.
#define ABOVE_OPEN_TURF_LAYER    2.04
#define CLOSED_TURF_LAYER        2.05
#define BULLET_HOLE_LAYER        2.06
#define DISPOSAL_PIPE_LAYER      2.30
#define GAS_PIPE_HIDDEN_LAYER    2.35  //layer = initial(layer) + piping_layer / 1000 in atmospherics/update_icon() to determine order of pipe overlap
#define WIRE_LAYER               2.4
#define WIRE_TERMINAL_LAYER      2.45
#define GAS_SCRUBBER_LAYER       2.46
#define GAS_PIPE_VISIBLE_LAYER   2.47 //layer = initial(layer) + piping_layer / 1000 in atmospherics/update_icon() to determine order of pipe overlap
#define GAS_FILTER_LAYER         2.48
#define GAS_PUMP_LAYER           2.49
#define DEBRIS_LAYER             2.45  // cleanable debris.
#define UNDERWATER_LAYER         2.5   // Anything on this layer will render under the water layer.
#define TABLE_LAYER              2.8   // Just under stuff that wants to be slightly below common objects.
#define BELOW_OBJ_LAYER          2.9
//! Turf/Obj layer boundary
#define ABOVE_TURF_LAYER         3.10  // Snow and wallmounted/floormounted equipment.
#define CLOSED_DOOR_LAYER        3.11
#define CLOSED_FIREDOOR_LAYER    3.12
#define ABOVE_OBJ_LAYER          3.20

// todo: kill all these useless goddamn arbitrary planes and unify things to 3-5 of turf, floor, obj, mob, there is no excuse for this utter charade.
//! DECALS
#define DECAL_PLANE -44


/**
 *! ## OBJ PLANES
 */

//! OBJS
#define OBJ_PLANE -35

#define STAIRS_LAYER       2.5 // Layer for stairs.
#define HIDING_LAYER       2.6 // Layer at which mobs hide to be under things like tables.
#define DOOR_OPEN_LAYER    2.7 // Under all objects if opened. 2.7 due to tables being at 2.6.
#define PROJECTILE_HIT_THRESHOLD_LAYER 2.8
//! Turf/Obj layer boundary
#define ON_WINDOW_LAYER    3.3 // Ontop of a window.
#define ABOVE_WINDOW_LAYER 3.4 // Above full tile windows so wall items are clickable.
#define MID_LANDMARK_LAYER 3.5


/**
 *! ## MOB PLANES
 */

//! ## MOB PLANE
#define MOB_PLANE -25

#define BELOW_MOB_LAYER 3.9 //! Should be converted to plane swaps!
//! Obj/Mob layer boundary
#define ABOVE_MOB_LAYER 4.1 //! Should be converted to plane swaps!


//! INVISIBLE
#define CLOAKED_PLANE -15


//! TOP
//? In the sense that it's the highest in 'the world' and not a UI element.
#define ABOVE_PLANE -10


/**
 *! ## WORLD PLANES
 */

//? BYOND's default value for plane, the "base plane".
#define PLANE_WORLD 0

//! For easy recordkeeping; these are byond defines.
//define FLOAT_LAYER -1
//#define AREA_LAYER  1
//#define TURF_LAYER  2
//#define    3
//#define MOB_LAYER   4
//#define FLY_LAYER   5
//! Now for our own.
//! Above lighting, but below obfuscation.
#define HUD_LAYER    20 // For in-game HUD effects. (whereas SCREEN_LAYER is for abstract/OOC things like inventory slots)
#define SCREEN_LAYER 22 // Mob HUD/effects layer.

/// Status Indicators that show over mobs' heads when certain things like stuns affect them.
#define PLANE_STATUS 2

/// Purely for shenanigans. (below lighting)
#define PLANE_ADMIN1 3

/// Lighting on planets.
#define PLANE_PLANETLIGHTING 4


/**
 *! ## LIGHTING PLANES
 */

/// Where the lighting (and darkness) lives. (ignoring all other higher planes)
#define LIGHTING_PLANE 5

#define LIGHTBULB_LAYER      0
#define LIGHTING_LAYER       1
//! Area/Turf layer boundary
#define ABOVE_LIGHTING_LAYER 2


/// For glowy eyes etc. that shouldn't be affected by darkness.
#define ABOVE_LIGHTING_PLANE 6

#define EYE_GLOW_LAYER         1
//! Area/Turf layer boundary
#define BEAM_PROJECTILE_LAYER  2
//! Turf/Obj layer boundary
#define SUPERMATTER_WALL_LAYER 3


#define SONAR_PLANE 8


/**
 *! ## MISC PLANES
 */

/// Spooooooooky ghooooooosts.
#define PLANE_GHOSTS 10

/// The AI eye lives here.
#define PLANE_AI_EYE 11

/// Stuff seen with mesons, like open ceilings. This is 30 for downstreams.
#define PLANE_MESONS 30

/// Purely for shenanigans. (above lighting)
#define PLANE_ADMIN2 33

/// Augmented-reality plane.
#define PLANE_AUGMENTED 40


/**
 *! ## FULLSCREEN PLANES
 */

#define FULLSCREEN_PLANE 90

#define OBFUSCATION_LAYER 19.9
#define FLASH_LAYER       20
#define FULLSCREEN_LAYER  20.1
#define UI_DAMAGE_LAYER   20.2
#define BLIND_LAYER       20.3
#define CRIT_LAYER        20.4
#define CURSE_LAYER       20.5
#define FULLSCREEN_RENDER_TARGET "FULLSCREEN_PLANE"


//! ## CLIENT UI HUD
//? The character's UI is on this plane.
#define PLANE_PLAYER_HUD 95

#define LAYER_HUD_UNDER 1 // Under the HUD items.
//! Area/Turf layer boundary
#define LAYER_HUD_BASE  2 // The HUD items themselves.
//! Turf/Obj layer boundary
#define LAYER_HUD_ITEM  3 // Things sitting on HUD items. (largely irrelevant because PLANE_PLAYER_HUD_ITEMS)
//! Obj/Mob layer boundary
#define LAYER_HUD_ABOVE 4 // Things that reside above items. (highlights)


/// Separate layer with which to apply colorblindness.
#define PLANE_PLAYER_HUD_ITEMS 96


/// Things above the player hud.
#define PLANE_PLAYER_HUD_ABOVE 97


/// Purely for shenanigans. (above HUD)
#define PLANE_ADMIN3 99


////////////////////////////////////////////////////

//Check if a mob can "logically" see an atom plane
#define 	MOB_CAN_SEE_PLANE(M, P) (P <= PLANE_WORLD || (P in M.planes_visible) || P >= PLANE_PLAYER_HUD)
