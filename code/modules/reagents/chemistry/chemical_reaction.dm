/proc/cmp_chemical_reaction_priority(datum/chemical_reaction/A, datum/chemical_reaction/B)
	return B.priority - A.priority

/datum/chemical_reaction
	abstract_type = /datum/chemical_reaction
	//* core *//

	/// id - must be unique and in CamelCase.
	var/id
	/// reagent reaction flags - see [code/__DEFINES/reagents/flags.dm]
	var/chemical_reaction_flags = NONE

	//* identity *//

	/// name; defaults to reagent produced's name.
	/// if this is defaulted, it also defaults display name to that reagent if unset.
	var/name
	/// description, if any; defaults to reagent produced's desc
	/// if this is defaulted, it also defaults display desc to that reagent if unset.
	var/desc
	/// display name; overrides name when player facing if set
	var/display_name
	/// display description; overrides desc when player facing if set
	var/display_description

	//* logging *//

	/// we should care enough about this to log it specifically
	var/important_for_logging = FALSE
	#warn impl

	//* reaction *//

	/// required reagents as ratios. path or id is supported, prefer paths for compile time checking.
	/// all of these will then make 1 unit of the reagent.
	var/list/required_reagents = list()
	/// require whole numbers of all reagents taken
	///
	/// * has no effect on ticked (non-instant) reactions
	/// * this actually just ensures reaction multiplier is a whole number.
	var/require_whole_numbers = TRUE

	/// result reagent path or id. prefer path for compile time checking.
	var/result
	/// how much of the result is made per 1 ratio of required_reagents consumed.
	///
	/// * If this is 0, multiplier / calculations still work; we just won't make any result reagents. Useful for pyrotechnics.
	var/result_amount = 0

	/// priority - higher is checked first when reacting.
	var/priority = 0

	/// required container typepath of holder my_atom
	var/required_container_path

	/// temperature minimum, kelvin
	var/temperature_low
	/// temperature maximum, kelvin
	var/temperature_high

	/// pH minimum
	var/ph_low
	/// pH maximum
	var/ph_high

	/// deciseconds to react half of the remaining amount.
	/// used in some bullshit complex math to determine actual reaction rate
	/// 0 for instant
	var/reaction_half_life = 0
	#warn half_life
	/// when total reactant volume is under this for reaction, don't care about half life and finish the rest
	///
	/// * has no effect on instant reactions
	var/reaction_completion_threshold = 0.2
	#warn half_life_instant_volume

	/// moderators: reagent ids or paths to number to determine how much it speeds reaction
	///
	/// * has no effect on instant reactions, other than being able to inhibit them if the moderation rate is too high.
	///
	/// number is multiplied to half life to get actual speed.
	///
	/// * > 1 will slow reaction
	/// * < 1, but not 0 will speed reaction
	/// * 0 will make reaction instant
	/// * INFINITY will completely inhibit the reaction.
	var/list/moderators
	/// inhibitors: basically, INFINITY multiplier moderators. this is here to make the code cleaner.
	///
	/// * id or path allowed; prefer path for compile-time checking.
	/// * this is null'd after New(); it's automatically merged into moderators.
	var/list/inhibitors
	/// catalysts: reagent ids or paths
	///
	/// * these are required reagents to perform the reaction
	/// * associate to amounts; default 0
	var/list/catalysts

	/// equilibrium point; less than 1, reaction will be inhibited if ratio of product to reactant is above that
	///
	/// * has no effect on instant reactions
	/// * makes no sense on reactions without a product
	/// * overrules reaction_completion_threshold!
	///
	/// Examples:
	///
	/// * 0.5 = we stop when product == reactant volume
	/// * 0.8 = we stop when product == 4 times reactant volume
	/// * 0.9 = we stop when product == 9 times reactant volume
	///
	/// todo: reactions being able to go in reverse once reaching equilibrium
	var/equilibrium = 1

	//* guidebook *//

	/// guidebook flags
	var/reaction_guidebook_flags = NONE
	/// guidebook category
	var/reaction_guidebook_category = "Unsorted"

	//? legacy / unsorted
	var/mix_message = "The solution begins to bubble."
	var/reaction_sound = 'sound/effects/bubbles.ogg'

