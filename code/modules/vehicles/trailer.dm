/obj/vehicle/trailer
	name = "the vague concept of a trailer"
	desc = "Yell at coderbus."
	//Trailers will anchor when hitched and unanchor when unhitched.
	anchored = FALSE
	max_drivers = 0
	max_occupants = 0

	var/allowed_cargo
	var/atom/movable/cargo
	var/cargo_item_visible = TRUE
	var/cargo_offset_x = 0
	var/cargo_offset_y = 8
//----------------------------------------------------------------------------------------
/datum/vehicle_dummy_load
	var/name = "dummy load"
	var/actual_load

/obj/vehicle/trailer/Move(dir)
	..()
	if(cargo && !istype(cargo, /datum/vehicle_dummy_load))
		cargo.forceMove(get_step(src, dir))
		//Fuck. Why not?
		//cargo.loc = src.loc
		cargo.setDir(dir)

//Take DroppedOn atoms and determine if they are cargo to be loaded.
/obj/vehicle/trailer/MouseDroppedOn(atom/dropping, mob/user, proximity, params)
	if(!istype(dropping) || !isliving(user) || !proximity || get_dist(dropping.loc, loc) != 1)
		return ..()

	//Cargo unload check
	if(dropping == cargo)
		if(unload(user))
			return CLICKCHAIN_DO_NOT_PROPAGATE
	//Cargo load check
	if(load(dropping, user))
		return CLICKCHAIN_DO_NOT_PROPAGATE

	return ..()

//If we are dropped onto something try to unload()
/obj/vehicle/trailer/OnMouseDrop(atom/over, mob/user, proximity, params)
	if (proximity < 2 && isturf(over))
		if (unload(user, get_dir(over.loc, loc)))
			return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

//If clicked on, try to unload() cargo
/obj/vehicle/trailer/attack_hand(mob/user, list/params)
	. = ..()
	unload(user)

//-------------------------------------------
// Loading/unloading procs
//
// Set specific item restriction checks in
// the vehicle load() definition before
// calling this parent proc.
//-------------------------------------------
/obj/vehicle/trailer/proc/load(var/atom/movable/C, var/mob/living/user)
	// If it is a mob, anchored, not on the ground, or we are loaded already, Do nothing.
	if(!isturf(C.loc) || cargo || C.anchored || ismob(C))
		return FALSE
	// If it is NOT one of these types, Do nothing.
	if(!(istype(C,/obj/machinery) || istype(C,/obj/structure/closet) || istype(C,/obj/structure/largecrate) || istype(C,/obj/structure/reagent_dispensers) || istype(C,/obj/structure/ore_box)))
		return FALSE

	// If there are any items you don't want to be interactable when loaded, add them to this check.
	if(istype(C, /obj/machinery))
		return load_object(C)

	// if a closet, close before loading
	if(istype(C, /obj/structure/closet))
		var/obj/structure/closet/crate = C
		crate.close()
		crate.update_icon()

	C.forceMove(loc)
	C.setDir(dir)
	C.anchored = TRUE
	C.density = FALSE

	cargo = C

	if(cargo_item_visible)
		C.pixel_x += cargo_offset_x
		C.pixel_y += cargo_offset_y
		C.layer = layer + 0.1
	return TRUE


/obj/vehicle/trailer/proc/unload(var/mob/user, var/direction)
	if(!cargo)
		return

	if(istype(cargo, /datum/vehicle_dummy_load))
		var/datum/vehicle_dummy_load/dummy_load = cargo
		cargo = dummy_load.actual_load
		dummy_load.actual_load = null
		qdel(dummy_load)
		cut_overlays()

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
		return FALSE

	cargo.forceMove(dest)
	cargo.setDir(get_dir(loc, dest))
	cargo.anchored = FALSE
	cargo.density = initial(cargo.density)
	cargo.pixel_x = initial(cargo.pixel_x)
	cargo.pixel_y = initial(cargo.pixel_y)
	cargo.layer = initial(cargo.layer)

	cargo = null

	return TRUE
//------------------------------------------------------------------------
//Load the object "inside" the trolley and add an overlay of it.
//This prevents the object from being interacted with until it has
// been unloaded. A dummy object is loaded instead so the loading
// code knows to handle it correctly.
/obj/vehicle/trailer/proc/load_object(atom/movable/C)
	if(!isturf(C.loc) || cargo || C.anchored || ismob(C) || isnull(C))
		return FALSE

	var/datum/vehicle_dummy_load/dummy_load = new()
	cargo = dummy_load
	dummy_load.actual_load = C
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
//----------------------------------------------------------------------------------------

/obj/vehicle/trailer/cargo
	name = "cargo train trolley"
	desc = "A trolley designed to be pulled by a cargo train tug."
	icon_state = "cargo_trailer"
	allowed_cargo = /obj/structure/
	trailer_type = /obj/vehicle/trailer/cargo
