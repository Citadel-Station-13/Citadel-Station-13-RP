//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Arbitrary holder for an in-progress combo.
 *
 * This matches via chaining, rather than tail match. For tail match, use
 * the simplified helper on `/datum/combo_set`
 *
 * todo: unit test this shit
 */
/datum/combo_tracker
	/// current stored key sequence, first to last
	/// * this is not a lazy list
	var/list/stored_keys = list()
	/// current comboset evaluating against
	/// * while we can techncially not store this, as remaining combos list
	///   is enough to run an existing combo chain, this is stored to more
	///   easily detect errors
	var/datum/combo_set/combo_active
	/// current possible combos left
	var/list/datum/combo/combo_possible
	/// current position in a potential combo
	var/combo_position

/datum/combo_tracker/proc/reset()
	// do not cut, make a new list; subtypes might be referencing this before reset!
	stored_keys = list()
	combo_active = combo_possible = combo_position = null

/**
 * ## algorithm
 *
 * * 'stored' is the current set of keys that still can trigger a combo. invalid keys will never be added to stored.
 * * after a combo is fully completed, the stored buffer is cleared.
 * * introspecting our internal state to see where we're at is valid
 *
 * ## caveats
 *
 * * cannot check multiple combo sets at once as this tracks info about the active combo set (via weakref).
 *   if the combo set being checked switches, the combo is dumped.
 * * current combos must be terminated to start a new one. a longer combo will always suppress immediately
 *   executing a shorter one if the keys at that point match.
 * * only supports, as of now, executing on an inbound key, instead of working in-place.
 *
 * ## invalid behavior
 *
 * certain invalid behavior listed occurs due to ambiguous combos and is intentionally unchecked.
 * * if two combos have the same length and keys neither will complete as the algoirthm will see there's
 *   more than one combo left and will keep going, skipping past the end of both.
 * * if a combo is a prefix of another combo, it will never be invoked as the algorithm will see there's
 *   more than one combo left and keep going instead of checking for completion.
 *
 * @params
 * * inbound - inbound key
 * * combo_set - combo set to evaluate against
 * * tail_match - allow tail matching. this means we will immediately evaluate all stored keys
 *                against the combo set, allowing a trigger of a combo mid-set. this can lead
 *                to unexpected behaviors, so be careful.
 *
 * @return /datum/combo successfully ran, or null
 */
/datum/combo_tracker/proc/process_inbound(inbound, datum/combo_set/combo_set, tail_match)
	SHOULD_NOT_SLEEP(TRUE)
	// increment stored
	stored_keys += inbound
	// if tail match requested, run tail match immediately and ask questions later
	if(tail_match)
		var/datum/combo/tail_matched = combo_set.simple_tail_match(stored_keys)
		if(tail_matched)
			return tail_matched
	// trim stored
	if(length(stored_keys) > combo_set.computed_max_sequence_length)
		stored_keys.len = combo_set.computed_max_sequence_length
	// reset if we changed combos
	if(combo_set != combo_active)
		combo_active = combo_set
		combo_possible = null
	// repopulate and reset if no current combo can still run empty
	if(!length(combo_possible))
		combo_possible = combo_set.combos.Copy()
		combo_position = 1
	// see what is still valid, eject invalid ones, etc
	for(var/datum/combo/combo as anything in combo_possible)
		// if combo_position went past last, it's no longer valid
		if(length(combo.keys) < combo_position)
			combo_possible -= combo
			continue
		// if current combo_position in combo keys is not inbound key it's no longer valid
		if(combo.keys[combo_position] != inbound)
			combo_possible -= combo
			continue
	// if we're out of possible ones, reset and return
	if(!length(combo_possible))
		combo_active = combo_position = combo_possible = null
		return

	var/datum/combo/one_left = length(combo_possible) == 1 ? combo_possible[1] : null
	var/finished = one_left ? combo_position == length(one_left.keys) : FALSE

	if(finished)
		// if finished, wipe possible and it'll trigger a reset on next iteration
		combo_active = combo_position = combo_possible = null
		. = one_left
	else
		// advance combo_position otherwise
		++combo_position
