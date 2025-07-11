//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * * Examining is **not** stateless. There's various hooks that fire when examines are used,
 *   including gameplay function hooks.
 *
 * @params
 * * examine - examiner args
 * * examine_for - examining for flags so we don't compute stuff we don't need to
 * * examine_from - examining from flags to communicate where the examine is coming from
 *
 * @return /datum/event_args/examine_output or null to not allow examine.
 */
/atom/proc/examine_new(datum/event_args/examine/examine, examine_for, examine_from)
	examine = pre_examine(
		examine,
		examine_for,
		examine_from,
	)
	if(!examine || !examine.examined)
		return

	return examine.examined.run_examine(
		examine,
		examine_for,
		examine_from,
	)

/**
 * @params
 * * examine - examiner args
 * * examine_for - examining for flags so we don't compute stuff we don't need to
 * * examine_from - examining from flags to communicate where the examine is coming from
 *
 * @return /datum/event_args/examine, or null to not allow examine.
 */
/atom/proc/pre_examine(datum/event_args/examine/examine, examine_for, examine_from)
	return examine

/**
 * @params
 * * examine - examiner args
 * * examine_for - examining for flags so we don't compute stuff we don't need to
 * * examine_from - examining from flags to communicate where the examine is coming from
 *
 * @return /datum/event_args/examine_output or null to not allow examine.
 */
/atom/proc/run_examine(datum/event_args/examine/examine, examine_for, examine_from)
	var/datum/event_args/examine_output/output = new
	if(examine_for & EXAMINE_FOR_NAME)
		output.entity_name = get_examine_name(examine, examine_for, examine_from)
	if(examine_for & EXAMINE_FOR_DESC)
		output.entity_desc = get_examine_desc(examine, examine_for, examine_from)
	if(examine_for & EXAMINE_FOR_RENDER)
		output.entity_appearance = appearance
		LAZYADD(output.required_appearances, appearance)
	return output

/**
 * Gets the name we should show in examine.
 *
 * @params
 * * ...
 * * ...
 * * ...
 * * embed_look_href - embed the href needed to look at us by click. Overridden to 'off' if examine
 *                     is not a live one.
 */
/atom/proc/get_examine_name(datum/event_args/examine/examine, examine_for, examine_from)
	return "[gender == PLURAL ? "some" : "a"][blood_DNA ? " <span class='warning'>blood-stained</span> " : ""][name]"

/atom/proc/get_examine_desc(datum/event_args/examine/examine, examine_for, examine_from)
	return desc

// TODO: re-evaluate below

/**
 * Gets a list of usage tips that players should be able to see.
 *
 * * These should not depend on the user's inhand items / worn equipment / whatever.
 * * These are fully HTML-formatted
 * * These will be formatted into list entries by the caller.
 *
 * @return list
 */
/atom/proc/examine_query_usage_hints(datum/event_args/examine/examining)
	return list()

/**
 * Gets a list of introspected data, like recharge delays, that players should be able to see.
 *
 * * These should not depend on the user's inhand items / worn equipment / whatever.
 * * These are fully HTML-formatted
 * * This can return either key-values or just strings.
 * * These will be formatted into list entries by the caller.
 *
 * @return list(key = value, key only, ...)
 */
/atom/proc/examine_query_stat_hints(datum/event_args/examine/examining)
	return list()
