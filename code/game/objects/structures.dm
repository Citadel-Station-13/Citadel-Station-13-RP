/obj/structure
	icon = 'icons/obj/structures.dmi'
	w_class = ITEMSIZE_NO_CONTAINER
	pass_flags = ATOM_PASS_BUCKLED

	// todo: rename to default_unanchor, allow generic structure unanchoring.
	var/allow_unanchor = FALSE
	var/breakable = FALSE

	var/list/connections
	var/list/other_connections
	var/list/blend_objects = newlist() // Objects which to blend with
	var/list/noblend_objects = newlist() //Objects to avoid blending with (such as children of listed blend objects.

/obj/structure/Initialize(mapload)
	. = ..()

	if(smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK))
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)
		if(smoothing_flags & SMOOTH_CORNERS)
			icon_state = ""

	GLOB.cameranet.updateVisibility(src)

/obj/structure/Destroy()
	GLOB.cameranet.updateVisibility(src)

	if(smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK))
		QUEUE_SMOOTH_NEIGHBORS(src)

	return ..()

/obj/structure/attack_hand(mob/user, list/params)
	if(breakable)
		if(MUTATION_HULK in user.mutations)
			user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
			attack_generic(user,1,"smashes")
		else if(istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(user))
				attack_generic(user,1,"slices")

	return ..()

/obj/structure/attack_tk()
	return

/obj/structure/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			return

/obj/structure/proc/turf_is_crowded()
	var/turf/T = get_turf(src)
	if(!T || !istype(T))
		return 0
	for(var/obj/O in T.contents)
		if(O.climb_allowed)
			continue
		if(O && O.density && !(O.atom_flags & ATOM_BORDER)) //ATOM_BORDER structures are handled by the Adjacent() check.
			return O
	return 0

// todo: remove
/obj/structure/proc/can_touch(var/mob/user)
	if (!user)
		return 0
	if(!Adjacent(user))
		return 0
	if (user.restrained() || user.buckled)
		to_chat(user, "<span class='notice'>You need your hands and legs free for this.</span>")
		return 0
	if (!CHECK_MOBILITY(user, MOBILITY_CAN_USE))
		return 0
	if (isAI(user))
		to_chat(user, "<span class='notice'>You need hands for this.</span>")
		return 0
	return 1

/obj/structure/attack_generic(var/mob/user, var/damage, var/attack_verb)
	if(!breakable || damage < STRUCTURE_MIN_DAMAGE_THRESHOLD)
		return 0
	visible_message("<span class='danger'>[user] [attack_verb] the [src] apart!</span>")
	user.do_attack_animation(src)
	spawn(1) qdel(src)
	return 1

/obj/structure/proc/can_visually_connect()
	return anchored

/obj/structure/proc/can_visually_connect_to(var/obj/structure/S)
	return istype(S, src)

/obj/structure/proc/update_connections(propagate = 0)
	var/list/dirs = list()
	var/list/other_dirs = list()

	for(var/obj/structure/S in orange(src, 1))
		if(can_visually_connect_to(S))
			if(S.can_visually_connect())
				if(propagate)
					S.update_connections()
					S.update_icon()
				dirs += get_dir(src, S)

	if(!can_visually_connect())
		connections = list("0", "0", "0", "0")
		other_connections = list("0", "0", "0", "0")
		return FALSE

	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		var/success = 0
		for(var/b_type in blend_objects)
			if(istype(T, b_type))
				success = 1
				if(propagate)
					var/turf/simulated/wall/W = T
					if(istype(W))
						QUEUE_SMOOTH(W)
				if(success)
					break // breaks inner loop
		if(!success)
			blend_obj_loop:
				for(var/obj/O in T)
					for(var/b_type in blend_objects)
						if(istype(O, b_type))
							success = 1
							for(var/obj/structure/S in T)
								if(istype(S, src))
									success = 0
							for(var/nb_type in noblend_objects)
								if(istype(O, nb_type))
									success = 0

						if(success)
							break blend_obj_loop // breaks outer loop

		if(success)
			dirs += get_dir(src, T)
			other_dirs += get_dir(src, T)

	refresh_neighbors()

	connections = dirs_to_corner_states(dirs)
	other_connections = dirs_to_corner_states(other_dirs)
	return TRUE

/obj/structure/proc/refresh_neighbors()
	for(var/turf/T as anything in RANGE_TURFS(1, src))
		T.update_icon()
