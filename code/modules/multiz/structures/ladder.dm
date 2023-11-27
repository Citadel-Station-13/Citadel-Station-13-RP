//* Ladders

/obj/structure/ladder
	name = "ladder"
	desc = "A ladder. You can climb it up and down."
	icon_state = "ladder01"
	icon = 'icons/obj/structures/multiz.dmi'
	density = 0
	opacity = 0
	anchored = 1

	var/allowed_directions = DOWN
	var/obj/structure/ladder/target_up
	var/obj/structure/ladder/target_down

	var/climb_time = 2 SECONDS

/obj/structure/ladder/Initialize(mapload)
	. = ..()
	// the upper will connect to the lower
	if(allowed_directions & DOWN) //we only want to do the top one, as it will initialize the ones before it.
		for(var/obj/structure/ladder/L in get_vertical_step(src, DOWN))
			if(L.allowed_directions & UP)
				target_down = L
				L.target_up = src
				return
	update_icon()

/obj/structure/ladder/Destroy()
	if(target_down)
		target_down.target_up = null
		target_down = null
	if(target_up)
		target_up.target_down = null
		target_up = null
	return ..()

/obj/structure/ladder/attackby(obj/item/C as obj, mob/user as mob)
	attack_hand(user)
	return

/obj/structure/ladder/attack_hand(mob/user, list/params)
	. = ..()
	if(.)
		return
	var/mob/living/M = user
	if(!istype(M))
		return
	if(!M.may_climb_ladders(src))
		return

	var/obj/structure/ladder/target_ladder = getTargetLadder(M)
	if(!target_ladder)
		return
	if(M.loc != loc)
		step_towards(M, loc)
		if(M.loc != loc)
			to_chat(M, "<span class='notice'>You fail to reach \the [src].</span>")
			return

	climbLadder(M, target_ladder)

/obj/structure/ladder/attack_ghost(var/mob/M)
	. = ..()
	var/target_ladder = getTargetLadder(M)
	if(target_ladder)
		M.locationTransitForceMove(get_turf(target_ladder), 1, allow_buckled = TRUE, allow_pulled = FALSE, allow_grabbed = TRUE)

/obj/structure/ladder/attack_robot(var/mob/M)
	attack_hand(M)

/obj/structure/ladder/proc/getTargetLadder(var/mob/M)
	if((!target_up && !target_down) || (target_up && !istype(target_up.loc, /turf) || (target_down && !istype(target_down.loc,/turf))))
		to_chat(M, "<span class='notice'>\The [src] is incomplete and can't be climbed.</span>")
		return
	if(target_down && target_up)
		var/direction = alert(M,"Do you want to go up or down?", "Ladder", "Up", "Down", "Cancel")

		if(direction == "Cancel")
			return

		if(!M.may_climb_ladders(src))
			return

		switch(direction)
			if("Up")
				return target_up
			if("Down")
				return target_down
	else
		return target_down || target_up

/mob/proc/may_climb_ladders(var/ladder)
	if(!Adjacent(ladder))
		to_chat(src, "<span class='warning'>You need to be next to \the [ladder] to start climbing.</span>")
		return FALSE
	if(incapacitated())
		to_chat(src, "<span class='warning'>You are physically unable to climb \the [ladder].</span>")
		return FALSE
	return TRUE

/mob/observer/ghost/may_climb_ladders(var/ladder)
	return TRUE

/obj/structure/ladder/proc/climbLadder(var/mob/M, var/obj/target_ladder)
	var/direction = (target_ladder == target_up ? "up" : "down")
	M.visible_message("<span class='notice'>\The [M] begins climbing [direction] \the [src]!</span>",
		"You begin climbing [direction] \the [src]!",
		"You hear the grunting and clanging of a metal ladder being used.")

	target_ladder.audible_message("<span class='notice'>You hear something coming [direction] \the [src]</span>")

	if(do_after(M, climb_time, src))
		var/turf/T = get_turf(target_ladder)
		for(var/atom/A in T)
			if(!A.CanPass(M, M.loc, 1.5, 0))
				to_chat(M, "<span class='notice'>\The [A] is blocking \the [src].</span>")
				return FALSE
		return M.forceMove(T)

/obj/structure/ladder/CanPass(obj/mover, turf/source, height, airflow)
	. = ..()
	return airflow || !density

/obj/structure/ladder/update_icon()
	icon_state = "ladder[!!(allowed_directions & UP)][!!(allowed_directions & DOWN)]"

/obj/structure/ladder/up
	allowed_directions = UP
	icon_state = "ladder10"

/obj/structure/ladder/updown
	allowed_directions = UP|DOWN
	icon_state = "ladder11"


// Meme Variants, Snake Eater. Used on Rift for that 3 meter difference between the base z level and the one above it -Bloop

/obj/structure/ladder/snake_eater
	name = "long ladder"
	desc = "A ladder. You can climb it up and down. This one looks really long, what a thrill..."
	climb_time = 120 SECONDS

