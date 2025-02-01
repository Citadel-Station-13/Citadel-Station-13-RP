/datum/reagent_holder
	//* Core *//

	/// reagent holder flags - see [code/__DEFINES/reagents/flags.dm]
	var/reagent_holder_flags = NONE

	//* Reactions *//

	/// active reactions
	///
	/// * instant reactions will never be added to this
	/// * lazy list
	/// * reaction datums are associated to their blackboard lists
	var/list/datum/chemical_reaction/active_reactions

	//* Reagents *//

	/// Our temperature
	var/temperature = T20C

	///? legacy / unsorted
	// todo: 3 lists, for volume, data, flags; data should always be a list.
	var/list/datum/reagent/reagent_list = list()
	var/total_volume = 0
	var/maximum_volume = 100

	var/atom/my_atom = null
	// todo: remove / refactor this var into reagent_holder_flags with proper defines, this was never ported properly.
	var/reagents_holder_flags

/datum/reagent_holder/New(max = 100, atom/A = null, new_flags = NONE)
	..()
	maximum_volume = max
	my_atom = A
	reagents_holder_flags = new_flags

/datum/reagent_holder/Destroy()
	if(reagent_holder_flags & REAGENT_HOLDER_FLAG_CURRENTLY_REACTING)
		stop_reacting()

	for(var/datum/reagent/R in reagent_list)
		qdel(R)
	reagent_list = null
	if(my_atom && my_atom.reagents == src)
		my_atom.reagents = null
	return ..()

// Used in attack logs for reagents in pills and such
/datum/reagent_holder/proc/log_list()
	if(!length(reagent_list))
		return "no reagents"

	var/list/data = list()
	for(var/r in reagent_list) //no reagents will be left behind
		var/datum/reagent/R = r
		data += "[R.type] [R.volume]u)"
		//Using IDs because SOME chemicals (I'm looking at you, chlorhydrate-beer) have the same names as other chemicals.
	return english_list(data)

/* Internal procs */

/datum/reagent_holder/proc/get_master_reagent() // Returns reference to the reagent with the biggest volume.
	var/the_reagent = null
	var/the_volume = 0

	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_reagent = A

	return the_reagent

/datum/reagent_holder/proc/get_master_reagent_name() // Returns the name of the reagent with the biggest volume.
	var/the_name = null
	var/the_volume = 0
	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_name = A.name

	return the_name

/datum/reagent_holder/proc/get_master_reagent_id() // Returns the id of the reagent with the biggest volume.
	var/the_id = null
	var/the_volume = 0
	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_id = A.id

	return the_id

/datum/reagent_holder/proc/update_total() // Updates volume.
	total_volume = 0
	for(var/datum/reagent/R in reagent_list)
		if(R.volume < MINIMUM_CHEMICAL_VOLUME)
			del_reagent_impl(R)
		else
			total_volume += R.volume

/datum/reagent_holder/proc/holder_full()
	if(total_volume >= maximum_volume)
		return TRUE
	return FALSE

/* Holder-to-chemical */

/**
 * Core proc: Add a specific amount of a reagent.
 *
 * @parmas
 * * id - reagent ID. Typepaths are allowed too.
 * * amount - amount to add.
 * * data_initializer - data_initializer passed to relevant /datum/reagent procs when initializing data.
 * * skip_reactions - don't do reaction checks or similar.
 *
 * @return amount added
 */
