/**
 * debris
 *
 * eventually going to be auto-collating objects for things like
 * * blood
 * * gibs
 * * dirt
 * * etc
 *
 * * Always define your own initialization procedures BEFORE calling parent, or Collate() won't run at the right time.
 */
/obj/effect/debris
	/// collate?
	var/collate = FALSE
	/// used by persistence serialization as a temp var for speed
	var/tmp/debris_serialization_temporary

/obj/effect/debris/Initialize(mapload)
	. = ..()
	if(collate && Collate())
		return INITIALIZE_HINT_QDEL

/**
 * return true to qdel on init instead
 *
 * this proc should kick our date into other matching thing son this turf.
 */
/obj/effect/debris/proc/Collate()
	// by default, deletes ourselves if there's anything like us in the turf.
	return locate(type) in loc

//* Atom Color - we don't use the expensive system. *//

/obj/effect/debris/get_atom_colour()
	return color

/obj/effect/debris/add_atom_colour(coloration, colour_priority)
	color = coloration

/obj/effect/debris/remove_atom_colour(colour_priority, coloration)
	color = null

/obj/effect/debris/update_atom_colour()
	return

/obj/effect/debris/copy_atom_colour(atom/other, colour_priority)
	if(isnull(other.color))
		return
	color = other.color

#warn turf click redirection
