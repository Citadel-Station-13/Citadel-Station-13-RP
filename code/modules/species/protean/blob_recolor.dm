/datum/protean_blob_recolor
	var/mob/living/simple_mob/protean_blob/our_blob
	var/activecolor = "#FFFFFF"
	var/temp
	var/snowflake_last_ui_expensive_update
	var/list/color_matrix_last
	var/active_mode = COLORMATE_HSV

	var/build_hue = 0
	var/build_sat = 1
	var/build_val = 1

/datum/protean_blob_recolor/New(var/mob/living/simple_mob/protean_blob/blob)
	our_blob = blob
	color_matrix_last = list(
		1, 0, 0,
		0, 1, 0,
		0, 0, 1,
		0, 0, 0,
	)

/datum/protean_blob_recolor/ui_state()
	return GLOB.conscious_state
/datum/protean_blob_recolor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ColorMate", our_blob.name)
		ui.set_autoupdate(FALSE) //This might be a bit intensive, better to not update it every few ticks
		ui.open()

/datum/protean_blob_recolor/proc/get_color_target()
	if(istype(our_blob.loc, /obj/item/holder))
		return our_blob.loc
	return our_blob

/datum/protean_blob_recolor/ui_data(mob/user, datum/tgui/ui)
	. = list()
	.["activemode"] = active_mode
	.["matrixcolors"] = list(
		"rr" = color_matrix_last[1],
		"rg" = color_matrix_last[2],
		"rb" = color_matrix_last[3],
		"gr" = color_matrix_last[4],
		"gg" = color_matrix_last[5],
		"gb" = color_matrix_last[6],
		"br" = color_matrix_last[7],
		"bg" = color_matrix_last[8],
		"bb" = color_matrix_last[9],
		"cr" = color_matrix_last[10],
		"cg" = color_matrix_last[11],
		"cb" = color_matrix_last[12],
	)
	.["buildhue"] = build_hue
	.["buildsat"] = build_sat
	.["buildval"] = build_val
	if(temp)
		.["temp"] = temp
	// TODO: use byondmap, don't use this shitty unresponsive throttling
	if(snowflake_last_ui_expensive_update + 0.15 SECONDS > world.time)
		return
	snowflake_last_ui_expensive_update = world.time
	var/atom/movable/color_target = get_color_target()
	.["item"] = list()
	.["item"]["name"] = color_target.name
	.["item"]["sprite"] = icon2base64(get_flat_icon(color_target,dir=SOUTH,no_anim=TRUE))
	.["item"]["preview"] = icon2base64(build_preview())

/datum/protean_blob_recolor/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	var/atom/movable/color_target = get_color_target()
	if(color_target)
		switch(action)
			if("switch_modes")
				active_mode = text2num(params["mode"])
				return TRUE
			if("choose_color")
				var/chosen_color = input(usr, "Choose a color: ", "Colour picking", activecolor) as color|null
				if(chosen_color)
					activecolor = chosen_color
				return TRUE
			if("paint")
				do_paint(usr)
				temp = "Painted Successfully!"
				return TRUE
			if("clear")
				color_target.remove_atom_color()
				temp = "Cleared Successfully!"
				return TRUE
			if("drop")
				build_hue = 0
				build_sat = 1
				build_val = 1
				color_matrix_last = list(
					1, 0, 0,
					0, 1, 0,
					0, 0, 1,
					0, 0, 0,
				)
				temp = "Reset Successfully!"
				return TRUE

			if("set_matrix_color")
				color_matrix_last[params["color"]] = params["value"]
				return TRUE
			if("set_hue")
				build_hue = clamp(text2num(params["buildhue"]), 0, 360)
				return TRUE
			if("set_sat")
				build_sat = clamp(text2num(params["buildsat"]), -10, 10)
				return TRUE
			if("set_val")
				build_val = clamp(text2num(params["buildval"]), -10, 10)

/datum/protean_blob_recolor/proc/do_paint(mob/user)
	var/color_to_use
	switch(active_mode)
		if(COLORMATE_TINT)
			color_to_use = activecolor
		if(COLORMATE_MATRIX)
			color_to_use = construct_rgb_color_matrix(
				text2num(color_matrix_last[1]),
				text2num(color_matrix_last[2]),
				text2num(color_matrix_last[3]),
				text2num(color_matrix_last[4]),
				text2num(color_matrix_last[5]),
				text2num(color_matrix_last[6]),
				text2num(color_matrix_last[7]),
				text2num(color_matrix_last[8]),
				text2num(color_matrix_last[9]),
				text2num(color_matrix_last[10]),
				text2num(color_matrix_last[11]),
				text2num(color_matrix_last[12]),
			)
		if(COLORMATE_HSV)
			color_to_use = color_matrix_hsv(build_hue, build_sat, build_val)
			color_matrix_last = color_to_use
	if(!color_to_use)
		to_chat(user, SPAN_NOTICE("Invalid color."))
		return FALSE
	var/atom/movable/color_target = get_color_target()
	color_target.add_atom_color(color_to_use)
	if(isitem(color_target))
		var/obj/item/CI = color_target
		CI.update_worn_icon()
	return TRUE


/// Produces the preview image of the item, used in the UI, the way the color is not stacking is a sin.
/datum/protean_blob_recolor/proc/build_preview()
	var/atom/movable/color_target = get_color_target()
	if(color_target) //sanity
		var/list/cm
		switch(active_mode)
			if(COLORMATE_MATRIX)
				cm = construct_rgb_color_matrix(
					text2num(color_matrix_last[1]),
					text2num(color_matrix_last[2]),
					text2num(color_matrix_last[3]),
					text2num(color_matrix_last[4]),
					text2num(color_matrix_last[5]),
					text2num(color_matrix_last[6]),
					text2num(color_matrix_last[7]),
					text2num(color_matrix_last[8]),
					text2num(color_matrix_last[9]),
					text2num(color_matrix_last[10]),
					text2num(color_matrix_last[11]),
					text2num(color_matrix_last[12]),
				)

			if(COLORMATE_HSV)
				cm = color_matrix_hsv(build_hue, build_sat, build_val)
				color_matrix_last = cm

		var/mutable_appearance/preview = mutable_appearance(color_target.icon, color_target.icon_state, color_target.layer, color_target.plane, color_target.alpha, color_target.appearance_flags)
		preview.overlays = color_target.overlays.Copy()
		preview.color = (active_mode == COLORMATE_TINT ? activecolor : cm)
		temp = ""

		. = get_flat_icon(preview, dir=SOUTH, no_anim=TRUE)
