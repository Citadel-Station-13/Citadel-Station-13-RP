/*This file is a list of all preclaimed planes & layers

All planes & layers should be given a value here instead of using a magic/arbitrary number.

After fiddling with planes and layers for some time, I figured I may as well provide some documentation:

What are planes?
	Think of Planes as a sort of layer for a layer - if plane X is a larger number than plane Y, the highest number for a layer in X will be below the lowest
	number for a layer in Y.
	Planes also have the added bonus of having planesmasters.

What are Planesmasters?
	Planesmasters, when in the sight of a player, will have its appearance properties (for example, colour matrices, alpha, transform, etc)
	applied to all the other objects in the plane. This is all client sided.
	Usually you would want to add the planesmaster as an invisible image in the client's screen.

What can I do with Planesmasters?
	You can: Make certain players not see an entire plane,
	Make an entire plane have a certain colour matrices,
	Make an entire plane transform in a certain way,
	Make players see a plane which is hidden to normal players - I intend to implement this with the antag HUDs for example.
	Planesmasters can be used as a neater way to deal with client images or potentially to do some neat things

How do planes work?
	A plane can be any integer from -100 to 100. (If you want more, bug lummox.)
	All planes above 0, the 'base plane', are visible even when your character cannot 'see' them, for example, the HUD.
	All planes below 0, the 'base plane', are only visible when a character can see them.

How do I add a plane?
	Think of where you want the plane to appear, look through the pre-existing planes and find where it is above and where it is below
	Slot it in in that place, and change the pre-existing planes, making sure no plane shares a number.
	Add a description with a comment as to what the plane does.

How do I make something a planesmaster?
	Add the PLANE_MASTER appearance flag to the appearance_flags variable.

What is the naming convention for planes or layers?
	Make sure to use the name of your object before the _LAYER or _PLANE, eg: [NAME_OF_YOUR_OBJECT HERE]_LAYER or [NAME_OF_YOUR_OBJECT HERE]_PLANE
	Also, as it's a define, it is standard practice to use capital letters for the variable so people know this.

*/

#define CLICKCATCHER_PLANE		-99
#define SPACE_PLANE				-95 /// Reserved for use in space/parallax
#define PARALLAX_PLANE			-90 /// Reserved for use in space/parallax
	/// Everything layering below.
	#define PARALLAX_VIS_LAYER_BELOW			-10000
	#define PARALLAX_LAYER_CENTER				0
	/// Also everything layering below.
	#define PARALLAX_VIS_LAYER_ABOVE			10000

#define PLANE_LOOKINGGLASS		-77 /// For the Looking Glass holodecks
#define PLANE_LOOKINGGLASS_IMG	-76 /// For the Looking Glass holodecks

//OPENSPACE_PLANE reserves all planes between OPENSPACE_PLANE_START and OPENSPACE_PLANE_END inclusive
///turf/simulated/open will use OPENSPACE_PLANE + z (Valid z's being 2 thru 17)
#define OPENSPACE_PLANE			-75
#define OPENSPACE_PLANE_START	-73
#define OPENSPACE_PLANE_END		-58
#define OVER_OPENSPACE_PLANE	-57


//! ## TURF PLANES ----

//? Plating.
#define PLATING_PLANE			-44
	#define PLATING_LAYER			1.0
	#define DISPOSAL_LAYER			2.1 /// Under objects, even when planeswapped.
	#define PIPES_LAYER				2.2 /// Under objects, even when planeswapped.
	#define WIRES_LAYER				2.3 /// Under objects, even when planeswapped.
	#define ATMOS_LAYER				2.4 /// Pipe-like atmos machinery that goes on the floor, like filters.
	#define ABOVE_UTILITY			2.5 /// Above stuff like pipes and wires.

//? Turfs themselves, most flooring.
#define TURF_PLANE				-45
	#define WATER_FLOOR_LAYER		2.0 /// The 'bottom' of water tiles.
	#define AUTODECAL_LAYER			2.1 /// For floors that automatically add decal overlays.
	#define DECAL_LAYER				2.2 ///For intentionally placed floor decal overlays
	#define UNDERWATER_LAYER		2.5	/// Anything on this layer will render under the water layer.
	#define WATER_LAYER				3.0 /// Layer for water overlays.
	#define ABOVE_TURF_LAYER		3.1 /// Snow and wallmounted/floormounted equipment.

//? Permanent decals.
#define DECAL_PLANE				-44

//? Nonpermanent decals.
#define DIRTY_PLANE				-43

//? Blood is really dirty, but we can do special stuff if we separate it.
#define BLOOD_PLANE				-42


//! ## OBJ PLANES ----
#define OBJ_PLANE				-35
	#define STAIRS_LAYER			2.5 /// Layer for stairs.
	#define SHALLOW_FLUID_LAYER		2.0 /// Layer for shallow water.
	#define HIDING_MOB_LAYER		2.6 /// Layer at which mobs hide to be under things like tables.
	#define DOOR_OPEN_LAYER			2.7 /// Under all objects if opened. 2.7 due to tables being at 2.6.
	#define TABLE_LAYER				2.8 /// Just under stuff that wants to be slightly below common objects.
	#define PROJECTILE_HIT_THRESHOLD_LAYER 2.8
	#define UNDER_JUNK_LAYER		2.9 /// Things that want to be slightly below common objects.

	//?Turf/Obj layer boundary.
	#define ABOVE_JUNK_LAYER		3.1 /// Things that want to be slightly above common objects.
	#define DOOR_CLOSED_LAYER		3.1 /// Doors when closed.
	#define WINDOW_LAYER			3.2 /// Windows.
	#define ON_WINDOW_LAYER			3.3 /// Ontop of a window.
	#define ABOVE_WINDOW_LAYER		3.4 /// Above full tile windows so wall items are clickable.
	#define MID_LANDMARK_LAYER		3.5


