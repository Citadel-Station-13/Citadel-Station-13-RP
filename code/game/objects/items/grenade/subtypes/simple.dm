/**
 * Simple grenade
 *
 * Blows up.
 * That's it.
 */
/obj/item/grenade/simple
	/// you don't really have a reason to use this most of the time but it's here if you somehow do
	var/delete_on_detonate = TRUE
	/// has been activated
	var/activated = FALSE

/obj/item/grenade/simple/on_activate_inhand(datum/event_args/actor/actor)
	..()
	if(activated)
		return
	activated = TRUE

/obj/item/grenade/simple/proc/detonate(do_not_delete)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	var/turf/location = get_turf(src)
	if(location)
		on_detonate(location, loc)

	if(delete_on_detonate && !do_not_delete)
		qdel(src)

/**
 * perform detonation effects here
 *
 * * do not delete the grenade, detonate() handles this
 */
/obj/item/grenade/simple/proc/on_detonate(turf/location, atom/grenade_location)
	location.hotspot_expose(700,125)
