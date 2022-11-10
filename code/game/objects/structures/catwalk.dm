// Based on catwalk.dm from https://github.com/Endless-Horizon/CEV-Eris
/obj/structure/catwalk
	name = "catwalk"
	desc = "Cats really don't like these things."
	plane = DECAL_PLANE
	layer = ABOVE_UTILITY
	icon = 'icons/turf/catwalks.dmi'
	icon_state = "catwalk"
	density = FALSE
	anchored = TRUE
	var/health = 100
	var/maxhealth = 100
	var/obj/item/stack/tile/plated_tile = null
	var/static/plating_color = list(
		/obj/item/stack/tile/floor = "#858a8f",
		/obj/item/stack/tile/floor/dark = "#4f4f4f",
		/obj/item/stack/tile/floor/white = "#e8e8e8")

/obj/structure/catwalk/Initialize(mapload)
	. = ..()
	for(var/obj/structure/catwalk/O in range(1))
		O.update_icon()
	for(var/obj/structure/catwalk/C in get_turf(src))
		if(C != src)
			warning("Duplicate [type] in [loc] ([x], [y], [z])")
			return INITIALIZE_HINT_QDEL
	update_icon()

/obj/structure/catwalk/Destroy()
	var/turf/location = loc
	. = ..()
	location.alpha = initial(location.alpha)
	for(var/obj/structure/catwalk/L in orange(location, 1))
		L.update_icon()

/obj/structure/catwalk/update_icon()
	var/connectdir = 0
	for(var/direction in GLOB.cardinal)
		if(locate(/obj/structure/catwalk, get_step(src, direction)))
			connectdir |= direction

	//Check the diagonal connections for corners, where you have, for example, connections both north and east. In this case it checks for a north-east connection to determine whether to add a corner marker or not.
	var/diagonalconnect = 0 //1 = NE; 2 = SE; 4 = NW; 8 = SW
	//NORTHEAST
	if(connectdir & NORTH && connectdir & EAST)
		if(locate(/obj/structure/catwalk, get_step(src, NORTHEAST)))
			diagonalconnect |= 1
	//SOUTHEAST
	if(connectdir & SOUTH && connectdir & EAST)
		if(locate(/obj/structure/catwalk, get_step(src, SOUTHEAST)))
			diagonalconnect |= 2
	//NORTHWEST
	if(connectdir & NORTH && connectdir & WEST)
		if(locate(/obj/structure/catwalk, get_step(src, NORTHWEST)))
			diagonalconnect |= 4
	//SOUTHWEST
	if(connectdir & SOUTH && connectdir & WEST)
		if(locate(/obj/structure/catwalk, get_step(src, SOUTHWEST)))
			diagonalconnect |= 8

	icon_state = "catwalk[connectdir]-[diagonalconnect]"


/obj/structure/catwalk/ex_act(severity)
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
		Destroy()

/obj/effect/catwalk_plated
	name = "plated catwalk spawner"
	icon = 'icons/turf/catwalks.dmi'
	icon_state = "catwalk_plated"
	density = 1
	anchored = 1.0
	var/activated = FALSE
	plane = DECAL_PLANE
	layer = ABOVE_UTILITY
	var/tile = /obj/item/stack/tile/floor
	var/platecolor = "#858a8f"

/obj/effect/catwalk_plated/Initialize(mapload)
	. = ..()
	activate()

/obj/effect/catwalk_plated/attack_hand()
	attack_generic()

/obj/effect/catwalk_plated/attack_ghost()
	. = ..()
	attack_generic()

/obj/effect/catwalk_plated/attack_generic()
	activate()

/obj/effect/catwalk_plated/proc/activate()
	if(activated) return

	if(locate(/obj/structure/catwalk) in loc)
		warning("Frame Spawner: A catwalk already exists at [loc.x]-[loc.y]-[loc.z]")
	else
		var/obj/structure/catwalk/C = new /obj/structure/catwalk(loc)
		C.plated_tile = tile
		C.plating_color = platecolor
		C.name = "plated catwalk"
		C.update_icon()
	activated = 1
	/* We don't have wallframes - yet
	for(var/turf/T in orange(src, 1))
		for(var/obj/effect/wallframe_spawn/other in T)
			if(!other.activated) other.activate()
	*/
	qdel(src)

/obj/effect/catwalk_plated/dark
	icon_state = "catwalk_plateddark"
	tile = /obj/item/stack/tile/floor/dark
	platecolor = "#4f4f4f"

/obj/effect/catwalk_plated/white
	icon_state = "catwalk_platedwhite"
	tile = /obj/item/stack/tile/floor/white
	platecolor = "#e8e8e8"

/obj/structure/catwalk/plank
	name = "plank bridge"
	desc = "Some flimsy wooden planks, generally set across a hazardous area."
	plane = DECAL_PLANE
	layer = ABOVE_UTILITY
	icon = 'icons/turf/catwalks.dmi'
	icon_state = "plank"
	density = 0
	anchored = 1.0

/obj/structure/catwalk/plank/Crossed()
	. = ..()
	if(isliving(usr) && !usr.is_incorporeal())
		switch(rand(1,100))
			if(1 to 5)
				qdel(src)
				visible_message("<span class='danger'>The planks splinter and disintegrate beneath the weight!</span>")
			if(6 to 50)
				take_damage(rand(10,20))
				visible_message("<span class='danger'>The planks creak and groan as they're crossed.</span>")
			if(51 to 100)
				return

/obj/structure/catwalk/plank/take_damage(amount)
	health -= amount
	update_icon()
	if(health <= 0)
		visible_message("<span class='warning'>\The [src] breaks down!</span>")
		Destroy()

/obj/structure/catwalk/plank/update_icon()
	if(health > 75)
		icon_state = "[initial(icon_state)]"
	if(health < 75)
		icon_state = "[initial(icon_state)]_scuffed"
	if(health < 50)
		icon_state = "[initial(icon_state)]_rickety"
	if(health < 25)
		icon_state = "[initial(icon_state)]_dangerous"
