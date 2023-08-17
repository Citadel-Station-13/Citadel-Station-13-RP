GLOBAL_LIST_INIT(possible_cable_coil_colours, list(
		"White" = COLOR_WHITE,
		"Silver" = COLOR_SILVER,
		"Gray" = COLOR_GRAY,
		"Black" = COLOR_BLACK,
		"Red" = COLOR_RED,
		"Maroon" = COLOR_MAROON,
		"Yellow" = COLOR_YELLOW,
		"Olive" = COLOR_OLIVE,
		"Lime" = COLOR_GREEN,
		"Green" = COLOR_LIME,
		"Cyan" = COLOR_CYAN,
		"Teal" = COLOR_TEAL,
		"Blue" = COLOR_BLUE,
		"Navy" = COLOR_NAVY,
		"Pink" = COLOR_PINK,
		"Purple" = COLOR_PURPLE,
		"Orange" = COLOR_ORANGE,
		"Beige" = COLOR_BEIGE,
		"Brown" = COLOR_BROWN
	))

/**
 * cables
 *
 * we're stubborn so we stuck with "old ss13" cables instead of /tg/ redstone cables.
 *
 * direction diagram
 * 9   1   5
 *   \ | /
 * 8 - 0 - 4
 *   / | \
 * 10  2   6
 *
 * cables can either be a "node" with a direction going out (all dirs),
 * or two dirs for a "smooth" cable from one dir to another.
 *
 * if d1 = 0, d2 = 0, there's no cable (why would there be; this is an error state)
 * if d1 = 0, d2 = X, it's a 0-X cable, going from center of tile (knot) to dir.
 * if d1 = X, d2 = Y, it's a X-Y cable, going from X to Y dirs.
 * By design, d1 is the smaller numeric value direction, d2 is the higher. Refere to the diagram.
 *
 * furthermore, UP / DOWN (16 / 32) are valid for d2 *only*
 *
 * violations of any of the above will result in undefined behavior.
 * you have been warned. do not fuck around, or ye shall find out.
 */
/obj/structure/wire/cable
	name = "power cable"
	desc = "A flexible superconducting cable for heavy-duty power transfer. Materials science certainly has come far."
	icon = 'icons/obj/power_cond_white.dmi'
	icon_state = "0-1"
	atom_colouration_system = FALSE

	plane = TURF_PLANE
	layer = EXPOSED_WIRE_LAYER
	color = COLOR_RED

	level = 1
	anchored = TRUE
	rad_flags = RAD_BLOCK_CONTENTS | RAD_NO_CONTAMINATE

	var/d1 = 0
	var/d2 = 1
	/// can we be cut with wirecutters? null for no, number for time; usually 0.
	var/cut_time = 0

/obj/structure/wire/cable/Initialize(mapload, _color, _d1, _d2)
	. = ..()

	if(_color)
		add_atom_colour(GLOB.possible_cable_coil_colours[_color] || COLOR_RED, FIXED_COLOUR_PRIORITY)

	if(_d1 || _d2)
		d1 = _d1
		d2 = _d2
	else
		// ensure d1 & d2 reflect the icon_state for entering and exiting cable
		var/dash = findtext(icon_state, "-")
		d1 = text2num(copytext(icon_state, 1, dash))
		d2 = text2num(copytext(icon_state, dash + 1))

#ifdef UNIT_TESTS
	ASSERT(d2 > d1) // triumph wiring incident - never again.
#endif

	if(dir != SOUTH)
		var/angle = 180 - dir2angle(dir)
		if(d1 != 0)
			d1 = turn(d1, angle)
		if(!(d2 & (UP | DOWN)))
			d2 = turn(d2, angle)
			if(d1 > d2)
				var/dswap = d2
				d2 = d1
				d1 = dswap
		icon_state = "[d1]-[d2]"
		dir = SOUTH

	is_junction = d1 == 0

