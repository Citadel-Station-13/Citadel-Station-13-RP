//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * A map helper that immediately loads a template, before
 * atom initialization.
 */
/obj/map_helper/template_loader
	name = "Template Loader"
	early = TRUE

	/// use an isolated map context for the template
	///
	/// TODO: a way to pass in map injections and stuff from mapping tools would be nice.
	var/detach_from_map = FALSE

/obj/map_helper/template_loader/map_initializations(datum/dmm_context/dmm_context, datum/map_context/map_context)
	..()

	var/list/resolved = resolve_aligned_load_target()
	if(!resolved)
		return

	var/datum/map_template/template = resolved[1]
	var/x = resolved[2]
	var/y = resolved[3]
	var/z = resolved[4]
	var/orientation = resolved[5]

	if(!template)
		return

	var/turf/T = locate(x, y, z)
	if(!T)
		CRASH("template loader failed to locate turf at specified coordinates ([x], [y], [z])")

	log_game("Chainloading template [template] at ([x], [y], [z]) with orientation [orientation] via [src] ([REF(src)]).")
	template.load_standalone(T, orientation = orientation)

/**
 * * This may return null to cancel
 * @return null or list(template datum, x, y, z, orientation); x/y/z is for the lower left corner.
 */
/obj/map_helper/template_loader/proc/resolve_aligned_load_target()
	return

/**
 * Loads a template aligned at a specific corner of the template.
 */
/obj/map_helper/template_loader/corner_aligned

#warn impl; do dirs too + icons

/obj/map_helper/template_loader/corner_aligned/proc/resolve_template()
	return null

/obj/map_helper/template_loader/corner_aligned/resolve_aligned_load_target()
	var/datum/map_template/template = resolve_template()
	if(!template)
		return

	#warn impl / measure
	var/x = get_turf(src).x
	var/y = get_turf(src).y
	var/z = get_turf(src).z
	var/orientation = SOUTH

	// adjust x/y based on orientation and template size
	var/width = template.width
	var/height = template.height

	if(orientation == SOUTH)
		// no adjustment
		pass()
	else if(orientation == EAST)
		x -= width - 1
	else if(orientation == NORTH)
		x -= width - 1
		y -= height - 1
	else if(orientation == WEST)
		y -= height - 1

	return list(template, x, y, z, orientation)
	#warn impl


/obj/map_helper/template_loader/corner_aligned/static_load
	/**
	 * May be an ID, path, or instance.
	 */
	var/load_template

/obj/map_helper/template_loader/corner_aligned/static_load/resolve_template()
	#warn impl