/obj/structure/ladder/snake_eater/up
	allowed_directions = UP
	icon_state = "ladder10"

/obj/structure/ladder/snake_eater/updown
	allowed_directions = UP|DOWN
	icon_state = "ladder11"

//* Ladder Assemblies

#define CONSTRUCTION_UNANCHORED 0
#define CONSTRUCTION_WRENCHED 1
#define CONSTRUCTION_WELDED 2

/obj/structure/ladder_assembly
	name = "ladder assembly"
	icon = 'icons/obj/structures.dmi'
	icon_state = "ladder00"
	density = 0
	opacity = 0
	anchored = 0
	w_class = ITEMSIZE_HUGE

	var/state = 0
	var/created_name = null

/obj/structure/ladder_assembly/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/pen))
		var/t = sanitizeSafe(input(user, "Enter the name for the ladder.", "Ladder Name", src.created_name), MAX_NAME_LEN)
		if(in_range(src, user))
			created_name = t
		return

	if(W.is_wrench())
		switch(state)
			if(CONSTRUCTION_UNANCHORED)
				state = CONSTRUCTION_WRENCHED
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("\The [user] secures \the [src]'s reinforcing bolts.", \
					"You secure the reinforcing bolts.", \
					"You hear a ratchet")
				src.anchored = 1
			if(CONSTRUCTION_WRENCHED)
				state = CONSTRUCTION_UNANCHORED
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("\The [user] unsecures \the [src]'s reinforcing bolts.", \
					"You undo the reinforcing bolts.", \
					"You hear a ratchet")
				src.anchored = 0
			if(CONSTRUCTION_WELDED)
				to_chat(user, "<span class='warning'>\The [src] needs to be unwelded.</span>")
		return

	if(istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W
		switch(state)
			if(CONSTRUCTION_UNANCHORED)
				to_chat(user, "<span class='warning'>The refinforcing bolts need to be secured.</span>")
			if(CONSTRUCTION_WRENCHED)
				if(WT.remove_fuel(0, user))
					playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message("\The [user] starts to weld \the [src] to the floor.", \
						"You start to weld \the [src] to the floor.", \
						"You hear welding")
					if(do_after(user, 2 SECONDS))
						if(QDELETED(src) || !WT.isOn()) return
						state = CONSTRUCTION_WELDED
						to_chat(user, "You weld \the [src] to the floor.")
						try_construct(user)
				else
					to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
			if(CONSTRUCTION_WELDED)
				if(WT.remove_fuel(0, user))
					playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message("\The [user] starts to cut \the [src] free from the floor.", \
						"You start to cut \the [src] free from the floor.", \
						"You hear welding")
					if(do_after(user, 2 SECONDS))
						if(QDELETED(src) || !WT.isOn()) return
						state = CONSTRUCTION_WRENCHED
						to_chat(user, "You cut \the [src] free from the floor.")
				else
					to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
		return

// Try to construct this into a real stairway.
// It must have a matching ladder assembly above and/or below, and both must be welded in place
// NOTE - Currently this design only supports three story tall ladders.  Its fine for our map tho.
// A better way would search upwards until finding the top, then call a proc on that to build the string.
/obj/structure/ladder_assembly/proc/try_construct(mob/user)
	var/obj/structure/ladder_assembly/below
	var/obj/structure/ladder_assembly/above

	for(var/direction in list(DOWN, UP))
		var/turf/T = get_vertical_step(src, direction)
		if(!T) continue
		var/obj/structure/ladder_assembly/LA = locate(/obj/structure/ladder_assembly, T)
		if(!LA) continue
		if(LA.state != CONSTRUCTION_WELDED)
			to_chat(user, "<span class='warning'>\The [LA] [direction == UP ? "above" : "below"] must be secured and welded.</span>")
			return
		if(direction == UP)
			above = LA
		if(direction == DOWN)
			below = LA

	if(!above && !below)
		to_chat(user, "<span class='notice'>\The [src] is ready to be connected to from above or below.</span>")
		return

	// Construct them from bottom to top, because they initialize from top to bottom.
	// If we made bottom last, nothing would initialize it.
	var/obj/structure/ladder_assembly/me = src
	src = null // So we can delete ourselves etc.

	if(below)
		var/obj/structure/ladder/L = new(get_turf(below))
		L.allowed_directions = UP
		if(below.created_name)
			L.name = below.created_name
		qdel(below)

	if(me)
		var/obj/structure/ladder/L = new(get_turf(me))
		L.allowed_directions = (below ? DOWN : 0) | (above ? UP : 0)
		if(me.created_name)
			L.name = me.created_name
		qdel(me)

	if(above)
		var/obj/structure/ladder/L = new(get_turf(above))
		L.allowed_directions = DOWN
		if(above.created_name)
			L.name = above.created_name
		qdel(above)

#undef CONSTRUCTION_UNANCHORED
#undef CONSTRUCTION_WRENCHED
#undef CONSTRUCTION_WELDED
