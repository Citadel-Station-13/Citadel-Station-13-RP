
#warn below

/obj/machinery/resleeving/body_printer/grower_pod/process(delta_time)
	if(((occupant.health >= heal_level) || (occupant.health == occupant.maxHealth)) && (!eject_wait))
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
		audible_message("\The [src] signals that the growing process is complete.")
		connected_message("Growing Process Complete.")
		locked = 0
		go_out()
		return

// Empties all of the beakers from the cloning pod, used to refill it
/obj/machinery/resleeving/body_printer/verb/empty_beakers()
	set name = "Eject Beakers"
	set category = VERB_CATEGORY_OBJECT
	set src in oview(1)

	if(usr.stat != 0)
		return

	add_fingerprint(usr)
	drop_beakers()
	return

// Actually does all of the beaker dropping
// Returns 1 if it succeeds, 0 if it fails. Added in case someone wants to add messages to the user.
/obj/machinery/resleeving/body_printer/proc/drop_beakers()
	if(LAZYLEN(containers))
		var/turf/T = get_turf(src)
		if(T)
			for(var/obj/item/reagent_containers/glass/G in containers)
				G.forceMove(T)
				containers -= G
		return	1
	return 0
