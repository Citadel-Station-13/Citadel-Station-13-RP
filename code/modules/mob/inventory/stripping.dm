// todo: tgui
// todo: ui state handles prechecks? interesting to deal with.
/mob/proc/mouse_drop_strip_interaction(mob/user)
	if(user.a_intent == INTENT_GRAB)
		return NONE	// riding code
	if(user == src)
		return NONE // why would we?
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	request_strip_menu(user)

/mob/proc/request_strip_menu(mob/user)
	if(!strip_interaction_prechecks(user, FALSE))
		return FALSE
	return open_strip_menu(user)

/mob/proc/open_strip_menu(mob/user)
	var/datum/browser/B = new(user, "strip_window_[REF(src)]", "[name] (stripping)", 340, 540)
	var/list/content = render_strip_menu(user)
	B.set_content(content.Join(""))
	B.open()
	return TRUE

/mob/proc/close_strip_menu(mob/user)
	user << browse(null, "window=strip_window_[REF(src)]")

/mob/proc/render_strip_menu(mob/user)
	RETURN_TYPE(/list)
	. = list()
	. += "<h1>Inventory</h1>"
	// inv slots
	. += "<hr>"
	var/list/slot_ids = get_inventory_slot_ids(semantic = TRUE, sorted = TRUE)
	var/last_order
	for(var/id in slot_ids)
		// todo: optimize
		var/datum/inventory_slot_meta/meta = resolve_inventory_slot_meta(id)
		var/remove_only = meta.inventory_slot_flags & INV_SLOT_STRIP_ONLY_REMOVES
		var/obj/item/I = _item_by_slot(id)
		if(remove_only && !I)
			continue
		var/simple = meta.inventory_slot_flags & INV_SLOT_STRIP_SIMPLE_LINK
		var/obfuscations = meta.strip_obfuscation_check(I, src, user)
		if(obfuscations & INV_VIEW_OBFUSCATE_HIDE_SLOT)
			continue
		if(last_order > 0 && meta.sort_order < 0)
			. += "<hr>"
		last_order = meta.sort_order
		if(simple)
			. += "<a href='?src=[REF(src)];strip=slot;id=[id]'>[capitalize(meta.name)]</a><br>"
		else
			var/item_known = !(obfuscations & (INV_VIEW_OBFUSCATE_HIDE_ITEM_EXISTENCE | INV_VIEW_OBFUSCATE_HIDE_ITEM_NAME))
			var/slot_text
			if(obfuscations & INV_VIEW_OBFUSCATE_HIDE_ITEM_EXISTENCE)
				slot_text = "<a href='?src=[REF(src)];strip=slot;id=[id]'>obscured</a><br>"
			else if(obfuscations & INV_VIEW_OBFUSCATE_HIDE_ITEM_NAME)
				slot_text = "<a href='?src=[REF(src)];strip=slot;id=[id]'>[I? "something" : "nothing"]</a><br>"
			else
				slot_text = "<a href='?src=[REF(src)];strip=slot;id=[id]'>[(I && I.name) || "nothing"]</a><br>"
			. += "[capitalize(meta.name)]: "
			. += slot_text
			if(I && item_known)
				var/list/options = I.strip_menu_options(user)
				if(LAZYLEN(options))
					// generate hrefs for the options
					for(var/key in options)
						var/name = options[key]
						. += "&nbsp;&nbsp;&nbsp;&nbsp;<a href='?src=[REF(src)];strip=opti;item=[REF(I)];act=[key]'>[name]</a><br>"
	. += "<hr>"

	// now for hands
	if(has_hands())
		for(var/i in 1 to get_number_of_hands())
			switch(i)
				if(1)
					. += "Left hand: "
				if(2)
					. += "Right hand: "
				else
					. += "Hand [i]: "
			var/obj/item/holding = get_held_item_of_index(i)
			. += "<a href='?src=[REF(src)];strip=hand;id=[i]'>[holding? holding.name : "nothing"]</a><br>"
		. += "<hr>"

	// now for options
	var/list/options = strip_menu_options(user)
	if(LAZYLEN(options))
		// generate hrefs for the options
		for(var/key in options)
			var/name = options[key]
			. += "<a href='?src=[REF(src)];strip=optm;act=[key]'>[name]</a><br>"
		. += "<hr>"

	// now for misc
	. += "<a href='?src=[REF(src)];strip=refresh'>Refresh</a><br>"

