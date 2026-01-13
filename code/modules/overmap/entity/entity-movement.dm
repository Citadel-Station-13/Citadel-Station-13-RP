//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// i got bored and bolted a pixel movement system onto overmap entities
// what's the worst that happens???
//
// the _p stands for pixel movement, or pixloc, or perhaps perilous

/obj/overmap/entity/proc/move_p(pixloc/dest)
	var/atom/old_loc = loc
	Move(dest)
	var/atom/new_loc = loc
	if(old_loc != new_loc)
		Moved(old_loc, NONE, FALSE, null, null)

/obj/overmap/entity/proc/step_p(vector/offset)
	Move(pixloc + offset)

/**
 * Will call side effects.
 */
/obj/overmap/entity/proc/force_move_p(pixloc/dest)
	var/atom/old_loc = loc
	force_move_p_impl(dest)
	var/atom/new_loc = loc
	if(old_loc != new_loc)
		Moved(old_loc, NONE, FALSE, null, null)

/**
 * Will call side effects.
 */
/obj/overmap/entity/proc/force_move_p_null()
	var/atom/old_loc = loc
	force_move_p_impl(null)
	var/atom/new_loc = loc
	if(old_loc != new_loc)
		Moved(old_loc, NONE, FALSE, null, null)

/**
 * Will not call side effects.
 */
/obj/overmap/entity/proc/force_move_p_abstract(pixloc/dest)
	var/atom/old_loc = loc
	pixloc = dest
	var/atom/new_loc = loc
	if(old_loc != new_loc)
		Moved(old_loc, NONE, FALSE, null, null)

/**
 * Will call side effects.
 */
/obj/overmap/entity/proc/force_move_p_impl(pixloc/dest)
	step_size = 0
	Move(dest)
