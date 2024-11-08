//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/action/organ_action
	target_type = /obj/item/organ
	button_icon_state = null

	/// automatically set button_additional_overlay to the organ
	var/render_organ_as_button = TRUE

/datum/action/organ_action/pre_render_hook()
	if(render_organ_as_button && isnull(button_icon_state))
		button_additional_only = TRUE
		var/image/generated = new
		generated.appearance = target
		// i hope you are not doing custom layers and planes for icons, right gamers??
		generated.layer = FLOAT_LAYER
		generated.plane = FLOAT_PLANE
		button_additional_overlay = generated
	return ..()

// todo: default check availability & a hook for updating it?
