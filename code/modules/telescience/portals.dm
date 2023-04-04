GLOBAL_LIST_BOILERPLATE(all_portals, /obj/effect/portal)

/obj/effect/portal
	name = "portal"
	desc = "A semi-stable conduit through bluespace. Surely this can't be a bad idea."
	#warn sprite
	anchored = TRUE

/obj/effect/portal/Initialize()
	. = ..()
	AddElement(/datum/element/connect_loc, list(COMSIG_ATOM_ENTERED, TYPE_PROC_REF(/obj/effect/portal, on_cross)))

/obj/effect/portal/Destroy()

	return ..()

/obj/effect/portal/proc/on_cross(datum/source, atom/movable/what, atom/oldloc)
	if(oldloc == loc)
		return // no loops
	teleport(what, TRUE)

/obj/effect/portal/attack_hand(mob/user, list/params)
	teleport(user, FALSE)
	return TRUE

/obj/effect/portal/proc/teleport(atom/movable/target, crossed)
	if(target.atom_flags & ATOM_ABSTRACT)
		return FALSE
	if(target.anchored)
		return FALSE

#warn impl


/obj/effect/portal
	name = "portal"
	desc = "Looks unstable. Best to test it with the clown."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal"
	density = 1
	unacidable = 1//Can't destroy energy portals.
	var/failchance = 5
	var/obj/item/target = null
	var/creator = null
	anchored = 1.0

/obj/effect/portal/attack_hand(mob/user, list/params)
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
	if (M.anchored&&istype(M, /obj/mecha))
		return
	if (icon_state == "portal1")
		return
	if (!( target ))
		qdel(src)
		return
	if (istype(M, /atom/movable))
		if(prob(failchance))
			src.icon_state = "portal1"
			do_teleport(M, locate(rand(5, world.maxx - 5), rand(5, world.maxy -5), pick(GLOB.using_map.get_map_levels(z))), 0)
		else
			do_teleport(M, target, 1) ///You will appear adjacent to the beacon


