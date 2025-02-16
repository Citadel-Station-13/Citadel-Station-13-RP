//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/action/item_action
	target_type = /obj/item
	button_icon_state = null

	/// automatically set button_additional_overlay to the item, if button_icon_state is null
	var/render_item_as_button = TRUE

/datum/action/item_action/pre_render_hook()
	if(render_item_as_button && isnull(button_icon_state))
		button_additional_only = TRUE
		var/image/generated = new
		var/obj/item/item_target = target
		item_target.compile_overlays()
		generated.appearance = target
		// i hope you are not doing custom layers and planes for icons, right gamers??
		generated.layer = FLOAT_LAYER
		generated.plane = FLOAT_PLANE
		button_additional_overlay = generated
	return ..()

/datum/action/item_action/calculate_availability()
	if(!check_mobility_flags)
		return 1
	var/obj/item/item = target
	var/mob/worn = item.get_worn_mob()
	return worn? (worn.mobility_flags & check_mobility_flags? 1 : 0) : 1
