//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

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
	set_junction(d1 == 0)
	rebuild()

/**
 * turns our knot cable (0-X) into a (dir-X) cable
 *
 * this does not sanity check for if it semantically makes sense! e.g. this won't stop you from doing X-X cables, where
 * X is in the same direction - you need to check yourself!
 */
/obj/structure/wire/cable/proc/denode(dir)
	// optimizations later, for now we just are fluffed reset_dirs().
	reset_dirs(dir, d2)

/obj/structure/wire/cable/examine(mob/user, dist)
	. = ..()
	if(isobserver(user) && !isnull(network))
		var/datum/wirenet/power/powernet = network
		. += powernet.observer_examine()

//! legacy: explosion handling

/obj/structure/wire/cable/legacy_ex_act(severity)
	// no breaking if we're underfloor
	if(invisibility)
		return
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if (prob(50))
				new/obj/item/stack/cable_coil(src.loc, src.d1 ? 2 : 1, null, color)
				qdel(src)

		if(3)
			if (prob(25))
				new/obj/item/stack/cable_coil(src.loc, src.d1 ? 2 : 1, null, color)
				qdel(src)

#warn below

/obj/structure/cable/drain_energy(datum/actor, amount, flags)
	if(!powernet)
		return 0
	return powernet.drain_energy_handler(actor, amount, flags)

/obj/structure/cable/can_drain_energy(datum/actor, flags)
	return TRUE

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
