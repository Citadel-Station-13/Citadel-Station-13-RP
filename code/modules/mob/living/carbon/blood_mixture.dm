//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/**
 * Reagent blood data
 */
/datum/blood_mixture
	var/list/legacy_antibodies
	var/list/legacy_virus2
	#warn uhh
	var/legacy_trace_chem

	/// Fragments, associated to **ratio of total**.
	var/list/datum/blood_fragment/fragments

	/// The total amount of all of our fragments
	/// * Only useful in a return-value context. This is to avoid needing to recalcualte this.
	/// * This can, in-fact, be '0'.
	/// * In a reagent / storage context, the reagent's volume will always supercede this.
	/// * This is not copied during a clone, as it's purely return-value context.
	var/tmp/ctx_return_amount = 0

/datum/blood_mixture/clone(include_contents)
	var/datum/blood_mixture/copy = new /datum/blood_mixture
	if(legacy_trace_chem)
		copy.legacy_trace_chem = legacy_trace_chem
	if(legacy_antibodies)
		copy.legacy_antibodies = legacy_antibodies
	if(legacy_virus2)
		copy.legacy_virus2 = legacy_virus2
	if(length(fragments))
		copy.fragments = list()
		for(var/datum/blood_fragment/data as anything in fragments)
			copy.fragments[data.clone()] = fragments[data]
	return copy
