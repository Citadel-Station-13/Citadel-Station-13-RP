//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Arbitrary holder for an in-progress combo.
 *
 * * 'process_inbound_via_*' runs processing, often with automatic handling and side effects.
 *    these procs should be SHOULD_NOT_SLEEP.
 * * 'evaluate_via_*' just runs the algorithm in question without touching anything.
 *    these procs should be SHOULD_NOT_OVERRIDE, and SHOULD_NOT_SLEEP.
 *
 * todo: unit test this shit
 */
/datum/combo_tracker
	/// current stored key sequence, first to last
	/// * this is not a lazy list
	var/list/stored = list()

	//* algorithm - stateful exclusive chain *//
	var/tmp/datum/combo_set/sec_set
	var/tmp/list/datum/combo/sec_possible
	var/tmp/sec_position
	/// out-list index
	/// access via ::
	var/SEC_OUT_IDX_RESOLVED = 1
	/// out-list index
	/// access via ::
	var/SEC_OUT_IDX_POSITION = 2
	/// out-list index
	/// access via ::
	var/SEC_OUT_IDX_FINISHED = 3
	/// out-list index
	/// access via ::
	var/SEC_OUT_IDX_POSSIBLE = 4

/datum/combo_tracker/proc/reset()
	// do not cut, make a new list; subtypes might be referencing this before reset!
	stored = list()
	sec_set = null
	sec_possible = null
	sec_position = null

/**
 * ## algorithm
 *
 * * 'stored' is set to last x keys that fit in the combo set's largest sequence.
 * * checks if the last x keys fit anything in the combo set.
 *   if they do, immediately wipe 'stored' and return the combo triggered.
 *
 * ## caveats
 *
 * * a shorter combo will always mask a longer one if it is present at any point in the longer one
 *
 * @return finished combo or null
 */
/datum/combo_tracker/proc/process_inbound_via_tail_match(inbound, datum/combo_set/combo_set) as /datum/combo
	SHOULD_NOT_SLEEP(TRUE)
	stored += inbound
	return evaluate_via_tail_match(combo_set)

/datum/combo_tracker/proc/evaluate_via_tail_match(datum/combo_set/combo_set) as /datum/combo
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!stored)
		return
	var/datum/combo/found
	var/stored_length = length(stored)
	var/offset = min(0, stored_length - combo_set.computed_max_sequence_length)
	for(var/datum/combo/combo as anything in combo_set.combos)
		if(length(combo.keys) > stored_length)
			continue
		var/adjusted_offset = offset + (combo_set.computed_max_sequence_length - length(combo.keys))
		for(var/i in 1 to length(combo.keys))
			if(combo.keys[i] != stored[adjusted_offset + i])
				continue
			found = combo
			break
		if(found)
			break
	if(found)
		stored = list()
		return found
	stored.len = min(stored.len, combo_set.computed_max_sequence_length)

/**
 * ## algorithm
 *
 * * 'stored' is the current set of keys that still can trigger a combo. invalid keys will never be added to stored.
 * * after a combo is fully completed, the stored buffer is cleared.
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
 * ## returns
 * * resolved is only set when there is only one remaining
 * * position is always set if any combos are possible; it will be null if no combo is possible with the current keys
 * * finished is TRUE if resolved exists and is finished, FALSE otherwise
 * * possible will be a list of combos that are still possible with the current tracked set
 *
 * @return list(datum/combo/resolved, position, finished, list/datum/combo/possible)
 */
/datum/combo_tracker/proc/process_inbound_via_stateful_exclusive_chain(inbound, datum/combo_set/combo_set)
	SHOULD_NOT_SLEEP(TRUE)
	// reset if we changed combos
	if(combo_set != sec_set)
		sec_set = combo_set
		sec_possible = null
	// repopulate possible if it's empty
	if(!length(sec_possible))
		sec_possible = combo_set.combos.Copy()
		sec_position = 1
		stored = list()
	// see what is still valid, eject invalid ones, etc
	for(var/datum/combo/combo as anything in sec_possible)
		// if position went past last, it's no longer valid
		if(length(combo.keys) < sec_position)
			sec_possible -= combo
			continue
		// if current position in combo keys is not inbound key it's no longer valid
		if(combo.keys[sec_position] != inbound)
			sec_possible -= combo
			continue
	// if we're out of possible ones, reset and return
	if(!length(sec_possible))
		stored = list()
		sec_possible = null
		return list(null, null, FALSE, list())

	var/datum/combo/one_left = length(sec_possible) == 1 ? sec_possible[1] : null
	var/finished = one_left ? sec_position == length(one_left.keys) : FALSE

	. = list(one_left, sec_position, finished, sec_possible)

	if(finished)
		// if finished, wipe possible and it'll trigger a reset on next iteration
		sec_possible = null
	else
		// advance position otherwise
		++sec_position