/datum/reagent_holder/proc/add_reagent(id, amount, data_initializer, skip_reactions)
	if(ispath(id))
		var/datum/reagent/accessing = id
		id = initial(accessing.id)

	if(!isnum(amount) || amount <= 0)
		return 0

	// todo: rewrite this entire proc; especially data.

	update_total()
	amount = min(amount, available_volume())

	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			if(current.id == "blood")
				if(data_initializer && !isnull(data_initializer["species"]) && !isnull(current.data["species"]) && data_initializer["species"] != current.data["species"])	// Species bloodtypes are already incompatible, this just stops it from mixing into the one already in a container.
					continue

			current.volume += amount
			if(!isnull(data_initializer)) // For all we know, it could be zero or empty string and meaningful
				current.mix_data(src, current.data, current.volume, data_initializer, amount)
			update_total()
			if(!skip_reactions)
				try_reactions_for_reagent_change(id)
			if(my_atom)
				my_atom.on_reagent_change()
			return amount
	var/datum/reagent/D = SSchemistry.reagent_lookup[id]
	if(D)
		var/datum/reagent/R = new D.type()
		reagent_list += R
		R.holder = src
		R.volume = amount
		R.initialize_data(data_initializer)
		update_total()
		if(!skip_reactions)
			// todo: use the relevant reactions on add, instead of all relevant reactions, for speed
			try_reactions_for_reagent_change(id)
		if(my_atom)
			my_atom.on_reagent_change()
		return amount
	else
		stack_trace("[my_atom] attempted to add a reagent called '[id]' which doesn't exist. ([usr])")
	return 0

/datum/reagent_holder/proc/isolate_reagent(reagent)
	var/list/changed_ids = list()
	for(var/A in reagent_list)
		var/datum/reagent/R = A
		if(R.id != reagent)
			changed_ids[R.id] = TRUE
			del_reagent(R.id)
			update_total()
	try_reactions_for_reagents_changed(changed_ids)

/**
 * Core proc: Remove a specific amount of a reagent.
 *
 * @params
 * * id - reagent ID. Typepaths are allowed too.
 * * amount - amount to add.
 * * skip_reactions - don't do reaction checks or similar.
 *
 * @return amount removed
 */
/datum/reagent_holder/proc/remove_reagent(id, amount, skip_reactions)
	if(ispath(id))
		var/datum/reagent/path = id
		id = initial(path.id)
	if(!isnum(amount))
		return 0
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			amount = min(amount, current.volume)
			current.volume -= amount
			update_total()
			if(!skip_reactions)
				// todo: use the relevant reactions on remove, instead of all relevant reactions, for speed
				try_reactions_for_reagent_change(id)
			if(my_atom)
				my_atom.on_reagent_change()
			return amount
	return 0

/datum/reagent_holder/proc/del_reagent(id, skip_reactions)
	for(var/datum/reagent/current in reagent_list)
		if (current.id == id)
			del_reagent_impl(current)
			update_total()
			if(!skip_reactions)
				// todo: use the relevant reactions on remove, instead of all relevant reactions, for speed
				try_reactions_for_reagent_change(current.id)
			if(my_atom)
				my_atom.on_reagent_change()
			return 0

// todo: burn this shit with fire
/datum/reagent_holder/proc/del_reagent_impl(datum/reagent/reagent)
	if(!(reagent in reagent_list))
		return
	reagent_list -= reagent
	qdel(reagent)

/datum/reagent_holder/proc/clear_reagents(skip_reactions)
	for(var/datum/reagent/current in reagent_list)
		//*         telling del_reagent skip reactions is very very important                *//
		//  without it, if you have potassium, water, and something halting the explosion,    //
		//  you can have an explosion by clearing the beaker if it goes in the wrong order    //
		//  that and it's faster this way. do not touch this call!                            //
		del_reagent(current.id, TRUE)
	if(!skip_reactions)
		reconsider_reactions()

/datum/reagent_holder/proc/has_reagent(id, amount = 0)
	if(ispath(id))
		var/datum/reagent/path = id
		id = initial(path.id)
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			if(current.volume >= amount)
				return 1
			else
				return 0
	return 0

/datum/reagent_holder/proc/has_any_reagent(list/check_reagents)
	for(var/datum/reagent/current in reagent_list)
		if(current.id in check_reagents)
			if(current.volume >= check_reagents[current.id])
				return 1
			else
				return 0
	return 0

/datum/reagent_holder/proc/has_all_reagents(list/check_reagents, multiplier = 1)
	//this only works if check_reagents has no duplicate entries... hopefully okay since it expects an associative list
	var/missing = check_reagents.len
	for(var/datum/reagent/current in reagent_list)
		if(current.id in check_reagents)
			if(current.volume >= check_reagents[current.id] * multiplier)
				missing--
	return !missing

/datum/reagent_holder/proc/get_reagent(id)
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			return current

