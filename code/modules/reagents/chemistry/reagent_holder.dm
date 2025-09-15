/datum/reagent_holder
	//* Core *//

	/// reagent holder flags - see [code/__DEFINES/reagents/flags.dm]
	var/reagent_holder_flags = NONE

	//* Container *//

	/// Our maximum volume
	var/maximum_volume = 100

	//* Reactions *//

	/// active reactions
	///
	/// * instant reactions will never be added to this
	/// * lazy list
	/// * reaction datums are associated to their blackboard lists
	var/list/datum/chemical_reaction/active_reactions

	//* Reagents *//

	/// Our reagent volumes
	///
	/// * Lazy list.
	var/list/reagent_volumes
	/// Our reagent datas
	///
	/// * Lazy list.
	var/list/reagent_datas
	/// Our temperature
	//  todo: this is currently half-implemented, we should finish it
	//  todo: when we do, make sure carbon-types will temperature-stabilize their reagents holders.
	var/temperature = T20C
	/// Our current volume
	///
	/// * Must be eagerly updated. Many internal procs depend on this for speed.
	var/total_volume = 0

	///? legacy / unsorted

	var/atom/my_atom = null
	// todo: remove / refactor this var into reagent_holder_flags with proper defines, this was never ported properly.
	var/reagents_holder_flags

/datum/reagent_holder/New(max = 100, atom/A = null, new_flags = NONE)
	..()
	maximum_volume = max
	my_atom = A
	reagents_holder_flags = new_flags

/datum/reagent_holder/Destroy()
	// stop all reactions
	if(reagent_holder_flags & REAGENT_HOLDER_FLAG_CURRENTLY_REACTING)
		stop_reacting()
	// unreference volumes and datas
	reagent_volumes = reagent_datas = null
	// unreference our atom
	if(my_atom)
		if(my_atom.reagents == src)
			my_atom.reagents = null
		my_atom = null
	return ..()

/datum/reagent_holder/clone()
	var/datum/reagent_holder/creating = new type
	creating.reagent_volumes = reagent_volumes.Copy()
	creating.reagent_datas = deep_clone_list(reagent_datas)
	creating.temperature = temperature
	creating.total_volume = total_volume
	return creating

// Used in attack logs for reagents in pills and such
/datum/reagent_holder/proc/log_list()
	if(!length(reagent_volumes))
		return "no reagents"

	var/list/data = list()
	for(var/id in reagent_volumes)
		data += "[id] ([reagent_volumes[id]]u)"
		//Using IDs because SOME chemicals (I'm looking at you, chlorhydrate-beer) have the same names as other chemicals.
	return english_list(data)

/* Internal procs */

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
 * * skip_updates - don't do reaction checks, quanitization, and similar.
 *
 * @return amount added
 */
/datum/reagent_holder/proc/add_reagent(id, amount, data_initializer, skip_updates)
	if(ispath(id))
		var/datum/reagent/accessing = id
		id = initial(accessing.id)

	amount = REAGENT_HOLDER_VOLUME_QUANTIZE(min(amount, maximum_volume - total_volume))
	if(amount <= 0)
		return 0

	// this reagent may need to be loaded from persistence
	var/datum/reagent/reagent = SSchemistry.fetch_reagent(id)

	if(!reagent)
		return 0

	if(reagent_volumes)
		reagent_volumes[id] += amount
	else
		reagent_volumes = list((id) = amount)

	if(reagent.holds_data)
		if(reagent_datas)
			reagent_datas[id] = reagent.mix_data(
				reagent_datas[id],
				reagent_volumes[id] - amount,
				reagent.preprocess_data(data_initializer),
				amount,
				src,
			)
		else
			reagent_datas = list((id) = reagent.mix_data(
				null,
				0,
				reagent.preprocess_data(data_initializer),
				amount,
				src,
			))

	total_volume += amount

	if(!skip_updates)
		try_reactions_for_reagent_change(id)

	//! LEGACY
	if(my_atom)
		my_atom.on_reagent_change()
	//! END

	return amount

/datum/reagent_holder/proc/isolate_reagent(reagent)
	if(ispath(reagent))
		var/datum/reagent/path = reagent
		reagent = initial(path.id)
	var/list/changed_ids = list()
	for(var/id in reagent_volumes)
		if(id == reagent)
			continue
		changed_ids += id
		del_reagent(id, TRUE)
	try_reactions_for_reagents_changed(changed_ids)

