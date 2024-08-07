//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Hands - Checks *//

/**
 * Gets effective manipulation level of a hand index
 */
/mob/proc/get_hand_manipulation_level(index)
	return HAND_MANIPULATION_PRECISE

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
		return
	if(silent)
		return
	var/list/reasons_we_cant = why_hand_manipulation_insufficient(index, manipulation)
	if(actor)
		actor.action_feedback(
			SPAN_WARNING("You can't do that right now! ([length(reasons_we_cant) ? english_list(reasons_we_cant) : "hand nonfunctional for unknown reason"])"),
			target = target,
		)
	else
		action_feedback(
			SPAN_WARNING("You can't do that right now! ([length(reasons_we_cant) ? english_list(reasons_we_cant) : "hand nonfunctional for unknown reason"])"),
			target = target,
		)

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
	var/obj/item/was_active = length(held_items) <= active_hand? held_items[active_hand] : null
	var/old_index = active_hand

	if(isnull(to_index))
		if(active_hand >= length(held_items))
			active_hand = length(held_items)? 1 : null
		else
			++active_hand
	else
		if(to_index > length(held_items))
			return FALSE
		active_hand = to_index

	. = TRUE

	hands_hud?.swap_active_hand(old_index, to_index)

	//! LEGACY
	// We just swapped hands, so the thing in our inactive hand will notice it's not the focus
	if(!isnull(was_active))
		if(was_active.zoom)
			was_active.zoom()
	//! End

#warn impl
