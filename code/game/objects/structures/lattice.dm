/obj/structure/lattice
	name = "lattice"
	desc = "A lightweight support lattice."
	icon = 'icons/obj/structures/lattice.dmi'
	icon_state = "lattice-255"
	base_icon_state = "lattice"

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_LATTICE)
	canSmoothWith = (SMOOTH_GROUP_LATTICE + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_MINERAL_WALLS)

	density = FALSE
	anchored = TRUE
	rad_flags = RAD_NO_CONTAMINATE
	w_class = ITEMSIZE_NORMAL
	plane = TURF_PLANE


/obj/structure/lattice/Initialize(mapload)
	. = ..()

	// Should remove this at some point.
	if(!(istype(loc, /turf/space) || istype(loc, /turf/simulated/open) || istype(loc, /turf/simulated/mineral)))
		return INITIALIZE_HINT_QDEL

	for(var/obj/structure/lattice/LAT in loc)
		if(LAT != src)
			stack_trace("multiple lattices found in ([loc.x], [loc.y], [loc.z])")
			return INITIALIZE_HINT_QDEL



/obj/structure/lattice/Destroy()
	var/turf/old_loc = get_turf(src)
	. = ..()
	if(isturf(old_loc))
		for(var/atom/movable/AM in old_loc)
			AM.fall(old_loc)


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
	return

/obj/structure/lattice/attackby(obj/item/C, mob/user)

	if (istype(C, /obj/item/stack/tile/floor))
		var/turf/T = get_turf(src)
		T.attackby(C, user) //BubbleWrap - hand this off to the underlying turf instead
		return
	if (istype(C, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = C
		if(WT.welding == 1)
			if(WT.remove_fuel(0, user))
				to_chat(user, SPAN_NOTICE("Slicing lattice joints..."))
			new /obj/item/stack/rods(loc)
			qdel(src)
		return
	if (istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		if(R.use(2))
			to_chat(user, SPAN_NOTICE("You start connecting \the [R.name] to \the [name]..."))
			if(do_after(user, 5 SECONDS))
				src.alpha = 0 // Note: I don't know why this is set, Eris did it, just trusting for now. ~Leshana
				new /obj/structure/catwalk(loc)
				qdel(src)
		return
	return

/obj/structure/lattice/prevent_z_fall(atom/movable/victim, levels = 0, fall_flags)
	if(check_standard_flag_pass(victim))
		return ..()
	return fall_flags | FALL_BLOCKED
