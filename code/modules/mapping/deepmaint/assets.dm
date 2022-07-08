/**
 * core assets
 */

GLOBAL_VAR(deepmaint_current_interior_wall)
GLOBAL_VAR(deepmaint_current_exterior_wall)
GLOBAL_VAR(deepmaint_current_interior_floor)
GLOBAL_VAR(deepmaint_current_interior_plating)
GLOBAL_VAR(deepmaint_current_exterior_floor)

/area/deepmaint
	icon = 'icons/mapping/deepmaint.dmi'
	name = "Unexplored Area"
	always_unpowered = FALSE

/area/deepmaint/room
	icon_state = "area_room"

/area/deepmaint/room/powered
	requires_power = FALSE

/area/deepmaint/tunnel
	area_flags = AREA_ABSTRACT
	icon_state = "area_path"

/turf/deepmaint
	icon = 'icons/mapping/deepmaint.dmi'
	icon_state = ""
	initial_gas_mix = ATMOSPHERE_ID_USE_DEFAULT

/turf/deepmaint/Initialize(mapload)
	. = ..()
	ChangeTurf(actual_path(), CHANGETURF_INHERIT_AIR)

/turf/deepmaint/proc/actual_path()
	return /turf/simulated/floor/plating

/turf/deepmaint/interior_wall
	name = "interior wall"
	icon_state = "interior_wall"

/turf/deepmaint/interior_wall/actual_path()
	return GLOB.deepmaint_current_interior_wall || /turf/simulated/wall

/turf/deepmaint/exterior_wall
	name = "exterior wall"
	icon_state = "exterior_wall"

/turf/deepmaint/exterior_wall/actual_path()
	return GLOB.deepmaint_current_exterior_wall || /turf/simulated/wall

/turf/deepmaint/interior_floor
	name = "interior floor"
	icon_state = "interior_floor"

/turf/deepmaint/interior_floor/actual_path()
	return GLOB.deepmaint_current_interior_floor || /turf/simulated/floor

/turf/deepmaint/interior_plating
	name = "interior plating"
	icon_state = "interior_plating"

/turf/deepmaint/interior_plating/actual_path()
	return GLOB.deepmaint_current_interior_plating | /turf/simulated/floor/plating

/turf/deepmaint/exterior_floor
	name = "exterior floor"
	icon_state = "exterior_floor"

/turf/deepmaint/exterior_floor/actual_path()
	return GLOB.deepmaint_current_exterior_floor || /turf/simulated/floor

/obj/landmark/deepmaint_marker
	icon = 'icons/mapping/deepmaint.dmi'

/**
 * room directives
 */
/obj/landmark/deepmaint_marker/room

/**
 * triggered when the directive is put into practice
 */
/obj/landmark/deepmaint_marker/room/proc/activate()
	#warn implement for multiz

/**
 * deepmaint room directive: connect entrance to this path
 */
/obj/landmark/deepmaint_marker/room/entrance
	icon_state = "room_entrance"

/**
 * deepmaint room directive: allow spawning of cross-level here
 */
/obj/landmark/deepmaint_marker/room/multiz
	/// are we allowed to go multiz up or down
	var/allowed_dirs = NONE

/obj/landmark/deepmaint_marker/room/multiz/up
	allowed_dirs = UP

/obj/landmark/deepmaint_marker/room/multiz/both/ladder
	icon_state = "ladder_both"

/obj/landmark/deepmaint_marker/room/multiz/both/stairs
	icon_state = "stairs_both"

/obj/landmark/deepmaint_marker/room/multiz/up
	allowed_dirs = UP

/obj/landmark/deepmaint_marker/room/multiz/up/ladder
	icon_state = "ladder_up"

/obj/landmark/deepmaint_marker/room/multiz/up/stairs
	icon_state = "stairs_up"

/obj/landmark/deepmaint_marker/room/multiz/down
	allowed_dirs = DOWN

/obj/landmark/deepmaint_marker/room/multiz/down/ladder
	icon_state = "ladder_down"

/obj/landmark/deepmaint_marker/room/multiz/down/stairs
	icon_state = "stairs_down"

/**
 * deepmaint generation directive: links to a generator and affects generation
 * all of these are soft directives
 * the generator is free to ignore them
 */
/obj/landmark/deepmaint_marker/generation
	/// id to link to
	var/id

/obj/landmark/deepmaint_marker/generation/Initialize(mapload)
	. = ..()
	if(!id)
		. = INITIALIZE_HINT_QDEL
		CRASH("no ID")
	SSmapping.add_deepmaint_marker(src, id)

/obj/landmark/deepmaint_marker/generation/Destroy()
	SSmapping.remove_deepmaint_marker(src, id)
	return ..()

/obj/landmark/deepmaint_marker/generation/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, id))
		SSmapping.remove_deepmaint_marker(src, id)
	. = ..()
	if(var_name == NAMEOF(src, id))
		SSmapping.add_deepmaint_marker(src, id)

/**
 * deepmaint generation directive: less danger towards this area
 */
/obj/landmark/deepmaint_marker/generation/low_danger
	icon_state = "marker_low_danger"

/**
 * deepmaint generation directive: more danger towards this area
 */
/obj/landmark/deepmaint_marker/generation/high_danger
	icon_state = "marker_high_danger"

/**
 * deepmaint generation directive: less rarity towards this area
 */
/obj/landmark/deepmaint_marker/generation/low_value
	icon_state = "marker_low_value"

/**
 * deepmaint generation directive: more rarity towards this area
 */
/obj/landmark/deepmaint_marker/generation/high_value
	icon_state = "marker_high_value"

/**
 * deepmaint generation directive: avoid this area
 */
/obj/landmark/deepmaint_marker/generation/avoid
	icon_state = "avoid"

/**
 * deepmaint generation directive: crowd this area
 */
/obj/landmark/deepmaint_marker/generation/crowd
	icon_state = "crowd"

/**
 * deepmaint generation directive: attepmt to use this as an entrance connector
 * this can be put in entrance templates.
 */
/obj/landmark/deepmaint_marker/generation/entrance
	icon_state = "entrance"
