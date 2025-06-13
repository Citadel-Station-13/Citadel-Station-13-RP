//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/action/robot_pick_resting_variation
	name = "Pick Resting Variation"
	desc = "Pick the variation of your chassis' resting sprite to use."
	target_type = /mob/living/silicon/robot

/datum/action/robot_pick_resting_variation/pre_render_hook()

/datum/action/robot_pick_resting_variation/invoke_target(mob/living/silicon/robot/target, datum/event_args/actor/actor)

	var/list/assembled_radial_choices = list()

	var/picked_radial_choice = show_radial_menu(actor.initiator, target, assembled_radial_choices)
#warn impl


