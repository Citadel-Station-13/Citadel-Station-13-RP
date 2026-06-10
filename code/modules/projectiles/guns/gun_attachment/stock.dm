//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/obj/item/gun_attachment/stock
	abstract_type = /obj/item/gun_attachment/stock
	icon = 'icons/modules/projectiles/attachments/stock.dmi'
	attachment_type = GUN_ATTACHMENT_TYPE_STOCK

// Collapsible stock things
/obj/item/gun_attachment/stock/collapsible
	attachment_action_name = "Toggle Stock"
	var/collapsible = TRUE
	var/extended = FALSE

/obj/item/gun_attachment/stock/collapsible/integrated
	name = "collapsible stock"
	desc = "The gun's integrated stock"
	can_detach = FALSE
	render_on_gun = FALSE
	attachment_slot = GUN_ATTACHMENT_SLOT_STOCK

/obj/item/gun_attachment/stock/collapsible/integrated/ui_action_click(datum/action/action, datum/event_args/actor/actor)
	set_extended(!extended)

/obj/item/gun_attachment/stock/collapsible/integrated/update_icon_state()
	. = ..()
	if(!extended && magazine)
		icon_state = "[base_icon_state || initial(icon_state)]"
	else if(extended && magazine)
		icon_state = "[base_icon_state || initial(icon_state)][extended ? "-ext" : ""]"
	else if(extended && !magazine)
		icon_state = "[base_icon_state || initial(icon_state)][extended ? "-ext" : ""]-empty"
	else
		icon_state = "[base_icon_state || initial(icon_state)]-empty"

/obj/item/gun_attachment/stock/collapsible/integrated/proc/set_on(state, datum/event_args/actor/actor)
	if(extended == state)
		return
	extended = state
	update_icon()
	var/datum/action/potential_action = istype(attachment_actions, /datum/action) ? attachment_actions : null
	// todo: silent support?
	if(extended)
		to_chat(user, "<span class='notice'>You pull out the stock on the [src], steadying the weapon.</span>")
		set_weight_class(WEIGHT_CLASS_FOR_SHORT_RIFLE)
		one_handed_penalty = 10
		extended = 1
		update_icon()
	else
		to_chat(user, "<span class='notice'>You push the stock back into the [src], making it more compact.</span>")
		set_weight_class(WEIGHT_CLASS_FOR_SIDEARM)
		one_handed_penalty = 30
		extended = 0
		update_icon()
