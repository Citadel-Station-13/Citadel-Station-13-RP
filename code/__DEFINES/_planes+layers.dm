/**
 *! This file is a list of all preclaimed planes & layers
 *
 * All planes & layers should be given a value here instead of using a magic/arbitrary number.
 *
 * After fiddling with planes and layers for some time, I figured I may as well provide some documentation:
 *
 *? What are planes?
 *  - Think of Planes as a sort of layer for a layer - if plane X is a larger number than plane Y, the highest number for a layer in X will be below the lowest
 *  - number for a layer in Y.
 *  - Planes also have the added bonus of having planesmasters.
 *
 *? What are Planesmasters?
 *  - Planesmasters, when in the sight of a player, will have its appearance properties (for example, colour matrices, alpha, transform, etc)
 *  - applied to all the other objects in the plane. This is all client sided.
 *  - Usually you would want to add the planesmaster as an invisible image in the client's screen.
 *
 *? What can I do with Planesmasters?
 *  - You can: Make certain players not see an entire plane,
 *  - Make an entire plane have a certain colour matrices,
 *  - Make an entire plane transform in a certain way,
 *  - Make players see a plane which is hidden to normal players - I intend to implement this with the antag HUDs for example.
 *  - Planesmasters can be used as a neater way to deal with client images or potentially to do some neat things
 *
 *? How do planes work?
 *  - A plane can be any integer from -100 to 100. (If you want more, bug lummox.)
 *  - All planes above 0, the 'base plane', are visible even when your character cannot 'see' them, for example, the HUD.
 *  - All planes below 0, the 'base plane', are only visible when a character can see them.
 *
 *? How do I add a plane?
 *  - Think of where you want the plane to appear, look through the pre-existing planes and find where it is above and where it is below
 *  - Slot it in in that place, and change the pre-existing planes, making sure no plane shares a number.
 *  - Add a description with a comment as to what the plane does.
 *
 *? How do I make something a planesmaster?
 *  - Add the PLANE_MASTER appearance flag to the appearance_flags variable.
 *
 *? What is the naming convention for planes or layers?
 *  - Make sure to use the name of your object before the _LAYER or _PLANE, eg: [NAME_OF_YOUR_OBJECT HERE]_LAYER or [NAME_OF_YOUR_OBJECT HERE]_PLANE
 *  - Also, as it's a define, it is standard practice to use capital letters for the variable so people know this.
 *
 *
 * For easy recordkeeping; these are BYOND defines.
 *
 * ! Primary Layers
 * FLOAT_LAYER -1
 * AREA_LAYER   1
 * TURF_LAYER   2
 * OBJ_LAYER    3
 * MOB_LAYER    4
 * FLY_LAYER    5
 *
 * ! Misc Layers
 * EFFECTS_LAYER    5000
 * TOPDOWN_LAYER    10000
 * BACKGROUND_LAYER 20000
 */

//TODO: Deplanify. @Zandario

// TODO: UNFUCK PLANES. HALF OF THESE HAVE NO REASON TO EXIST. WHOEVER ADDED THEM IS AN IDIOT!

/// smallest reasonable base layer resolution - YOU SHOULD NOT VIOLATE THIS
#define LAYER_RESOLUTION_BASE 0.01
/// smallest relative layer resolution - YOU SHOULD NOT VIOLATE THIS
#define LAYER_RESOLUTION_FULL 0.001

/// lowest reasonable plane; this should stay at -99. NO, YOU DON'T NEED MORE.
#define LOWEST_PLANE -99

//! todo: layers still need to be linear regardless of plane. stuff like projectiles DO CARE.

/**
 *! -- Click Catcher Plane
 *? For the click catcher. It catches clicks... Who would've guessed.
 */
#define CLICKCATCHER_PLANE -99


/**
 *! -- Space Plane
 *? For space turfs.
 */
#define SPACE_PLANE -95 /// Reserved for use in space/parallax.


/**
 *! -- Parallax Plane
 *? For the parallax background.
 */
#define PARALLAX_PLANE -90

#define PARALLAX_VIS_LAYER_BELOW -100 // Everything layering below.
#define PARALLAX_LAYER_CENTER       0
#define PARALLAX_VIS_LAYER_ABOVE  100 // Ditto


/**
 *! -- LOOKING GLAS PLANE
 *? For the Looking Glass holodecks.
 */
#define PLANE_LOOKINGGLASS     -77
#define PLANE_LOOKINGGLASS_IMG -76


// Openspace uses planes -80 through -70.
#define OVER_OPENSPACE_PLANE -50


/**
 *! -- Turfs Plane
 *? Turfs themselves, most flooring.
 */
#define TURF_PLANE -45

