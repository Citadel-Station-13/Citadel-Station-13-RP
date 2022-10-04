/obj/item/radio/beacon
	name = "tracking beacon"
	desc = "A beacon used by a teleporter."
	icon = 'icons/obj/machines/teleporter.dmi'
	icon_state = "beacon"
	item_state = "beacon"
	base_icon_state = "beacon"
	var/code = "electronic"
	var/functioning = TRUE
	origin_tech = list(TECH_BLUESPACE = 1)

GLOBAL_LIST_BOILERPLATE(all_beacons, /obj/item/radio/beacon)

/obj/item/radio/beacon/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/radio/beacon/update_icon()
	cut_overlays()
	if(!functioning)
		add_overlay("[base_icon_state]_malfunction")
	else
		add_overlay("[base_icon_state]_on")

/obj/item/radio/beacon/hear_talk()
	return

/obj/item/radio/beacon/send_hear()
	return null

/obj/item/radio/beacon/verb/alter_signal(t as text)
	set name = "Alter Beacon's Signal"
	set category = "Object"
	set src in usr

	if ((usr.canmove && !( usr.restrained() )))
		src.code = t
	if (!( src.code ))
		src.code = "beacon"
	src.add_fingerprint(usr)
	return

/obj/item/radio/beacon/anchored
	desc = "A beacon used by a teleporter. This one appears to be bolted to the ground."
	anchored = TRUE
	w_class = ITEMSIZE_HUGE
	//randpixel = 0

	var/repair_fail_chance = 35


/obj/item/radio/beacon/anchored/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	hide(hides_under_flooring() && !T.is_plating())


/obj/item/radio/beacon/anchored/attackby(obj/item/I, mob/living/user)
	..()
	if(istype(I, /obj/item/stack/nanopaste))
		var/obj/item/stack/nanopaste/S = I
		if(b_stat)
			if(S.use(1))
				to_chat(user, SPAN_NOTICE("You pour some of \the [S] over \the [src]'s circuitry."))
				if(prob(repair_fail_chance))
					flick("[initial(icon_state)]_flickon", src)
					visible_message(SPAN_WARNING("The [src]'s lights come back on briefly, then die out again."))
				else
					visible_message(SPAN_NOTICE("\The [src]'s lights come back on."))
					functioning = TRUE
					repair_fail_chance += pick(5, 10, 10, 15)
					update_icon()
			else
				to_chat(user, SPAN_WARNING("There's not enough of \the [S] left to fix \the [src]."))
		else
			to_chat(user, SPAN_WARNING("You can't work on \the [src] until its been opened up."))

// Probably a better way of doing this, I'm lazy.
/obj/item/radio/beacon/bacon/proc/digest_delay()
	spawn(600)
		qdel(src)


/// SINGULO BEACON SPAWNER
/obj/item/radio/beacon/syndicate
	name = "suspicious beacon"
	desc = "A label on it reads: <i>Activate to have a singularity beacon teleported to your location</i>."
	origin_tech = list(TECH_BLUESPACE = 1, TECH_ILLEGAL = 7)

/obj/item/radio/beacon/syndicate/attack_self(mob/user as mob)
	if(user)
		to_chat(user, SPAN_NOTICE("Locked In"))
		new /obj/machinery/power/singularity_beacon/syndicate(user.loc)
		playsound(src, 'sound/effects/pop.ogg', 100, 1, 1)
		qdel(src)
	return
