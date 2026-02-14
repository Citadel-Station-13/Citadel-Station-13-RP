//This file is just for the necessary /world definition
//Try looking in /code/game/world.dm, where initialization order is defined

/**
 * # World
 *
 * Two possibilities exist: either we are alone in the Universe or we are not. Both are equally terrifying. ~ Arthur C. Clarke
 *
 * The byond world object stores some basic byond level config, and has a few hub specific procs for managing hub visibility
 */
/world
	mob = /mob/new_player
	// TODO: replace with /turf/unallocated
	// --           DO NOT USE THIS TURF ANYWHERE ELSE!                --
	// -- DO NOT EVEN REFERENCE WORLD.TURF OTHER THAN TO CHECK FOR IT. --
	turf = /turf/space/basic
	// TODO: replace with /area/unallocated
	area = /area/space
	view = "15x15"
	name = "Citadel Station 13 - Roleplay"
	status = "ERROR: Default status"
	/// world visibility. this should never, ever be touched.
	/// a weird byond bug yet to be resolved is probably making this
	/// permanently delist the server if this is disabled at any point.
	visibility = TRUE
	/// static value, do not change
	hub = "Exadv1.spacestation13"
	/// static value, do not change, except to toggle visibility
	/// * use this instead of `visibility` to toggle, via `update_hub_visibility`
	hub_password = "kMZy3U5jJHSiBQjr"
	movement_mode = PIXEL_MOVEMENT_MODE
	fps = 20
#ifdef FIND_REF_NO_CHECK_TICK
	loop_checks = FALSE
#endif
