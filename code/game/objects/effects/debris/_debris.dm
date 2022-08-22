/**
 * debris
 *
 * eventually going to be auto-collating objects for things like
 * blood
 * gibs
 * dirt
 * etc
 */
/obj/effect/debris
	/// collatE?
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
