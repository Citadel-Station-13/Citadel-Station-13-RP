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
 * resets our armor to initial values
 */
/atom/proc/reset_armor()
	set_armor(initial(armor_type))

/**
 * sets our armor
 *
 * @params
 * * what - list of armor values or a /datum/armor path
 */
/atom/proc/set_armor(what)
	armor = fetch_armor_struct(what)

/**
 * gets our armor datum or otherwise make sure it exists
 */
/atom/proc/fetch_armor()
	RETURN_TYPE(/datum/armor)
	return armor || (armor = fetch_armor_struct(armor_type))

/**
 * calculates the resulting damage from an attack, taking into account our armor and soak
 *
 * @params
 * * damage - raw damage
 * * tier - penetration / attack tier
 * * flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 * * mode - reserved - todo: pointer to damage mode to allow for dampening of piercing / etc.
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) attacking /obj/item for melee or thrown, /obj/projectile for ranged, /mob for unarmed
 *
 * @return resulting damage
 */
/atom/proc/check_armor(damage, tier, flag, mode, attack_type, datum/weapon)
	return fetch_armor().resultant_damage(damage, tier, flag)

/**
 * runs armor against an incoming attack
 * this proc can have side effects
 *
 * @params
 * * damage - raw damage
 * * tier - penetration / attack tier
 * * flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 * * mode - reserved - todo: pointer to damage mode to allow for dampening of piercing / etc.
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) attacking /obj/item for melee or thrown, /obj/projectile for ranged, /mob for unarmed
 *
 * @return resulting damage
 */
/atom/proc/run_armor(damage, tier, flag, mode, attack_type, datum/weapon)
	return fetch_armor().resultant_damage(damage, tier, flag)

//? shieldcalls

/**
 * checks for shields
 * not always accurate
 *
 * todo: use pointers instead
 *
 * params are modified and then returned as a list.
 */
/atom/proc/atom_shieldcheck(damage, tier, flag, mode, attack_type, datum/weapon, list/additional = list(), retval = NONE)
	retval |= SHIELDCALL_JUST_CHECKING
	SEND_SIGNAL(src, COMSIG_ATOM_SHIELDCALL, args)
	return args.Copy()

/**
 * runs an attack against shields
 * side effects are allowed
 *
 * todo: use pointers instead
 *
 * params are modified and then returned as a list
 */
/atom/proc/atom_shieldcall(damage, tier, flag, mode, attack_type, datum/weapon, list/additional = list(), retval = NONE)
	SEND_SIGNAL(src, COMSIG_ATOM_SHIELDCALL, args)
	return args.Copy()
