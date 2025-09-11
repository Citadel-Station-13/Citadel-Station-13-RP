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
	VAR_PRIVATE/list/datum/blood_fragment/guest_blood_volumes = list()
	/// Total amount of guest blood volume; this is a cached value
	VAR_PRIVATE/tmp/cached_guest_blood_volume = 0

// todo: serialize
// todo: deserialize
// todo: clone

//* total blood *//

/datum/blood_holder/proc/get_total_volume()
	return host_blood_volume + cached_guest_blood_volume

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

/**
 * @return amount injected
 */
/datum/blood_holder/proc/inject_mixture(datum/blood_mixture/mixture, amount)
	if(isnull(amount))
		amount = mixture.ctx_return_amount
	if(amount <= 0)
		return 0

	var/old_volume = host_blood_volume + cached_guest_blood_volume
	var/list/fragment_ratios = mixture.unsafe_get_fragment_list_ref()
	for(var/datum/blood_fragment/fragment as anything in fragment_ratios)
		var/ratio = fragment_ratios[fragment]
		inject_fragment(fragment, amount * ratio)
	return (cached_guest_blood_volume + host_blood_volume) - old_volume

/**
 * @return amount injected
 */
/datum/blood_holder/proc/inject_fragment(datum/blood_fragment/fragment, amount)
	if(amount <= 0)
		return 0
	if(host_blood.equivalent(fragment))
		return adjust_host_volume(amount)

	for(var/i in 1 to length(guest_blood_volumes))
		var/datum/blood_fragment/checking = guest_blood_volumes[i]
		if(checking.equivalent(fragment))
			guest_blood_volumes[checking] += amount
			cached_guest_blood_volume += amount
			return
	guest_blood_volumes[fragment] = amount
	cached_guest_blood_volume += amount

/**
 * Erases blood uniformly.
 *
 * * Fails if we don't have enough.
 *
 * @return amount erased
 */
/datum/blood_holder/proc/checked_erase(amount)
	return (cached_guest_blood_volume + host_blood_volume) < amount ? 0 : erase(amount)

/**
 * Erases blood uniformly.
 *
 * @return amount erased
 */
/datum/blood_holder/proc/erase(amount)
	var/total = host_blood_volume + cached_guest_blood_volume
	if(!total)
		return 0
	. = min(amount, total)
	if(total==0) //No divide by zero, return value's set already
		return
	var/multiplier = max(0, 1 - (. / total))

	host_blood_volume *= multiplier
	cached_guest_blood_volume *= multiplier
	for(var/datum/blood_fragment/fragment as anything in guest_blood_volumes)
		guest_blood_volumes[fragment] *= multiplier

	if(cached_guest_blood_volume <= 0)
		guest_blood_volumes.len = 0
		cached_guest_blood_volume = 0

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
	return (cached_guest_blood_volume + host_blood_volume) < amount ? 0 : draw(amount)

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
 * @return mixture taken, if any
 */
/datum/blood_holder/proc/draw(amount, infinite) as /datum/blood_mixture
	var/total = host_blood_volume + cached_guest_blood_volume
	if(!total)
		return null
	amount = min(amount, total)
	if(amount < 0) return null
	var/multiplier = max(0, 1 - (amount / total))

	var/datum/blood_mixture/creating = new
	creating.ctx_return_amount = amount
	var/list/fragment_ratio_list = list()
	for(var/datum/blood_fragment/fragment as anything in guest_blood_volumes)
		fragment_ratio_list[fragment] = guest_blood_volumes[fragment] / total
	fragment_ratio_list[host_blood] = host_blood_volume / total
	creating.unsafe_set_fragment_list_ref(fragment_ratio_list)

	host_blood_volume *= multiplier
	cached_guest_blood_volume *= multiplier
	for(var/datum/blood_fragment/fragment as anything in guest_blood_volumes)
		guest_blood_volumes[fragment] *= multiplier

	if(cached_guest_blood_volume <= 0)
		guest_blood_volumes.len = 0
		cached_guest_blood_volume = 0
	return creating

/**
 * Gets our overall color.
 */
/datum/blood_holder/proc/get_color()
	// red, green, blue, alpha, total
	var/list/rgbat = decode_rgba(host_blood.color || "#000000")
	// 'total' is index 5
	rgbat += host_blood_volume

	for(var/datum/blood_fragment/fragment as anything in guest_blood_volumes)
		var/guest_volume = guest_blood_volumes[fragment]
		var/list/decoded_guest = decode_rgba(fragment.color || "#000000")
		rgbat[1] += decoded_guest[1] * guest_volume
		rgbat[2] += decoded_guest[2] * guest_volume
		rgbat[3] += decoded_guest[3] * guest_volume
		rgbat[4] += decoded_guest[4] * guest_volume
		rgbat[5] += guest_volume

	var/divisor = rgbat[5]
	return rgb(
		rgbat[1] / divisor,
		rgbat[2] / divisor,
		rgbat[3] / divisor,
		rgbat[4] / divisor,
	)

//* misc *//

/**
 * assimilate all guest bloods immediately
 */
/datum/blood_holder/proc/do_assimilate_all()
	host_blood_volume += max(0, cached_guest_blood_volume)
	cached_guest_blood_volume = 0
	guest_blood_volumes.len = 0

/**
 * assimilates guest blood
 */
/datum/blood_holder/proc/do_assimilate(volume)
	if(!length(guest_blood_volumes))
		return
	var/max_assimilate_per_iteration = max(volume * (1 / 7), volume / length(guest_blood_volumes))
	var/iterations = 0
	while(volume > 0)
		if(++iterations > 20)
			CRASH("too many iterations in blood assimilation simulation")
		var/random_index = rand(1, length(guest_blood_volumes))
		var/datum/blood_fragment/random_fragment = guest_blood_volumes[random_index]
		var/random_volume = guest_blood_volumes[random_fragment]
		var/random_assimilate = min(random_volume, max(volume * 0.5, max_assimilate_per_iteration))
		volume -= random_assimilate
		cached_guest_blood_volume -= random_assimilate
		guest_blood_volumes[random_fragment] -= random_assimilate
		host_blood_volume += random_assimilate

//* unsafe access to internals *//

/**
 * Get a direct reference to host blood.
 * * You are not allowed to edit this.
 */
/datum/blood_holder/proc/unsafe_get_host_fragment_ref()
	return host_blood
