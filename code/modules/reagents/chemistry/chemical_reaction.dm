/proc/cmp_chemical_reaction_priority(datum/chemical_reaction/A, datum/chemical_reaction/B)
	return B.priority - A.priority

/datum/chemical_reaction
	abstract_type = /datum/chemical_reaction

	//* core *//
	
	/// id - must be unique and in CamelCase.
	var/id
	/// reagent reaction flags - see [code/__DEFINES/reagents/flags.dm]
	var/chemical_reaction_flags = NONE

	//* guidebook *//

	/// guidebook flags
	var/reaction_guidebook_flags = NONE
	/// guidebook category
	var/reaction_guidebook_category = "Unsorted"

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

	//* reaction *//

	/// required reagents as ratios. path or id is supported, prefer paths for compile time checking.
	/// all of these will then make 1 unit of the reagent.
	var/list/required_reagents = list()

	/// require whole numbers of all reagents taken
	var/require_whole_numbers = TRUE

	/// result reagent path or id. prefer path for compile time checking.
	var/result
	/// how much of the result is made per 1 ratio of required_reagents consumed.
	var/result_amount = 0

	/// priority - higher is checked first when reacting.
	var/priority = 0
	
	/// required container typepath of holder my_atom
	var/required_container

	/// temperature minimum, kelvin
	var/temperature_low 
	/// temperature maximum, kelvin
	var/temperature_high

	/// deciseconds to react half of the remaining amount.
	/// used in some bullshit complex math to determine actual reaction rate
	/// 0 for instant
	var/reaction_half_life = 0

	/// moderators: reagent ids to number to determine how much it speeds reaction
	///
	/// number is multiplied to half life to get actual speed
	/// * > 1 will slow reaction
	/// * < 0, but not 0 will speed reaction
	/// * 0 will make reaction instant
	/// * INFINITY will completely inhibit the reaction.
	var/list/moderators
	/// catalysts: reagent ids
	///
	/// these are required reagents to perform the reaction
	var/list/catalysts
	
	/// equilibrium point; less than 1, reaction will be inhibited if ratio of product to reactant is above that
	/// 0.5 = we stop when product == reactant volume
	/// 0.8 = we stop when product == 4 times reactant volume
	/// 0.9 = we stop when product == 9 times reactant volume
	var/equilibrium = 1

	//? legacy / unsorted

	var/mix_message = "The solution begins to bubble."
	var/reaction_sound = 'sound/effects/bubbles.ogg'

/datum/chemical_reaction/New()
	resolve_paths()
	generate()

//* Init *//

/datum/chemical_reaction/proc/resolve_paths()
	for(var/i in 1 to length(required_reagents))
		var/datum/reagent/path = required_reagents[i]
		if(!ispath(path))
			continue
		var/amt = required_reagents[path]
		var/id = initial(path.id)
		required_reagents[i] = id
		required_reagents[id] = amt
	for(var/i in 1 to length(catalysts))
		var/datum/reagent/path = catalysts[i]
		if(!ispath(path))
			continue
		var/amt = catalysts[path]
		var/id = initial(path.id)
		catalysts[i] = id
		catalysts[id] = amt
	for(var/i in 1 to length(inhibitors))
		var/datum/reagent/path = inhibitors[i]
		if(!ispath(path))
			continue
		var/amt = inhibitors[path]
		var/id = initial(path.id)
		inhibitors[i] = id
		inhibitors[id] = amt
	if(ispath(result, /datum/reagent))
		var/datum/reagent/result_initial = result
		result = initial(result_initial.id)

/datum/chemical_reaction/proc/generate()
	var/datum/reagent/resolved = SSchemistry.get_reagent(result)
	if(isnull(name))
		name = resolved?.name || "???"
		if(isnull(display_name) && !isnull(resolved))
			display_name = resolved.display_name

	if(isnull(desc))
		desc = resolved?.description || "Unknown Description - contact coders."
		if(isnull(display_description) && !isnull(resolved))
			display_description = resolved.display_description

//* Checks *//

