/obj/structure/lattice
	name = "lattice"
	desc = "A lightweight support lattice."
	icon = 'icons/obj/structures.dmi'
	icon_state = "latticefull"
	density = 0
	anchored = 1.0
	rad_flags = RAD_NO_CONTAMINATE
	w_class = ITEMSIZE_NORMAL
	plane = TURF_PLANE

	// smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_LATTICE)
	canSmoothWith = (SMOOTH_GROUP_LATTICE + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_OPEN_FLOOR)

/obj/structure/lattice/Initialize(mapload)
	. = ..()

	if(!(istype(src.loc, /turf/space) || istype(src.loc, /turf/simulated/open) || istype(src.loc, /turf/simulated/mineral)))
		return INITIALIZE_HINT_QDEL

	for(var/obj/structure/lattice/LAT in src.loc)
		if(LAT != src)
			//stack_trace("Found multiple lattices at '[log_info_line(loc)]'")
			return INITIALIZE_HINT_QDEL
	icon = 'icons/obj/smoothlattice.dmi'
	icon_state = "latticeblank"
	updateOverlays()
	for (var/dir in GLOB.cardinal)
		var/obj/structure/lattice/L
		if(locate(/obj/structure/lattice, get_step(src, dir)))
			L = locate(/obj/structure/lattice, get_step(src, dir))
			L.updateOverlays()

/obj/structure/lattice/Destroy()
	var/turf/old_loc = get_turf(src)
	. = ..()
	if(istype(old_loc))
		update_neighbors(old_loc)
		for(var/atom/movable/AM in old_loc)
			AM.fall(old_loc)

/obj/structure/lattice/proc/update_neighbors(location = loc)
	for (var/dir in GLOB.cardinal)
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, get_step(location, dir))
		if(L)
			L.update_icon()

/obj/structure/lattice/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			return
		else
	return

/obj/structure/lattice/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/tile/floor))
		var/turf/T = get_turf(src)
		T.attackby(C, user) //BubbleWrap - hand this off to the underlying turf instead
		return
	if (istype(C, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = C
		if(WT.welding == 1)
			if(WT.remove_fuel(0, user))
				to_chat(user, "<span class='notice'>Slicing lattice joints ...</span>")
			new /obj/item/stack/rods(src.loc)
			qdel(src)
		return
	if (istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		if(R.use(2))
			to_chat(user, "<span class='notice'>You start connecting \the [R.name] to \the [src.name] ...</span>")
			if(do_after(user, 5 SECONDS))
				src.alpha = 0 // Note: I don't know why this is set, Eris did it, just trusting for now. ~Leshana
				new /obj/structure/catwalk(src.loc)
				qdel(src)
		return
	return

/obj/structure/lattice/proc/updateOverlays()
	//if(!(istype(src.loc, /turf/space)))
	//	qdel(src)
	spawn(1)
		cut_overlays()

		var/dir_sum = 0

		for (var/direction in GLOB.cardinal)
			if(locate(/obj/structure/lattice, get_step(src, direction)))
				dir_sum += direction
			else
				if(!(istype(get_step(src, direction), /turf/space)))
					dir_sum += direction

		icon_state = "lattice[dir_sum]"
		return

/obj/structure/lattice/prevent_z_fall(atom/movable/victim, levels = 0, fall_flags)
	if(check_standard_flag_pass(victim))
		return ..()
	return fall_flags | FALL_BLOCKED
