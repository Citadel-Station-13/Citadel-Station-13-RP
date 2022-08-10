// todo: tgui
// todo: ui state handles prechecks? interesting to deal with.
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
		if(last_order > 0 && meta.sort_order < 0)
			. += "<hr>"
		last_order = meta.sort_order
		var/remove_only = meta.inventory_slot_flags & INV_SLOT_STRIP_ONLY_REMOVES
		var/obj/item/I = _item_by_slot(id)
		if(remove_only && !I)
			continue
		var/simple = meta.inventory_slot_flags & INV_SLOT_STRIP_SIMPLE_LINK
		var/obfuscations = meta.strip_obfuscation_check(I, src, user)
		if(obfuscations & INV_VIEW_OBFUSCATE_HIDE_SLOT)
			continue
		if(simple)
			. += "<a href='?src=[REF(src)];strip=slot;id=[id]'>[capitalize(meta.display_name)]</a><br>"
		else
			var/item_known = obfuscations & (INV_VIEW_OBFUSCATE_HIDE_ITEM_EXISTENCE | INV_VIEW_OBFUSCATE_HIDE_ITEM_NAME)
			var/slot_text
			if(obfuscations & INV_VIEW_OBFUSCATE_HIDE_ITEM_EXISTENCE)
				slot_text = "<a href='?src=[REF(src)];strip=slot;id=[id]'> (Obscured) </a><br>"
			else if(obfuscations & INV_VIEW_OBFUSCATE_HIDE_ITEM_NAME)
				slot_text = "<a href='?src=[REF(src)];strip=slot;id=[id]'> ([I? "Full" : "Empty"]) </a><br>"
			else
				slot_text = "<a href='?src=[REF(src)];strip=slot;id=[id]'> [I.name] </a><br>"
			. += "[capitalize(meta.display_name)]: "
			. += slot_text
			if(item_known)
				var/list/options = I.strip_menu_options(user)
				if(LAZYLEN(options))
					// generate hrefs for the options
					for(var/key in options)
						var/name= options[name]
						. += "    <a href='?src=[REF(src)];strip=opti;item=[REF(I)];act=[key]'>[name]</a><br>"

	// now for hands
	if(has_hands())
		. += "<hr>"

	// now for options
	var/list/options = strip_menu_options(user)
	if(LAZYLEN(options))
		// generate hrefs for the options
		for(var/key in options)
			var/name = options[name]
			. += "<a href='?src=[REF(src)];strip=optm;act=[key]'>[name]</a><br>"
		. += "<hr>"

	// now for misc
	. += "<hr>"
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
		to_chat(user, SPAN_WARNING("There's nothing [slot_meta.display_preposition] their [slot_meta.display_name]."))
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

	#warn check strip obfuscations

	if(removing)
		if(!can_unequip(ours))
			to_chat(user, SPAN_WARNING("[ours] is stuck!"))
			return FALSE

		visible_message(
			SPAN_DANGER("[user] is trying to remove [src]'s [ours]!"),
			SPAN_DANGER("[user] is trying to remove your [ours]!")
		)
	else
		if(!user.can_unequip(theirs))
			to_chat(user, SPAN_WARNING("[theirs] is stuck to your hand!"))
			return FALSE


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

	if(!do_after(user, HUMAN_STRIP_DELAY, src, FALSE))
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

/mob/proc/handle_strip_topic(mob/user, list/href_list, operation)
	// do checks
	if(!strip_interaction_prechecks(user))
		return
	// act
	switch(operation)
		if("slot")
			var/slot = href_list["id"]
			. = attempt_slot_strip(user, slot)
		if("hand")
			var/index = href_list["id"]
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
	return

/**
 * use for strip menu options
 * adjacency/can act is checked already
 * return TRUE to refresh
 */
/mob/proc/strip_menu_act(mob/user, action)
	return FALSE