/datum/reagent_holder/proc/get_reagent_amount(id)
	if(ispath(id))
		var/datum/reagent/path = id
		id = initial(path.id)
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			return current.volume
	return 0

/datum/reagent_holder/proc/get_data(id)
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			return current.get_data()
	return 0

/datum/reagent_holder/proc/get_reagents()
	. = list()
	for(var/datum/reagent/current in reagent_list)
		. += "[current.id] ([current.volume])"
	return english_list(., "EMPTY", "", ", ", ", ")

/* Holder-to-holder and similar procs */

/datum/reagent_holder/proc/remove_any(amount = 1) // Removes up to [amount] of reagents from [src]. Returns actual amount removed.
	amount = min(amount, total_volume)

	if(!amount)
		return

	var/part = amount / total_volume

	for(var/datum/reagent/current in reagent_list)
		var/amount_to_remove = current.volume * part
		remove_reagent(current.id, amount_to_remove, 1)

	update_total()
	// todo: do we really need to update everything?
	reconsider_reactions()
	return amount

// Transfers [amount] reagents from [src] to [target], multiplying them by [multiplier].
// Returns actual amount removed from [src] (not amount transferred to [target]).
/datum/reagent_holder/proc/trans_to_holder(datum/reagent_holder/target, amount = 1, multiplier = 1, copy = 0)
	if(!target || !istype(target))
		return

	amount = max(0, min(amount, total_volume, target.available_volume() / multiplier))

	if(!amount)
		return

	var/part = amount / total_volume

	for(var/datum/reagent/current in reagent_list)
		var/amount_to_transfer = current.volume * part
		target.add_reagent(current.id, amount_to_transfer * multiplier, current.get_data(), TRUE)
		if(!copy)
			remove_reagent(current.id, amount_to_transfer, 1)

	// todo: do we really need to update everything?
	if(!copy)
		reconsider_reactions()
	target.reconsider_reactions()

	return amount

/* Holder-to-atom and similar procs */

/**
 * The general proc for applying reagents to things. This proc assumes the reagents are being applied externally,
 * not directly injected into the contents. It first calls touch, then the appropriate trans_to_*() or splash_mob().
 * If for some reason touch effects are bypassed (e.g. injecting stuff directly into a reagent container or person),
 * call the appropriate trans_to_*() proc.
 */
/datum/reagent_holder/proc/trans_to(atom/target, amount = 1, multiplier = 1, copy = 0)
	touch(target) //First, handle mere touch effects

	if(ismob(target))
		return splash_mob(target, amount, copy)
	if(isturf(target))
		return trans_to_turf(target, amount, multiplier, copy)
	if(isobj(target) && target.is_open_container())
		return trans_to_obj(target, amount, multiplier, copy)
	return 0

//Splashing reagents is messier than trans_to, the target's loc gets some of the reagents as well.
/datum/reagent_holder/proc/splash(atom/target, amount = 1, multiplier = 1, copy = 0, min_spill = 0, max_spill = 60)
	var/spill = 0
	if(!isturf(target) && target.loc)
		spill = amount*(rand(min_spill, max_spill)/100)
		amount -= spill
	if(spill)
		splash(target.loc, spill, multiplier, copy, min_spill, max_spill)

	trans_to(target, amount, multiplier, copy)

/datum/reagent_holder/proc/trans_id_to(atom/target, id, amount = 1)
	if (!target || !target.reagents)
		return

	amount = min(amount, get_reagent_amount(id), target.reagents.maximum_volume - target.reagents.total_volume)

	if(amount <= 0)
		return

	var/datum/reagent_holder/F = new /datum/reagent_holder(amount)
	var/tmpdata = get_data(id)
	F.add_reagent(id, amount, tmpdata)
	remove_reagent(id, amount)

	return F.trans_to(target, amount) // Let this proc check the atom's type

// When applying reagents to an atom externally, touch() is called to trigger any on-touch effects of the reagent.
// This does not handle transferring reagents to things.
// For example, splashing someone with water will get them wet and extinguish them if they are on fire,
// even if they are wearing an impermeable suit that prevents the reagents from contacting the skin.
/datum/reagent_holder/proc/touch(atom/target, amount)
	if(ismob(target))
		touch_mob(target, amount)
	if(isturf(target))
		touch_turf(target, amount)
	if(isobj(target))
		touch_obj(target, amount)
	return

