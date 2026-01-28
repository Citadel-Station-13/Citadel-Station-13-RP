GLOBAL_LIST_BOILERPLATE(all_portals, /obj/effect/portal)

/obj/effect/portal
	name = "portal"
	desc = "Looks unstable. Best to test it with the clown."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal"
	anchored = TRUE
	density = TRUE // dense for receiving bumbs
	light_range = 3
	light_power = 1
	light_color = COLOR_BLUE_LIGHT

	var/obj/item/target = null
	var/creator = null

/obj/effect/portal/Move(newloc)
	for(var/T in newloc)
		if(istype(T, /obj/effect/portal))
			return FALSE
	return ..()

// Prevents portals spawned by jaunter/handtele from floating into space when relocated to an adjacent tile.
/obj/effect/portal/newtonian_move()
	return TRUE

/obj/effect/portal/attackby(obj/item/W, mob/user, list/modifiers)
	if(user && Adjacent(user))
		teleport(user)
		return TRUE

/obj/effect/portal/Bumped(atom/movable/bumper)
	teleport(bumper)

/obj/effect/portal/attack_hand(mob/user,)
	. = ..()
	if(.)
		return
	if(Adjacent(user))
		teleport(user)

/obj/effect/portal/attack_robot(mob/living/user)
	if(Adjacent(user))
		teleport(user)

/obj/effect/portal/Initialize(mapload, ...)
	. = ..()
	QDEL_IN(src, 30 SECONDS)

/obj/effect/portal/singularity_pull(atom/singularity, current_size)
	return

/obj/effect/portal/singularity_act()
	return

/obj/effect/portal/Destroy()
	target = null
	creator = null
	return ..()

/obj/effect/portal/attack_ghost(mob/observer/dead/ghost)
	if(!teleport(ghost, force = TRUE))
		return ..()
	return TRUE

/obj/effect/portal/proc/teleport(atom/movable/moving, force = FALSE)
	if(!force && (!istype(moving) || iseffect(moving)|| (!isobj(moving) && !ismob(moving)))) //Things that shouldn't teleport.
		return

	var/turf/real_target = get_turf(target)
	if(!istype(real_target))
		return FALSE

	if(!force && (!ismecha(moving) && moving.anchored))
		return

	if (icon_state == "portal1")
		return

	do_teleport(moving, real_target, 1) ///You will appear adjacent to the beacon
