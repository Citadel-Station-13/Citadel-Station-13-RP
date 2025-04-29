/**
 * Simple grenade
 *
 * Blows up.
 * That's it.
 */
/obj/item/grenade/simple

/obj/item/grenade/simple/proc/detonate(do_not_delete)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	var/turf/location = get_turf(src)
	if(location)
		on_detonate(location, loc)

	if(!do_not_delete)
		qdel(src)

/**
 * perform detonation effects here
 *
 * * do not delete the grenade, detonate() handles this
 */
/obj/item/grenade/simple/proc/on_detonate(turf/location, atom/grenade_location)
	location.hotspot_expose(700,125)
