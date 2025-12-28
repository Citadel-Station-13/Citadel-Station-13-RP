//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/action/robot_pick_resting_variation
	name = "Pick Resting Variation"
	desc = "Pick the variation of your chassis' resting sprite to use."
	target_type = /mob/living/silicon/robot

/datum/action/robot_pick_resting_variation/pre_render_hook()
#warn impl

/datum/action/robot_pick_resting_variation/invoke_target(mob/living/silicon/robot/target, datum/event_args/actor/actor)
	// resolve iconset variations
	var/datum/prototype/robot_iconset/base = target.iconset
	var/list/datum/robot_iconset_variation/variations = list()
	for(var/id in target.iconset?.variations)
		var/datum/robot_iconset_variation/variation = target.iconset.variations[id]
		if(variation.alt_resting_state)
			variations += variation
	if(length(variations) <= 1)
		actor.chat_feedback(
			SPAN_WARNING("Your chassis has no resting variations to pick from."),
			target = target,
		)
		return TRUE

	// assemble radial choices
	var/list/assembled_radial_choices = list()
	for(var/datum/robot_iconset_variation/variation as anything in variations)
		var/image/built = image(
			variation.icon_override || base.icon,
			variation.icon_state || "[base.icon_state][variation.icon_state_append]",
		)
		built.maptext = MAPTEXT_CENTER(variation.id)
		assembled_radial_choices[variation.id] = built

	// ask them
	var/picked_id = show_radial_menu(actor.initiator, target, assembled_radial_choices)

	// check & update
	if(!target.iconset?.variations[picked_id])
		return TRUE
	if(target.picked_resting_variation == picked_id)
		return TRUE
	#warn log
	target.picked_resting_variation = picked_id
	target.update_icon()
