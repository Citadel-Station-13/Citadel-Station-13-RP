/**
 * file for sonar functions
 *
 * sonar basically functions as a filter over everything that renders in a way people can see.
 */

/**
 * gets an abstract sonar appearance
 */
/datum/controller/subsystem/sonar/proc/get_shape_appearance(type, size = world.icon_size)
	RETURN_TYPE(/mutable_appearance)
	. = new /mutable_appearance
	#warn impl

/**
 * gets a filter for a given resolution
 */
/datum/controller/subsystem/sonar/proc/get_sonar_filter(resolution)
	#warn impl

/**
 * gets an appearance from an input atom and a given resolution
 */
/datum/controller/subsystem/sonar/proc/get_sonar_appearance(atom/rendering, resolution)
	// this proc will be very messy
	#warn impl

/atom/proc/__debug_to_sonar_appearance()
	appearance = get_sonar_appearance(src, resolution)

/**
 * sonar overlays
 */
/atom/movable/sonar_overlay
	name = "sonar overlay"
	desc = "why do you see this?"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/sonar_overlay/Initialize(mapload, mutable_appearance/MA)
	appearance = MA
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