/mob/proc/attempt_slot_strip(mob/user, slot_id, delay_mod = 1)
	if(!strip_interaction_prechecks(user))
		return FALSE

	var/datum/inventory_slot_meta/slot_meta = resolve_inventory_slot_meta(slot_id)
	if(!slot_meta)
		return FALSE

	var/obj/item/ours = item_by_slot(slot_id)
	var/obj/item/theirs = user.get_active_held_item()
	if(!ours && !theirs)
		to_chat(user, SPAN_WARNING("They're not wearing anything in that slot!"))
		return FALSE

	if(!attempt_strip_common(ours, theirs, user, slot_id))
		return FALSE

	if(ours)
		if(temporarily_remove_from_inventory(ours, user = user))
			add_attack_logs(user, src, "Removed [ours] from slot [slot_id]")
			user.put_in_hands_or_drop(ours)
		else
			add_attack_logs(user, src, "Failed to remove [ours] from slot [slot_id]")
	else
		if(equip_to_slot_if_possible(theirs, slot_id))
			add_attack_logs(user, src, "Put [theirs] in slot [slot_id]")
		else
			add_attack_logs(user, src, "Failed to put [theirs] in slot [slot_id]")
	return TRUE

/mob/proc/attempt_hand_strip(mob/user, index, delay_mod = 1)
	if(!strip_interaction_prechecks(user))
		return FALSE

	if((index < 1) || (index > get_number_of_hands()))
		return FALSE

	var/obj/item/ours = get_held_item_of_index(index)
	var/obj/item/theirs = user.get_active_held_item()

	if(!ours && !theirs)
		to_chat(user, SPAN_WARNING("They're not holding anything in that hand!"))
		return FALSE

	if(!attempt_strip_common(ours, theirs, user, index))
		return FALSE

	if(ours)
		if(temporarily_remove_from_inventory(ours, user = user))
			add_attack_logs(user, src, "Removed [ours] from hand index [index]")
			user.put_in_hands_or_drop(ours)
		else
			add_attack_logs(user, src, "Failed to remove [ours] from hand index [index]")
	else
		if(put_in_hand(theirs, index))
			add_attack_logs(user, src, "Put [theirs] in hand index [index]")
		else
			add_attack_logs(user, src, "Failed to put [theirs] in hand index [index]")
	return TRUE