/datum/chemical_reaction/New()
	resolve_paths()
	generate()

/datum/chemical_reaction/proc/resolve_paths()
	// resolve ingredients
	for(var/i in 1 to length(required_reagents))
		var/datum/reagent/path = required_reagents[i]
		if(!ispath(path))
			continue
		var/amt = required_reagents[path]
		var/id = initial(path.id)
		required_reagents[i] = id
		required_reagents[id] = amt
	// resolve catalysts
	for(var/i in 1 to length(catalysts))
		var/datum/reagent/path = catalysts[i]
		if(!ispath(path))
			continue
		var/amt = catalysts[path]
		var/id = initial(path.id)
		catalysts[i] = id
		catalysts[id] = amt
	// merge inhibitors
	for(var/i in 1 to length(inhibitors))
		moderators[inhibitors[i]] = INFINITY
	inhibitors = null
	// resolve moderators
	for(var/i in 1 to length(moderators))
		var/datum/reagent/path = moderators[i]
		if(!ispath(path))
			continue
		var/amt = moderators[path]
		var/id = initial(path.id)
		moderators[i] = id
		moderators[id] = amt
	// resolve product
	if(ispath(result, /datum/reagent))
		var/datum/reagent/result_initial = result
		result = initial(result_initial.id)

/datum/chemical_reaction/proc/generate()
	var/datum/reagent/resolved = SSchemistry.fetch_reagent(result)
	if(isnull(name))
		name = resolved?.name || "???"
		if(isnull(display_name) && !isnull(resolved))
			display_name = resolved.display_name

	if(isnull(desc))
		desc = resolved?.description || "Unknown Description - contact coders."
		if(isnull(display_description) && !isnull(resolved))
			display_description = resolved.display_description

//called after processing reactions, if they occurred
/datum/chemical_reaction/proc/post_reaction(datum/reagent_holder/holder)
	SHOULD_NOT_OVERRIDE(TRUE)
	#warn kill
	var/atom/container = holder.my_atom
	if(mix_message && container && !ismob(container))
		var/turf/T = get_turf(container)
		var/list/seen = viewers(4, T)
		for(var/mob/M in seen)
			M.show_message("<span class='notice'>[icon2html(thing = container, target = M)] [mix_message]</span>", 1)
		playsound(T, reaction_sound, 80, 1)

#warn above

//obtains any special data that will be provided to the reaction products
//this is called just before reactants are removed.
// todo: rework data system
/datum/chemical_reaction/proc/send_data(datum/reagent_holder/holder, reaction_limit)
	return null

//* Guidebook *//

/**
 * Guidebook Data for TGUIGuidebookReaction
 */
/datum/chemical_reaction/proc/tgui_guidebook_data()
	return list(
		"name" = display_name || name,
		"desc" = display_description || desc,
		"category" = reaction_guidebook_category,
		"id" = id,
		"flags" = NONE,
		"guidebookFlags" = reaction_guidebook_flags,
		// below are stubbed and overridden on subtypes
		// todo: why is this the case?
		"alcoholStrength" = null,
	)

//* Checks *//

/**
 * Checks if we can happen in a given container. Checks everything.
 *
 * * Unlike 'can_start_reaction' and 'can_proceed_reaction', this is meant to be able to be called
 *   externally, rather than just by the reaction loop.
 * * This proc is more expensive than what would usually be called in the reaction loop.
 * * Therefore, this proc will check for reagents.
 *
 * Checks:
 * * Reagents, catalysts, moderators
 * * Everything in 'can_start_reaction'
 */