/**
 * Core proc: Remove a specific amount of a reagent.
 *
 * @params
 * * id - reagent ID. Typepaths are allowed too.
 * * amount - amount to add.
 * * skip_updates - don't do reaction checks or similar.
 *
 * @return amount removed
 */
/datum/reagent_holder/proc/remove_reagent(id, amount, skip_updates)
	if(ispath(id))
		var/datum/reagent/path = id
		id = initial(path.id)

	amount = REAGENT_HOLDER_VOLUME_QUANTIZE(amount)
	if(amount <= 0)
		return 0

	var/current = reagent_volumes?[id]
	if(!current)
		return

	if(amount >= FLOOR(current, REAGENT_HOLDER_VOLUME_PRECISION))
		reagent_volumes -= id
		if(reagent_datas)
			reagent_datas -= id
		total_volume -= current
		. = current
	else
		reagent_volumes[id] -= amount
		total_volume -= amount
		. = amount

	// -- deal with floating point inaccuracy incase we went below 0 --
	if(total_volume < REAGENT_HOLDER_VOLUME_PRECISION)
		clear_reagents()
	// -- end --

	if(!skip_updates)
		try_reactions_for_reagent_change(id)
	//! LEGACY
	if(my_atom)
		my_atom.on_reagent_change()
	//! END

/**
 * Completely remove a reagent.
 *
 * @params
 * * id - id or typepath.
 * * skip_updates - do not reconsider relevant reactions.
 *
 * @return amount removed
 */
/datum/reagent_holder/proc/del_reagent(id, skip_updates)
	if(ispath(id))
		var/datum/reagent/path = id
		id = initial(path.id)
	var/current = reagent_volumes?[id]
	if(!current)
		return 0
	reagent_volumes -= id
	total_volume -= current

	// -- deal with floating point inaccuracy incase we went below 0 --
	if(total_volume < REAGENT_HOLDER_VOLUME_PRECISION)
		clear_reagents()
	// -- end

	if(!skip_updates)
		try_reactions_for_reagent_change(id)
	//! LEGACY
	if(my_atom)
		my_atom.on_reagent_change()
	//! END
	return current

/**
 * Completely remove all reagents.
 */
/datum/reagent_holder/proc/clear_reagents()
	reagent_volumes = null
	reagent_datas = null
	total_volume = 0
	temperature = initial(temperature)

/datum/reagent_holder/proc/has_reagent(id, amount = REAGENT_HOLDER_VOLUME_PRECISION)
	if(ispath(id))
		var/datum/reagent/path = id
		id = initial(path.id)
	return !isnull(reagent_volumes?[id])

/datum/reagent_holder/proc/get_reagents()
	. = list()
	for(var/id in reagent_volumes)
		var/volume = reagent_volumes[id]
		. += "[id] ([volume])"
	return english_list(., "EMPTY", "", ", ", ", ")

/* Holder-to-holder and similar procs */

/**
 * Removes a given amount from the holder, equally from all reagents.
 *
 * @params
 * * amount - amount to remove
 *
 * @return amount removed
 */
/datum/reagent_holder/proc/remove_any(amount)
	if(amount <= 0 || !total_volume)
		return 0
	if(amount >= total_volume)
		. = total_volume
		clear_reagents()
		return
	var/remaining_ratio = 1 - (amount / total_volume)
	for(var/id in reagent_volumes)
		reagent_volumes[id] *= remaining_ratio
	// todo: don't update everything, just update relevant?
	reconsider_reactions()
	return amount

// Transfers [amount] reagents from [src] to [target], multiplying them by [multiplier].
// Returns actual amount removed from [src] (not amount transferred to [target]).
// todo: audit this proc
/datum/reagent_holder/proc/trans_to_holder(datum/reagent_holder/target, amount = 1, multiplier = 1, copy = 0)
	return transfer_to_holder(target, null, amount, copy, multiplier)

/* Holder-to-atom and similar procs */

/**
 * The general proc for applying reagents to things. This proc assumes the reagents are being applied externally,
 * not directly injected into the contents. It first calls touch, then the appropriate trans_to_*() or splash_mob().
 * If for some reason touch effects are bypassed (e.g. injecting stuff directly into a reagent container or person),
 * call the appropriate trans_to_*() proc.
 */
