#warn impl oh god oh fuck

/mob/proc/request_strip_menu(mob/user, ignore_adjacency = FALSE, ignore_incapacitation = FALSE)
	if(!ignore_incapacitation && user.incapacitated())
		return FALSE
	if(!ignore_adjacency && !user.Adjacent(src))
		return FALSE

/mob/proc/open_strip_menu(mob/user)
	var/datum/browser/B = new(user, "strip_window_[REF(src)]", "[name] (stripping)", 340, 540)
	B.set_content(render_strip_menu(user).Join(""))
	B.open()

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
		#warn impl obfuscation
		if(simple)

		else

			var/list/options =
			// generate hrefs for the options

	// now for hands
	. += "<hr>"


/mob/proc/handle_strip_topic(mob/user, list/href_list)
