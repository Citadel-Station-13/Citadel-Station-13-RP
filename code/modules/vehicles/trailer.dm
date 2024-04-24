/obj/vehicle/trailer
	name = "the vague concept of a trailer"
	desc = "Yell at coderbus."
	//Trailers will anchor when hitched and unanchor when unhitched.
	anchored = FALSE
	max_drivers = 0
	max_occupants = 0

	var/allowed_cargo
	var/cargo
	var/cargo_item_visible = TRUE
	var/cargo_offset_x
	var/cargo_offset_y
	var/passenger_allowed = FALSE


/* //This is a huge complicated mess, copying the old procs rn.
//Attempts to load cargo to the trailer. Assumes proximity checks are already made. Returns TRUE if cargo is loaded, else returns FALSE.
/obj/vehicle/trailer/proc/load(var/atom/movable/C)
	//No free rides, No double stacking, No bolted down items, No inventory items.
	if((ismob(C) && !passenger_allowed) || cargo || C.anchored || !isturf(C.loc))
		return FALSE
	//Check if its an allowed_cargo
	if(istype(C, allowed_cargo))
		var/datum/vehicle_dummy_load/dummy_cargo = new()
		cargo = dummy_cargo

		dummy_cargo.actual_load = C
		C.forceMove(src)

		if(cargo_item_visible)
			C.pixel_x += cargo_offset_x
			C.pixel_y += cargo_offset_y
			C.layer = layer

			add_overlay(C)

			//we can set these back now since we have already cloned the icon into the overlay
			C.pixel_x = initial(C.pixel_x)
			C.pixel_y = initial(C.pixel_y)
			C.layer = initial(C.layer)
		return TRUE
	return FALSE

/obj/vehicle/trailer/proc/unload(mob/user, direction)
	if(istype(load, /datum/vehicle_dummy_cargo))
		var/datum/vehicle_dummy_cargo/dummy_cargo = cargo
		load = dummy_cargo.actual_cargo
		dummy_cargo.actual_cargo = null
		qdel(dummy_load)
		cut_overlays()
	..()
		if(!load)
		return

	var/turf/dest = null

	//find a turf to unload to
	if(direction)	//if direction specified, unload in that direction
		dest = get_step(src, direction)
	else if(user)	//if a user has unloaded the vehicle, unload at their feet
		dest = get_turf(user)

	if(!dest)
		dest = get_step_to(src, get_step(src, turn(dir, 90))) //try unloading to the side of the vehicle first if neither of the above are present

	//if these all result in the same turf as the vehicle or nullspace, pick a new turf with open space
	if(!dest || dest == get_turf(src))
		var/list/options = new()
		for(var/test_dir in GLOB.alldirs)
			var/new_dir = get_step_to(src, get_step(src, test_dir))
			if(new_dir && load.Adjacent(new_dir))
				options += new_dir
		if(options.len)
			dest = pick(options)
		else
			dest = get_turf(src)	//otherwise just dump it on the same turf as the vehicle

	if(!isturf(dest))	//if there still is nowhere to unload, cancel out since the vehicle is probably in nullspace
		return 0

	if(ismob(load))
		unbuckle_mob(load, BUCKLE_OP_FORCE)

	load.forceMove(dest)
	load.setDir(get_dir(loc, dest))
	load.anchored = 0		//we can only load non-anchored items, so it makes sense to set this to false
	load.pixel_x = initial(load.pixel_x)
	load.pixel_y = initial(load.pixel_y)
	load.layer = initial(load.layer)

	load = null

	return 1
*/
//OLD PROC CLONE
/*
/obj/vehicle/trailer/proc/load(var/atom/movable/C, var/mob/living/user)
	//This loads objects onto the vehicle so they can still be interacted with.
	//Define allowed items for loading in specific vehicle definitions.
	if(!isturf(C.loc)) //To prevent loading things from someone's inventory, which wouldn't get handled properly.
		return 0
	if(cargo || C.anchored)
		return 0

	// if a create/closet, close before loading
	var/obj/structure/closet/crate = C
	if(istype(crate))
		crate.close()

	C.forceMove(loc)
	C.setDir(dir)
	C.anchored = 1

	cargo = C

	if(cargo_item_visible)
		C.pixel_x += cargo_offset_x
		C.pixel_y += cargo_offset_y
		C.layer = layer + 0.1

	//if(ismob(C))
	//	user_buckle_mob(C, user = user)

	return 1


/obj/vehicle/trailer/proc/unload(var/mob/user, var/direction)
	if(!cargo)
		return

	var/turf/dest = null

	//find a turf to unload to
	if(direction)	//if direction specified, unload in that direction
		dest = get_step(src, direction)
	else if(user)	//if a user has unloaded the vehicle, unload at their feet
		dest = get_turf(user)

	if(!dest)
		dest = get_step_to(src, get_step(src, turn(dir, 90))) //try unloading to the side of the vehicle first if neither of the above are present

	//if these all result in the same turf as the vehicle or nullspace, pick a new turf with open space
	if(!dest || dest == get_turf(src))
		var/list/options = new()
		for(var/test_dir in GLOB.alldirs)
			var/new_dir = get_step_to(src, get_step(src, test_dir))
			if(new_dir && cargo.Adjacent(new_dir))
				options += new_dir
		if(options.len)
			dest = pick(options)
		else
			dest = get_turf(src)	//otherwise just dump it on the same turf as the vehicle

	if(!isturf(dest))	//if there still is nowhere to unload, cancel out since the vehicle is probably in nullspace
		return 0

	//if(ismob(load))
	//	unbuckle_mob(load, BUCKLE_OP_FORCE)

	cargo.forceMove(dest)
	cargo.setDir(get_dir(loc, dest))
	cargo.anchored = 0		//we can only load non-anchored items, so it makes sense to set this to false
	cargo.pixel_x = initial(cargo.pixel_x)
	cargo.pixel_y = initial(cargo.pixel_y)
	cargo.layer = initial(cargo.layer)

	cargo = null

	return 1










*/

//----------------------------------------------------------------------------------------

/obj/vehicle/trailer/cargo
	name = "cargo train trolley"
	desc = "A trolley designed to be pulled by a cargo train tug."
	icon_state = "cargo_trailer"
	allowed_cargo = /obj/structure/
	trailer_type = /obj/vehicle/trailer/cargo
