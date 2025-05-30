// Disposal pipes
/// todo: /obj/structure/disposal_pipe
/obj/structure/disposalpipe
	icon = 'icons/obj/pipes/disposal.dmi'
	name = "disposal pipe"
	desc = "An underfloor disposal pipe."
	anchored = 1
	density = 0
	hides_underfloor = OBJ_UNDERFLOOR_ACTIVE
	dir = 0 // dir will contain dominant direction for junction pipes
	plane = TURF_PLANE
	layer = DISPOSAL_LAYER // slightly lower than wires and other pipes.

	integrity = 100
	integrity_max = 100

	#ifdef IN_MAP_EDITOR // Display disposal pipes etc. above walls in map editors.
	alpha = 128 // Set for the benefit of mapping.
	#endif

	/// Bitmask of pipe directions.
	var/dpdir = 0
	var/sortType = ""
	var/subtype = 0
	// new pipe, set the icon_state as on map

/obj/structure/disposalpipe/Initialize(mapload, dir)
	. = ..()
	base_icon_state = icon_state
	if(!isnull(dir))
		setDir(dir)

// pipe is deleted
// ensure if holder is present, it is expelled
/obj/structure/disposalpipe/Destroy()
	var/obj/structure/disposalholder/H = locate() in src
	if(H)
		// holder was present
		H.active = 0
		var/turf/T = src.loc
		if(T.density)
			// deleting pipe is inside a dense turf (wall)
			// this is unlikely, but just dump out everything into the turf in case

			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(0)
			qdel(H)
			..()
			return

		// otherwise, do normal expel from turf
		if(H)
			expel(H, T, 0)
	..()

// returns the direction of the next pipe object, given the entrance dir
// by default, returns the bitmask of remaining directions
/obj/structure/disposalpipe/proc/nextdir(var/fromdir)
	return dpdir & (~turn(fromdir, 180))

// transfer the holder through this pipe segment
// overriden for special behaviour
//
/obj/structure/disposalpipe/proc/transfer(var/obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.setDir(nextdir)
	var/turf/T = H.nextloc()
	var/obj/structure/disposalpipe/P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P

// update actual icon_state depending on visibility
// if invisible, append "f" to icon_state to show faded version
// this will be revealed if a T-scanner is used
// if visible, use regular icon_state
/obj/structure/disposalpipe/proc/updateicon()
	icon_state = base_icon_state

// expel the held objects into a turf
// called when there is a break in the pipe
/obj/structure/disposalpipe/proc/expel(var/obj/structure/disposalholder/H, var/turf/T, var/direction)
	if(!istype(H))
		return

	// Empty the holder if it is expelled into a dense turf.
	// Leaving it intact and sitting in a wall is stupid.
	if(T.density)
		for(var/atom/movable/AM in H)
			AM.loc = T
			AM.pipe_eject(0)
		qdel(H)
		return

	if(!T.is_plating() && istype(T,/turf/simulated/floor)) //intact floor, pop the tile
		var/turf/simulated/floor/F = T
		F.break_tile()
		new /obj/item/stack/tile(H)	// add to holder so it will be thrown with other stuff

	var/turf/target
	if(direction)		// direction is specified
		if(istype(T, /turf/space)) // if ended in space, then range is unlimited
			target = get_edge_target_turf(T, direction)
		else						// otherwise limit to 10 tiles
			target = get_ranged_target_turf(T, direction, 10)

		playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
		if(H)
			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(direction)
				spawn(1)
					if(AM)
						AM.throw_at_old(target, 100, 1)
			H.vent_gas(T)
			qdel(H)

	else	// no specified direction, so throw in random direction

		playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
		if(H)
			for(var/atom/movable/AM in H)
				target = get_offset_target_turf(T, rand(5)-rand(5), rand(5)-rand(5))

				AM.forceMove(T)
				AM.pipe_eject(0)
				spawn(1)
					if(AM)
						AM.throw_at_old(target, 5, 1)

			H.vent_gas(T)	// all gas vent to turf
			qdel(H)

/obj/structure/disposalpipe/deconstructed(method)
	. = ..()
	src.invisibility = 101	// make invisible (since we won't delete the pipe immediately)
	var/obj/structure/disposalholder/H = locate() in src
	if(H)
		// holder was present
		H.active = 0
		var/turf/T = src.loc
		if(T.density)
			// broken pipe is inside a dense turf (wall)
			// this is unlikely, but just dump out everything into the turf in case

			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(0)
			qdel(H)
			return

		// otherwise, do normal expel from turf
		if(H)
			expel(H, T, 0)
	return ..()

/obj/structure/disposalpipe/drop_products(method, atom/where)
	. = ..()
	if(method != ATOM_DECONSTRUCT_DISASSEMBLED)
		new /obj/structure/disposalpipe/broken(where, dir)

//attack by item
//weldingtool: unfasten and convert to obj/disposalconstruct

/obj/structure/disposalpipe/attackby(var/obj/item/I, var/mob/user)

	var/turf/T = src.loc
	if(!T.is_plating())
		return		// prevent interaction with T-scanner revealed pipes
	src.add_fingerprint(user, 0, I)
	if(istype(I, /obj/item/weldingtool))
		var/obj/item/weldingtool/W = I

		if(W.remove_fuel(0,user))
			playsound(src, W.tool_sound, 50, 1)
			// check if anything changed over 2 seconds
			var/turf/uloc = user.loc
			var/atom/wloc = W.loc
			to_chat(user, "Slicing the disposal pipe.")
			sleep(30)
			if(!W.isOn()) return
			if(user.loc == uloc && wloc == W.loc)
				welded()
			else
				to_chat(user, "You must stay still while welding the pipe.")
		else
			to_chat(user, "You need more welding fuel to cut the pipe.")
			return

// called when pipe is cut with welder
/obj/structure/disposalpipe/proc/welded()

	var/obj/structure/disposalconstruct/C = new (src.loc)
	switch(base_icon_state)
		if("pipe-s")
			C.ptype = 0
		if("pipe-c")
			C.ptype = 1
		if("pipe-j1")
			C.ptype = 2
		if("pipe-j2")
			C.ptype = 3
		if("pipe-y")
			C.ptype = 4
		if("pipe-t")
			C.ptype = 5
		if("pipe-j1s")
			C.ptype = 9
			C.sortType = sortType
		if("pipe-j2s")
			C.ptype = 10
			C.sortType = sortType
///// Z-Level stuff
		if("pipe-u")
			C.ptype = 11
		if("pipe-d")
			C.ptype = 12
///// Z-Level stuff
		if("pipe-tagger")
			C.ptype = 13
		if("pipe-tagger-partial")
			C.ptype = 14
	C.subtype = src.subtype
	src.transfer_fingerprints_to(C)
	C.setDir(dir)
	C.density = 0
	C.anchored = 1
	C.update()

	qdel(src)

// pipe is deleted
// ensure if holder is present, it is expelled
/obj/structure/disposalpipe/Destroy()
	var/obj/structure/disposalholder/H = locate() in src
	if(H)
		// holder was present
		H.active = 0
		var/turf/T = src.loc
		if(T.density)
			// deleting pipe is inside a dense turf (wall)
			// this is unlikely, but just dump out everything into the turf in case

			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(0)
			qdel(H)
			..()
			return

		// otherwise, do normal expel from turf
		if(H)
			expel(H, T, 0)
	..()
