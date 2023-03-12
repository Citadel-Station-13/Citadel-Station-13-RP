//! Welcome to the atom damage module.
//! Enjoy the bitfield and #define vomit.

//? Deconstruction

/**
 * called to semantically deconstruct an atom
 *
 * @params
 * - method - how we were deconstructed
 */
/atom/proc/deconstruct(method = ATOM_DECONSTRUCT_DISASSEMBLED)
	SHOULD_NOT_OVERRIDE(TRUE)

	// send signal
	// todo: signal
	// do da funny logic
	deconstructed(method)
	// drop things after so things that rely on having objects don't break
	drop_products(method)
	// goodbye, cruel world
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
 */
/atom/proc/drop_products(method)
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

//? Armor

/**
 * sets our armor
 *
 * @params
 * * what - list of armor values or a /datum/armor path
 */
/atom/proc/set_armor(what)
	r_armor = fetch_armor_struct(what)

/**
 * gets our armor datum or otherwise make sure it exists
 */
/atom/proc/fetch_armor()
	RETURN_TYPE(/datum/armor)
	return r_armor || (r_armor = fetch_armor_struct(r_armor_type))

/**
 * calculates the resulting damage from an attack, taking into account our armor and soak
 *
 * @params
 * * damage - raw damage
 * * tier - penetration / attack tier
 * * flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 *
 * @return resulting damage
 */
/atom/proc/check_armor(damage, tier, flag)
	SHOULD_BE_PURE(TRUE)
	return fetch_armor().resultant_damage(damage, tier, flag)

/**
 * runs armor against an incoming attack
 * this proc can have side effects
 *
 * @params
 * * damage - raw damage
 * * tier - penetration / attack tier
 * * flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 *
 * @return resulting damage
 */
/atom/proc/run_armor(damage, tier, flag)
	return fetch_armor().resultant_damage(damage, tier, flag)

#warn vv admin armor with /datum/tgui_input_multi
