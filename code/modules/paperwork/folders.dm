/obj/item/folder
	name = "folder"
	desc = "A folder."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "folder"
	w_class = WEIGHT_CLASS_SMALL
	pressure_resistance = 2
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

	/// The background color for tgui in hex (with a `#`)
	var/bg_color = "#7f7f7f"
	/// A typecache of the objects that can be inserted into a folder
	var/static/list/folder_insertables = typecacheof(list(
		/obj/item/paper,
		/obj/item/photo,
		/obj/item/paper_bundle,
	))
	/// Do we hide the contents on examine?
	var/contents_hidden = FALSE

/obj/item/folder/Initialize(mapload)
	update_icon()
	. = ..()

/obj/item/folder/Destroy()
	for(var/obj/important_thing in contents)
		if(!(important_thing.integrity_flags & INTEGRITY_INDESTRUCTIBLE))
			continue
		important_thing.forceMove(drop_location()) //don't destroy round critical content such as objective documents.
	return ..()

/obj/item/folder/proc/rename(mob/user, obj/item/writing_instrument)
	if(istype(writing_instrument, /obj/item/pen))
		return

	var/inputvalue = sanitizeSafe(input(user, "What would you like to label the folder?", "Folder Labelling", null) as text, MAX_NAME_LEN)
	if(!inputvalue)
		return

	name = "folder[(inputvalue ? " - '[inputvalue]'" : null)]"
	// playsound(src, SFX_WRITING_PEN, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, SOUND_FALLOFF_EXPONENT + 3, ignore_walls = FALSE)

/obj/item/folder/proc/remove_item(obj/item/Item, mob/user)
	if(istype(Item))
		Item.forceMove(user.loc)
		user.put_in_hands(Item)
		to_chat(user, SPAN_NOTICE("You remove [Item] from [src]."))
		update_icon()

/obj/item/folder/update_overlays()
	. = ..()
	if(contents.len)
		. += "folder_paper"

/obj/item/folder/attackby(obj/item/weapon, mob/user, params)
	if(is_type_in_typecache(weapon, folder_insertables))
		//Add paper, photo or documents into the folder
		if(!user.transfer_item_to_loc(weapon, src))
			return
		to_chat(user, SPAN_NOTICE("You put [weapon] into [src]."))
		update_appearance()
	else if(istype(weapon, /obj/item/pen))
		rename(user, weapon)

/obj/item/folder/attack_self(mob/user)
	add_fingerprint(usr)
	ui_interact(user)
	return

/obj/item/folder/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Folder")
		ui.open()

/obj/item/folder/ui_data(mob/user)
	var/list/data = list()
	// if(istype(src, /obj/item/folder/syndicate))
	// 	data["theme"] = "syndicate"
	data["bg_color"] = "[bg_color]"
	data["folder_name"] = "[name]"

	data["contents"] = list()
	data["contents_ref"] = list()
	for(var/Content in src)
		data["contents"] += "[Content]"
		data["contents_ref"] += "[REF(Content)]"

	return data

/obj/item/folder/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	if(usr.stat != CONSCIOUS || usr.restrained())
		return

	switch(action)
		// Take item out
		if("remove")
			var/obj/item/Item = locate(params["ref"]) in src
			remove_item(Item, usr)
			. = TRUE
		// Inspect the item
		if("examine")
			var/obj/item/Item = locate(params["ref"]) in src
			if(istype(Item))
				usr.examinate(Item)
				. = TRUE
