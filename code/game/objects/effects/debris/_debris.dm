/**
 * debris
 *
 * eventually going to be auto-collating objects for things like
 * blood
 * gibs
 * dirt
 * etc
 *
 * !Always define your own initialization procedures BEFORE calling parent, or Collate() won't run at the right time.
 */
/obj/effect/debris
	/// collate?
	var/collate = FALSE

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
