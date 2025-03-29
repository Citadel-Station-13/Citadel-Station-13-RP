//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Physiology holder for localized physiology.
 *
 * * On simplemobs, only one of these exists and will affect the whole mob,
 *   as simplemobs don't have external organs/bodypart simulation.
 */
/datum/local_physiology
	/// multiply all incoming **damage** by this much
	var/inbound_brute_mod
	/// multiply all incoming **damage** by this much
	var/inbound_burn_mod
	/// multiply fracture threshold by this much
	var/bone_fracture_threshold_mod

	#warn hook all

/datum/local_physiology/proc/reset()
	inbound_brute_mod = initial(initial_brute_mod)
	inbound_burn_mod = initial(inbound_burn_mod)
	bone_fracture_threshold_mod = initial(bone_fracture_threshold_mod)

/datum/local_physiology/proc/apply(datum/physiology_modifier/modifier)
	if(modifier.l_inbound_brute_mod != 1)
		inbound_brute_mod *= modifier.l_inbound_brute_mod
	if(modifier.l_inbound_burnte_mod != 1)
		inbound_burn_mod *= modifier.l_inbound_burn_mod
	if(modifier.l_bone_fracture_threshold_mod != 1)
		bone_fracture_threshold_mod *= modifier.l_bone_fracture_threshold_mod

/**
 * return FALSE if we need to reset due to non-canonical operations
 */
/datum/local_physiology/proc/revert(datum/physiology_modifier/modifier)
	. = TRUE
	if(modifier.l_inbound_brute_mod != 1)
		inbound_brute_mod /= modifier.l_inbound_brute_mod
	if(modifier.l_inbound_burnte_mod != 1)
		inbound_burn_mod /= modifier.l_inbound_burn_mod
	if(modifier.l_bone_fracture_threshold_mod != 1)
		bone_fracture_threshold_mod /= modifier.l_bone_fracture_threshold_mod
