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

	/// carry baseline modify
	var/carry_strength = CARRY_STRENGTH_BASELINE
	/// carry penalty modifier
	var/carry_factor = CARRY_FACTOR_BASELINE
	/// carry bias modify
	var/carry_bias = 1
	/// carry weight add - added to carry_strength for carry weight only, not encumbrance.
	var/carry_weight_add = 0
	/// carry weight factor - multiplied to carry_factor for carry weight only, not encumbrance.
	var/carry_weight_factor = 1
	/// carry weight bias - multipled to carry_bias for carry weight only, not encumbrance
	var/carry_weight_bias = 1

/datum/global_physiology/Destroy()
	ownership = null
	return ..()

/datum/global_physiology/proc/reset()
	carry_strength = initial(carry_strength)
	carry_factor = initial(carry_factor)
	carry_weight_add = initial(carry_weight_add)
	carry_weight_factor = initial(carry_weight_factor)
	carry_bias = initial(carry_bias)
	carry_weight_bias = initial(carry_weight_bias)

/datum/global_physiology/proc/apply(datum/physiology_modifier/modifier)
	if(!isnull(modifier.carry_strength_add))
		carry_strength += modifier.carry_strength_add
	if(!isnull(modifier.carry_strength_factor))
		carry_factor *= modifier.carry_strength_factor
	if(!isnull(modifier.carry_weight_add))
		carry_weight_add += modifier.carry_weight_add
	if(!isnull(modifier.carry_weight_factor))
		carry_weight_factor *= modifier.carry_weight_factor
	if(!isnull(modifier.carry_strength_bias))
		carry_bias *= modifier.carry_strength_bias
	if(!isnull(modifier.carry_weight_bias))
		carry_weight_bias *= modifier.carry_weight_bias

/**
 * return FALSE if we need to reset due to non-canonical operations
 */
/datum/global_physiology/proc/revert(datum/physiology_modifier/modifier)
	. = TRUE
	if(!isnull(modifier.carry_strength_add))
		carry_strength -= modifier.carry_strength_add
	if(!isnull(modifier.carry_strength_factor))
		carry_factor /= modifier.carry_strength_factor
	if(!isnull(modifier.carry_weight_add))
		carry_weight_add -= modifier.carry_weight_add
	if(!isnull(modifier.carry_weight_factor))
		carry_weight_factor /= modifier.carry_weight_factor
	if(!isnull(modifier.carry_strength_bias))
		carry_bias /= modifier.carry_strength_bias
	if(!isnull(modifier.carry_weight_bias))
		carry_weight_bias /= modifier.carry_weight_bias

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
			varedit_modifier.carry_strength_factor = var_value / carry_factor
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
	var/name = "Some Modifier"
	/// is this a globally cached modifier?
	var/is_globally_cached = FALSE

	// todo: on biologies update, we need to specify what biologies this applies to

	//? global modifiers
	var/carry_strength_add = 0
	var/carry_strength_factor = 1
	var/carry_strength_bias = 1
	var/carry_weight_add = 0
	var/carry_weight_factor = 1
	var/carry_weight_bias = 1

/datum/physiology_modifier/serialize()
	. = ..()
	if(name != initial(name))
		.["name"] = name
	if(carry_strength_add != initial(carry_strength_add))
		.["carry_strength_add"] = carry_strength_add
	if(carry_strength_factor != initial(carry_strength_factor))
		.["carry_strength_factor"] = carry_strength_factor

/datum/physiology_modifier/deserialize(list/data)
	. = ..()
	if(istext(data["name"]))
		name = data["name"]
	if(isnum(data["carry_strength_add"]))
		carry_strength_add = data["carry_strength_add"]
	if(isnum(data["carry_strength_factor"]))
		carry_strength_factor = data["carry_strength_factor"]
	if(isnum(data["carry_strength_bias"]))
		carry_strength_bias = data["carry_strength_bias"]
	if(isnum(data["carry_weight_add"]))
		carry_weight_add = data["carry_weight_add"]
	if(isnum(data["carry_weight_factor"]))
		carry_weight_factor = data["carry_weight_factor"]
	if(isnum(data["carry_weight_bias"]))
		carry_weight_bias = data["carry_Weight_bias"]

