/datum/reagent_holder
	//* core *//

	/// what atom we're attached to, if any
	var/atom/attached
	/// reagent holder flags - see [code/__DEFINES/reagents/flags.dm]
	var/reagent_holder_flags = NONE

	//* Reactions *//

	/// ongoing reactions
	var/list/datum/chemical_reaction/ongoing_reactions
	/// scratch list for reactions ; when doing stuff, make sure to key it by reaction id.
	/// reactions automatically remove their id from this list when finishing.
	var/list/reaction_blackboard

	//* Reagents - Core *//

	/// volumes; id = volume
	var/list/reagent_volumes = list()
	/// datas; id = list(...)
	///
	/// lazy-list, because only some reagents have data.
	var/list/reagent_datas

	//* Reagents - Metabolism *//

	/// id = metabolism datum
	///
	/// lazy-list, because only mobs have this.
	var/list/reagent_metabolism

	//* Temperature *//

	/// Current temperature in Kelvin
	var/temperature = T20C
	/// Current total heat capacity
	var/heat_capacity = 0

	//* Volume *//

	/// updated by add/remove procs, as well as update_total().
	var/total_volume = 0
	/// updated by add/remove procs, as well as update_total().
	var/maximum_volume = 100

//* Init *//

/datum/reagent_holder/New(volume = 100, atom/parent, flags)
	src.reagent_holder_flags = flags
	src.attached = parent
	src.maximum_volume = volume

/datum/reagent_holder/Destroy()
	if(length(ongoing_reactions))
		stop_reactions()
	reagent_volumes = null
	reagent_datas = null
	return ..()

//* Add / Remove *//

/**
 * please do not specify data unless you know what you are doing.
 *
 * defer_recalc implies defer_reactions.
 *
 * @return amount added
 */
/datum/reagent_holder/proc/add_reagent(datum/reagent/reagentlike, amount, temperature, defer_reactions, defer_recalc, list/data)
	// we only care about id
	if(ispath(reagentlike))
		reagentlike = initial(reagentlike.id)
	else if(!istext(reagentlike))
		reagentlike = reagentlike.id

	var/datum/reagent/resolved = SSchemistry.fetch_reagent(reagentlike)
	var/id = resolved.id

	amount = min(amount, maximum_volume - total_volume)

	if(amount <= 0)
		return 0

	var/inbound_capacity = resolved.specific_heat * amount
	var/overall_energy = (src.temperature * src.heat_capacity) + (temperature * inbound_capacity)
	src.heat_capacity += inbound_capacity
	src.temperature = overall_energy / src.heat_capacity

	var/existing_amount = reagent_volumes[id]

	if(existing_amount)
		LAZYSET(reagent_datas, id, resolved.mix_data(src, reagent_datas[id], existing_amount, data, amount))
		reagent_volumes[id] += amount
	else
		data = resolved.init_data(src, amount, data)
		LAZYSET(reagent_datas, id, data)
		reagent_volumes[id] = amount

	if(!defer_recalc)
		update_total()
		if(!defer_reactions)
			consider_reactions()

	attached?.on_reagent_change()

/**
 * defer_recalc implies defer_reactions
 *
 * @return amount removed
 */
/datum/reagent_holder/proc/remove_reagent(datum/reagent/reagentlike, amount, defer_reactions, defer_recalc)
	// we only care about id
	if(ispath(reagentlike))
		reagentlike = initial(reagentlike.id)
	else if(!istext(reagentlike))
		reagentlike = reagentlike.id

	var/datum/reagent/resolved = SSchemistry.fetch_reagent(reagentlike)
	var/id = resolved.id

	amount = min(amount, reagent_volumes[id])

	if(amount <= 0)
		return 0

	src.heat_capacity -= resolved.specific_heat * amount

	reagent_volumes[id] -= amount
	if(!reagent_volumes[id])
		reagent_volumes -= id
		reagent_datas?.Remove(id)
		reagent_metabolism?.Remove(id)

	if(!defer_recalc)
		update_total()
		if(!defer_reactions)
			consider_reactions()

	attached?.on_reagent_change()

/**
 * Remove this amount of volume from the holder, equally from all reagents in holder.
 */
