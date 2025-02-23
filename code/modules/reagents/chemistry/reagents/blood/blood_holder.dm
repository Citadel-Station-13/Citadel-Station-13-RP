//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Blood holder.
 *
 * This is basically just a blood mixture datum but permanent. Caching is more pronounced,
 * and things can be stored that otherwise wouldn't be because we're considered cheap to store.
 *
 * * We own all fragments in us. We always copy when giving references, and always copy
 *   when accepting references.
 * * This datum is differently optimized than /datum/blood_mixture, which is
 *   intended as a method of transferring blood around the game's code.
 */
/datum/blood_holder
	/// Our host blood.
	VAR_PRIVATE/datum/blood_fragment/host_blood
	/// Amount of host blood we have
	VAR_PRIVATE/host_blood_volume = 0
	/// Our fragments that aren't ourselves, associated to their volume.
	VAR_PRIVATE/list/datum/blood_fragment/guest_blood_volumes
	/// Total amount of guest blood volume; this is a cached value
	VAR_PRIVATE/tmp/cached_guest_blood_volume = 0
	/// Total amount of guest blood volume we're pending to erase; this is a cached value
	/// * this is used to optimize.
	///   if we store blood fragment ratios, we have a very fast uniform removal operation,
	///   and very slow non-uniform insertion and removal as we have to recompute ratios
	///   every time. if we store volumes, it's the other way around but nothing is fast.
	///   by storing both volume and a 'borrowed uniform removal ratio',
	///   we can have fast performance for both types of operations.
	/// * if this is non-0, guest blood volume values are not 'real' and are
	///   actually the value times the ratio of (total volume - borrowed volume) / total volume.
	VAR_PRIVATE/tmp/cached_guest_blood_volume_borrow = 0

// todo: serialize
// todo: deserialize
// todo: clone

/**
 * recalculate caches and reconcile state
 * * required to make guest blood volumes accurate again
 */
/datum/blood_holder/proc/reconcile()
	#warn reconcile guest blood volumes

//* total blood *//

/datum/blood_holder/proc/get_total_volume()
	return host_blood_volume + cached_guest_blood_volume - cached_guest_blood_volume_borrow

//* host blood *//

/datum/blood_holder/proc/set_host_fragment_to(datum/blood_fragment/fragment)
	host_blood = fragment.clone()

/datum/blood_holder/proc/set_host_volume(amount)
	host_blood_volume = amount

/datum/blood_holder/proc/get_host_volume()
	return host_blood_volume

/**
 * @return amount change
 */
/datum/blood_holder/proc/adjust_host_volume(amount)
	. = host_blood_volume
	host_blood_volume = max(host_blood_volume + amount, 0)
	. = host_blood_volume - .

//* guest blood *//

// none yet because we haven't needed any yet

//* mixture operations *//

#warn below

/**
 * @return amount injected
 */
/datum/blood_holder/proc/inject_mixture(datum/blood_mixture/mixture, amount)
	if(amount < 0)
		return 0
	if(isnull(amount))
		amount = mixture.ctx_return_amount
	if(!amount)
		return 0

	// todo: auto-trim system

	var/list/datum/blood_fragment/new_fragments = list()

	first_pass:
		for(var/datum/blood_fragment/potential_injecting as anything in mixture.fragments)
			if(host_blood.equivalent(potential_injecting))
				var/computed_amount = (1 - mixture.fragments[potential_injecting]) * amount
				. += adjust_host_volume(computed_amount)
				continue first_pass
			for(var/datum/blood_fragment/potential_pair as anything in guest_bloods)
				if(potential_pair.equivalent(potential_injecting))
					var/computed_amount = (1 - mixture.fragments[potential_injecting]) * amount
					var/new_guest_blood_volume = guest_blood_volume + computed_amount
					var/scaler = guest_blood_volume / new_guest_blood_volume
					var/adder = computed_amount / new_guest_blood_volume
					for(var/datum/blood_fragment/rescaling as anything in guest_bloods)
						guest_bloods[rescaling] = guest_bloods[rescaling] * scaler
					guest_bloods[potential_pair] += adder
					guest_blood_volume = new_guest_blood_volume
					continue first_pass
			new_fragments += potential_injecting

	var/old_volume = guest_blood_volume

/**
 * @return amount injected
 */
/datum/blood_holder/proc/inject_fragment(datum/blood_fragment/fragment, amount)
	if(amount < 0)
		return 0
	if(host_blood.equivalent(fragment))
		return adjust_host_volume(amount)

	// todo: auto-trim system

	var/datum/blood_fragment/existing
	for(var/datum/blood_fragment/checking as anything in guest_bloods)
		if(checking.equivalent(fragment))
			existing = checking
			break

	var/old_volume = guest_blood_volume
	guest_blood_volume += amount
	var/scaler = old_volume / guest_blood_volume

	for(var/datum/blood_fragment/scaling as anything in guest_bloods)
		guest_bloods[scaling] *= scaler

	if(!existing)
		guest_bloods[fragment] = 1 - scaler
	else
		guest_bloods[existing] += 1 - scaler

	return amount

/**
 * Erases blood uniformly.
 *
 * * Fails if we don't have enough.
 *
 * @return amount erased
 */
/datum/blood_holder/proc/checked_erase(amount)
	var/total = host_blood_volume + guest_blood_volume
	if(amount < total)
		return 0
	var/multiplier = 1 - (amount / total)
	host_blood_volume *= multiplier
	guest_blood_volume *= multiplier
	if(!guest_blood_volume)
		guest_bloods.len = 0
	return amount

/**
 * Erases blood uniformly.
 *
 * @return amount erased
 */
/datum/blood_holder/proc/erase(amount)
	var/total = host_blood_volume + guest_blood_volume
	var/multiplier = max(0, 1 - (amount / total))
	. = min(amount, total)
	host_blood_volume *= multiplier
	guest_blood_volume *= multiplier
	if(!guest_blood_volume)
		guest_bloods.len = 0

/**
 * Takes a blood mixture from us.
 *
 * * Expensive.
 * * Fails if we don't have enough.
 * * Does not put viruses/antibodies/etc into it; that's the responsibiliy of the host, for now.
 * * `ctx_return_amount` will be set on the returned mixture.
 *
 * @return mixture taken or null
 */
/datum/blood_holder/proc/checked_draw(amount) as /datum/blood_mixture
	if(get_total_volume() < amount)
		return null
	var/datum/blood_mixture/taken = draw(amount)
	// assert that it is enough
	taken.ctx_return_amount = amount
	return taken

/**
 * Takes a blood mixture from us.
 *
 * * Expensive.
 * * Does not put viruses/antibodies/etc into it; that's the responsibiliy of the host, for now.
 * * `ctx_return_amount` will be set on the returned mixture.
 *
 * @params
 * * amount - amount to take
 * * infinite - don't actually take any, and allow drawing any amount
 *
 * @return mixture taken
 */
/datum/blood_holder/proc/draw(amount, infinite) as /datum/blood_mixture
	var/datum/blood_mixture/creating = new
	creating.fragments = list()
	#warn impl fragments self/others, amounts
	if(!guest_blood_volume)
		guest_bloods.len = 0
	return creating


#warn how to handle color? compute_color_from_data, don't forget!

#warn above

//* misc *//

/**
 * assimilate all guest bloods immediately
 */
/datum/blood_holder/proc/do_immediate_assimilate_all()
	host_blood_volume += max(0, cached_guest_blood_volume - cached_guest_blood_volume_borrow)
	cached_guest_blood_volume = cached_guest_blood_volume_borrow = 0
	guest_blood_volumes = list()
