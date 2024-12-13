//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/**
 * Blood holder.
 *
 * This is basically just a blood mixture datum but permanent. Caching is more pronounced,
 * and things can be stored that otherwise wouldn't be because we're considered cheap to store.
 *
 * * We own all fragments in us. We always copy when giving references, and always copy
 *   when accepting references.
 */
/datum/blood_holder
	/// Our host blood.
	var/datum/blood_fragment/host_blood
	/// Amount of host blood we have
	var/host_blood_volume = 0
	/// Our fragments that aren't ourselves, associated to amount.
	var/list/datum/blood_fragment/guest_bloods
	/// Total amount of guest blood volume
	var/guest_blood_volume = 0

/datum/blood_holder/proc/set_host_fragment_to(datum/blood_fragment/fragment)
	host_blood = fragment.clone()

/datum/blood_holder/proc/set_host_volume(amount)
	host_blood_volume = amount

/datum/blood_holder/proc/adjust_host_volume(amount)
	host_blood_volume = max(host_blood_volume + amount, 0)

/datum/blood_holder/proc/set_volume(datum/blood_fragment/fragment, amount)
	#warn impl; check for host blood

/datum/blood_holder/proc/adjust_volume(datum/blood_fragment/fragment, amount)
	#warn impl; check for host blood

/datum/blood_holder/proc/get_total_volume()
	return host_blood_volume + guest_blood_volume

/**
 * Takes a blood mixture from us.
 *
 * * Expensive.
 * * Fails if we don't have enough.
 * * Does not put viruses/antibodies/etc into it; that's the responsibiliy of the host, for now.
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
	return creating

#warn how to handle color? compute_color_from_data, don't forget!