/datum/reagent_holder/proc/remove_any(amount)
	if(amount >= total_volume)
		for(var/id in reagent_volumes)
			remove_reagent(id, defer_recalc = TRUE)
		. = total_volume
		update_total()
		attached?.on_reagent_change()
		return
	var/ratio = amount / total_volume
	for(var/id in reagent_volumes)
		remove_reagent(id, reagent_volumes[id] * ratio, defer_recalc = TRUE)
	update_total()
	consider_reactions()
	attached?.on_reagent_change()
	return amount

/**
 * Clear all reagents that aren't the given reagent.
 */
/datum/reagent_holder/proc/isolate_reagent(datum/reagent/reagentlike)
	// we only care about id
	if(ispath(reagentlike))
		reagentlike = initial(reagentlike.id)
	else if(!istext(reagentlike))
		reagentlike = reagentlike.id

	. = 0

	for(var/id in reagent_volumes)
		if(id != reagentlike)
			. += remove_reagent(id, defer_recalc = TRUE)

	if(.)
		update_total()
		consider_reactions()
		attached?.on_reagent_change()

/**
 * Clear all reagents.
 */
/datum/reagent_holder/proc/clear()
	return remove_any(total_volume)

//* Check *//

/datum/reagent_holder/proc/is_full()
	return total_volume >= maximum_volume

/datum/reagent_holder/proc/is_empty()
	return !length(reagent_volumes)

/datum/reagent_holder/proc/has_reagent(datum/reagent/reagentlike, amount)
	// we only care about id
	if(ispath(reagentlike))
		reagentlike = initial(reagentlike.id)
	else if(!istext(reagentlike))
		reagentlike = reagentlike.id

	return reagent_volumes[reagentlike] >= amount

/**
 * returns lowest multiple of what we have compared to reagents list.
 *
 * both typepaths and ids are acceptable.
 */
/datum/reagent_holder/proc/has_multiple(list/reagents)
	. = INFINITY
	for(var/i in 1 to length(reagents))
		var/datum/reagent/reagentlike = reagents[i]
		var/amount = reagents[reagentlike]
		if(ispath(reagentlike))
			reagentlike = initial(reagentlike.id)
		else if(!istext(reagentlike))
			reagentlike = reagentlike.id
		. = min(., reagent_volumes[i] / amount)

/**
 * input can be associated to an amount.
 *
 * @return TRUE / FALSE
 */
/datum/reagent_holder/proc/has_all_reagents(list/reagents)
	for(var/i in 1 to length(reagents))
		var/datum/reagent/reagentlike = reagents[i]
		var/amount = reagents[reagentlike]
		if(ispath(reagentlike))
			reagentlike = initial(reagentlike.id)
		else if(!istext(reagentlike))
			reagentlike = reagentlike.id
		if(reagent_volumes[reagentlike] < amount)
			return FALSE
	return TRUE

/**
 * input can be associated to an amount.
 *
 * @return first valid id will be returned, or null on fail.
 */
/datum/reagent_holder/proc/has_any_reagent(list/reagents)
	for(var/i in 1 to length(reagents))
		var/datum/reagent/reagentlike = reagents[i]
		var/amount = reagents[reagentlike]
		if(ispath(reagentlike))
			reagentlike = initial(reagentlike.id)
		else if(!istext(reagentlike))
			reagentlike = reagentlike.id
		if(reagent_volumes[reagentlike] >= amount)
			return reagentlike

//* Color *//

/datum/reagent_holder/proc/get_color()
	// todo: cache this shit
	if(is_empty())
		return "#ffffffff"
	if(length(reagent_volumes) == 1) // It's pretty common and saves a lot of work
		var/datum/reagent/R = SSchemistry.fetch_reagent(reagent_volumes[1])
		return R.color

	var/list/colors = list(0, 0, 0, 0)
	var/tot_w = 0
	for(var/id in reagent_volumes)
		var/datum/reagent/R = SSchemistry.fetch_reagent(id)
		var/volume = reagent_volumes[id]
		var/hex = uppertext(R.color)
		if(length(hex) == 7)
			hex += "FF"
		if(length(hex) != 9) // PANIC PANIC PANIC
			warning("Reagent [R.id] has an incorrect color set ([R.color])")
			hex = "#FFFFFFFF"
		colors[1] += hex2num(copytext(hex, 2, 4)) * volume * R.color_weight
		colors[2] += hex2num(copytext(hex, 4, 6)) * volume * R.color_weight
		colors[3] += hex2num(copytext(hex, 6, 8)) * volume * R.color_weight
		colors[4] += hex2num(copytext(hex, 8, 10)) * volume * R.color_weight
		tot_w += volume * R.color_weight

	return rgb(colors[1] / tot_w, colors[2] / tot_w, colors[3] / tot_w, colors[4] / tot_w)

