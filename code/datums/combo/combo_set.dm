//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Arbitrary holder for string-sequence combos.
 *
 * * Precomputes variables used in checking.
 * * Owns the /datum/combo's in it; other things should never edit or delete them unless changing the entire combo set.
 *
 * ## Hey! Listen!
 *
 * * A design flaw in how /datum/combo_tracker works means that combo sets and their internal combos **will** be hard referenced
 *   and there's currently no way to inform holders to clear ref when we're being deleted. For now.
 *   A component signal system will be added later. For now, until we need to start deleting these / runtime-generating,
 *   please store combo sets in global variables.
 */
/datum/combo_set
	/// expected combo type
	var/expected_combo_type = /datum/combo
	/// combos;
	/// * set to typepaths or anonymous types to init on New()
	var/list/datum/combo/combos = list()
	/// cached: max sequence length of any combo's keys
	var/tmp/computed_max_sequence_length = 0

/datum/combo_set/New(list/datum/combo/combos = src.combos)
	src.combos = combos
	hydrate()
	reload()

/datum/combo_set/Destroy()
	QDEL_NULL(combos)
	return ..()

/datum/combo_set/proc/hydrate()
	for(var/i in 1 to length(combos))
		var/datum/combo/maybe_combo = combos[i]
		if(ispath(maybe_combo))
			maybe_combo = new maybe_combo
		else if(IS_ANONYMOUS_TYPEPATH(maybe_combo))
			maybe_combo = new maybe_combo
		combos[i] = maybe_combo

/datum/combo_set/proc/reload()
	computed_max_sequence_length = 0

	for(var/datum/combo/combo as anything in combos)
		computed_max_sequence_length = max(computed_max_sequence_length, combo.get_length())

/**
 * check tail match, where 1 to n is first to last of current combo;
 * returns the first combo resolved from the current stored set
 *
 * @return /datum/combo instance or null
 */
/datum/combo_set/proc/simple_tail_match(list/keys_so_far)
	var/stored_length = length(keys_so_far)
	var/offset = min(0, stored_length - computed_max_sequence_length)
	for(var/datum/combo/combo as anything in combos)
		if(length(combo.keys) > stored_length)
			continue
		var/adjusted_offset = offset + (computed_max_sequence_length - length(combo.keys))
		for(var/i in 1 to length(combo.keys))
			if(combo.keys[i] != keys_so_far[adjusted_offset + i])
				continue
			. = combo
			break
		if(.)
			break