#define PLATING_LAYER               (AREA_LAYER)
#define DISPOSAL_LAYER              (AREA_LAYER+0.1)
#define DECAL_PLATING_LAYER         (AREA_LAYER+0.2)
#define DISPOSALS_PIPE_LAYER        (AREA_LAYER+0.3)
#define LATTICE_LAYER               (AREA_LAYER+0.4)
#define HEAVYDUTY_WIRE_LAYER        (AREA_LAYER+0.45)
#define PIPE_LAYER                  (AREA_LAYER+0.5)
#define WIRE_LAYER                  (AREA_LAYER+0.6)
#define WIRE_TERMINAL_LAYER         (AREA_LAYER+0.7)
#define ATMOS_LAYER                 (AREA_LAYER+0.8)  /// Pipe-like atmos machinery that goes on the floor, like filters.
#define BELOW_TURF_LAYER            (AREA_LAYER+0.9)  /// Above stuff like pipes and wires.

//? ABOVE PLATING

#define WATER_FLOOR_LAYER           (TURF_LAYER)      /// The 'bottom' of water tiles.
#define TURF_DETAIL_LAYER           (TURF_LAYER+0.01) /// For floors that automatically add decal overlays.

//? ABOVE TURF

#define DECAL_LAYER                 (TURF_LAYER+0.03) /// For intentionally placed floor decal overlays.
#define AO_LAYER                    (TURF_LAYER+0.04) /// Ambient Occlusion layer.
#define EXPOSED_PIPE_LAYER          (TURF_LAYER+0.06)
#define EXPOSED_WIRE_LAYER          (TURF_LAYER+0.07)
#define EXPOSED_WIRE_TERMINAL_LAYER (TURF_LAYER+0.08)
#define EXPOSED_ATMOS_LAYER         (TURF_LAYER+0.09) /// Pipe-like atmos machinery that goes on the floor, like filters.
#define CATWALK_LAYER               (TURF_LAYER+0.10)
#define PLANT_LAYER                 (TURF_LAYER+0.12)

//? HIDING MOB

#define HIDING_LAYER                (TURF_LAYER+0.14) /// Layer at which mobs hide to be under things like tables.
#define UNDERWATER_LAYER            (TURF_LAYER+0.15) /// Anything on this layer will render under the water layer.

#define BELOW_OBJ_LAYER             (TURF_LAYER+0.90)

//! Turf/Obj layer boundary

#define WATER_LAYER                 (OBJ_LAYER)      /// Layer for water overlays.
#define ABOVE_TURF_LAYER            (OBJ_LAYER+0.1)  /// Snow and wallmounted/floormounted equipment.

//! Obj/Mob layer boundary

#define MIMICED_LIGHTING_LAYER      (MOB_LAYER+0.22) /// Z-Mimic-managed lighting


/**
 *! -- Obj Plane
 */
#define OBJ_PLANE -35

#define DEBRIS_LAYER       (TURF_LAYER+0.4) /// Cleanable debris.
#define STAIRS_LAYER       (TURF_LAYER+0.5) /// Layer for stairs.
#define DOOR_OPEN_LAYER    (TURF_LAYER+0.7) /// Under all objects if opened. 2.7 due to tables being at 2.6.
#define TABLE_LAYER        (TURF_LAYER+0.8) /// Just under stuff that wants to be slightly below common objects.
#define PROJECTILE_HIT_THRESHOLD_LAYER 2.8
#define UNDER_JUNK_LAYER   (TURF_LAYER+0.9) /// Things that want to be slightly below common objects.

//! Turf/Obj layer boundary

#define ABOVE_JUNK_LAYER   (OBJ_LAYER+0.1) /// Things that want to be slightly above common objects.
#define DOOR_CLOSED_LAYER  (OBJ_LAYER+0.1) /// Doors when closed.
#define WINDOW_LAYER       (OBJ_LAYER+0.2) /// Windows.
#define ON_WINDOW_LAYER    (OBJ_LAYER+0.3) /// Ontop of a window.
#define ABOVE_WINDOW_LAYER (OBJ_LAYER+0.4) /// Above full tile windows so wall items are clickable.
#define MID_LANDMARK_LAYER (OBJ_LAYER+0.5)


/**
 *! -- Mob Plane
*/
#define MOB_PLANE -25

#define BELOW_MOB_LAYER (OBJ_LAYER+0.9)
#define ABOVE_MOB_LAYER (MOB_LAYER+0.1)

/**
 *! -- Cloaked Plane
 *? Invisible things plane.
 */
#define CLOAKED_PLANE -15


/**
 *! -- Above Plane
 *? In the sense that it's the highest in 'the world' and not a UI element.
 */
#define ABOVE_PLANE -10


/**
 *! -- World Plane
 *? BYOND's default value for plane, the "base plane"
 */
#define PLANE_WORLD 0 //! Black tiles outisde of your vision render here.

// I doubt these should be HERE, but they were here so they stay here until I can be bothered to move them. @Zandario
#define HUD_LAYER    20 /// Above lighting, but below obfuscation. For in-game HUD effects (whereas SCREEN_LAYER is for abstract/OOC things like inventory slots)
#define SCREEN_LAYER 22 /// Mob HUD/effects layer.


/**
 *! -- Status Plane
 *? Status Indicators that show over mobs' heads when certain things like stuns affect them.
 */
#define PLANE_STATUS 2


/**
 *! -- Admin1 Plane
 *? Purely for shenanigans (below lighting)
 * TODO: Probably remove this. @Zandario
 */