//* Data *//

/**
 * direct list set. do not use on reference types.
 */
/datum/reagent_holder/proc/set_reagent_data_key_value(datum/reagent/reagentlike, key, value)
	if(ispath(reagentlike))
		reagentlike = initial(reagentlike.id)
	else if(!istext(reagentlike))
		reagentlike = reagentlike.id
	ASSERT(reagent_volumes[reagentlike])
	if(isnull(reagent_datas[reagentlike]))
		reagent_datas[reagentlike] = list(
			(key) = value,
		)
	else
		reagent_datas[reagentlike][key] = value

/**
 * get a shallow copy of a reagent's data
 *
 * * You must not use this on a reagent that requires 2-deep data, like on the 'blood' reagent. Doing so will cause severe issues.
 * * You can edit the returned list.
 *
 * @return list or null
 */
/datum/reagent_holder/proc/get_reagent_shallow_data(datum/reagent/reagentlike)
	if(ispath(reagentlike))
		reagentlike = initial(reagentlike.id)
	else if(!istext(reagentlike))
		reagentlike = reagentlike.id
	ASSERT(reagent_volumes[reagentlike])
	var/list/L =  reagent_datas[reagentlike]
	return isnull(L)? null : L.Copy()

/**
 * get a refernece of a reagent's data list
 *
 * * You can not edit the returned list, hence readonly. Do not violate this under **any** circumstances.
 *
 * @return list or null
 */
/datum/reagent_holder/proc/get_reagent_data_readonly(datum/reagent/reagentlike)
	if(ispath(reagentlike))
		reagentlike = initial(reagentlike.id)
	else if(!istext(reagentlike))
		reagentlike = reagentlike.id
	ASSERT(reagent_volumes[reagentlike])
	return reagent_datas[reagentlike]

//* Get *//

/datum/reagent_holder/proc/maximum_reagent_id()
	var/highest = 0
	for(var/id in reagent_volumes)
		if(reagent_volumes[id] > highest)
			highest = reagent_volumes[id]
			. = id

/datum/reagent_holder/proc/maximum_reagent_datum()
	var/highest = 0
	for(var/id in reagent_volumes)
		if(reagent_volumes[id] > highest)
			highest = reagent_volumes[id]
			. = id
	return SSchemistry.fetch_reagent(.)

/datum/reagent_holder/proc/get_reagent_amount(datum/reagent/reagentlike)
	if(ispath(reagentlike))
		reagentlike = initial(reagentlike.id)
	else if(!istext(reagentlike))
		reagentlike = reagentlike.id
	return reagent_volumes[reagentlike]

/**
 * @return list(reagent datum instance = volume)
 *
 * returned instances **ARE IMMUTABLE.**
 */
/datum/reagent_holder/proc/lazy_expensive_dangerous_reagent_list()
	var/list/built = list()
	for(var/id in reagent_volumes)
		var/datum/reagent/resolved = SSchemistry.fetch_reagent(id)
		built[resolved] = reagent_volumes[id]
	return built

/**
 * returns volume remaining
 */
/datum/reagent_holder/proc/available_volume()
	return maximum_volume - total_volume

//* Reactions *//

/datum/reagent_holder/proc/consider_reactions(ignore_no_react)
	// check noreact
	if((reagent_holder_flags & REAGENT_HOLDER_NO_REACT) && !ignore_no_react)
		return
	// continually react all instant reactions while tallying potential long reactions
	var/continue_instantly_reacting = FALSE
	var/instantly_reacted = FALSE
	var/list/datum/chemical_reaction/potential_long_reactions = list()
	do
		// first, round up potential reactions
		var/list/datum/chemical_reaction/checking_reactions = list()
		for(var/id in reagent_volumes)
			if(isnull(SSchemistry.chemical_reactions_by_reagent[id]))
				continue
			checking_reactions |= SSchemistry.chemical_reactions_by_reagent[id]
		// then, filter by possible reactions, and process any instant ones, adding any long ones to the long list
		for(var/datum/chemical_reaction/reaction as anything in checking_reactions)
			#warn impl
	while(continue_instantly_reacting)
	// after all instant reactions are done, check long reactions
	var/requires_processing = FALSE
	for(var/datum/chemical_reaction/reaction as anything in potential_long_reactions)
		#warn check long reactions for continued validity, and start
	// lastly, update
	if(instantly_reacted)
		update_total()
	// and start processing if needed
	if(requires_processing)
		START_PROCESSING(SSchemistry, src)

