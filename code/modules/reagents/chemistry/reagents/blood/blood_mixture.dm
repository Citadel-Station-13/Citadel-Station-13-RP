//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Reagent blood data
 */
#warn fragment_volumes, and a total amount tracker / manual gc system.
/datum/blood_mixture
	var/list/legacy_antibodies
	var/list/legacy_virus2
	#warn uhh
	var/legacy_trace_chem
	#warn hook
	var/legacy_is_synthetic = FALSE

	/// Fragments, associated to volume in units.
	VAR_PRIVATE/list/datum/blood_fragment/fragment_ratios

	/// The total amount of all of our fragments
	/// * Only useful in a return-value context. This is to avoid needing to recalcualte this.
	/// * This can, in-fact, be '0'.
	/// * In a reagent / storage context, the reagent's volume will always supercede this.
	/// * This is not copied during a clone, as it's purely return-value context.
	var/tmp/ctx_return_amount = 0

// todo: serialize
// todo: deserialize

/datum/blood_mixture/clone(include_contents)
	var/datum/blood_mixture/copy = new /datum/blood_mixture
	if(!isnull(legacy_trace_chem))
		copy.legacy_trace_chem = legacy_trace_chem
	if(!isnull(legacy_antibodies))
		copy.legacy_antibodies = legacy_antibodies
	if(!isnull(legacy_is_synthetic))
		copy.legacy_is_synthetic = legacy_is_synthetic
	if(!isnull(legacy_virus2))
		copy.legacy_virus2 = legacy_virus2
	if(length(fragment_ratios))
		copy.fragment_ratios = list()
		for(var/datum/blood_fragment/data as anything in fragment_ratios)
			copy.fragment_ratios[data.clone()] = fragment_ratios[data]
	return copy

/**
 * Get overall color
 */
/datum/blood_mixture/proc/get_color()
	// red, green, blue, alpha, total
	var/list/rgbat = list(0, 0, 0, 0, 0)

	for(var/datum/blood_fragment/fragment as anything in fragment_ratios)
		var/guest_volume = fragment_ratios[fragment]
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

/**
 * Get overall name
 */
/datum/blood_mixture/proc/get_name()
	#warn impl

/**
 * Get atom blood DNA variable
 *
 * * this is shit, ugh
 */
/datum/blood_mixture/proc/legacy_get_forensic_blood_dna()
	if(!length(fragment_ratios))
		return null
	var/highest_so_far
	var/datum/blood_fragment/highest_to_use
	for(var/datum/blood_fragment/fragment as anything in fragment_ratios)
		if(fragment_ratios[fragment] > highest_so_far)
			highest_so_far = fragment_ratios[fragment]
			highest_to_use = fragment
	return list(
		(highest_to_use.legacy_blood_dna) = (highest_to_use.legacy_blood_type),
	)

/**
 * Sets our internal fragment list reference to a given value.
 *
 * * passed in fragment ratios are not auto-normalized; you must do that.
 * * passed in fragment ratios are directly referenced, not copied.
 *
 * @params
 * * fragment_ratios - list of /datum/blood_fragment to number as a ratio from (0, 1]
 */
/datum/blood_mixture/proc/unsafe_set_fragment_list_ref(list/fragment_ratios)
	src.fragment_ratios = fragment_ratios

/**
 * Returns an immutable reference to our internal fragment list.
 *
 * * You may only use the keys of the returned list to access fragments in a read-only fashion.
 *   You may not use this to infer the ratio or volume of any fragment.
 * * You are not allowed to edit this list or the datums in its entries in any way,
 *   unless you clone() said datums or deep_list_clone() the list first.
 */
/datum/blood_mixture/proc/unsafe_get_fragment_list_ref() as /list
	RETURN_TYPE(/list)
	return fragment_ratios

/**
 * Returns an immutable reference to a fragment.
 *
 * * You are not allowed to edit the returned datum without clone()ing it first.
 * * This is checked to ensure the index isn't out of bounds on the high end.
 */
/datum/blood_mixture/proc/unsafe_get_fragment_ref(index) as /datum/blood_fragment
	RETURN_TYPE(/datum/blood_fragment)
	if(index < length(fragment_ratios))
		return
	return fragment_ratios[index]

/**
 * Merge other into self. This changes self.
 * * Don't call unless you know what you're doing.
 *
 * @params
 * * other - the mixture being merged into self
 * * other_volume - their volume
 * * self_volume - our volume
 */
/datum/blood_mixture/proc/unsafe_merge_other_into_self(datum/blood_mixture/other, other_volume, self_volume)
	legacy_antibodies |= other.legacy_antibodies
	legacy_is_synthetic ||= other.legacy_is_synthetic
	legacy_virus2 |= other.legacy_virus2
	legacy_trace_chem ||= other.legacy_trace_chem

	if(!self_volume)
		if(length(other.lfragment_ratios))
			fragment_ratios = list()
			for(var/datum/blood_fragment/data as anything in other.fragment_ratios)
				fragment_ratios[data.clone()] = other.lfragment_ratios[data]
	#warn impl

//* Subtypes *//

/datum/blood_mixture/preset/single
	var/tmp/prefill_volume

/datum/blood_mixture/preset/single/New(list/fragments, volume = src.prefill_volume)
	..()
	#warn do stuff; if no fragments exist, we are whole ratio, otherwise we are prefill volume of ratio

/datum/blood_mixture/preset/single/proc/create_preset_fragment()

/datum/blood_mixture/preset/single/synthblood

/datum/blood_mixture/preset/single/synthblood/create_preset_fragment()
	var/datum/blood_fragment/creating = new
	creating.color = "#999966"
	creating.legacy_blood_type = "O-"
	return creating
