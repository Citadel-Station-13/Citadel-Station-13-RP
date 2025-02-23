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
	/// * Reading the key (fragment datum) is allowed and is the only reason
	///   this is not a private variable.
	/// * Writing in any way to this list or interpreting the value of the association
	///   is not.
	var/list/datum/blood_fragment/fragment_volumes

	/// The total amount of all of our fragments
	/// * Only useful in a return-value context. This is to avoid needing to recalcualte this.
	/// * This can, in-fact, be '0'.
	/// * In a reagent / storage context, the reagent's volume will always supercede this.
	/// * This is not copied during a clone, as it's purely return-value context.
	var/tmp/ctx_return_amount = 0

/datum/blood_mixture/New(list/fragments)
	#warn impl; autonormalize ratios / amounts

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
	if(length(fragments))
		copy.fragments = list()
		for(var/datum/blood_fragment/data as anything in fragments)
			copy.fragments[data.clone()] = fragments[data]
	return copy

/**
 * Get overall color
 */
/datum/blood_mixture/proc/get_color()
	#warn impl

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
	if(!length(fragments))
		return null
	var/highest_so_far
	var/datum/blood_fragment/highest_to_use
	for(var/datum/blood_fragment/fragment as anything in fragments)
		if(fragments[fragment] > highest_so_far)
			highest_so_far = fragments[fragment]
			highest_to_use = fragment
	return list(
		(highest_to_use.legacy_blood_dna) = (highest_to_use.legacy_blood_type),
	)

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