/datum/reagent_holder/proc/touch_mob(mob/target)
	if(!target || !istype(target))
		return

	for(var/datum/reagent/current in reagent_list)
		current.touch_mob(target, current.volume)

	update_total()

/datum/reagent_holder/proc/touch_turf(turf/target, amount)
	if(!target || !istype(target))
		return

	for(var/datum/reagent/current in reagent_list)
		current.touch_turf(target, amount)

	update_total()

/datum/reagent_holder/proc/touch_obj(obj/target, amount)
	if(!target || !istype(target))
		return

	for(var/datum/reagent/current in reagent_list)
		current.touch_obj(target, amount)

	update_total()

// Attempts to place a reagent on the mob's skin.
// Reagents are not guaranteed to transfer to the target.
// Do not call this directly, call trans_to() instead.
/datum/reagent_holder/proc/splash_mob(mob/target, amount = 1, copy = 0)
	var/perm = 1
	if(isliving(target)) //will we ever even need to tranfer reagents to non-living mobs?
		var/mob/living/L = target
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.atom_shieldcall_handle_touch(null, SHIELDCALL_CONTACT_FLAG_NEUTRAL, SHIELDCALL_CONTACT_SPECIFIC_CHEMICAL_SPRAY) & SHIELDCALL_FLAGS_BLOCK_ATTACK)
				amount = 0
		perm = L.reagent_permeability()
	return trans_to_mob(target, amount, CHEM_TOUCH, perm, copy)

/datum/reagent_holder/proc/trans_to_mob(mob/target, amount = 1, type = CHEM_INJECT, multiplier = 1, copy = 0) // Transfer after checking into which holder...
	if(!target || !istype(target))
		return
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(type == CHEM_INJECT)
			var/datum/reagent_holder/R = C.reagents
			return trans_to_holder(R, amount, multiplier, copy)
		if(type == CHEM_INGEST)
			var/datum/reagent_holder/R = C.ingested
			return C.ingest(src, R, amount, multiplier, copy)
		if(type == CHEM_TOUCH)
			var/datum/reagent_holder/R = C.touching
			return trans_to_holder(R, amount, multiplier, copy)
	else
		var/datum/reagent_holder/R = new /datum/reagent_holder(amount)
		. = trans_to_holder(R, amount, multiplier, copy)
		R.touch_mob(target)

/datum/reagent_holder/proc/trans_to_turf(turf/target, amount = 1, multiplier = 1, copy = 0) // Turfs don't have any reagents (at least, for now). Just touch it.
	if(!target)
		return

	var/datum/reagent_holder/R = new /datum/reagent_holder(amount * multiplier)
	. = trans_to_holder(R, amount, multiplier, copy)
	R.touch_turf(target, amount)
	return

/// Objects may or may not; if they do, it's probably a beaker or something and we need to transfer properly; otherwise, just touch.
/datum/reagent_holder/proc/trans_to_obj(obj/target, amount = 1, multiplier = 1, copy = 0)
	if(!target)
		return

	if(!target.reagents)
		var/datum/reagent_holder/R = new /datum/reagent_holder(amount * multiplier)
		. = trans_to_holder(R, amount, multiplier, copy)
		R.touch_obj(target, amount)
		return

	return trans_to_holder(target.reagents, amount, multiplier, copy)

/* Atom reagent creation - use it all the time */

/atom/proc/create_reagents(max_vol)
	reagents = new /datum/reagent_holder(max_vol, src)
	return reagents

//Spreads the contents of this reagent holder all over the vicinity of the target turf.
/datum/reagent_holder/proc/splash_area(turf/epicentre, range = 3, portion = 1.0, multiplier = 1, copy = 0)
	var/list/things = dview(range, epicentre, INVISIBILITY_LIGHTING)
	var/list/turfs = list()
	for (var/turf/T in things)
		turfs += T
	if (!turfs.len)
		return//Nowhere to splash to, somehow
	//Create a temporary holder to hold all the amount that will be spread
	var/datum/reagent_holder/R = new /datum/reagent_holder(total_volume * portion * multiplier)
	trans_to_holder(R, total_volume * portion, multiplier, copy)
	//The exact amount that will be given to each turf
	var/turfportion = R.total_volume / turfs.len
	for (var/turf/T in turfs)
		var/datum/reagent_holder/TR = new /datum/reagent_holder(turfportion)
		R.trans_to_holder(TR, turfportion, 1, 0)
		TR.splash_turf(T)
	qdel(R)

