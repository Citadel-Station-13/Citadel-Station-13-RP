GLOBAL_LIST_BOILERPLATE(all_portals, /obj/effect/portal)

/obj/effect/portal
	name = "portal"
	desc = "Looks unstable. Best to test it with the clown."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal"
	density = TRUE
	anchored = TRUE
	integrity_flags = INTEGRITY_INDESTRUCTIBLE | INTEGRITY_ACIDPROOF | INTEGRITY_FIREPROOF | INTEGRITY_LAVAPROOF
	var/obj/item/target = null
	var/creator = null

/obj/effect/portal/Bumped(mob/M as mob|obj)
	if(istype(M,/mob) && !(istype(M,/mob/living)))
		return	//do not send ghosts, zshadows, ai eyes, etc
	teleport(M)

/obj/effect/portal/Crossed(AM as mob|obj)
	. = ..()
	teleport(AM)

/obj/effect/portal/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(istype(user) && !(istype(user,/mob/living)))
		return	//do not send ghosts, zshadows, ai eyes, etc
	spawn(0)
		src.teleport(user)
		return
	return

/obj/effect/portal/Initialize(mapload, ...)
	. = ..()
	QDEL_IN(src, 30 SECONDS)

/obj/effect/portal/proc/teleport(atom/movable/M as mob|obj)
	if(istype(M, /obj/effect)) //sparks don't teleport
		return
	if (M.anchored&&istype(M, /obj/vehicle/sealed/mecha))
		return
	if (icon_state == "portal1")
		return
	if (!( target ))
		qdel(src)
		return
	if (istype(M, /atom/movable))
		do_teleport(M, target, 1) ///You will appear adjacent to the beacon

/obj/effect/portal/attack_ghost(mob/user)
	. = ..()
	if(target)
		user.forceMove(get_turf(target))