// todo: audit this proc
/datum/reagent_holder/proc/trans_to(atom/target, amount = 1, multiplier = 1, copy = 0)
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
	var/datum/reagent/resolved = SSchemistry.fetch_reagent(id)
	var/tmpdata = resolved.make_copy_data_initializer(reagent_datas?[resolved.id])
	F.add_reagent(id, amount, tmpdata)
	remove_reagent(id, amount)

	return F.trans_to(target, amount) // Let this proc check the atom's type

// Attempts to place a reagent on the mob's skin.
// Reagents are not guaranteed to transfer to the target.
// Do not call this directly, call trans_to() instead.
// todo: audit this proc
/datum/reagent_holder/proc/splash_mob(mob/target, amount = 1, copy = 0)
	var/perm = 1
	if(isliving(target)) //will we ever even need to tranfer reagents to non-living mobs?
		var/mob/living/L = target
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.atom_shieldcall_handle_touch(null, null, SHIELDCALL_CONTACT_FLAG_NEUTRAL, SHIELDCALL_CONTACT_SPECIFIC_CHEMICAL_SPRAY) & SHIELDCALL_FLAGS_BLOCK_ATTACK)
				amount = 0
		perm = L.reagent_permeability()
	return trans_to_mob(target, amount, CHEM_TOUCH, perm, copy)

// todo: audit this proc
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
		R.perform_entity_contact(target, 1)

// todo: audit this proc
/datum/reagent_holder/proc/trans_to_turf(turf/target, amount = 1, multiplier = 1, copy = 0) // Turfs don't have any reagents (at least, for now). Just touch it.
	if(!target)
		return

	var/datum/reagent_holder/R = new /datum/reagent_holder(amount * multiplier)
	. = trans_to_holder(R, amount, multiplier, copy)
	R.perform_entity_contact(target, 1)

/// Objects may or may not; if they do, it's probably a beaker or something and we need to transfer properly; otherwise, just touch.
// todo: audit this proc
/datum/reagent_holder/proc/trans_to_obj(obj/target, amount = 1, multiplier = 1, copy = 0)
	if(!target)
		return

	if(!target.reagents)
		var/datum/reagent_holder/R = new /datum/reagent_holder(amount * multiplier)
		. = trans_to_holder(R, amount, multiplier, copy)
		R.perform_entity_contact(target, 1)
		return

	return trans_to_holder(target.reagents, amount, multiplier, copy)

/* Atom reagent creation - use it all the time */

/atom/proc/create_reagents(max_vol)
	reagents = new /datum/reagent_holder(max_vol, src)
	return reagents

//Spreads the contents of this reagent holder all over the vicinity of the target turf.
// todo: audit this proc
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
		TR.perform_uniform_contact(T, 1)
		// TR.splash_turf(T)
	qdel(R)

//Spreads the contents of this reagent holder all over the target turf, dividing among things in it.
//50% is divided between mobs, 20% between objects, and whatever is left on the turf itself
// todo: audit this proc
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
	for(var/id in reagent_volumes)
		var/datum/reagent/reagent = SSchemistry.fetch_reagent(id)
		if(!(reagent.reagent_filter_flags & flags))
			continue
		filtering_ids += id
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
	var/list/filtering_ids = list()
	for(var/id in reagent_volumes)
		var/datum/reagent/reagent = SSchemistry.fetch_reagent(id)
		if(!(reagent.reagent_filter_flags & flags))
			continue
		total_filterable += reagent_volumes[id]
		filtering_ids += id
	var/ratio = amount / total_filterable
	for(var/id in filtering_ids)
		remove_reagent(id, reagent_volumes[id] * ratio, TRUE)
	reconsider_reactions()
	return min(amount, total_filterable)

//* Getters *//

/**
 * Gets the amount of a reagent ID or path
 */
/datum/reagent_holder/proc/get_reagent_amount(datum/reagent/reagentlike)
	return reagent_volumes ? reagent_volumes[ispath(reagentlike) ? initial(reagentlike.id) : (istype(reagentlike) ? reagentlike.id : reagentlike)] : 0

/**
 * Gets the data of a reagent ID or path
 */
/datum/reagent_holder/proc/get_reagent_data(datum/reagent/reagentlike)
	return reagent_datas ? reagent_datas[ispath(reagentlike) ? initial(reagentlike.id) : (istype(reagentlike) ? reagentlike.id : reagentlike)] : null

/**
 * Gets the global singletons of reagents in us.
 *
 * todo: how do we handle this cleanly? this shouldn't be the usual case. rename to fetch_reagent_datums()?
 */
