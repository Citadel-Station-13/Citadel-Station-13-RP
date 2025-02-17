//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/retail_tagger

	#warn sprite

	/// are we in auto mode?
	var/automatic_mode = FALSE

	/// manual mode: price to set
	/// * set to 0 or null to remove tags
	var/manual_set_price = 0

	/// auto mode: markup (or markdown) as multiplier
	var/auto_set_markup = 1

/obj/item/retail_tagger/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/obj/item/retail_tagger/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/item/retail_tagger/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)

/obj/item/retail_tagger/using_as_item(atom/target, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
	. = ..()

/obj/item/retail_tagger/proc/tag_object(obj/target, datum/event_args/actor/actor, silent)

#warn impl all
