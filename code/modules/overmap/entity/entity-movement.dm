//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// i got bored and bolted a pixel movement system onto overmap entities
// what's the worst that happens???
//
// the _p stands for pixel movement, or pixloc, or perhaps perilous

/obj/overmap/entity/proc/move_p(pixloc/dest)

/obj/overmap/entity/proc/step_p(vector/offset)
	Move(pixloc + offset)

/**
 * Will call side effects.
 */
/obj/overmap/entity/proc/force_move_p(pixloc/dest)

	move_p_impl(dest)

/**
 * Will call side effects.
 */
/obj/overmap/entity/proc/force_move_p_null()

	move_p_impl(null)

/**
 * Will not call side effects.
 */
/obj/overmap/entity/proc/force_move_p_abstract(pixloc/dest)

	move_p_impl(dest)

/**
 * Will not call side effects.
 */
/obj/overmap/entity/proc/force_move_p_impl(pixloc/dest)

#warn impl