#define PLANE_ADMIN1 3


/**
 *! -- Planet Lighting Plane
 *? Lighting on planets.
 */
#define PLANE_PLANETLIGHTING 4


/**
 *! -- Emissive Blocker Plane
 */
#define EMISSIVE_BLOCKER_PLANE 7

#define EMISSIVE_BLOCKER_RENDER_TARGET "*EMISSIVE_BLOCKER_PLANE"

#define EMISSIVE_BLOCKER_LAYER 12


/**
 *! -- Emissives Plane
 */
#define EMISSIVE_PLANE 8

#define EMISSIVE_LAYER 13


/**
 *! -- Unblockable Emissives Plane
 */
#define EMISSIVE_UNBLOCKABLE_PLANE 9

#define EMISSIVE_UNBLOCKABLE_RENDER_TARGET "*EMISSIVE_UNBLOCKABLE_PLANE"
#define EMISSIVE_RENDER_TARGET "*EMISSIVE_PLANE"

#define EMISSIVE_UNBLOCKABLE_LAYER 14
#define EMISSIVE_LAYER_UNBLOCKABLE 14


/**
 *! -- Lighting Plane
 *? Where the lighting (and darkness) lives (ignoring all other higher planes)
 */
#define LIGHTING_PLANE 10

#define LIGHTBULB_LAYER      0 // Unused.
#define LIGHTING_LAYER       1
#define ABOVE_LIGHTING_LAYER 2


/**
 *! -- Lighting Plane
 *? For glowy eyes etc. that shouldn't be affected by darkness.
 */
#define ABOVE_LIGHTING_PLANE 15

#define EYE_GLOW_LAYER         1
#define BEAM_PROJECTILE_LAYER  2
#define SUPERMATTER_WALL_LAYER 3


/**
 *! -- Sonar Plane
 */
#define SONAR_PLANE 16


/**
 *! -- Ghost Plane
 *? Where ghosts live.
 * ~ Spooooooooky ghooooooosts ~
 */
#define PLANE_GHOSTS 20


/**
 *! -- AI Eye Plane
 *? The AI eye lives here.
 */
#define PLANE_AI_EYE 29


/**
 *! -- Meson Plane
 *? Stuff seen with mesons, like open ceilings. This is 30 for downstreams.
 */
#define PLANE_MESONS 30


/**
 *! -- Admin2 Plane
 *? Purely for shenanigans (above lighting)
 * TODO: Probably remove this. @Zandario
 */
#define PLANE_ADMIN2 33


/**
 *! -- Augmented Plane
 *? Augmented-reality stuff.
 */
#define PLANE_AUGMENTED 40

/**
 *! -- Fullscreen Plane
 *? Fullscreen overlays.
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


/**
 *! -- Player HUD Plane
 *? Client UI HUD stuff.
 *? The character's UI is on this plane.
 */
#define PLANE_PLAYER_HUD 95

#define LAYER_HUD_UNDER 1 /// Under the HUD items.
#define LAYER_HUD_BASE  2 /// The HUD items themselves.
#define LAYER_HUD_ITEM  3 /// Things sitting on HUD items (largely irrelevant because PLANE_PLAYER_HUD_ITEMS).
#define LAYER_HUD_ABOVE 4 /// Things that reside above items (highlights).


/**
 *! -- Player HUD Items Plane
 *? Separate layer with which to apply colorblindness.
 */
#define PLANE_PLAYER_HUD_ITEMS 96


/**
 *! -- Above HUD Plane
 *? Things above the player hud.
 */
#define PLANE_PLAYER_HUD_ABOVE 97


/**
 *! -- Admin3 Plane
 *? Purely for shenanigans (above HUD)
 * TODO: Probably remove this. @Zandario
 */
#define PLANE_ADMIN3 99


/// Highest plane. This should stay at 99. No, you don't need more than that.
#define HIGHEST_PLANE 99
/// Master rendering plane - we actually render onto this plane
// todo: unified rendering and a single game render master plane?
// #define MASTER_RENDERER_PLANE

//////////////////////////

//! Helpers
/**
 * "mangle" a plane and layer to get a layer that'll always layer it correctly
 * this is useful for multiz/emissive purposes if you don't want to make multiple sets of planes.
 *
 * luckily, as of right now, lowest is -99 and highest is 99
 * and we don't do /tg/'s planecube thing
 * thus, we can get away with stuffing everything with those assumptions
 *
 * we also can't be negative because of FLOAT_LAYER behavior so..
 *
 * oh yeah and this does NOT work well with FLOAT_LAYER.
 */
#define MANGLE_PLANE_AND_LAYER(P, L) ((P - LOWEST_PLANE + 1) * (PLANE_MANGLING_FACTOR) + L)
/// computed based on highest/lowest plane, and highest/lowest layer (which I assume to be 10k.)
#define PLANE_MANGLING_FACTOR 40
// todo: optimize
/// Check if a mob can "logically" see an atom plane
#define MOB_CAN_SEE_PLANE(M, P) (P <= PLANE_WORLD || (P in M.planes_visible) || P >= PLANE_PLAYER_HUD)