/datum/reagent_holder/proc/handle_reactions()
	#warn impl

/datum/reagent_holder/proc/stop_reactions()
	ongoing_reactions = null
	STOP_PROCESSING(SSchemistry, src)

/**
 * returns a whole number (integer), leftovers get added to reaction id
 */
/datum/reagent_holder/proc/lazy_reaction_integer_collation(datum/chemical_reaction/reaction, amount)
	LAZYINITLIST(reaction_blackboard)
	var/total = reaction_blackboard[reaction.id] + amount
	reaction_blackboard[reaction.id] = total % 1
	return round(total)

//* Set *//

/datum/reagent_holder/proc/set_temperature(temperature, defer_reactions)
	src.temperature = temperature
	if(!defer_reactions)
		consider_reactions()

/datum/reagent_holder/proc/set_no_reacting(truthy)
	var/existing = reagent_holder_flags
	if(truthy)
		reagent_holder_flags |= REAGENT_HOLDER_NO_REACT
	else
		reagent_holder_flags &= REAGENT_HOLDER_NO_REACT
	if(existing != reagent_holder_flags)
		consider_reactions()

/datum/reagent_holder/proc/set_considered_open(truthy)
	var/existing = reagent_holder_flags
	if(truthy)
		reagent_holder_flags |= REAGENT_HOLDER_CONSIDERED_OPEN
	else
		reagent_holder_flags &= REAGENT_HOLDER_CONSIDERED_OPEN

//* Transfer *//

#warn /transfer_to_holder post ice crema

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
 * update totals and quantize
 */
/datum/reagent_holder/proc/update_total()
	total_volume = 0
	var/quantize_fucked_shit_up = FALSE
	for(var/id in reagent_volumes)
		if(id < REAGENT_ACCURACY)
			remove_reagent(id, defer_reactions = TRUE)
			quantize_fucked_shit_up = TRUE
		total_volume += reagent_volumes[id]
	if(quantize_fucked_shit_up)
		consider_reactions()

/**
 * completely rebuild cached data
 */
/datum/reagent_holder/proc/rebuild_everything()
	heat_capacity = 0
	for(var/id in reagent_volumes)
		var/datum/reagent/reagent = SSchemistry.fetch_reagent(id)
		heat_capacity += reagent.specific_heat * reagent_volumes[id]

#warn below

//! Legacy Below

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


/datum/reagent_holder/proc/get_reagents()
	. = list()
	for(var/datum/reagent/current in reagent_list)
		. += "[current.id] ([current.volume])"
	return english_list(., "EMPTY", "", ", ", ", ")

/* Holder-to-holder and similar procs */

/datum/reagent_holder/proc/trans_to_holder(datum/reagent_holder/target, amount = 1, multiplier = 1, copy = 0) // Transfers [amount] reagents from [src] to [target], multiplying them by [multiplier]. Returns actual amount removed from [src] (not amount transferred to [target]).
	if(!target || !istype(target))
		return

	amount = max(0, min(amount, total_volume, target.available_volume() / multiplier))

	if(!amount)
		return

	var/part = amount / total_volume

	for(var/datum/reagent/current in reagent_list)
		var/amount_to_transfer = current.volume * part
		target.add_reagent(current.id, amount_to_transfer * multiplier, current.get_data(), safety = 1) // We don't react until everything is in place
		if(!copy)
			remove_reagent(current.id, amount_to_transfer, 1)

	if(!copy)
		handle_reactions()
	target.handle_reactions()
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

	amount = min(amount, get_reagent_amount(id))

	if(!amount)
		return

	var/datum/reagent_holder/F = new /datum/reagent_holder(amount)
	var/tmpdata = get_data(id)
	F.add_reagent(id, amount, data = tmpdata)
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
			if(H.check_shields(0, null, null, null, "the spray") == 1)		//If they block the spray, it does nothing.
				amount = 0
		perm = L.reagent_permeability()
	return trans_to_mob(target, amount, REAGENT_APPLY_TOUCH, perm, copy)

