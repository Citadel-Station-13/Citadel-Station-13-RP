/proc/cmp_chemical_reaction_priority(datum/chemical_reaction/A, datum/chemical_reaction/B)
	return B.priority - A.priority

/datum/chemical_reaction
	abstract_type = /datum/chemical_reaction

	//* core *//
	/// id - must be unique and in CamelCase.
	var/id
	/// reagent reaction flags - see [code/__DEFINES/reagents/flags.dm]
	var/chemical_reaction_flags = NONE
	/// ignore all collision checks
	///
	/// * THIS IS EXPLICITLY ONLY FOR FOOD UNTIL WE REWORK THEM TO NOT COLLIDE.
	///   YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO USE THIS ANYWHERE ELSE.
	var/___legacy_allow_collision_do_not_use = FALSE

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

	//* reaction *//
	/// required reagents as ratios. path or id is supported, prefer paths for compile time checking.
	/// all of these will then make 1 unit of the reagent.
	var/list/required_reagents = list()
	/// cached: total volume of all required reagents for a single unit-multiplier (every 1 multiplier basically) reacted
	var/tmp/required_reagents_unit_volume
	/// require whole numbers of all reagents taken
	///
	/// * has no effect on ticked (non-instant) reactions
	/// * this actually just ensures reaction multiplier is a whole number.
	var/require_whole_numbers = FALSE

	/// result reagent path or id. prefer path for compile time checking.
	///
	/// * It is allowed to have this set without a result_amount.
	var/result
	/// how much of the result is made per 1 ratio of required_reagents consumed.
	///
	/// * If this is 0, multiplier / calculations still work; we just won't make any result reagents. Useful for pyrotechnics.
	/// * It is undefined behavior to have this be non-zero and still have a result defined.
	var/result_amount = 0

	/// priority - higher is checked first when reacting.
	var/priority = 0

	/// required container typepath of holder my_atom
	var/required_container_path

	/// temperature minimum, kelvin
	var/temperature_low = TCMB
	/// temperature maximum, kelvin
	var/temperature_high = INFINITY

	/// deciseconds to react half of the remaining amount.
	/// used in some bullshit complex math to determine actual reaction rate
	/// 0 for instant
	var/reaction_half_life = 0 SECONDS
	/// when total reactant volume is under this for reaction, don't care about half life and finish the rest
	///
	/// * has no effect on instant reactions
	var/reaction_completion_threshold = 0.2

	/// moderators: reagent ids or paths to number to determine how much it speeds reaction
	///
	/// todo: rework this
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
	/// todo: rework this
	///
	/// * id or path allowed; prefer path for compile-time checking.
	/// * this is null'd after New(); it's automatically merged into moderators.
	var/list/inhibitors
	/// catalysts: reagent ids or paths
	///
	/// todo: rework this
	///
	/// * these are required reagents to perform the reaction
	/// * associate to amounts; default 0
	var/list/catalysts

	/// equilibrium constant
	///
	/// * has no effect on instant reactions
	/// * makes no sense on reactions without a product
	/// * overrules reaction_completion_threshold!
	/// * absolute; will not be overridden by anything, including catalysts / positive-moderators
	///
	/// Examples:
	///
	/// * INFINITY = go to completion
	/// * 0 = don't fucking do this it'll runtime
	/// * 10 = 10 times the products as reactants
	///
	/// todo: reactions being able to go in reverse once reaching equilibrium
	var/equilibrium = INFINITY

	/**
	 * Perform data calculations. This is semi-expensive.
	 */
	var/has_data_semantics = FALSE

	//* Reaction - Feedback *//
	/// if set, everyone around sees this on react
	var/reaction_message_instant = "The solution begins to bubble."
	/// if set, everyone around hears this on react
	var/reaction_sound_instant = 'sound/effects/bubbles.ogg'
	// todo: soundloop support? maybe ambience subsystem for deduping..

	//* guidebook *//
	/// guidebook flags
	var/reaction_guidebook_flags = NONE
	/// guidebook category
	var/reaction_guidebook_category = "Unsorted"

/datum/chemical_reaction/New()
	resolve()
	generate()

/**
 * Expand convenient compile-time stuff to the real IDs.
 */
/datum/chemical_reaction/proc/resolve()
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
	if(inhibitors)
		LAZYINITLIST(moderators)
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

/**
 * Generate our metadata.
 */
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

	required_reagents_unit_volume = 0
	for(var/id in required_reagents)
		required_reagents_unit_volume += required_reagents[id]

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
			if(holder.reagent_volumes?[reagent] < required_reagents[reagent])
				return FALSE
	else
		for(var/reagent in required_reagents)
			if(holder.reagent_volumes?[reagent] <= 0)
				return FALSE

	// ensure catalysts are there
	for(var/reagent in catalysts)
		var/catalyst_amount = holder.reagent_volumes?[reagent]
		if(isnull(catalyst_amount) || (catalyst_amount < catalysts[reagent]))
			return FALSE
	// check for stuff that will halt it
	for(var/reagent in moderators)
		var/power = moderators[reagent]
		// not a halting moderator
		if(power < SHORT_REAL_LIMIT)
			continue
		var/moderator_amount = holder.reagent_volumes?[reagent]
		if(!isnull(moderator_amount))
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
	return can_proceed_reaction(holder)

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
	return TRUE

//* Data *//

/**
 * Performs data calculations for the data **initializer** to give to the result.
 *
 * * Only called if `has_data_semantics` is on.
 *
 * @params
 * * holder - source holder
 * * multiplier - reaction multiplier
 */
/datum/chemical_reaction/proc/compute_result_data_initializer(datum/reagent_holder/holder, multiplier)
	return

//* Queries *//

/**
 * Get inhibitors
 */
/datum/chemical_reaction/proc/get_inhibitors() as /list
	. = list()
	for(var/id in moderators)
		if(moderators[id] >= SHORT_REAL_LIMIT)
			. += id

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
	var/atom/container = holder.my_atom
	if(container)
		if(reaction_message_instant)
			container.visible_message(SPAN_NOTICE(reaction_message_instant))
		if(reaction_sound_instant)
			playsound(container, reaction_sound_instant, 75, TRUE)

//* Reaction Modulation *//

/**
 * @return new half life, or null to halt
 */
/datum/chemical_reaction/proc/temperature_modulation(current_half_life, temperature)
	if(temperature < temperature_low || temperature > temperature_high)
		return null
	return current_half_life
