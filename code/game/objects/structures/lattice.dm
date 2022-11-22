/obj/structure/lattice
	name = "lattice"
	desc = "A lightweight support lattice."
	icon = 'icons/obj/smooth_structures/lattice.dmi'
	icon_state = "lattice-255"
	base_icon_state = "lattice"
	density = FALSE
	anchored = TRUE
	w_class = ITEMSIZE_NORMAL
	plane = FLOOR_PLANE
	layer = LATTICE_LAYER
	color = COLOR_STEEL
	obj_flags = OBJ_FLAG_NOFALL

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_LATTICE)
	canSmoothWith = list(SMOOTH_GROUP_OPEN_FLOOR, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_LATTICE)

	var/init_material = MAT_STEEL

/obj/structure/lattice/Initialize(mapload)
	. = ..()

	if(!(istype(src.loc, /turf/space) || istype(src.loc, /turf/simulated/open) || istype(src.loc, /turf/simulated/mineral)))
		return INITIALIZE_HINT_QDEL

	for(var/obj/structure/lattice/LAT in loc)
		if(LAT == src)
			continue
		stack_trace("multiple lattices found in ([loc.x], [loc.y], [loc.z])")
		return INITIALIZE_HINT_QDEL

/obj/structure/lattice/blob_act(obj/structure/blob/B)
	return

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

/obj/structure/lattice/prevent_z_fall(atom/movable/victim, levels = 0, fall_flags)
	if(check_standard_flag_pass(victim))
		return ..()
	return fall_flags | FALL_BLOCKED
