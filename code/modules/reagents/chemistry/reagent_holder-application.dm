//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Dip - will consume reagents      *//
//* Does not perform any simulation. *//

/**
 * Dip an entity into us.
 *
 * * This can cause reagent duping.
 *
 * @params
 * * target - what to dip
 * * ratio - % to apply
 * * zone - body zone to target, if any
 * * unsafe_drain_ratio - multiplier to actual drained amount. can result in reagent dupes if below 1.
 *
 * @return amount used
 */
/datum/reagent_holder/proc/perform_entity_dip(atom/target, ratio, zone, unsafe_drain_ratio = 1)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(target.atom_flags & (ATOM_ABSTRACT | ATOM_NONWORLD))
		return 0

	if(isobj(target))
		for(var/id in reagent_volumes)
			var/datum/reagent/resolved = SSchemistry.fetch_reagent(id)
			var/vol = reagent_volumes[id]
			var/used = resolved ? resolved.on_touch_obj(target, vol, vol * ratio, reagent_datas?[id]) : 0
			. += used
			if(used && unsafe_drain_ratio)
				remove_reagent(id, used * unsafe_drain_ratio, TRUE)
	else if(isturf(target))
		for(var/id in reagent_volumes)
			var/datum/reagent/resolved = SSchemistry.fetch_reagent(id)
			var/vol = reagent_volumes[id]
			var/used = resolved ? resolved.on_touch_turf(target, vol, vol * ratio, reagent_datas?[id]) : 0
			. += used
			if(used && unsafe_drain_ratio)
				remove_reagent(id, used * unsafe_drain_ratio, TRUE)
	else if(ismob(target))
		for(var/id in reagent_volumes)
			var/datum/reagent/resolved = SSchemistry.fetch_reagent(id)
			var/vol = reagent_volumes[id]
			var/used = resolved ? resolved.on_touch_mob(target, vol, vol * ratio, reagent_datas?[id], zone) : 0
			. += used
			if(used && unsafe_drain_ratio)
				remove_reagent(id, used * unsafe_drain_ratio, TRUE)

	if(.)
		reconsider_reactions()

//* Contact - will not consume reagents *//
//* Does not perform any simulation.    *//

/**
 * Apply us to an object without draining.
 *
 * * This can cause reagent duping.
 *
 * @params
 * * target - what to dip
 * * ratio - % to apply
 * * zone - body zone to target, if any
 *
 * @return amount 'used'; nothing is actually drained, so this is basically just
 *         how many units were said to be consumed by the reagent datums
 *         that object touch was called on.
 */
/datum/reagent_holder/proc/perform_entity_contact(atom/target, ratio, zone)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(target.atom_flags & (ATOM_ABSTRACT | ATOM_NONWORLD))
		return 0

	if(isobj(target))
		for(var/id in reagent_volumes)
			var/datum/reagent/resolved = SSchemistry.fetch_reagent(id)
			var/vol = reagent_volumes[id]
			. += resolved?.on_touch_obj(target, vol, vol * ratio, reagent_datas?[id])
	else if(isturf(target))
		for(var/id in reagent_volumes)
			var/datum/reagent/resolved = SSchemistry.fetch_reagent(id)
			var/vol = reagent_volumes[id]
			. += resolved?.on_touch_turf(target, vol, vol * ratio, reagent_datas?[id])
	else if(ismob(target))
		for(var/id in reagent_volumes)
			var/datum/reagent/resolved = SSchemistry.fetch_reagent(id)
			var/vol = reagent_volumes[id]
			. += resolved?.on_touch_mob(target, vol, vol * ratio, reagent_datas?[id], zone)

/**
 * Apply us to an atom or everything on a turf.
 *
 * * This can cause reagent duping.
 *
 * @params
 * * target - atom or turf to hit
 * * ratio - % to apply
 * * zone - body zone to target, if any
 * * reapplication_exclusion - a list that can be provided to provide entities that are already
 *                             sprayed on. this will be modified by this proc to associate
 *                             entities sprayed to TRUE.
 *
 * @return amount 'used'; nothing is actually drained, so this is basically just
 *         how many units were said to be consumed by the reagent datums
 *         that object touch was called on.
 */
/datum/reagent_holder/proc/perform_uniform_contact(atom/target, ratio, zone, list/reapplication_exclusion = list())
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(isturf(target))
		for(var/atom/movable/AM as anything in target.contents)
			if(AM.atom_flags & (ATOM_ABSTRACT | ATOM_NONWORLD))
				continue
			if(reapplication_exclusion[AM])
				continue
			if(isobj(AM))
				var/obj/O = AM
				if(O.is_hidden_underfloor())
					continue
			reapplication_exclusion[AM] = TRUE
			. += perform_entity_contact(AM, ratio, zone)
	if(!reapplication_exclusion[target])
		reapplication_exclusion[target] = TRUE
		. += perform_entity_contact(target, ratio, zone)

//*          Splash          *//
//* ... It's complicated.    *//

/**
 * Splashes onto, and around something.
 *
 * * This can cause reagent duping.
 *
 * @params
 * * target - what to splash on
 * * ratio - % to apply
 * * zone - target zone, if any
 * * no_drain - do not take splashed reagents out
 * * splash_coeff - ratio of reagents to splash. if on a large thing like a human,
 *                  it might first splash to other zones on them then the floor.
 *
 * @return amount 'used'; nothing is actually drained, so this is basically just
 *         how many units were said to be consumed by the reagent datums
 *         that object touch was called on.
 */
/datum/reagent_holder/proc/perform_entity_splash(atom/target, ratio, zone, no_drain, splash_coeff = 0.5)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	var/ratio_left = ratio

	// splash target
	if(!(target.atom_flags & (ATOM_ABSTRACT | ATOM_NONWORLD)))
		perform_entity_contact(target, ratio * (1 - splash_coeff), zone)
		ratio_left *= splash_coeff

	// if target was a carbon and zone wasn't specified, splash other zones
	// todo: impl

	// splash turf
	. += perform_uniform_contact(target.loc, ratio_left)

	// drain if needed
	if(!no_drain && ratio > 0)
		for(var/id in reagent_volumes)
			remove_reagent(id, reagent_volumes[id] * ratio, TRUE)
		reconsider_reactions()
