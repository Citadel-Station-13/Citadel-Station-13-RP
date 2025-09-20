#define MAX_NOTICES 8

/obj/structure/noticeboard
	name = "notice board"
	desc = "A board for pinning important notices upon."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "noticeboard"
	density = FALSE
	anchored = TRUE
	integrity_max = 150
	/// Current number of a pinned notices
	var/notices = 0

/obj/structure/noticeboard/Initialize(mapload, dir, building = FALSE)
	. = ..()

	if(building)
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -32 : 32)
		pixel_y = (dir & 3)? (dir ==1 ? -27 : 27) : 0
		update_appearance(UPDATE_ICON)

	if(!mapload)
		return

	for(var/obj/item/I in loc)
		if(notices > MAX_NOTICES)
			break
		if(istype(I, /obj/item/paper))
			I.forceMove(src)
			notices++
	update_appearance(UPDATE_ICON)

//attaching papers!!
/obj/structure/noticeboard/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/paper) || istype(O, /obj/item/photo))
		if(!allowed(user))
			to_chat(user, SPAN_WARNING("You are not authorized to add notices!"))
			return
		if(notices < MAX_NOTICES)
			if(!user.transfer_item_to_loc(O, src))
				return
			notices++
			update_appearance(UPDATE_ICON)
			to_chat(user, SPAN_NOTICE("You pin the [O] to the noticeboard."))
		else
			to_chat(user, SPAN_WARNING("The notice board is full!"))
	// else
	// 	return ..()

	if(O.is_wrench())
		to_chat(user, "<span class='notice'>You start to unwrench the noticeboard.</span>")
		playsound(src.loc, O.tool_sound, 50, 1)
		if(do_after(user, 15 * O.tool_speed))
			to_chat(user, "<span class='notice'>You unwrench the noticeboard.</span>")
			new /obj/item/frame/noticeboard( src.loc )
			qdel(src)

/obj/structure/noticeboard/ui_state(mob/user)
	return GLOB.physical_state

/obj/structure/noticeboard/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NoticeBoard", name)
		ui.open()

/obj/structure/noticeboard/ui_data(mob/user)
	var/list/data = list()
	data["allowed"] = allowed(user)
	data["items"] = list()
	for(var/obj/item/content in contents)
		var/list/content_data = list(
			name = content.name,
			ref = REF(content)
		)
		data["items"] += list(content_data)
	return data

/obj/structure/noticeboard/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	var/obj/item/item = locate(params["ref"]) in contents
	if(!istype(item) || item.loc != src)
		return

	var/mob/user = usr

	switch(action)
		if("examine")
			// if(istype(item, /obj/item/paper))
			// 	item.ui_interact(user) // not using tguipaper
			// else
			user.examinate(item)
			return TRUE
		if("remove")
			if(!allowed(user))
				return
			remove_item(item, user)
			return TRUE

/obj/structure/noticeboard/update_overlays()
	. = ..()
	if(notices)
		. += "notices_[notices]"

/**
 * Removes an item from the notice board
 *
 * Arguments:
 * * item - The item that is to be removed
 * * user - The mob that is trying to get the item removed, if there is one
 */
/obj/structure/noticeboard/proc/remove_item(obj/item/item, mob/user)
	item.forceMove(drop_location())
	if(user)
		user.put_in_hands(item)
		to_chat(user, SPAN_NOTICE("Removed from board."))
	notices--
	update_appearance(UPDATE_ICON)

/obj/structure/noticeboard/deconstructed(disassembled = TRUE)
	if(!disassembled)
		new /obj/item/stack/material/wood(loc)
	else
		new /obj/item/frame/noticeboard(loc)
	for(var/obj/item/content in contents)
		remove_item(content)

#undef MAX_NOTICES
