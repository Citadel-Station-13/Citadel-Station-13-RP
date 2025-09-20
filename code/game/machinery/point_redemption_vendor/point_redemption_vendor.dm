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
	var/old_stat = machine_stat
	. = ..()
	// todo: machine-level update icon hook?
	if(machine_stat != old_stat)
		update_icon()
	if(!powered() && inserted_id)
		visible_message(
			SPAN_NOTICE("The ID slot indicator light on [src] flickers as it spits out [inserted_id]."),
		)
		inserted_id.forceMove(drop_location())

/obj/machinery/point_redemption_vendor/drop_products(method, atom/where)
	. = ..()
	if(inserted_id)
		drop_product(inserted_id, where)
		inserted_id = null

/obj/machinery/point_redemption_vendor/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(handle_id_insertion(using, clickchain))
		// in either case they wouldn't do anything because the id is either not on them anymore
		// or is not going to touch the machine
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/**
 * @return TRUE if handled
 */
/obj/machinery/point_redemption_vendor/proc/handle_id_insertion(obj/item/maybe_id, datum/event_args/actor/actor)
	if(!istype(maybe_id, /obj/item/card/id))
		return FALSE
	if(inserted_id)
		actor.chat_feedback(
			SPAN_WARNING("[src] already has an inserted ID."),
			target = src,
		)
		return TRUE
	if(!actor.performer.attempt_insert_item_for_installation(maybe_id, src))
		return TRUE
	actor.chat_feedback(
		SPAN_NOTICE("You insert [maybe_id] into [src]'s card slot."),
		target = src,
	)
	inserted_id = maybe_id
	return TRUE

/obj/machinery/point_redemption_vendor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	switch(action)
		if("idcard")
			if(inserted_id)
				actor.visible_feedback(
					target = src,
					range = MESSAGE_RANGE_INVENTORY_SOFT,
					visible = SPAN_NOTICE("[actor.performer] retrieves [inserted_id] from [src]."),
				)
				actor.performer.put_in_hands_or_drop(inserted_id)
				inserted_id = null
			else if(!inserted_id)
				var/obj/item/active_held = actor.performer.get_active_held_item()
				handle_id_insertion(active_held, actor)
			return TRUE
		if("vend")
			if(!inserted_id)
				return TRUE
			// double-verify incase entry changed; we don't give them the refs though so
			// no locate() in list!
			var/target_index = params["index"]
			var/target_name = params["name"]
			if(target_index < 1 || target_index > length(prize_list))
				update_static_data(hard_refresh = TRUE)
				return TRUE
			var/datum/point_redemption_item/resolved = prize_list[target_index]
			if(resolved.name != target_name)
				update_static_data(hard_refresh = TRUE)
				return TRUE
			if(inserted_id.get_redemption_points(point_type) < resolved.cost)
				return TRUE
			inserted_id.adjust_redemption_points(point_type, -resolved.cost)
			vend_item(resolved)
			return TRUE

/obj/machinery/point_redemption_vendor/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "machines/PointRedemptionVendor")
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

/obj/machinery/point_redemption_vendor/proc/vend_item(datum/point_redemption_item/item)
	item.instantiate(drop_location())
	flick_vend()
	return TRUE

/obj/machinery/point_redemption_vendor/proc/flick_deny()
	if(!icon_state_append_deny)
		return
	flick("[base_icon_state || initial(icon_state)][icon_state_append_deny]", src)

/obj/machinery/point_redemption_vendor/proc/flick_vend()
	if(!icon_state_append_vend)
		return
	flick("[base_icon_state || initial(icon_state)][icon_state_append_vend]", src)
