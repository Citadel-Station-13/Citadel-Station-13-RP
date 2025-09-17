//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Hands are weird. Unlike inventory slots, they tend to be very tightly  *//
//* coupled to organ state, so it's not a good thing to have all behavior  *//
//* on /datum/inventory.                                                   *//
//*                                                                        *//
//* To make it worse, hands are not just an inventory concept; interacting *//
//* with the world requires hands, which requires hand code, meaning hand  *//
//* code cannot only live on /datum/inventory.                             *//
//*                                                                        *//
//* Therefore, the separation of concerns is that mob-side hands code      *//
//* is only responsible for orchestrating state that concerns the health   *//
//* system like organ integration and whatnot, while /datum/inventory      *//
//* side orchestrates pickup/drop logic and all that stuff.                *//
//*                                                                        *//
//* An abstraction layer provides mob integration to the inventory datum.  *//
//* That is what is in this file, along with common mob-level handling     *//
//* for non-inventory-related uses of hands.                               *//
//*                                                                        *//
//* Any purpose / notion of 'usable' hands also belongs here, because our  *//
//* inventory datum has no notion of a usable hand or an unusable one, let *//
//* alone manipulation levels, as it only cares about the actual state     *//
//* of whether or not an object is held.                                *//

//* Hands - Abstraction *//

/**
 * gets if we have any hands at all
 */
/mob/proc/has_hands()
	SHOULD_NOT_OVERRIDE(TRUE)
	return !!get_nominal_hand_count()

/**
 * get number of physical hands / arms / whatever that we have and should check for
 *
 * this is not number we can use
 * this is the number we should use for things like rendering
 * a hand stump is still rendered, and we should never render less than 2 hands for mobs
 * that nominally have hands.
 */
/mob/proc/get_nominal_hand_count()
	return length(inventory?.held_items)

/**
 * get number of usable hands / arms / whatever that we have and should check for
 *
 * this is the number we can use
 * missing = can't use
 * stump = can't use
 * broken = *can* use.
 *
 * basically if a red deny symbol is in the hand it is not usable, otherwise it's usable.
 */
/mob/proc/get_usable_hand_count() as num
	return get_nominal_hand_count()

/**
 * get indices of usable hands
 */
/mob/proc/get_usable_hand_indices() as /list
	RETURN_TYPE(/list)
	. = list()
	for(var/i in 1 to get_nominal_hand_count())
		. += i

/**
 * Are usable hands all holding items?
 *
 * * if a hand slot is unusable but still has an item, it's ignored.
 * * if we have no hands, this returns TRUE
 */
/mob/proc/are_usable_hands_full()
	if(!length(inventory?.held_items))
		return TRUE
	for(var/i in get_usable_hand_indices())
		if(isnull(inventory.held_items[i]))
			return FALSE
	return TRUE

/**
 * usable hands are all empty?
 *
 * * if a hand slot is unusable but still has an item, it's ignored.
 * * if we have no hands, this returns TRUE
 */
/mob/proc/are_usable_hands_empty()
	if(!length(inventory?.held_items))
		return TRUE
	for(var/i in get_usable_hand_indices())
		if(isnull(inventory.held_items[i]))
			continue
		return FALSE
	return TRUE

//* Hands - Checks *//

/**
 * Gets effective manipulation level of a hand index
 */
/mob/proc/get_hand_manipulation_level(index)
	return HAND_MANIPULATION_PRECISE

// todo: can we combine all these procs?

/**
 * Checks if a hand can be used at a given manipulation level.
 */
/mob/proc/is_hand_manipulation_sufficient(index, manipulation)
	// until there's a reason to do otherwise, get_hand_manipulation_level() should be what you override!
	SHOULD_NOT_OVERRIDE(TRUE)
	return get_hand_manipulation_level(index) >= manipulation

/**
 * get a list of reasons (e.g. 'broken bone', 'stunned', etc)
 * a hand **cannot** be at a certain manipulation level.
 */
/mob/proc/why_hand_manipulation_insufficient(index, manipulation)
	RETURN_TYPE(/list)
	return list()

//* Hands - Helpers *//

/**
 * Runs a standard hand usability check against a target with a given manipulation level required.
 *
 * @params
 * * target - what is being interacted with
 * * index - hand index being used
 * * manipulation - required manipulation level
 * * actor - (optional) interactor
 * * silent - (optional) if set, will not emit error message
 *
 * @return TRUE / FALSE sucecss / fail
 */
/mob/proc/standard_hand_usability_check(atom/target, index, manipulation, datum/event_args/actor/actor, silent)
	if(is_hand_manipulation_sufficient(index, manipulation))
		return TRUE
	if(silent)
		return FALSE
	var/list/reasons_we_cant = why_hand_manipulation_insufficient(index, manipulation)
	if(actor)
		actor.chat_feedback(
			SPAN_WARNING("You can't do that right now! ([length(reasons_we_cant) ? english_list(reasons_we_cant) : "hand nonfunctional for unknown reason"])"),
			target = target,
		)
	else
		action_feedback(
			SPAN_WARNING("You can't do that right now! ([length(reasons_we_cant) ? english_list(reasons_we_cant) : "hand nonfunctional for unknown reason"])"),
			target = target,
		)
	return FALSE

//* Hands - Identity *//

/**
 * Returns something like "left hand", "right hand", "3rd right hand", "left hand #2", etc.
 */
/mob/proc/get_hand_generalized_name(index)
	var/number_on_side = round(index / 2)
	return "[index % 2? "left" : "right"] hand[number_on_side > 1 && " #[number_on_side]"]"

//* Hands - Legacy / WIP *//

/**
 * Swaps our active hand
 *
 * * In the future, we'll want to track active hand, attack intents, etc, by operator, instead of by mob.
 * * This is so remote control abstraction works.
 */
/mob/proc/swap_hand(to_index)
	if(active_hand == to_index)
		return
	var/hand_count = get_nominal_hand_count()
	var/obj/item/was_active = get_active_held_item()
	var/old_index = active_hand || 1

	if(isnull(to_index))
		if(active_hand >= hand_count)
			active_hand = hand_count? 1 : null
		else
			++active_hand
	else
		if(to_index > hand_count)
			return FALSE
		active_hand = to_index
	to_index = active_hand

	. = TRUE

	client?.actor_huds?.inventory?.swap_active_hand(old_index, to_index)

	//! LEGACY
	if(was_active?.zoom)
		was_active?.zoom()
	//! End