//! # MOB PLANES ----
#define MOB_PLANE				-25
	#define BELOW_MOB_LAYER			3.9 /// Should be converted to plane swaps.
	#define ABOVE_MOB_LAYER			4.1 /// Should be converted to plane swaps.


//! ## INVISIBLE PLANES ----
#define CLOAKED_PLANE			-15


//! ## TOP PLANES ----
//? Top plane (in the sense that it's the highest in 'the world' and not a UI element)
#define ABOVE_PLANE				-10

////////////////////////////////////////////////////////////////////////////////////////
#define PLANE_WORLD				0	// BYOND's default value for plane, the "base plane"
////////////////////////////////////////////////////////////////////////////////////////

	//#define AREA_LAYER		1 //For easy recordkeeping; this is a byond define

	//#define TURF_LAYER		2 //For easy recordkeeping; this is a byond define

	//#define OBJ_LAYER			3 //For easy recordkeeping; this is a byond define

	//#define MOB_LAYER			4 //For easy recordkeeping; this is a byond define

	//#define FLY_LAYER			5 //For easy recordkeeping; this is a byond define

	//? Above lighting, but below obfuscation.
	#define HUD_LAYER				20 /// For in-game HUD effects (whereas SCREEN_LAYER is for abstract/OOC things like inventory slots).

	#define SCREEN_LAYER			22 ///Mob HUD/effects layer.

//? Status Indicators that show over mobs' heads when certain things like stuns affect them.
#define PLANE_STATUS			2
//? Purely for shenanigans (below lighting).
#define PLANE_ADMIN1			3
//? Lighting on planets.
#define PLANE_PLANETLIGHTING	4


//! ## LIGHTING PLANES ----
//? Where the lighting (and darkness) lives (ignoring all other higher planes).
#define LIGHTING_PLANE			5
	#define LIGHTBULB_LAYER			0
	#define LIGHTING_LAYER			1
	#define ABOVE_LIGHTING_LAYER	2


//! ## ABOVE LIGHTING PLANES ----
//? For glowy eyes etc. that shouldn't be affected by darkness.
#define ABOVE_LIGHTING_PLANE	6
	#define EYE_GLOW_LAYER			1
	#define DEEP_FLUID_LAYER		2
	#define BEAM_PROJECTILE_LAYER	3
	#define SUPERMATTER_WALL_LAYER	4

#define SONAR_PLANE				8

//? Spooooooooky ghooooooosts
#define PLANE_GHOSTS			10
///? he AI eye lives here
#define PLANE_AI_EYE			11
//? Stuff seen with mesons, like open ceilings. This is 30 for downstreams.
#define PLANE_MESONS			30
//? Purely for shenanigans (above lighting)
#define PLANE_ADMIN2			33
//? Augmented-reality plane
#define PLANE_AUGMENTED			40

//! ## FULLSCREEN PLANES ----
//? Fullscreen overlays under inventory
#define FULLSCREEN_PLANE		90 /// Blindness, mesons, druggy, etc.
	#define OBFUSCATION_LAYER		19.9  /// Where images covering the view for eyes are put.
	#define FLASH_LAYER				20
	#define FULLSCREEN_LAYER		20.1
	#define UI_DAMAGE_LAYER			20.2
	#define DAMAGE_SCREEN_LAYER		18.1
	#define BLIND_LAYER				18.3
	#define CRIT_LAYER				18.4
	#define CURSE_LAYER				18.5

#define FULLSCREEN_RENDER_TARGET "FULLSCREEN_PLANE"

//! ## UI PLANES ----
#define PLANE_PLAYER_HUD		95 /// The character's UI is on this plane.
	#define LAYER_HUD_UNDER			1 /// Under the HUD items.
	#define LAYER_HUD_BASE			2 /// The HUD items themselves.
	#define LAYER_HUD_ITEM			3 /// Things sitting on HUD items (largely irrelevant because PLANE_PLAYER_HUD_ITEMS).
	#define LAYER_HUD_ABOVE			4 /// Things that reside above items (highlights).

//? Separate layer with which to apply colorblindness.
#define PLANE_PLAYER_HUD_ITEMS	96


//! ## ABOVE UI PLANES ----
//? Things above the player hud.
#define PLANE_PLAYER_HUD_ABOVE	97
//? Purely for shenanigans (above HUD).
#define PLANE_ADMIN3			99

//////////////////////////
/atom/proc/hud_layerise()
	plane = PLANE_PLAYER_HUD_ITEMS
	layer = LAYER_HUD_ITEM

/atom/proc/reset_plane_and_layer()
	plane = initial(plane)
	set_base_layer(initial(layer))

/// Check if a mob can "logically" see an atom plane.
#define MOB_CAN_SEE_PLANE(M, P) (P <= PLANE_WORLD || (P in M.planes_visible))
