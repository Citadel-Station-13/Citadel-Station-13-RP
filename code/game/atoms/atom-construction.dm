//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Deconstruction *//

/**
 * called to semantically deconstruct an atom
 *
 * @params
 * * method - how we were deconstructed
 */
/atom/proc/deconstruct(method = ATOM_DECONSTRUCT_DISASSEMBLED)
	SHOULD_NOT_OVERRIDE(TRUE)

	// send signal
	// todo: signal
	// do da funny logic
	deconstructed(method)
	// drop things after so things that rely on having objects don't break
	drop_products(method, drop_location())
	// goodbye, cruel world
	break_apart(method)

/**
 * called to actually destroy ourselves
 */
/atom/proc/break_apart(method)
	qdel(src)

/**
 * called when we are deconstructed
 *
 * **do not drop products in here**
 *
 * @params
 * - method - how we were deconstructed
 */
/atom/proc/deconstructed(method)
	return

/**
 * called to drop the products of deconstruction
 *
 * @params
 * * method - how we were deconstructed
 * * where - where to drop products; set in base if null to drop_location().
 */
/atom/proc/drop_products(method, atom/where = drop_location())
	return

/**
 * called to move a product to a place
 *
 * @params
 * * method - how we were deconstructed
 * * dropping - movable in question
 * * where - where to move to
 */
/atom/proc/drop_product(method, atom/movable/dropping, atom/where)
	dropping.forceMove(where || drop_location())
