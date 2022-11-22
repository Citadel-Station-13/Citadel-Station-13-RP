// Based on catwalk.dm from https://github.com/Endless-Horizon/CEV-Eris
/obj/structure/catwalk
	name = "catwalk"
	icon = 'icons/obj/smooth_structures/catwalk.dmi'
	icon_state = "catwalk-0"
	base_icon_state = "catwalk"
	plane = FLOOR_PLANE
	layer = CATWALK_LAYER
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_OPEN_FLOOR, SMOOTH_GROUP_LATTICE, SMOOTH_GROUP_CATWALK)
	canSmoothWith = list(SMOOTH_GROUP_CATWALK)
	anchored = TRUE
	obj_flags = OBJ_FLAG_NOFALL

	var/health = 100
	var/maxhealth = 100

/obj/structure/catwalk/Initialize(mapload)
	. = ..()
	for(var/obj/structure/catwalk/C in get_turf(src))
		if(C != src)
			warning("Duplicate [type] in [loc] ([x], [y], [z])")
			return INITIALIZE_HINT_QDEL

/obj/structure/catwalk/Destroy()
	var/turf/location = loc
	. = ..()
	location.alpha = initial(location.alpha)

/obj/structure/catwalk/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			qdel(src)
		if(3.0)
			qdel(src)
	return

/obj/structure/catwalk/attackby(obj/item/C as obj, mob/user as mob)
	if(istype(C, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = C
		if(WT.isOn())
			if(WT.remove_fuel(0, user))
				to_chat(user, "<span class='notice'>Slicing lattice joints ...</span>")
				new /obj/item/stack/rods(src.loc)
				new /obj/item/stack/rods(src.loc)
				new /obj/structure/lattice(src.loc)
				qdel(src)
	if(C.is_screwdriver())
		if(health < maxhealth)
			to_chat(user, "<span class='notice'>You begin repairing \the [src.name] with \the [C.name].</span>")
			if(do_after(user, 20, src))
				health = maxhealth
	else
		take_damage(C.force)
		user.setClickCooldown(user.get_attack_speed(C))
	return ..()

/obj/structure/catwalk/Crossed()
	. = ..()
	if(isliving(usr) && !usr.is_incorporeal())
		playsound(src, pick('sound/effects/footstep/catwalk1.ogg', 'sound/effects/footstep/catwalk2.ogg', 'sound/effects/footstep/catwalk3.ogg', 'sound/effects/footstep/catwalk4.ogg', 'sound/effects/footstep/catwalk5.ogg'), 25, 1)

/obj/structure/catwalk/CheckExit(atom/movable/O, turf/target)
	if(O.check_pass_flags(ATOM_PASS_GRILLE))
		return TRUE
	if(target && target.z < src.z)
		return FALSE
	return TRUE

/obj/structure/catwalk/take_damage(amount)
	health -= amount
	if(health <= 0)
		visible_message("<span class='warning'>\The [src] breaks down!</span>")
		playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
		new /obj/item/stack/rods(get_turf(src))
		qdel(src)

/obj/structure/catwalk/prevent_z_fall(atom/movable/victim, levels = 0, fall_flags)
	return fall_flags | FALL_BLOCKED

/obj/structure/catwalk/z_pass_in(atom/movable/AM, dir, turf/old_loc)
	return dir == UP

/obj/structure/catwalk/z_pass_out(atom/movable/AM, dir, turf/new_loc)
	return dir == UP


/obj/structure/catwalk/plated
	name = "plated catwalk"
	icon = 'icons/obj/smooth_structures/catwalk_plated.dmi'
	icon_state = "plated_catwalk-0"
	base_icon_state = "plated_catwalk"

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_OPEN_FLOOR, SMOOTH_GROUP_LATTICE, SMOOTH_GROUP_PLATED_CATWALK)
	canSmoothWith = list(SMOOTH_GROUP_PLATED_CATWALK)

	// plated_tile = /obj/item/stack/tile/floor
	color = "#858a8f"

/obj/structure/catwalk/plated/dark
	// plated_tile = /obj/item/stack/tile/floor/dark
	color = "#4f4f4f"

/obj/structure/catwalk/plated/white
	// plated_tile = /obj/item/stack/tile/floor/white
	color = "#e8e8e8"

/obj/structure/catwalk/plank
	name = "plank bridge"
	desc = "Some flimsy wooden planks, generally set across a hazardous area."
	icon = 'icons/obj/structures/catwalk_planks.dmi'
	icon_state = "plank"
	plane = GAME_PLANE
	layer = CATWALK_LAYER
	density = FALSE
	anchored = TRUE

	smoothing_flags = null
	smoothing_groups = null
	canSmoothWith = null

/obj/structure/catwalk/plank/Initialize(mapload)
	. = ..()
	update_icon_state()

/obj/structure/catwalk/plank/Crossed()
	. = ..()
	if(isliving(usr) && !usr.is_incorporeal())
		switch(rand(1,100))
			if(1 to 5)
				qdel(src)
				visible_message(SPAN_DANGER("The planks splinter and disintegrate beneath the weight!"))
			if(6 to 50)
				take_damage(rand(10,20))
				visible_message(SPAN_DANGER("The planks creak and groan as they're crossed."))
			if(51 to 100)
				return

/obj/structure/catwalk/plank/take_damage(amount)
	health -= amount
	update_icon_state()
	if(health <= 0)
		visible_message(SPAN_WARNING("\The [src] breaks down!"))
		Destroy()

/obj/structure/catwalk/plank/update_icon_state()
	. = ..()
	if(health > 75)
		icon_state = "[initial(icon_state)]"
	if(health < 75)
		icon_state = "[initial(icon_state)]_scuffed"
	if(health < 50)
		icon_state = "[initial(icon_state)]_rickety"
	if(health < 25)
		icon_state = "[initial(icon_state)]_dangerous"
