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
 *! -- Render Holder Plane
 *? Screen objects that act as an intermediate for render targets.
 *? Everything on this plane should use * to not be rendered.
 *? This plane has NO plane master.
 */
#define RENDER_INTERMEDIATE_PLANE -99


/**
 *! -- Click Catcher Plane
 *? For the click catcher. It catches clicks... Who would've guessed.
 *? This plane has NO plane master.
 */
#define CLICKCATCHER_PLANE -98


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
 *! -- Turfs Plane
 *? Turfs themselves, most flooring.
 */
#define TURF_PLANE -45
#define TURF_PLANE_RENDER_TARGET "TURF_PLANE"

#define PLATING_LAYER               (AREA_LAYER)
#define PLATING_DECAL_LAYER         (AREA_LAYER+0.01) //! Used for decals on plating and for map editors.
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
#define FLOOR_DECAL_LAYER           (TURF_LAYER+0.01) /// For floors that automatically add decal overlays.

//? ABOVE FLOOR

#define DECAL_LAYER                 (TURF_LAYER+0.03)  /// For intentionally placed floor decal overlays.
#define TURF_DAMAGE_LAYER           (TURF_LAYER+0.035) /// Layer at which turf damage overlays are placed.
#define TURF_AO_LAYER               (TURF_LAYER+0.04)  /// Ambient Occlusion layer.
#define EDGE_LAYER                  (TURF_LAYER+0.05)  /// Floor edge overlay layer.
#define EXPOSED_PIPE_LAYER          (TURF_LAYER+0.06)
#define EXPOSED_WIRE_LAYER          (TURF_LAYER+0.07)
#define EXPOSED_WIRE_TERMINAL_LAYER (TURF_LAYER+0.08)
#define EXPOSED_ATMOS_LAYER         (TURF_LAYER+0.09)  /// Pipe-like atmos machinery that goes on the floor, like filters.
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

#define MIMICED_LIGHTING_LAYER_MAIN      (MOB_LAYER+0.22) /// Z-Mimic-managed lighting

/**
 *! -- Obj Plane
 */
#define OBJ_PLANE -35
#define OBJ_PLANE_RENDER_TARGET "OBJ_PLANE"

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
#define MOB_PLANE_RENDER_TARGET "MOB_PLANE"

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
#define BYOND_PLANE 0 //! Black tiles outisde of your vision render here.

/**
 *! -- Planet Lighting Plane
 *? Lighting on planets.
 */
#define WEATHER_PLANE 4

/**
 *! -- Emissives Plane
 */
#define EMISSIVE_PLANE 8
#define EMISSIVE_RENDER_TARGET "*EMISSIVE_PLANE"

/**
 *! -- Lighting Plane
 *? Where the lighting (and darkness) lives (ignoring all other higher planes)
 */
#define LIGHTING_PLANE 10
#define LIGHTING_LAYER_MAIN 1
#define LIGHTING_RENDER_TARGET "LIGHTING_PLANE"
#define LIGHTING_ALPHA_FORWARD_TARGET "*LIGHTING_PLANE_ALPHA"

/**
 *! -- Soft Darkvision Render --
 *? Game world is projected onto this plane.
 */
#define DARKVISION_PLATE_PLANE 11
#define DARKVISION_PLATE_LAYER_TURFS 1
#define DARKVISION_PLATE_LAYER_OBJS 2
#define DARKVISION_PLATE_LAYER_MOBS 3
#define DARKVISION_PLATE_LAYER_MAIN 4
#define DARKVISION_PLATE_RENDER_TARGET "*DARKVISION_PLATE_PLANE"
#define DARKVISION_PLATE_FORWARD_TARGET "*DARKVISION_PLATE_PROCESSED"

/**
 *! -- Soft Darkvision Plane --
 *? This plane is what darkvision gets kicked onto.
 */
#define DARKVISION_PLANE 12
#define DARKVISION_LAYER_MAIN 1

/**
 *! -- Lighting Plane
 *? For effects etc. that shouldn't be affected by darkness.
 */
#define ABOVE_LIGHTING_PLANE 15
#define ABOVE_LIGHTING_LAYER_MAIN 1

/**
 *! -- Sonar Plane
 */
#define SONAR_PLANE 16

/**
 *! -- Ghost Plane
 *? Where ghosts live.
 * ~ Spooooooooky ghooooooosts ~
 */
#define OBSERVER_PLANE 20

/**
 *! -- Verticality Plane
 *? Stuff that used to be seen only with mesons, like open ceilings.
 */
#define VERTICALITY_PLANE 30

/**
 *! -- Augmented Plane
 *? Augmented-reality stuff.
 */
#define AUGMENTED_PLANE 40

/**
 *! -- Fullscreen Plane
 *? Fullscreen overlays.
 */
#define FULLSCREEN_PLANE 90

#define FULLSCREEN_LAYER_OBFUSCATION 19.9
#define FULLSCREEN_LAYER_MAIN 20.1
#define FULLSCREEN_LAYER_DAMAGE 20.2
#define FULLSCREEN_LAYER_BLIND 20.3
#define FULLSCREEN_LAYER_CRIT 20.4
#define FULLSCREEN_LAYER_CURSE 20.5

/**
 *! -- Player HUD Plane
 *? Client UI HUD stuff.
 *? The character's UI is on this plane.
 *
 * todo: some layers are unused?
 */
#define HUD_PLANE 95

#define HUD_LAYER_UNDER 1 /// Under the HUD items.
#define HUD_LAYER_BASE  2 /// The HUD items themselves.
#define HUD_LAYER_ITEM  3 /// Things sitting on HUD items (largely irrelevant because INVENTORY_PLANE).
#define HUD_LAYER_ABOVE 4 /// Things that reside above items (highlights).

/**
 *! -- Player HUD Items Plane
 *? Separate layer with which to apply colorblindness.
 */
#define INVENTORY_PLANE 96

/**
 *! -- Above HUD Plane
 *? Things above the player hud.
 */
#define ABOVE_HUD_PLANE 97

/// Highest plane. This should stay at 99. No, you don't need more than that.
#define HIGHEST_PLANE 99
/// Master rendering plane - we actually render onto this plane
// todo: unified rendering and a single game render master plane?
// #define MASTER_RENDERER_PLANE

//? Misc render sources / targets

#define RENDER_SOURCE_HOLOGRAM(key) "*hg_[key]"

//! Helpers
/// computed based on highest/lowest plane, and highest/lowest layer (which I assume to be 10k.)
#define PLANE_MANGLING_FACTOR 50
/// i don't even know how to compute this this is a wild guess that works for most
#define LAYER_MANGLING_FACTOR 0.5
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
#define MANGLE_PLANE_AND_LAYER(P, L) ((P - LOWEST_PLANE + 1) * (PLANE_MANGLING_FACTOR) + L * LAYER_MANGLING_FACTOR)
