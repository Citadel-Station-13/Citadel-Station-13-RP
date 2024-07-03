//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/action/item_action
	target_type = /obj/item

	/// automatically set button_additional_overlay to the item
	var/render_item_as_button = TRUE

/datum/action/item_action/pre_render_hook()
	if(render_item_as_button)
		button_additional_only = TRUE
		var/image/generated = new
		generated.appearance = target
		// i hope you are not doing custom layers and planes for icons, right gamers??
		generated.layer = FLOAT_LAYER
		generated.plane = FLOAT_PLANE
		button_additional_overlay = generated
	return ..()

/datum/action/item_action/calculate_availability()
	var/obj/item/item = target
	var/mob/worn = item.worn_mob()
	return worn? (worn.mobility_flags & check_mobility_flags? 1 : 0) : 1
