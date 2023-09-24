/**
 * physiology holder
 *
 * todo: on biologies update, we might need to lazy-cache this, and have different physiologies for each biology.
 */
/datum/global_physiology
	// back-reference to mob, for vv purposes.
	var/mob/ownership

	// todo: /datum/global_physiology should hold global body physiology, limbs should hold modifiers/whatever themselves.
	//       this way biologies can be supported as efficiently as possible.

	/// carry weight baseline modify
	var/carry_strength = CARRY_STRENGTH_BASELINE
	/// carry weight penalty divisor
	var/carry_factor = CARRY_FACTOR_BASELINE
	/// carry weight exponent
	//  todo: a modifier var for this
	var/carry_exponent = CARRY_EXPONENT_BASELINE

/datum/global_physiology/Destroy()
	ownership = null
	return ..()

/datum/global_physiology/proc/reset()
	carry_strength = initial(carry_strength)
	carry_factor = initial(carry_factor)
	carry_exponent = initial(carry_exponent)

/datum/global_physiology/proc/apply(datum/physiology_modifier/modifier)
	if(!isnull(modifier.carry_strength_add))
		carry_strength += modifier.carry_strength_add
	if(!isnull(modifier.carry_factor_mult))
		carry_factor *= modifier.carry_factor_mult

/**
 * return FALSE if we need to reset due to non-canonical operations
 */
/datum/global_physiology/proc/revert(datum/physiology_modifier/modifier)
	. = TRUE
	if(!isnull(modifier.carry_strength_add))
		carry_strength -= modifier.carry_strength_add
	if(!isnull(modifier.carry_factor_mult))
		carry_factor /= modifier.carry_factor_mult

/datum/global_physiology/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	// we automatically hook varedits and change the admin varedit holder so rebuilds take it into account
	// this is not necessarily the best of ideas,
	// because things like multiplicative factors don't scale as admins usually would expect
	// but having this is better than not having it, as otherwise things would silently be wiped.
	if(raw_edit)
		return ..()
	if(isnull(ownership))
		return ..()
	var/datum/physiology_modifier/varedit/varedit_modifier = ownership.get_varedit_physiology_modifier()
	switch(var_name)
		if(NAMEOF(src, carry_strength))
			if(!isnum(var_value))
				if(!mass_edit)
					to_chat(usr, SPAN_WARNING("Invalid value [var_value] for [var_name] physiology edit rejected."))
				return FALSE
			. = ..()
			if(!.)
				return
			varedit_modifier.carry_strength_add = var_value - carry_strength
		if(NAMEOF(src, carry_factor))
			if(!isnum(var_value))
				if(!mass_edit)
					to_chat(usr, SPAN_WARNING("Invalid value [var_value] for [var_name] physiology edit rejected."))
				return FALSE
			. = ..()
			if(!.)
				return
			varedit_modifier.carry_factor_mult = var_value / carry_factor
		else
			return ..()
	if(!mass_edit)
		to_chat(usr, SPAN_NOTICE("Committing change to [var_name] on [ownership] ([REF(ownership)]) to physiology modifiers automatically."))

/**
 * physiology modifier
 */
/datum/physiology_modifier
	abstract_type = /datum/physiology_modifier

	/// our name
	var/name
	/// is this a globally cached modifier?
	var/is_globally_cached = FALSE

	// todo: on biologies update, we need to specify what biologies this applies to

	//? global modifiers
	var/carry_strength_add
	var/carry_factor_mult

/**
 * subtype for hardcoded physiology modifiers
 */
/datum/physiology_modifier/intrinsic
	abstract_type = /datum/physiology_modifier/intrinsic

/**
 * subtype for admin varedit tracking
 */
/datum/physiology_modifier/varedit

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
	physiology.ownership = src
	for(var/datum/physiology_modifier/modifier as anything in physiology_modifiers)
		if(!istype(modifier))
			physiology_modifiers -= modifier
			continue
		physiology.apply(modifier)

/mob/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(null, "-----")
	VV_DROPDOWN_OPTION(VV_HK_ADD_PHYSIOLOGY_MODIFIER, "Add PHysiology Modifier")
	VV_DROPDOWN_OPTION(VV_HK_REMOVE_PHYSIOLOGY_MODIFIER, "Remove PHysiology Modifier")

/mob/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_ADD_PHYSIOLOGY_MODIFIER])
		#warn impl
	if(href_list[VV_HK_REMOVE_PHYSIOLOGY_MODIFIER])
		#warn impl

/mob/proc/get_varedit_physiology_modifier()
	RETURN_TYPE(/datum/physiology_modifier)
	. = locate(/datum/physiology_modifier/varedit) in physiology_modifiers
	if(!isnull(.))
		return
	var/datum/physiology_modifier/varedit/new_holder = new
	add_physiology_modifier(new_holder)
	return new_holder