/**
 * subtype for hardcoded physiology modifiers
 */
/datum/physiology_modifier/intrinsic
	abstract_type = /datum/physiology_modifier/intrinsic

/**
 * subtype for admin varedit tracking
 */
/datum/physiology_modifier/varedit
	name = "Admin Varedits"

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
	LAZYADD(physiology_modifiers, modifier)
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
	LAZYREMOVE(physiology_modifiers, modifier)
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
	VV_DROPDOWN_OPTION(VV_HK_ADD_PHYSIOLOGY_MODIFIER, "Add Physiology Modifier")
	VV_DROPDOWN_OPTION(VV_HK_REMOVE_PHYSIOLOGY_MODIFIER, "Remove Physiology Modifier")

/mob/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_ADD_PHYSIOLOGY_MODIFIER])
		// todo: this should be able to be done globally via admin panel and then added to mobs

		var/datum/tgui_dynamic_query/query = new
		query.string("name", "Name", "Name your modifier.", 64, FALSE, "Custom Modifier")
		query.number("carry_strength_add", "Carry Strength - Add", "Modify the person's base carry strength. Higher is better.", default = 0)
		query.number("carry_strength_factor", "Carry Factor - Multiply", "Multiply the person's carry weight/encumbrance to slowdown effect when carrying over their limit. Lower is better.", default = 1)
		query.number("carry_strength_bias", "Carry Bias - Multiply", "Multiply the person's carry weight/encumbrance to slowdown bias when carrying over their limit. Lower is better.", default = 1)
		query.number("carry_weight_add", "Carry Weight - Add", "Modify the person's base carry weight. Higher is better. This only applies to weight, not encumbrance.", default = 0)
		query.number("carry_weight_factor", "Carry Weight - Multiply", "Multiply the person's weight to slowdown effect when carrying over their limit. Lower is better. This only applies to weight, not encumbrance.", default = 1)
		query.number("carry_weight_bias", "Carry Weight - Bias", "Multiply the person's weight to slowdown calculation bias; lower is better.", default = 1)

		var/list/choices = tgui_dynamic_input(usr, "Add a physiology modifier", "Add Physiology Modifier", query)

		if(isnull(choices))
			return
		if(QDELETED(src))
			return

		var/datum/physiology_modifier/modifier = new

		// we manually deserialize because we might have custom datatypes
		// in the future that won't be serialized by the ui necessarily in the same way
		// we would serialize it via json.

		modifier.name = choices["name"]
		modifier.carry_strength_add = choices["carry_strength_add"]
		modifier.carry_strength_factor = choices["carry_strength_factor"]
		modifier.carry_strength_bias = choices["carry_strength_bias"]
		modifier.carry_weight_add = choices["carry_weight_add"]
		modifier.carry_weight_factor = choices["carry_weight_factor"]
		modifier.carry_weight_bias = choices["carry_weight_bias"]

		log_admin("[key_name(usr)] --> [key_name(src)] - added physiology modifier [json_encode(modifier.serialize())]")
		add_physiology_modifier(modifier)
		return TRUE

	if(href_list[VV_HK_REMOVE_PHYSIOLOGY_MODIFIER])
		var/list/assembled = list()
		var/i = 0
		for(var/datum/physiology_modifier/modifier as anything in physiology_modifiers)
			assembled["[modifier.name] (#[++i])"] = modifier
		var/picked = input(usr, "Which modifier to remove? Please do not do this unless you know what you are doing.", "Remove Physiology Modifier") as null|anything in assembled
		var/datum/physiology_modifier/removing = assembled[picked]
		if(!(removing in physiology_modifiers))
			return TRUE
		log_admin("[key_name(usr)] --> [key_name(src)] - removed physiology modifier [json_encode(removing.serialize())]")
		remove_physiology_modifier(removing)
		return TRUE

/mob/proc/get_varedit_physiology_modifier()
	RETURN_TYPE(/datum/physiology_modifier)
	. = locate(/datum/physiology_modifier/varedit) in physiology_modifiers
	if(!isnull(.))
		return
	var/datum/physiology_modifier/varedit/new_holder = new
	add_physiology_modifier(new_holder)
	return new_holder
