//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/machinery/point_redemption_vendor
	name = "point redemption vendor"
	desc = "An equipment vendor that trades points for various gear. Usually found in the station's departments \
		and used to incentivize good performance."
	density = TRUE
	anchored = TRUE

	/// point type we operate with
	var/point_type

	/// flick tihs state when denying sometihng
	var/icon_state_append_deny
	/// set to this state if panel is open
	//  todo: render at /obj/machinery level
	var/icon_state_append_open
	/// set to this state if we're depowered
	//  todo: render at /obj/machinery level
	var/icon_state_append_off
	/// flick this state when vending something
	var/icon_state_append_vend
	/// set to this state if we're broken
	var/icon_state_append_broken

	/// The inserted ID, if any
	var/obj/item/card/id/inserted_id

	/// available items
	var/list/datum/point_redemption_item/prize_list = list()

/obj/machinery/point_redemption_vendor/update_icon_state()
	var/icon_base_state = base_icon_state || initial(icon_state)
	var/is_broken = atom_flags & ATOM_BROKEN
	if(is_broken && icon_state_append_broken)
		icon_state = "[icon_base_state][icon_state_append_broken]"
	else if((!powered() || is_broken) && icon_state_append_off)
		icon_state = "[icon_base_state][icon_state_append_off]"
	else if(panel_open)
		icon_state = "[icon_base_state][icon_state_append_open]"
	else
		icon_state = icon_base_state
	return ..()

/obj/machinery/point_redemption_vendor/power_change()
	var/old_stat = stat
	. = ..()
	// todo: machine-level update icon hook?
	if(stat != old_stat)
		update_icon()
	if(!powered() && inserted_id)
		SPAN_NOTICE("The ID slot indicator light on [src] flickers as it spits out [inserted_id].")
		inserted_id.forceMove(drop_location())

/obj/machinery/point_redemption_vendor/drop_products(method, atom/where)
	. = ..()
	if(inserted_id)
		drop_product(inserted_id, where)
		inserted_id = null

/obj/machinery/point_redemption_vendor/using_item_on(obj/item/using, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(istype(using, /obj/item/card/id))
		if(inserted_id)
			e_args?.chat_feedback(
				SPAN_WARNING("[src] already has an inserted ID."),
				target = src,
			)
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		#warn impl

/obj/machinery/point_redemption_vendor/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("idcard")
		if("buy")

/obj/machinery/point_redemption_vendor/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "machines/PointRedemptionVendor.tsx")
		ui.set_title(name)
		ui.open()

/obj/machinery/point_redemption_vendor/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["pointName"] = point_type
	var/list/serialized_items = list()
	for(var/datum/point_redemption_item/item in prize_list)
		serialized_items[++serialized_items.len] = list(
			"name" = item.name,
			"desc" = item.desc,
			"cost" = item.cost,
		)
	.["availableItems"] = serialized_items

/obj/machinery/point_redemption_vendor/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["points"] = inserted_id ? inserted_id.get_redemption_points(point_type) : 0
	.["insertedId"] = inserted_id ? list(
		"name" = inserted_id.name,
		"rank" = inserted_id.rank,
		"owner" = inserted_id.registered_name,
	) : null