/datum/chemical_reaction/proc/can_happen(datum/reagent_holder/holder)
	// check container
	if(!isnull(required_container) && !istype(holder.my_atom, required_container))
		return FALSE
	
	var/maximum_ratio = INFINITY
	if(require_whole_numbers)
		for(var/id in required_reagents)
			maximum_ratio = min(maximum_ratio, holder.reagent_volumes[id] / required_reagents[id])
			if(!maximum_ratio)
				return FALSE
		if(maximum_ratio < 1)
			return FALSE
	else
		for(var/id in required_reagents)
			if(holder.reagent_volumes[id])
				continue
			return FALSE
	
	#warn check rest

#warn below

//! legacy below

/datum/chemical_reaction/proc/can_happen(datum/reagent_holder/holder)

	//check that all the required catalysts are present in the required amount
	if(!holder.has_all_reagents(catalysts))
		return 0

	//check that none of the inhibitors are present in the required amount
	if(holder.has_any_reagent(inhibitors))
		return 0

	return 1

/datum/chemical_reaction/proc/calc_reaction_progress(datum/reagent_holder/holder, reaction_limit)
	var/progress = reaction_limit * reaction_rate //simple exponential progression

	//calculate yield
	if(1-yield > 0.001) //if yield ratio is big enough just assume it goes to completion
		/*
			Determine the max amount of product by applying the yield condition:
			(max_product/result_amount) / reaction_limit == yield/(1-yield)

			We make use of the fact that:
			reaction_limit = (holder.get_reagent_amount(reactant) / required_reagents[reactant]) of the limiting reagent.
		*/
		var/yield_ratio = yield/(1-yield)
		var/max_product = yield_ratio * reaction_limit * result_amount //rearrange to obtain max_product
		var/yield_limit = max(0, max_product - holder.get_reagent_amount(result))/result_amount

		progress = min(progress, yield_limit) //apply yield limit

	//apply min reaction progress - wasn't sure if this should go before or after applying yield
	//I guess people can just have their miniscule reactions go to completion regardless of yield.
	for(var/reactant in required_reagents)
		var/remainder = holder.get_reagent_amount(reactant) - progress*required_reagents[reactant]
		if(remainder <= min_reaction*required_reagents[reactant])
			progress = reaction_limit
			break

	return progress

/datum/chemical_reaction/process(datum/reagent_holder/holder)
	//determine how far the reaction can proceed
	var/list/reaction_limits = list()
	for(var/reactant in required_reagents)
		reaction_limits += holder.get_reagent_amount(reactant) / required_reagents[reactant]

	//determine how far the reaction proceeds
	var/reaction_limit = min(reaction_limits)
	var/progress_limit = calc_reaction_progress(holder, reaction_limit)

	var/reaction_progress = min(reaction_limit, progress_limit) //no matter what, the reaction progress cannot exceed the stoichiometric limit.

	//need to obtain the new reagent's data before anything is altered
	var/data = send_data(holder, reaction_progress)

	//remove the reactants
	for(var/reactant in required_reagents)
		var/amt_used = required_reagents[reactant] * reaction_progress
		holder.remove_reagent(reactant, amt_used, safety = 1)

	//add the product
	var/amt_produced = result_amount * reaction_progress
	if(result)
		holder.add_reagent(result, amt_produced, data, safety = 1)

	on_reaction(holder, amt_produced)

	return reaction_progress

//called when a reaction processes
/datum/chemical_reaction/proc/on_reaction(datum/reagent_holder/holder, created_volume)
	return

//called after processing reactions, if they occurred
/datum/chemical_reaction/proc/post_reaction(datum/reagent_holder/holder)
	var/atom/container = holder.my_atom
	if(mix_message && container && !ismob(container))
		var/turf/T = get_turf(container)
		var/list/seen = viewers(4, T)
		for(var/mob/M in seen)
			M.show_message("<span class='notice'>[icon2html(thing = container, target = M)] [mix_message]</span>", 1)
		playsound(T, reaction_sound, 80, 1)

//obtains any special data that will be provided to the reaction products
//this is called just before reactants are removed.
/datum/chemical_reaction/proc/send_data(datum/reagent_holder/holder, reaction_limit)
	return null

#warn uhh above?

//* Guidebook

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
