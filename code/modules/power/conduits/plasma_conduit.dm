//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/***
 * Conduits
 * Comes in 2, 3, 4 way's.
 * 2 way: Atmos-pipe-like, normalized towards 1 direction, if diagonal, is bend in that direction.
 * 3 way: the direction is the direction where they have no connection
 * 4 way: No directions, normalized
 * Junction: 1 cardinal direction.
 */
/obj/structure/wire/plasma_conduit
	name = "plasma conduit"
	desc = "Ooh, shiny. Better hope this doesn't break."
	#warn icon

	/// stored volume during network rebuild
	var/rebuilding_volume
	/// stored temperature during network rebuild
	var/rebuilding_temperature
	/// stored materials during network rebuild
	var/list/rebuilding_materials

	/// directions we are open as bitfield
	var/connect_dirs = NONE
	/// % of energy we lose per tick - DANGER: THIS IS EXTREMELY SENSITIVE.
	var/energy_loss = 0.025

/obj/structure/wire/plasma_conduit/Initialize(mapload)
	normalize_direction()
	return ..()

/obj/structure/wire/plasma_conduit/proc/normalize_direction()
	return

/obj/structure/wire/plasma_conduit/proc/vis_key()
	return

/obj/structure/wire/plasma_conduit/junction
	#warn icon

/obj/structure/wire/plasma_conduit/junction/normalize_direction()
	connect_dirs = dir

/obj/structure/wire/plasma_conduit/junction/vis_key()
	#warn impl

/obj/structure/wire/plasma_conduit/junction/adjacent_wires()
	. = list()
	var/turned = turn(dir, 180)
	for(var/obj/structure/wire/plasma_conduit/other in get_step(src, dir))
		if(other.connect_dirs & turned)
			. += other

/obj/structure/wire/plasma_conduit/segment
	#warn icon

/obj/structure/wire/plasma_conduit/section/normalize_direction()
	if(ISDIAGONALDIR(dir))
		connect_dirs = dir
	else
		connect_dirs = dir | turn(dir, 180)

/obj/structure/wire/plasma_conduit/section/vis_key()
	#warn impl

/obj/structure/wire/plasma_conduit/section/adjacent_wires()
	. = list()
	if(ISDIAGONALDIR(dir))
		var/ns = NSCOMPONENT(dir)
		var/ew = EWCOMPONENT(dir)
		for(var/obj/structure/wire/plasma_conduit/other in get_step(src, ns))
			if(other.connect_dirs & turn(ns, 180))
				. += other
		for(var/obj/structure/wire/plasma_conduit/other in get_step(src, ew))
			if(other.connect_dirs & turn(ew, 180))
				. += other
	else
		var/turned = turn(dir, 180)
		for(var/obj/structure/wire/plasma_conduit/other in get_step(src, dir))
			if(other.connect_dirs & turned)
				. += other
		for(var/obj/structure/wire/plasma_conduit/other in get_step(src, turned))
			if(other.connect_dirs & dir)
				. += other

/obj/structure/wire/plasma_conduit/manifold
	#warn icon

/obj/structure/wire/plasma_conduit/manifold/normalize_direction()
	connect_dirs = (NORTH | SOUTH | EAST | WEST) & ~(dir)

/obj/structure/wire/plasma_conduit/manifold/vis_key()
	#warn impl

/obj/structure/wire/plasma_conduit/manifold/adjacent_wires()
	. = list()
	for(var/dir in GLOB.cardinal)
		if(dir == src.dir)
			continue
		var/turned = turn(dir, 180)
		for(var/obj/structure/wire/plasma_conduit/other in get_step(src, dir))
			if(other.connect_dirs & turned)
				. += other

/obj/structure/wire/plasma_conduit/omni
	#warn icon

/obj/structure/wire/plasma_conduit/omni/normalize_direction()
	connect_dirs = (NORTH | SOUTH | EAST | WEST)

/obj/structure/wire/plasma_conduit/omni/vis_key()
	#warn impl

/obj/structure/wire/plasma_conduit/omni/adjacent_wires()
	. = list()
	for(var/dir in GLOB.cardinal)
		var/turned = turn(dir, 180)
		for(var/obj/structure/wire/plasma_conduit/other in get_step(src, dir))
			if(other.connect_dirs & turned)
				. += other