/datum/reagent_holder/proc/get_reagent_datums() as /list
	. = list()
	for(var/id in reagent_volumes)
		. += SSchemistry.fetch_reagent(id)

//* Queries *//

/**
 * returns volume remaining
 */
/datum/reagent_holder/proc/available_volume()
	return maximum_volume - total_volume

/**
 * Returns if we have any of the given reagent IDs or paths.
 *
 * @params
 * * reagent_ids - ids or paths
 * * minimum - minimum to be considered to be there. Do not set this to 0 or this proc will always succeed.
 */
/datum/reagent_holder/proc/has_any(list/reagent_ids, minimum = 0.00001)
	for(var/datum/reagent/id as anything in reagent_ids)
		if(ispath(id))
			id = initial(id.id)
		if(reagent_volumes[id] >= minimum)
			return TRUE
	return FALSE

/**
 * Returns lowest multiple of what we have compared to reagents list.
 *
 * * Reagent instances are not allowed in reagent ids list.
 *
 * @params
 * * reagent_ids - ids or paths
 */
/datum/reagent_holder/proc/has_multiple(list/reagent_ids)
	. = INFINITY
	// *sigh*
	for(var/datum/reagent/reagent as anything in reagent_ids)
		. = min(., reagent_volumes[ispath(reagent)? initial(reagent.id) : reagent] / reagent_ids[reagent])
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
	// todo: this shouldn't be on atom AAAAA
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
 * Transfers to a holder.
 *
 * * Transference is done uniformly within the target reagents, keeping any ratios between them during the transfer.
 * * It is **undefined behavior** to have duplicate IDs in the list of reagent IDs to filter by.
 * * Reagent instances are not allowed in reagent filter list.
 *
 * @params
 * * target - target holder
 * * reagents - list of reagent ids or paths to filter by;
 * * amount - limit of how much
 * * copy - do not remove the reagent from source
 * * multiplier - magically multiply the transferred reagent volumes by this much; does not affect return value.
 * * defer_reactions - should we + the recipient skip handling reactions immediately?
 *
 * @return total volume transferred
 */
/datum/reagent_holder/proc/transfer_to_holder(datum/reagent_holder/target, list/reagents, amount = INFINITY, copy, multiplier = 1, defer_reactions)
	if(!total_volume)
		return 0

	var/list/ids_to_transfer
	var/ratio

	if(reagents)
		var/total_transferable = 0
		ids_to_transfer = list()
		for(var/datum/reagent/potential as anything in reagents)
			if(ispath(potential))
				potential = initial(potential.id)
			var/volume = reagent_volumes[potential]
			if(!volume)
				continue
			total_transferable += volume
			ids_to_transfer += potential
		if(!total_transferable)
			return 0
		ratio = min(1, min(amount, target.maximum_volume - target.total_volume) / total_transferable)
	else
		ids_to_transfer = reagent_volumes
		ratio = min(1, min(amount, target.maximum_volume - target.total_volume) / total_volume)

	if(!copy)
		for(var/id in ids_to_transfer)
			var/datum/reagent/resolved = SSchemistry.fetch_reagent(id)
			var/transferred = reagent_volumes[id] * ratio
			. += transferred
			target.add_reagent(
				id,
				transferred,
				resolved.holds_data ? resolved.make_copy_data_initializer(reagent_datas?[id]) : null,
				TRUE,
			)
			remove_reagent(id, transferred, TRUE)
	else
		for(var/id in ids_to_transfer)
			var/datum/reagent/resolved = SSchemistry.fetch_reagent(id)
			var/transferred = reagent_volumes[id] * ratio
			. += transferred
			target.add_reagent(
				id,
				transferred,
				resolved.holds_data ? resolved.make_copy_data_initializer(reagent_datas?[id]) : null,
				TRUE,
			)

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
	for(var/id in reagent_volumes)
		var/datum/reagent/R = SSchemistry.fetch_reagent(id)
		var/volume = reagent_volumes[id]
		built[++built.len] = list(
			"name" = R.name,
			"amount" = volume,
			"id" = R.id,
		)
	return built

//* Updates *//

/**
 * Updates total volume, quantizing all reagent amounts as well.
 */
/datum/reagent_holder/proc/update_total()
	var/new_volume = 0
	for(var/id in reagent_volumes)
		var/amount = REAGENT_HOLDER_VOLUME_QUANTIZE(reagent_volumes[id])
		reagent_volumes[id] = amount
		new_volume += amount
	total_volume = new_volume
