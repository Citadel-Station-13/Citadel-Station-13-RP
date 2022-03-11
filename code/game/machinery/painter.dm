// I'm honestly pretty sure that short of stuffing five million things into this
// there's absolutely no way it could ever have any performance impact
// Given that all it does is set the color var
// But just in case it's cursed in some arcane horrible way
// I'm going to leave this limit here
#define MAX_PROCESSING 10 // Arbitrary performance insurance

/obj/machinery/gear_painter
	name = "Color Mate"
	desc = "A machine to give your apparel a fresh new color! Recommended to use with white items for best results."
	icon = 'icons/obj/vending.dmi'
	icon_state = "colormate"
	density = TRUE
	anchored = TRUE
	var/list/processing = list()
	var/activecolor = "#FFFFFF"
	var/list/color_matrix_last
	var/matrix_mode = FALSE
	var/list/allowed_types = list(
			/obj/item/clothing,
			/obj/item/storage/backpack,
			/obj/item/storage/belt,
			/obj/item/toy
			)

/obj/machinery/gear_painter/Initialize(mapload)
	. = ..()
	color_matrix_last = list(
		1, 0, 0,
		0, 1, 0,
		0, 0, 1,
		0, 0, 0
	)

/obj/machinery/gear_painter/update_icon()
	if(panel_open)
		icon_state = "colormate_open"
	else if(inoperable())
		icon_state = "colormate_off"
	else if(processing.len)
		icon_state = "colormate_active"
	else
		icon_state = "colormate"

/obj/machinery/gear_painter/Destroy()
	for(var/atom/movable/O in processing)
		O.forceMove(drop_location())
	processing.Cut()
	return ..()

/obj/machinery/gear_painter/attackby(obj/item/W, mob/user)
	if(LAZYLEN(processing) >= MAX_PROCESSING)
		to_chat(user, "<span class='warning'>The machine is full.</span>")
		return
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_unfasten_wrench(user, W, 40))
		return

	if(is_type_in_list(W, allowed_types) && !inoperable())
		user.visible_message("<span class='notice'>[user] inserts \the [W] into the Color Mate receptable.</span>")
		user.drop_from_inventory(W)
		W.forceMove(src)
		processing |= W
		SStgui.update_uis(src)
	else
		..()
	update_icon()

/obj/machinery/gear_painter/attack_hand(mob/user)
	if(..())
		return
	ui_interact(user)

/obj/machinery/gear_painter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ColorMate", name)
		ui.open()

/obj/machinery/gear_painter/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/list/data = ..()

	var/list/items = list()
	for(var/atom/movable/O in processing)
		items.Add("[O]")
	data["items"] = items

	data["activecolor"] = activecolor
	return data

/obj/machinery/gear_painter/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	add_fingerprint(usr)

	switch(action)
		if("select")
			var/newcolor = input(usr, "Choose a color.", "", activecolor) as color|null
			if(newcolor)
				activecolor = newcolor
			. = TRUE

		if("paint")
			for(var/atom/movable/O in processing)
				O.color = activecolor
				CHECK_TICK
			playsound(src, 'sound/effects/spray3.ogg', 50, 1)
			. = TRUE

	if(href_list["toggle_matrix_mode"])
		matrix_mode = !matrix_mode

	if(href_list["matrix_paint"])
		// assemble matrix
		var/list/cm = rgb_construct_color_matrix(
			text2num(href_list["rr"]),
			text2num(href_list["rg"]),
			text2num(href_list["rb"]),
			text2num(href_list["gr"]),
			text2num(href_list["gg"]),
			text2num(href_list["gb"]),
			text2num(href_list["br"]),
			text2num(href_list["bg"]),
			text2num(href_list["bb"]),
			text2num(href_list["cr"]),
			text2num(href_list["cg"]),
			text2num(href_list["cb"])
		)
		color_matrix_last = cm.Copy()
		for(var/atom/movable/AM in processing)
			AM.add_atom_colour(cm, FIXED_COLOUR_PRIORITY)
		playsound(src, 'sound/effects/spray3.ogg', 50, 1)

		if("clear")
			for(var/atom/movable/O in processing)
				O.color = initial(O.color)
				CHECK_TICK
			playsound(src, 'sound/effects/spray3.ogg', 50, 1)
			. = TRUE

		if("eject")
			for(var/atom/movable/O in processing)
				O.forceMove(drop_location())
				CHECK_TICK
			processing.Cut()
			. = TRUE

	update_icon()