//Spreads the contents of this reagent holder all over the target turf, dividing among things in it.
//50% is divided between mobs, 20% between objects, and whatever is left on the turf itself
/datum/reagent_holder/proc/splash_turf(turf/T, amount = null, multiplier = 1, copy = 0)
	if (isnull(amount))
		amount = total_volume
	else
		amount = min(amount, total_volume)
	if (amount <= 0)
		return
	var/list/mobs = list()
	for (var/mob/M in T)
		mobs += M
	var/list/objs = list()
	for (var/obj/O in T)
		objs += O
	if (objs.len)
		var/objportion = (amount * 0.2) / objs.len
		for (var/o in objs)
			var/obj/O = o
			trans_to(O, objportion, multiplier, copy)
	amount = min(amount, total_volume)
	if (mobs.len)
		var/mobportion = (amount * 0.5) / mobs.len
		for (var/m in mobs)
			var/mob/M = m
			trans_to(M, mobportion, multiplier, copy)
	trans_to(T, total_volume, multiplier, copy)
	if (total_volume <= 0)
		qdel(src)

/datum/reagent_holder/proc/conditional_update_move(atom/A, Running = 0)
	var/list/cached_reagents = reagent_list
	for(var/datum/reagent/R in cached_reagents)
		R.on_move (A, Running)
	update_total()

/datum/reagent_holder/proc/conditional_update(atom/A)
	var/list/cached_reagents = reagent_list
	for(var/datum/reagent/R in cached_reagents)
		R.on_update (A)
	update_total()

//* Filtering *//

/**
 * Filters chemicals by `reagent_filter_flags`
 *
 * @params
 * * transfer_to - where to transfer to
 * * amount - volume limit
 * * flags - only these flags are allowed
 */
/datum/reagent_holder/proc/filter_to_holder(datum/reagent_holder/transfer_to, amount = INFINITY, flags)
	if(amount <= 0)
		return
	var/list/filtering_ids = list()
	for(var/datum/reagent/reagent in reagent_list)
		if(!(reagent.reagent_filter_flags & flags))
			continue
		filtering_ids += reagent.id
	return transfer_to_holder(transfer_to, filtering_ids, amount)

/**
 * Filters chemicals by `reagent_filter_flags`
 *
 * @params
 * * amount - volume limit
 * * flags - only these flags are allowed
 */
/datum/reagent_holder/proc/filter_to_void(amount = INFINITY, flags)
	if(amount <= 0)
		return
	var/total_filterable = 0
	var/list/datum/reagent/filtering = list()
	for(var/datum/reagent/reagent in reagent_list)
		if(!(reagent.reagent_filter_flags & flags))
			continue
		total_filterable += reagent.volume
		filtering += reagent
	var/ratio = amount / total_filterable
	for(var/datum/reagent/to_filter in filtering)
		remove_reagent(to_filter.id, to_filter.volume * ratio, TRUE)
	reconsider_reactions()
	return min(amount, total_filterable)

//* Queries *//

/**
 * returns volume remaining
 */
/datum/reagent_holder/proc/available_volume()
	return maximum_volume - total_volume

/**
 * returns lowest multiple of what we have compared to reagents list.
 *
 * both typepaths and ids are acceptable.
 */
/datum/reagent_holder/proc/has_multiple(list/reagents, multiplier = 1)
	. = INFINITY
	// *sigh*
	var/list/legacy_translating = list()
	for(var/datum/reagent/R in reagent_list)
		legacy_translating[R.id] = R.volume
	for(var/datum/reagent/reagent as anything in reagents)
		. = min(., legacy_translating[ispath(reagent)? initial(reagent.id) : reagent] / reagents[reagent])
		if(!.)
			return

