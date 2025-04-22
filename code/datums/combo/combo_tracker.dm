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
	var/list/stored = list()
	/// current comboset evaluating against
	/// * while we can techncially not store this, as remaining combos list
	///   is enough to run an existing combo chain, this is stored to more
	///   easily detect errors
	var/datum/combo_set/running
	/// current possible combos left
	var/list/datum/combo/remaining
	/// current position in a potential combo
	var/position

/datum/combo_tracker/proc/reset()
	// do not cut, make a new list; subtypes might be referencing this before reset!
	stored = list()
	running = remaining = position = null

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
	stored += inbound
	// if tail match requested, run tail match immediately and ask questions later
	if(tail_match)
		var/datum/combo/tail_matched = combo_set.simple_tail_match(stored)
		if(tail_matched)
			return tail_matched
	// trim stored
	if(length(stored) > combo_set.computed_max_sequence_length)
		stored.len = combo_set.computed_max_sequence_length
	// reset if we changed combos
	if(combo_set != running)
		running = combo_set
		remaining = null
	// repopulate and reset if no current combo can still run empty
	if(!length(remaining))
		remaining = combo_set.combos.Copy()
		position = 1
	// see what is still valid, eject invalid ones, etc
	for(var/datum/combo/combo as anything in remaining)
		// if position went past last, it's no longer valid
		if(length(combo.keys) < position)
			remaining -= combo
			continue
		// if current position in combo keys is not inbound key it's no longer valid
		if(combo.keys[position] != inbound)
			remaining -= combo
			continue
	// if we're out of possible ones, reset and return
	if(!length(remaining))
		running = position = remaining = null
		return

	var/datum/combo/one_left = length(remaining) == 1 ? remaining[1] : null
	var/finished = one_left ? position == length(one_left.keys) : FALSE

	if(finished)
		// if finished, wipe possible and it'll trigger a reset on next iteration
		running = position = remaining = null
		. = one_left
	else
		// advance position otherwise
		++position