/datum/chemical_reaction/proc/can_happen(datum/reagent_holder/holder)
	// as an external proc, you should not need to override this
	// without overriding can_start_reaction or can_proceed_reaction.
	SHOULD_NOT_OVERRIDE(TRUE)

	// check requirements, if it's whole numbers required we need atleast multiplier = 1
	if(require_whole_numbers)
		for(var/reagent in required_reagents)
			if(holder.legacy_direct_access_reagent_amount(reagent) >= required_reagents[reagent])
				return FALSE
	else
		for(var/reagent in required_reagents)
			if(holder.legacy_direct_access_reagent_amount(reagent) <= 0)
				return FALSE

	// ensure catalysts are there
	for(var/reagent in catalysts)
		if(!holder.legacy_direct_access_reagent_amount(reagent) < catalysts[reagent])
			return FALSE
	// check for stuff that will halt it
	for(var/reagent in moderators)
		var/power = moderators[reagent]
		if(power >= SHORT_REAL_LIMIT && holder.legacy_direct_access_reagent_amount(reagent) >= 0)
			return FALSE

	return can_start_reaction(holder)

/**
 * Can we happen in a given container? Checks only some things.
 *
 * Checks:
 * * Container path
 * * Everything in 'can_proceed_reaction'
 */
/datum/chemical_reaction/proc/can_start_reaction(datum/reagent_holder/holder)
	if(required_container_path && !istype(holder.my_atom, required_container_path))
		return FALSE
	return can_proceed(holder)

/**
 * Can we proceed in a given container? Only checks some specific things.
 *
 * Checks:
 * * Temperature
 * * pH
 */
/datum/chemical_reaction/proc/can_proceed_reaction(datum/reagent_holder/holder)
	if(holder.temperature < temperature_low || holder.temperature > temperature_high)
		return FALSE
	if(holder.ph < ph_low || holder.ph > ph_high)
		return FALSE
	return TRUE

//* Reaction Hooks *//

/**
 * on reaction start
 *
 * * do `var/list/blackboard = holder.active_reactions[src]` to access our blackboard list.
 * * blackboard is a list preserved through a given start-end cycle of a reaction, for that specific reaction
 * * accessing other reactions' blackboards, while allowed, is expressly discouraged.
 */
/datum/chemical_reaction/proc/on_reaction_start(datum/reagent_holder/holder)
	return

/**
 * on reaction tick
 *
 * * do `var/list/blackboard = holder.active_reactions[src]` to access our blackboard list.
 * * blackboard is a list preserved through a given start-end cycle of a reaction, for that specific reaction
 * * accessing other reactions' blackboards, while allowed, is expressly discouraged.
 *
 * @params
 * * holder - the reacting holder
 * * delta_time - elapsed time in seconds
 * * multiplier - multiples of result_amount made. 2 on a 1u result is 2u, 2 on a 2u result is 4, etc.
 */
/datum/chemical_reaction/proc/on_reaction_tick(datum/reagent_holder/holder, delta_time, multiplier)
	return

/**
 * on reaction finish
 *
 * * do `var/list/blackboard = holder.active_reactions[src]` to access our blackboard list.
 * * blackboard is a list preserved through a given start-end cycle of a reaction, for that specific reaction
 * * accessing other reactions' blackboards, while allowed, is expressly discouraged.
 */
/datum/chemical_reaction/proc/on_reaction_finish(datum/reagent_holder/holder)
	return

/**
 * called on completion of instant reaction
 *
 * @params
 * * holder - the reacting holder
 * * multiplier - multiples of result_amount made. 2 on a 1u result is 2u, 2 on a 2u result is 4, etc.
 */
/datum/chemical_reaction/proc/on_reaction_instant(datum/reagent_holder/holder, multiplier)
	return

#warn impl all

//* Reaction Modulation *//

/**
 * @return new half life, or null to halt
 */
/datum/chemical_reaction/proc/temperature_modulation(current_half_life, temperature)
	if(temperature < reaction.temperature_low || temperature > reaction.temperature_high)
		return null
	return current_half_life