//* Setters *//

/**
 * Sets our host atom
 */
/datum/reagent_holder/proc/set_atom(atom/new_atom)
	// set
	my_atom = new_atom
	// recheck reactions
	for(var/datum/chemical_reaction/reaction as anything in active_reactions)
		if(reaction.required_container_path && !istype(new_atom, reaction.required_container_path))
			stop_ticked_reaction(reaction)

/**
 * Sets if we're no-react
 *
 * @params
 * * new_value - should we block reactions? TRUE / FALSE.
 * * no_check_reactions - We usually check reactions immediately. This will halt reactions if we're set to no-react, and start them otherwise.
 *                     If 'no_check_reactions' is set to TRUE, we skip that.
 */
/datum/reagent_holder/proc/set_no_react(new_value, no_check_reactions)
	if(!my_atom)
		return
	if(!!new_value == !!(my_atom?.atom_flags & NOREACT))
		return
	if(new_value)
		my_atom?.atom_flags |= NOREACT
	else
		my_atom?.atom_flags &= ~NOREACT
	if(no_check_reactions)
		return
	if(new_value)
		for(var/datum/chemical_reaction/reaction as anything in active_reactions)
			stop_ticked_reaction(reaction)
	else
		reconsider_reactions()

//* Transfers *//

/**
 * @params
 * * target - target holder
 * * reagents - list of paths or ids to filter by
 * * amount - limit of how much
 * * copy - do not remove the reagent from source
 * * multiplier - magically multiply the transferred reagent volumes by this much; does not affect return value.
 * * defer_reactions - should we + the recipient handle reactions?
 *
 * @return reagents transferred
 */
/datum/reagent_holder/proc/transfer_to_holder(datum/reagent_holder/target, list/reagents, amount = INFINITY, copy, multiplier = 1, defer_reactions)
	. = 0
	// todo: rework this proc
	if(!total_volume)
		return
	if(!reagents)
		var/ratio = min(1, min(amount, target.maximum_volume - target.total_volume) / total_volume)
		. = total_volume * ratio
		if(!copy)
			for(var/datum/reagent/R as anything in reagent_list)
				var/transferred = R.volume * ratio
				target.add_reagent(R.id, transferred * multiplier, R.get_data(), TRUE)
				remove_reagent(R.id, transferred, TRUE)
		else
			for(var/datum/reagent/R as anything in reagent_list)
				var/transferred = R.volume * ratio
				target.add_reagent(R.id, transferred * multiplier, R.get_data(), TRUE)
	else
		var/total_transferable = 0
		var/list/reagents_transferring = list()
		// preprocess to IDs
		for(var/i in 1 to length(reagents))
			var/datum/reagent/resolved = SSchemistry.fetch_reagent(reagents[i])
			reagents[i] = resolved.id
		// filter & gather
		for(var/datum/reagent/R as anything in reagent_list)
			if(!(R.id in reagents))
				continue
			total_transferable += R.volume
			reagents_transferring += R
		if(!total_transferable)
			return 0
		var/ratio = min(1, min(amount, target.maximum_volume - target.total_volume) / total_transferable)
		. = total_transferable * ratio
		if(!copy)
			for(var/datum/reagent/R as anything in reagents_transferring)
				var/transferred = R.volume * ratio
				target.add_reagent(R.id, transferred * multiplier, R.get_data(), TRUE)
				remove_reagent(R.id, transferred, TRUE)
		else
			for(var/datum/reagent/R as anything in reagents_transferring)
				var/transferred = R.volume * ratio
				target.add_reagent(R.id, transferred * multiplier, R.get_data(), TRUE)

	if(!defer_reactions)
		if(!copy)
			reconsider_reactions()
		target.reconsider_reactions()

//* UI *//

/**
 * data list for ReagentContents in /tgui/interfaces/common/Reagents.tsx
 */
/datum/reagent_holder/proc/tgui_reagent_contents()
	var/list/built = list()
	for(var/datum/reagent/R as anything in reagent_list)
		built[++built.len] = list(
			"name" = R.name,
			"amount" = R.volume,
			"id" = R.id,
		)
	return built
