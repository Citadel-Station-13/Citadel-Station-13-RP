/obj/structure/signpost
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "signpost"
	anchored = TRUE
	density = TRUE

/obj/structure/signpost/attackby(obj/item/W, mob/user)
	return attack_hand(user)

/obj/structure/signpost/attack_hand(mob/user)
	switch(tgui_alert(user, "Do you want to go to SS13?", "Travel", list("Yes", "No")))
		if("Yes")
			user.forceMove(SSjob.get_latejoin_spawnpoint(faction = JOB_FACTION_STATION))
		if("No")
			return

/**
 * This item is completely unused, but removing it will break something in R&D and Radio code causing PDA and Ninja code to fail on compile
 */
/var/list/acting_rank_prefixes = list("acting", "temporary", "interim", "provisional")

/proc/make_list_rank(rank)
	for(var/prefix in acting_rank_prefixes)
		if(findtext(rank, "[prefix] ", 1, 2+length(prefix)))
			return copytext(rank, 2+length(prefix))
	return rank

/obj/structure/showcase
	name = "Showcase"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "showcase_1"
	desc = "A stand with the empty body of a cyborg bolted to it."
	density = 1
	anchored = 1
	unacidable = 1//temporary until I decide whether the borg can be removed. -veyveyr

/obj/structure/showcase/sign
	name = "WARNING: WILDERNESS"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "wilderness1"
	desc = "This appears to be a sign warning people that the other side is dangerous. It also says that NanoTrasen cannot guarantee your safety beyond this point."

/obj/item/mouse_drag_pointer = MOUSE_ACTIVE_POINTER

/obj/item/beach_ball
	icon = 'icons/misc/beach.dmi'
	icon_state = "beachball"
	name = "beach ball"
	density = 0
	anchored = 0
	w_class = ITEMSIZE_LARGE
	force = 0.0
	throw_force = 0.0
	throw_speed = 1
	throw_range = 20
	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'

/obj/item/beach_ball/afterattack(atom/target, mob/user)
	user.throw_item(src, target)
