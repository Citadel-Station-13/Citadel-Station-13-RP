//! Welcome to the atom damage module.
//! Enjoy the bitfield and #define vomit.

//? Hooks / External

#warn bullet_act hook
#warn throw_impact hook
#warn melee_object_hit hook
#warn ex_act hook - objs / turfs only
#warn impact sounds...

//? Damage API

/**
 * takes damage from a standard attack, taking into account armor but not shields.
 *
 * @return raw damage taken
 */
/atom/proc/take_atom_damage(amount, tier, damage_type, damage_mode, armor_flag)
	if(!integrity_enabled)
		CRASH("attempted to take_atom_damage without [NAMEOF(src, integrity_enabled)] being on.")
	#warn how to even deal with this?

//? Direct Integrity

/**
 * damages integrity directly, ignoring armor / shields
 *
 * @params
 * * amount - how much
 * * gradual - burst or gradual? if you want to play a sound or something, you usually want to check this.
 */
/atom/proc/damage_integrity(amount, gradual)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/was_working = integrity > integrity_failure
	integrity = max(0, integrity - amount)
	if(was_working && integrity <= integrity_failure)
		atom_break()
	if(!integrity)
		atom_destruction()

/**
 * heals integrity directly
 *
 * @params
 * * amount - how much
 * * gradual - burst or gradual? if you want to play a sound or something, you usually want to check this.
 */
/atom/proc/heal_integrity(amount, gradual)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/was_failing = integrity <= integrity_failure
	integrity = min(integrity_max, integrity + amount)
	if(was_failing && integrity > integrity_failure)
		atom_fix()

/**
 * directly sets integrity - ignores armor / sihelds
 *
 * @params
 * * amount - how much to set to?
 */
/atom/proc/set_integrity(amount)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/was_failing = integrity <= integrity_failure
	integrity = clamp(amount, 0, integrity_max)
	if(!was_failing && integrity <= integrity_failure)
		atom_break()
	else if(was_failing && integrity > integrity_failure)
		atom_fix()
	if(!integrity)
		atom_destruction()

/**
 * adjusts integrity - routes directly to [damage_integrity] and [heal_integrity]
 *
 * @params
 * * amount - how much
 * * gradual - burst or gradual?
 */
/atom/proc/adjust_integrity(amount, gradual)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(amount > 0)
		return heal_integrity(amount, gradual)
	else
		return damage_integrity(amount, gradual)

/**
 * percent integrity, rounded.
 */
/atom/proc/percent_integrity(round_to = 0.1)
	return integrity_max? round(integrity / integrity_max, round_to) : 0

//? Thresholds & Events

/**
 * called when integrity reaches 0 from a non 0 value
 */
/atom/proc/atom_destruction()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(!(integrity_flags & INTEGRITY_NO_DECONSTRUCT))
		deconstruct(ATOM_DECONSTRUCT_DESTROYED)

/**
 * called when integrity drops below or at integrity_failure
 *
 * if integrity_failure is 0, this is called before destruction.
 */
/atom/proc/atom_break()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * called when integrity rises above integrity_failure
 *
 * if integrity_failure is 0, this still works.
 */
/atom/proc/atom_fix()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

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
 * * mode - damage_mode
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) attacking /obj/item for melee or thrown, /obj/projectile for ranged, /mob for unarmed
 *
 * @return args as list.
 */
/atom/proc/check_armor(damage, tier, flag, mode, attack_type, datum/weapon)
	damage = fetch_armor().resultant_damage(damage, tier, flag)
	return args.Copy()

/**
 * runs armor against an incoming attack
 * this proc can have side effects
 *
 * @params
 * * damage - raw damage
 * * tier - penetration / attack tier
 * * flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 * * mode - damage_mode
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) attacking /obj/item for melee or thrown, /obj/projectile for ranged, /mob for unarmed
 *
 * @return args as list.
 */
/atom/proc/run_armor(damage, tier, flag, mode, attack_type, datum/weapon)
	damage = fetch_armor().resultant_damage(damage, tier, flag)
	return args.Copy()

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
