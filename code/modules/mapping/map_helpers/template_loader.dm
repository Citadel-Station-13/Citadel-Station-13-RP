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

/obj/map_helper/template_loader/map_initializations(datum/dmm_context/context)
	. = ..()

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
	template.load(T, centered = FALSE, orientation = orientation)

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

/**
 * For /datum/map_injection/fixed_template_seeding.
 *
 * * This allows specific tags to be spawned here.
 * * As of right now, this has no checks on maximum size. Make your tags accordingly.
 */
/obj/map_helper/template_loader/corner_aligned/fixed_template_seeding_target
	/**
	 * Target tags for the template seeding.
	 * * Optionally associate a tag to a number to weight it.
	 *   Injection gets final say.
	 */
	var/list/allow_tags = list()

/obj/map_helper/template_loader/corner_aligned/fixed_template_seeding_target/default
	allow_tags = list(
		"default" = 1,
	)
