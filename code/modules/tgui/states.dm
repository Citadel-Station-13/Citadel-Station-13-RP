/*!
 * Base state and helpers for states. Just does some sanity checks,
 * implement a proper state for in-depth checks.
 *
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * private
 *
 * Checks if a user can use src_object's UI, and returns the state.
 * Can call a mob proc, which allows overrides for each mob.
 *
 * required src_object datum The object/datum which owns the UI.
 * required user mob The mob who opened/is using the UI.
 *
 * return UI_state The state of the UI.
 */
/datum/ui_state/proc/can_use_topic(src_object, mob/user)
	// Don't allow interaction by default.
	return UI_CLOSE

/**
 * public
 *
 * Standard interaction/sanity checks. Different mob types may have overrides.
 *
 * return UI_state The state of the UI.
 */
/mob/proc/shared_ui_interaction(src_object)
	// Close UIs if mindless.
	if(!client)
		return UI_CLOSE
	// Disable UIs if unconscious.
	else if(stat)
		return UI_DISABLED
	// Update UIs if incapicitated but conscious.
	else if(incapacitated())
		return UI_UPDATE
	return UI_INTERACTIVE

// /mob/living/shared_ui_interaction(atom/src_object)
// 	. = ..()
// 	if(!(mobility_flags & MOBILITY_UI) && !(src_object.interaction_flags_atom & INTERACT_ATOM_IGNORE_MOBILITY) && . == UI_INTERACTIVE)
// 		return UI_UPDATE

/mob/living/silicon/ai/shared_ui_interaction(src_object)
	// Disable UIs if the AI is unpowered.
	// if(apc_override == src_object) //allows AI to (eventually) use the interface for their own APC even when out of power
	// 	return UI_INTERACTIVE
	if(lacks_power())
		return UI_DISABLED
	return ..()

/mob/living/silicon/robot/shared_ui_interaction(src_object)
	// Disable UIs if the object isn't installed in the borg AND the borg is either locked, has a dead cell, or no cell.
	var/atom/device = src_object
	if((istype(device) && device.loc != src) && (!cell || cell.charge <= 0 || lockcharge))
		return UI_DISABLED
	return ..()

/**
 * public
 *
 * Distance versus interaction check.
 *
 * required src_object atom/movable The object which owns the UI.
 *
 * return UI_state The state of the UI.
 */
/mob/living/proc/shared_living_ui_distance(atom/movable/src_object, viewcheck = TRUE, allow_tk = TRUE)
	// If the object is obscured, close it.
	if(viewcheck && !(src_object in view(src)))
		return UI_CLOSE
	var/dist = get_dist(src_object, src)
	// Open and interact if 1-0 tiles away.
	if(dist <= 1)
		return UI_INTERACTIVE
	// View only if 2-3 tiles away.
	else if(dist <= 2)
		return UI_UPDATE
	// Disable if 5 tiles away.
	else if(dist <= 5)
		return UI_DISABLED
	// Otherwise, we got nothing.
	return UI_CLOSE

/mob/living/carbon/human/shared_living_ui_distance(atom/movable/src_object, viewcheck = TRUE, allow_tk = TRUE)
	if(allow_tk && (MUTATION_TELEKINESIS in mutations))
		return UI_INTERACTIVE
	return ..()

/**
 * public
 *
 * TODO: what's this for?
 *
 * Check the distance for a living mob.
 * Really only used for checks outside the context of a mob.
 * Otherwise, use shared_living_ui_distance().
 *
 * required src_object The object which owns the UI.
 * required user mob The mob who opened/is using the UI.
 *
 * return UI_state The state of the UI.
 */
/atom/proc/contents_ui_distance(src_object, mob/living/user)
	// Just call this mob's check.
	return user.shared_living_ui_distance(src_object)