/obj/structure/wire/cable/adjacent_wires()
	. = list()

	var/obj/structure/wire/cable/C

	// we only want to handle a for loop per turf once, so, start with same turf
	for(C in loc)
		if(C == src)
			continue
		if(C.d1 != d1 && C.d2 != d2 && C.d1 != d2 && C.d2 != d1) // no matches
			continue
		. += C

	var/turf/T
	var/reverse
	if(d1)
		// we don't need to worry about up/down here
		reverse = global.reverse_dir[d1]
		T = get_step(src, d1)
		if(!isnull(T))
			for(C in T)
				if(C.d1 != reverse && C.d2 != reverse)
					continue
				. += C
			// check diagonals for contacting wires in all adjacent turfs to that diagonal join-point
			if(ISDIAGONALDIR(d1))
				T = get_step(src, d1 & (NORTH|SOUTH))
				if(!isnull(T))
					reverse = d1 ^ (NORTH|SOUTH)
					for(C in T)
						if(C.d1 != reverse && C.d2 != reverse)
							continue
						. += C
				T = get_step(src, d1 & (EAST|WEST))
				if(!isnull(T))
					reverse = d1 ^ (EAST|WEST)
					for(C in T)
						if(C.d1 != reverse && C.d2 != reverse)
							continue
						. += C
	if(d2)
		// we *do* need to worry about up/down here
		if(d2 & (UP|DOWN))
			// we do not need to check diagonals as UP|DOWN cannot be diagonal
			reverse = global.reverse_dir[d2]
			T = get_step_multiz(src, d2)
			if(!isnull(T))
				for(C in T)
					if(C.d2 != reverse && C.d1 != reverse)
						continue
					. += C
		else
			reverse = global.reverse_dir[d2]
			T = get_step(src, d2)
			if(!isnull(T))
				for(C in T)
					if(C.d1 != reverse && C.d2 != reverse)
						continue
					. += C
				// check diagonals for contacting wires in all adjacent turfs to that diagonal join-point
				if(ISDIAGONALDIR(d2))
					T = get_step(src, d2 & (NORTH|SOUTH))
					if(!isnull(T))
						reverse = d2 ^ (NORTH|SOUTH)
						for(C in T)
							if(C.d1 != reverse && C.d2 != reverse)
								continue
							. += C
					T = get_step(src, d2 & (EAST|WEST))
					if(!isnull(T))
						reverse = d2 ^ (EAST|WEST)
						for(C in T)
							if(C.d1 != reverse && C.d2 != reverse)
								continue
							. += C

/obj/structure/wire/cable/drop_products(method, atom/where)
	. = ..()
	new /obj/item/stack/cable_coil(where, d1? 2 : 1)

/obj/structure/wire/cable/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	. = ..()
	#warn cable coil

/obj/structure/wire/cable/wirecutter_act(obj/item/I, mob/user, flags, hint)
	if(!cut_time)
		return FALSE
	if(d2 == UP)
		user.action_feedback(SPAN_WARNING("You must cut this cable from above."), src)
		return TRUE
	if(cut_time)
		user.visible_action_feedback(
			target = src,
			visible_hard = SPAN_WARNING("[user] starts to cut [src]..."),
			hard_range = MESSAGE_RANGE_CONSTRUCTION,
		)
		if(!do_after(user, cut_time, src, mobility_flags = MOBILITY_CAN_USE))
			return FALSE
	user.visible_action_feedback(
		target = src,
		visible_hard = SPAN_WARNING("[user] cuts [src]."),
		hard_range = MESSAGE_RANGE_CONSTRUCTION,
	)
	investigate_log("[d1]-[d2] cut by [key_name(user)]", INVESTIGATE_WIRES)
	deconstruct(ATOM_DECONSTRUCT_DISASSEMBLED)

/obj/structure/wire/cable/proc/reset_dirs(d1, d2)
	src.d1 = d1
	src.d2 = d2
	update_icon()
	#warn update

#warn below

/obj/structure/cable/drain_energy(datum/actor, amount, flags)
	if(!powernet)
		return 0
	return powernet.drain_energy_handler(actor, amount, flags)

/obj/structure/cable/can_drain_energy(datum/actor, flags)
	return TRUE

/obj/structure/cable/Initialize(mapload, _color, _d1, _d2, auto_merge)

	cable_list += src //add it to the global cable list
	#warn cable list???


/obj/structure/cable/Destroy()					// called when a cable is deleted
	if(powernet)
		cut_cable_from_powernet()				// update the powernets
	cable_list -= src							//remove it from global cable list
	return ..()									// then go ahead and delete the cable

