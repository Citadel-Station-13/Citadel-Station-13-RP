/obj/structure/signpost
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "signpost"
	anchored = TRUE
	density = TRUE

/obj/structure/signpost/attackby(obj/item/W, mob/user)
	return attack_hand(user)

/obj/structure/signpost/attack_hand(mob/user)
	switch(tgui_alert("Travel back to ss13?",,"Yes","No"))
		if("Yes")
			if(!user.z != src.z)
				return
			user.forceMove(SSjob.GetLatejoinSpawnpoint(faction = JOB_FACTION_STATION))
		if("No")
			return

/obj/effect/mark
		var/mark = ""
		icon = 'icons/misc/mark.dmi'
		icon_state = "blank"
		anchored = TRUE
		layer = PLANE_ADMIN3 // Why??
		mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		unacidable = TRUE

/obj/effect/beam
	name = "beam"
	density = FALSE
	unacidable = TRUE
	var/def_zone
	flags = PROXMOVE
	pass_flags = PASSTABLE


/obj/effect/begin
	name = "begin"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "begin"
	anchored = TRUE
	unacidable = TRUE

/*
 * This item is completely unused, but removing it will break something in R&D and Radio code causing PDA and Ninja code to fail on compile
 */

/var/list/acting_rank_prefixes = list("acting", "temporary", "interim", "provisional")

/proc/make_list_rank(rank)
	for(var/prefix in acting_rank_prefixes)
		if(findtext(rank, "[prefix] ", 1, 2+length(prefix)))
			return copytext(rank, 2+length(prefix))
	return rank

/obj/effect/list_container
	name = "list container"

/obj/effect/list_container/mobl
	name = "mobl"
	var/master = null
	var/list/container = list(  )

/obj/structure/showcase
	name = "Showcase"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "showcase_1"
	desc = "A stand with the empty body of a cyborg bolted to it."
	density = TRUE
	anchored = TRUE
	unacidable = TRUE //temporary until I decide whether the borg can be removed. -veyveyr

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
	density = FALSE
	anchored = FALSE
	w_class = ITEMSIZE_LARGE
	force = 0
	throwforce = 0
	throw_speed = 1
	throw_range = 20
	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'

/obj/item/beach_ball/afterattack(atom/target, mob/user)
	user.drop_item()
	throw_at(target, throw_range, throw_speed, user)

/obj/effect/stop
	icon_state = "empty"
	name = "Geas"
	desc = "You can't resist."
	var/atom/movable/victim

/obj/effect/stop/Uncross(atom/movable/AM)
	. = ..()
	if(AM == victim)
		return FALSE

/obj/effect/spawner
	name = "object spawner"