/datum/reagent_holder/proc/trans_to_mob(mob/target, amount = 1, type = REAGENT_APPLY_INJECT, multiplier = 1, copy = 0) // Transfer after checking into which holder...
	if(!target || !istype(target))
		return
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(type == REAGENT_APPLY_INJECT)
			var/datum/reagent_holder/R = C.reagents
			return trans_to_holder(R, amount, multiplier, copy)
		if(type == REAGENT_APPLY_INGEST)
			var/datum/reagent_holder/R = C.reagents_ingested
			return C.ingest(src, R, amount, multiplier, copy)
		if(type == REAGENT_APPLY_TOUCH)
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


#warn above

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
	if(!total_volume)
		return
	if(!reagents)
		var/ratio = min(1, (target.maximum_volume - target.total_volume) / total_volume)
		. = total_volume * ratio
		if(!copy)
			for(var/id in reagent_volumes)
				var/transferred = reagent_volumes[id] * ratio
				target.add_reagent(id, transferred * multiplier, temperature, data = reagent_datas[id], defer_recalc = TRUE)
				remove_reagent(R.id, transferred, defer_recalc = TRUE)
		else
			for(var/id in reagent_volumes)
				var/transferred = reagent_volumes[id] * ratio
				target.add_reagent(id, transferred * multiplier, temperature, data = reagent_datas[id], defer_recalc = TRUE)
	else
		var/total_transferable = 0
		var/list/reagents_transferring = list()
		// preprocess
		for(var/i in 1 to length(reagents))
			if(istext(reagents[i]))
			else if(ispath(reagents[i], /datum/reagent))
				var/datum/reagent/casted = reagents[i]
				reagents[i] = initial(casted.id)
			else if(istype(reagents[i], /datum/reagent))
				var/datum/reagent/casted = reagents[i]
				reagents[i] = casted.id
			else
				CRASH("what?")
		// filter & gather
		for(var/id in reagent_volumes)
			if(!(R.id in reagents))
				continue
			total_transferable += reagent_volumes[id]
			reagents_transferring += id
		var/ratio = min(1, (target.maximum_volume - target.total_volume) / total_transferable)
		. = total_transferable * ratio
		if(!copy)
			for(var/id in reagents_transferring)
				var/transferred = reagent_volumes[id] * ratio
				target.add_reagent(id, transferred * multiplier, temperature, data = reagent_datas[id], defer_recalc = TRUE)
				remove_reagent(R.id, transferred, defer_recalc = TRUE)
		else
			for(var/id in reagents_transferring)
				var/transferred = reagent_volumes[id] * ratio
				target.add_reagent(id, transferred * multiplier, temperature, data = reagent_datas[id], defer_recalc = TRUE)

	if(!defer_reactions)
		if(!copy)
			update_total()
			consider_reactions()
		target.update_total()
		target.consider_reactions()
	else
		if(!copy)
			update_total()
		target.update_total()

//* Atom API *//

/atom/proc/create_reagents(max_vol, flags)
	reagents = new /datum/reagent_holder(max_vol, src, flags)
	return reagents

//* Metabolizing Holders *//

/**
 * Metabolizing holders. Handles reagent metabolism for /mob/living/carbon mobs.
 */
/datum/reagent_holder/metabolism
	/// REAGENT_APPLY_X that this stands for
	var/application
	/// base metabolism multiplier
	var/metabolism_multiplier = 1

/datum/reagent_holder/metabolism/proc/metabolize(speed_mult = 1, force_allow_dead)
	#warn rewrite

	var/metabolism_type = 0 //non-human mobs
	if(ishuman(parent))
		var/mob/living/carbon/human/H = parent
		metabolism_type = H.species.reagent_tag

	for(var/datum/reagent/current in reagent_list)
		current.on_mob_life(parent, metabolism_type, src, speed_mult, force_allow_dead)
	update_total()

/**
 * A carbon mob's bloodstream. It only has one of these, but in the future this is tied to the presence of a bloodstream.
 */
/datum/reagent_holder/metabolism/bloodstream
	application = REAGENT_APPLY_INJECT

/**
 * A carbon mob's stomach contents. It currently has one of these, but in the future this is tied to stomach organs.
 */
/datum/reagent_holder/metabolism/ingested
	application = REAGENT_APPLY_INGEST
	metabolism_multiplier = 0.5

/**
 * A carbon mob external organ's skin holder. Pretty much only used for hypodermic patch medications.
 */
/datum/reagent_holder/metabolism/dermal
	application = REAGENT_APPLY_PATCH