// Ghost examining the cable -> tells him the power
/obj/structure/cable/attack_ghost(mob/user)
	. = ..()
	if(user.client?.inquisitive_ghost)
		// following code taken from attackby (multitool)
		if(powernet && (powernet.avail > 0))
			to_chat(user, "<span class='warning'>[render_power(powernet.avail, ENUM_POWER_SCALE_KILO, ENUM_POWER_UNIT_WATT)] in power network.</span>")
		else
			to_chat(user, "<span class='warning'>The cable is not powered.</span>")

///////////////////////////////////
// General procedures
///////////////////////////////////


// Items usable on a cable :
//   - Wirecutters : cut it duh !
//   - Cable coil : merge cables
//   - Multitool : get the power currently passing through the cable
//

/obj/structure/cable/attackby(obj/item/W, mob/user)


	else if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = W
		if (coil.get_amount() < 1)
			to_chat(user, "Not enough cable")
			return
		coil.cable_join(src, user)

	else if(istype(W, /obj/item/multitool))

		if(powernet && (powernet.avail > 0))		// is it powered?
			to_chat(user, "<span class='warning'>[render_power(powernet.avail, ENUM_POWER_SCALE_KILO, ENUM_POWER_UNIT_WATT)] in power network.</span>")

		else
			to_chat(user, "<span class='warning'>The cable is not powered.</span>")

		shock(user, 5, 0.2)

	else
		if(!(W.atom_flags & NOCONDUCT))
			shock(user, 50, 0.7)

	src.add_fingerprint(user)

// shock the user with probability prb
/obj/structure/cable/proc/shock(mob/user, prb, var/siemens_coeff = 1.0)
	if(!prob(prb))
		return 0
	if (electrocute_mob(user, powernet, src, siemens_coeff))
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		if(!CHECK_MOBILITY(user, MOBILITY_CAN_USE))
			return 1
	return 0

//explosion handling
/obj/structure/wire/cable/legacy_ex_act(severity)
	// no breaking if we're underfloor
	if(invisibility)
		return
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if (prob(50))
				new/obj/item/stack/cable_coil(src.loc, src.d1 ? 2 : 1, null, color)
				qdel(src)

		if(3.0)
			if (prob(25))
				new/obj/item/stack/cable_coil(src.loc, src.d1 ? 2 : 1, null, color)
				qdel(src)

//////////////////////////////////////////////
// Powernets handling helpers
//////////////////////////////////////////////

//should be called after placing a cable which extends another cable, creating a "smooth" cable that no longer terminates in the centre of a turf.
//needed as this can, unlike other placements, disconnect cables
/obj/structure/cable/proc/denode()
	var/turf/T1 = loc
	if(!T1) return

	var/list/powerlist = power_list(T1,src,0,0) //find the other cables that ended in the centre of the turf, with or without a powernet
	if(powerlist.len>0)
		var/datum/powernet/PN = new()
		propagate_network(powerlist[1],PN) //propagates the new powernet beginning at the source cable

		if(PN.is_empty()) //can happen with machines made nodeless when smoothing cables
			qdel(PN)

// cut the cable's powernet at this cable and updates the powergrid
/obj/structure/cable/proc/cut_cable_from_powernet()
	var/turf/T1 = loc
	var/list/P_list
	if(!T1)	return
	if(d1)
		T1 = get_step(T1, d1)
		P_list = power_list(T1, src, turn(d1,180),0,cable_only = 1)	// what adjacently joins on to cut cable...

	P_list += power_list(loc, src, d1, 0, cable_only = 1)//... and on turf


	if(P_list.len == 0)//if nothing in both list, then the cable was a lone cable, just delete it and its powernet
		powernet.remove_cable(src)

		for(var/obj/machinery/power/P in T1)//check if it was powering a machine
			if(!P.connect_to_network()) //can't find a node cable on a the turf to connect to
				P.disconnect_from_network() //remove from current network (and delete powernet)
		return

	// remove the cut cable from its turf and powernet, so that it doesn't get count in propagate_network worklist
	loc = null
	powernet.remove_cable(src) //remove the cut cable from its powernet

	var/datum/powernet/newPN = new()// creates a new powernet...
	propagate_network(P_list[1], newPN)//... and propagates it to the other side of the cable

	// Disconnect machines connected to nodes
	if(d1 == 0) // if we cut a node (O-X) cable
		for(var/obj/machinery/power/P in T1)
			if(!P.connect_to_network()) //can't find a node cable on a the turf to connect to
				P.disconnect_from_network() //remove from current network


