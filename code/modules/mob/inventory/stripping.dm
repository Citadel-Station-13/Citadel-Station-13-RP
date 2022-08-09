// todo: tgui
// todo: ui state handles prechecks? interesting to deal with.
/mob/proc/request_strip_menu(mob/user)
	if(!strip_interaction_prechecks(user, FALSE))
		return FALSE
	return open_strip_menu(user)

/mob/proc/open_strip_menu(mob/user)
	var/datum/browser/B = new(user, "strip_window_[REF(src)]", "[name] (stripping)", 340, 540)
	B.set_content(render_strip_menu(user).Join(""))
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
		var/obfuscations = NONE
		if(obfuscations & INV_VIEW_OBFUSCATE_HIDE_SLOT)
			continue
		#warn impl obfuscation
		if(simple)
			. += "<a href='?src=[REF(src)];strip=slot;id=[id]'>[capitalize(meta.display_name)]</a>"
		else
			var/item_known = obfuscations & (INV_VIEW_OBFUSCATE_HIDE_ITEM_EXISTENCE | INV_VIEW_OBFUSCATE_HIDE_ITEM_NAME)
			#warn finish + better way of rendering since 4x nbsp tabs to expensive
			if(item_known)
				var/list/options = I.strip_menu_options(user)
				if(LAZYLEN(options))
					// generate hrefs for the options
					for(var/name in options)
						var/key = options[name]
						. += "<a href='?src=[REF(src)];strip=opti;item=[REF(I)];act=[key]'>[name]</a>"

	// now for hands
	if(has_hands())
		. += "<hr>"

	// now for options
	var/list/options = strip_menu_options(user)
	if(LAZYLEN(options))
		#warn see no problem yet but when we start using it.
		// generate hrefs for the options
		for(var/name in options)
			var/key = options[name]
			. += "<a href='?src=[REF(src)];strip=optm;act=[key]'>[name]</a>"
		. += "<hr>"

	// now for misc
	. += "<hr>"
	. += "<a href='?src=[REF(src)];strip=refresh'>Refresh</a><br>"

#warn finish above

/mob/proc/attempt_slot_strip(mob/user, slot_id, delay_mod = 1)
	#warn finish

/mob/proc/attempt_hand_strip(mob/user, index, delay_mod = 1)
	#warn finish

/mob/proc/attempt_strip_common(mob/user, delay_mod = 1, obj/item/I, removing)
	#warn finish

/mob/proc/handle_strip_topic(mob/user, list/href_list, operation)
	// do checks
	if(!strip_interaction_prechecks(user))
		return
	// act
	switch(operation)
		if("slot")
			var/slot = href_list["id"]
			attempt_slot_strip(user, slot)
		if("hand")
			var/index = href_list["id"]
			attempt_hand_strip(user, slot)
		// option mob
		if("optm")
			var/action = href_list["act"]
			strip_menu_topic(user, action)
		// option item
		if("opti")
			var/obj/item/I = locate(href_list["item"])
			if(!istype(I) || !is_in_inventory(I))
				return
			var/action = href_list["act"]
			I.strip_menu_act(user, action)
		if("refresh")
			open_strip_menu(user)

/mob/proc/strip_interaction_prechecks(mob/user, autoclose = TRUE)
	if(user.incapacitated())
		close_strip_menu(user)
		return FALSE
	if(!user.Adjacent(src))
		close_strip_menu(user)
		return FALSE
	return TRUE

/**
 * return a list of name = action. action should be short, for hrefs! same for name!
 */
/mob/proc/strip_menu_options(mob/user)
	return

/**
 * use for strip menu options
 * adjacency/can act is checked already
 */
/mob/proc/strip_menu_act(mob/user, action)
	return FALSE