/mob/proc/attempt_strip_common(obj/item/ours, obj/item/theirs, mob/user, slot_id_or_index)
	var/removing = !!ours

	var/view_flags = NONE

	var/datum/inventory_slot_meta/slot_meta = resolve_inventory_slot_meta(slot_id_or_index)
	if(!isnum(slot_id_or_index))
		slot_meta = resolve_inventory_slot_meta(slot_id_or_index)
		view_flags = slot_meta.strip_obfuscation_check(ours, src, user)
		if(view_flags & (INV_VIEW_OBFUSCATE_HIDE_SLOT))
			return FALSE	// how are you seeing this

	var/hide_item = view_flags & (INV_VIEW_OBFUSCATE_HIDE_ITEM_NAME | INV_VIEW_OBFUSCATE_HIDE_ITEM_EXISTENCE)

	if(removing)
		if(!can_unequip(ours))
			to_chat(user, SPAN_WARNING("[ours] is stuck!"))
			return FALSE
		if(!(view_flags & INV_VIEW_STRIP_IS_SILENT))
			if(hide_item)
				visible_message(
					SPAN_DANGER("[user] is trying to remove something from [src]!"),
					SPAN_DANGER("[user] is trying to remove your [ours.name]!")
				)
			else
				visible_message(
					SPAN_DANGER("[user] is trying to remove [src]'s [ours.name]!"),
					SPAN_DANGER("[user] is trying to remove your [ours.name]!")
				)
		else
			to_chat(user, SPAN_WARNING("You start trying to sneakily remove [hide_item? "something" : ours.name] from [src]!"))
	else
		if(!user.can_unequip(theirs))
			to_chat(user, SPAN_WARNING("[theirs] is stuck to your hand!"))
			return FALSE

		// if it isn't a hand index, check semantic conflicts first so they don't waste time.
		if(!isnum(slot_id_or_index) && !inventory_slot_semantic_conflict(theirs, slot_meta, user))
			to_chat(user, SPAN_WARNING("[theirs] doesn't go there!"))
			return FALSE

		if(!(view_flags & INV_VIEW_STRIP_IS_SILENT))
			switch(slot_id_or_index)
				if(SLOT_ID_MASK)
					visible_message(
						SPAN_DANGER("[user] is trying to put \a [theirs] in [src]'s mouth!"),
						SPAN_DANGER("[user] is trying to put \a [theirs] in your mouth!")
					)
				else
					visible_message(
						SPAN_DANGER("[user] is trying to put \a [theirs] on [src]!"),
						SPAN_DANGER("[user] is trying to put \a [theirs] on you!")
					)
		else
			to_chat(user, SPAN_WARNING("You start trying to sneakily put \a [theirs] on [src]!"))

	if(!do_after(user, HUMAN_STRIP_DELAY, src, FALSE))
		if(view_flags & INV_VIEW_STRIP_FUMBLE_ON_FAILURE)
			// slot_meta must not be null if view_flags isn't NONE, so.
			to_chat(src, SPAN_WARNING("You feel something being fumbled with near your [slot_meta.name]!"))
		return FALSE

	if(removing)
		if(isnum(slot_id_or_index))
			if(get_held_index(ours) != slot_id_or_index)
				return FALSE
		else
			if(slot_by_item(ours) != slot_id_or_index)
				return FALSE
	else
		if(!user.is_holding(theirs))
			return FALSE
	return TRUE

/mob/proc/handle_strip_topic(mob/user, list/href_list, operation = href_list["strip"])
	// do checks
	if(!strip_interaction_prechecks(user))
		return
	// act
	switch(operation)
		if("slot")
			var/slot = href_list["id"]
			. = attempt_slot_strip(user, slot)
		if("hand")
			var/index = text2num(href_list["id"])
			if(!index || (index < 1) || (index > get_number_of_hands()))
				return
			. = attempt_hand_strip(user, index)
		// option mob
		if("optm")
			var/action = href_list["act"]
			. = strip_menu_act(user, action)
		// option item
		if("opti")
			var/obj/item/I = locate(href_list["item"])
			if(!istype(I) || !is_in_inventory(I))
				return
			var/slot = I.worn_slot
			if(slot != SLOT_ID_HANDS)
				var/datum/inventory_slot_meta/slot_meta = resolve_inventory_slot_meta(slot)
				var/view_flags = slot_meta.strip_obfuscation_check(I, src, user)
				if(view_flags & (INV_VIEW_OBFUSCATE_DISALLOW_INTERACT | INV_VIEW_OBFUSCATE_HIDE_ITEM_EXISTENCE | INV_VIEW_OBFUSCATE_HIDE_SLOT))
					return	// how tf are you gonna interact with it huh
			var/action = href_list["act"]
			. = I.strip_menu_act(user, action)
		if("refresh")
			// we do that later
			. = TRUE

	// refresh
	if(.)
		open_strip_menu(user)

/mob/proc/strip_interaction_prechecks(mob/user, autoclose = TRUE)
	if(!isliving(user))
		// no ghost fuckery
		return FALSE
	if(user.incapacitated())
		close_strip_menu(user)
		return FALSE
	if(!user.Adjacent(src))
		close_strip_menu(user)
		return FALSE
	return TRUE

/**
 * return a list of action = name. action should be short, for hrefs! same for name!
 */
/mob/proc/strip_menu_options(mob/user)
	RETURN_TYPE(/list)
	return list()

/**
 * use for strip menu options
 * adjacency/can act is checked already
 * return TRUE to refresh
 */
/mob/proc/strip_menu_act(mob/user, action)
	return FALSE
