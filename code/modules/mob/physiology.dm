/**
 * physiology holder
 *
 * todo: on biologies update, we might need to lazy-cache this, and have different physiologies for each biology.
 */
/datum/global_physiology
	// todo: /datum/global_physiology should hold global body physiology, limbs should hold modifiers/whatever themselves.
	//       this way biologies can be supported as efficiently as possible.

	/// carry weight baseline modify
	var/carry_strength = CARRY_STRENGTH_BASELINE
	/// carry weight penalty divisor
	var/carry_factor = CARRY_FACTOR_BASELINE
	/// carry weight exponent
	var/carry_exponent = CARRY_EXPONENT_BASELINE

/datum/global_physiology/proc/reset()
	carry_strength = initial(carry_strength)
	carry_factor = initial(carry_factor)
	carry_exponent = initial(carry_exponent)

/datum/global_physiology/proc/apply(datum/physiology_modifier/modifier)
	if(!isnull(modifier.carry_strength_add))
		carry_strength += modifier.carry_strength_add
	if(!isnull(modifier.carry_factor_mult))
		carry_factor *= modifier.carry_factor_mult
	if(!isnull(modifier.carry_exponent_mult))
		carry_exponent = carry_exponent ** modifier.carry_exponent_pow

/**
 * return FALSE if we need to reset due to non-canonical operations
 */
/datum/global_physiology/proc/revert(datum/physiology_modifier/modifier)
	. = TRUE
	if(!isnull(modifier.carry_strength_add))
		carry_strength -= modifier.carry_strength_add
	if(!isnull(modifier.carry_factor_mult))
		carry_factor /= modifier.carry_factor_mult
	if(!isnull(modifier.carry_exponent_mult))
		carry_exponent = carry_exponent ** (1 / modifier.carry_exponent_pow)

/**
 * physiology modifier
 */
/datum/physiology_modifier
	abstract_type = /datum/physiology_modifier

	/// is this a globally cached modifier?
	var/is_globally_cached = FALSE

	// todo: on biologies update, we need to specify what biologies this applies to

	//? global modifiers
	var/carry_strength_add
	var/carry_factor_mult
	var/carry_exponent_pow

/**
 * subtype for hardcoded physiology modifiers
 */
/datum/physiology_modifier/intrinsic
	abstract_type = /datum/physiology_modifier/intrinsic

GLOBAL_LIST_EMPTY(cached_physiology_modifiers)

/proc/cached_physiology_modifier(datum/physiology_modifier/path)
	ASSERT(ispath(path, /datum/physiology_modifier))
	ASSERT(initial(path.abstract_type) != path)
	// if it already exists, set default return value to it and return
	if((. = GLOB.cached_physiology_modifiers[path]))
		return
	var/datum/physiology_modifier/modifier = new path
	modifier.is_globally_cached = TRUE
	GLOB.cached_physiology_modifiers[path] = modifier
	return modifier

/**
 * initializes physiology modifiers
 * paths in physiology modifier are converted to the cached instances in globals.
 */
/mob/proc/init_physiology()
	for(var/i in 1 to length(physiology_modifiers))
		if(ispath(physiology_modifiers[i]))
			physiology_modifiers[i] = cached_physiology_modifier(physiology_modifiers[i])
	rebuild_physiology()

/**
 * adds a modifier to physiology
 * you are responsible for not double-adding
 * paths are allowed; if modifier is a path, it'll be the globally cached modifier of that type.
 */
/mob/proc/add_physiology_modifier(datum/physiology_modifier/modifier)
	if(ispath(modifier))
		modifier = cached_physiology_modifier(modifier)
	ASSERT(!(modifier in physiology_modifiers))
	physiology_modifiers += modifier
	physiology.apply(modifier)

/**
 * removes a modifier from physiology
 * you are responsible for not double-adding
 * paths are allowed
 */
/mob/proc/remove_physiology_modifier(datum/physiology_modifier/modifier)
	if(ispath(modifier))
		modifier = cached_physiology_modifier(modifier)
	ASSERT(modifier in physiology_modifiers)
	physiology_modifiers -= modifier
	if(!physiology.revert(modifier))
		// todo: optimize with reset().
		rebuild_physiology()

/**
 * completely rebuilds physiology from our modifiers
 */
/mob/proc/rebuild_physiology()
	physiology = new
	for(var/datum/physiology_modifier/modifier as anything in physiology_modifiers)
		if(!istype(modifier))
			physiology_modifiers -= modifier
			continue
		physiology.apply(modifier)

// todo: admin vv verb via tgui to input new modifier
