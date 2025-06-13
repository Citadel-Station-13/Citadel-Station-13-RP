//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/retail_tagger
	name = "retail tagger"
	desc = "A device that can affix price labels to things."

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
	if(.)
		return

	switch(action)
		if("toggleAuto")
			automatic_mode = !!params["value"]
			return TRUE
		if("setManualPrice")
			var/price = params["price"]
			if(!is_safe_number(price))
				return TRUE
			manual_set_price = price
			return TRUE
		if("setAutoMarkup")
			var/markup = params["value"]
			if(!is_safe_number(markup))
				return TRUE
			auto_set_markup = markup
			return TRUE

/obj/item/retail_tagger/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["automatic"] = automatic_mode
	.["manualPrice"] = manual_set_price
	.["autoMarkup"] = auto_set_markup

/obj/item/retail_tagger/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "items/RetailTagger.tsx")
		ui.open()
		#warn impl ui

/obj/item/retail_tagger/using_as_item(atom/target, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
	. = ..()
	if(.)
		return
	// no moca you can't have your 2.51$ catgirl gimmick
	if(iscarbon(target))
		return
	tag_entity(target, e_args)
	return CLICKCHAIN_DID_SOMETHING

/obj/item/retail_tagger/proc/tag_entity(atom/movable/target, datum/event_args/actor/actor, silent)
	if(!istype(target))
		return FALSE
	#warn impl

	return TRUE
