/**
  * call back when a var is edited on this atom
  *
  * Can be used to implement special handling of vars
  *
  * At the atom level, if you edit a var named "color" it will add the atom colour with
  * admin level priority to the atom colours list
  *
  * Also, if GLOB.Debug2 is FALSE, it sets the ADMIN_SPAWNED_1 flag on flags_1, which signifies
  * the object has been admin edited
  */
/atom/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	if(raw_edit)
		return ..()

	switch(var_name)
		if(NAMEOF(src, smoothing_junction))
			set_smoothed_icon_state(var_value)
			. = TRUE
		if(NAMEOF(src, opacity))
			set_opacity(var_value)
			. = TRUE
		if(NAMEOF(src, base_pixel_x))
			set_base_pixel_x(var_value)
			. = TRUE
		if(NAMEOF(src, base_pixel_y))
			set_base_pixel_y(var_value)
			. = TRUE
		if(NAMEOF(src, integrity))
			if(!isnum(var_value))
				return FALSE
			if(var_value > integrity_max)
				integrity_max = var_value
			var_value = max(0, var_value)
			if(integrity_enabled)
				set_integrity(var_value)
				. = TRUE
		if(NAMEOF(src, integrity_failure))
			if(!isnum(var_value) || var_value < 0)
				return FALSE
		if(NAMEOF(src, integrity_max))
			if(!isnum(var_value))
				return FALSE
			var_value = max(0, var_value)
		if(NAMEOF(src, contents))
			var/list/O = contents
			var/list/N = var_value
			for(var/atom/movable/AM in O - N)
				// these go away
				AM.moveToNullspace()
			for(var/atom/movable/AM in N - O)
				// these go in
				AM.forceMove(src)

	if(!isnull(.))
		datum_flags |= DF_VAR_EDITED
		return

	. = ..()
	if(!.)
		return

	switch(var_name)
		if(NAMEOF(src, color))
			add_atom_colour(color, ADMIN_COLOUR_PRIORITY)
		if(NAMEOF(src, base_layer), NAMEOF(src, layer))
			set_base_layer(var_value)
		if(NAMEOF(src, relative_layer))
			set_relative_layer(var_value)
		if(NAMEOF(src, integrity_max))
			integrity = min(integrity_max, integrity)
		if(NAMEOF(src, integrity_failure))
			if(integrity_enabled)
				var/was_failing = integrity_failure >= integrity
				var/now_failing = var_value >= integrity
				if(!was_failing && now_failing)
					atom_break()
				else if(was_failing && !now_failing)
					atom_fix()

/atom/vv_get_var(var_name)
	switch(var_name)
		if(NAMEOF(src, base_layer))
			if(isnull(base_layer))
				return debug_variable(NAMEOF(src, base_layer), layer, 0, src)
			else
				return debug_variable(NAMEOF(src, base_layer), base_layer, 0, src)
	return ..()

/**
  * Return the markup to for the dropdown list for the VV panel for this atom
  *
  * Override in subtypes to add custom VV handling in the VV panel
  */
/atom/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---------")
	if(!ismovable(src))
		var/turf/curturf = get_turf(src)
		if(curturf)
			. += "<option value='?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[curturf.x];Y=[curturf.y];Z=[curturf.z]'>Jump To</option>"
	VV_DROPDOWN_OPTION(VV_HK_ADD_REAGENT, "Add Reagent")
	VV_DROPDOWN_OPTION(VV_HK_EDIT_ARMOR, "Edit Armor")
	VV_DROPDOWN_OPTION(VV_HK_EDIT_FILTERS, "Edit Filters")
	VV_DROPDOWN_OPTION(VV_HK_EDIT_COLOR_MATRIX, "Edit Color as Matrix")
	VV_DROPDOWN_OPTION(VV_HK_MODIFY_TRANSFORM, "Modify Transform")
	VV_DROPDOWN_OPTION(VV_HK_TRIGGER_EXPLOSION, "Explosion")
	VV_DROPDOWN_OPTION(VV_HK_TRIGGER_EMP, "EMP Pulse")

/atom/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_ADD_REAGENT] && check_rights(R_VAREDIT))
		if(!reagents)
			var/amount = input(usr, "Specify the reagent size of [src]", "Set Reagent Size", 50) as num|null
			if(amount)
				create_reagents(amount)

		if(reagents)
			var/chosen_id
			switch(alert(usr, "Choose a method.", "Add Reagents", "Search", "Choose from a list", "I'm feeling lucky"))
				if("Search")
					var/valid_id
					while(!valid_id)
						chosen_id = input(usr, "Enter the ID of the reagent you want to add.", "Search reagents") as null|text
						if(isnull(chosen_id)) //Get me out of here!
							break
						if (!ispath(text2path(chosen_id)))
							chosen_id = pick_closest_path(chosen_id, make_types_fancy(subtypesof(/datum/reagent)))
							if (ispath(chosen_id))
								valid_id = TRUE
						else
							valid_id = TRUE
						if(!valid_id)
							to_chat(usr, "<span class='warning'>A reagent with that ID doesn't exist!</span>")
				if("Choose from a list")
					chosen_id = input(usr, "Choose a reagent to add.", "Choose a reagent.") as null|anything in subtypesof(/datum/reagent)
				if("I'm feeling lucky")
					chosen_id = pick(subtypesof(/datum/reagent))
			if(chosen_id)
				var/amount = input(usr, "Choose the amount to add.", "Choose the amount.", reagents.maximum_volume) as num|null
				if(amount)
					reagents.add_reagent(chosen_id, amount)
					log_admin("[key_name(usr)] has added [amount] units of [chosen_id] to [src]")
					message_admins("<span class='notice'>[key_name(usr)] has added [amount] units of [chosen_id] to [src]</span>")
	if(href_list[VV_HK_TRIGGER_EXPLOSION] && check_rights(R_FUN))
		usr.client.cmd_admin_explosion(src)
	if(href_list[VV_HK_TRIGGER_EMP] && check_rights(R_FUN))
		usr.client.cmd_admin_emp(src)
	if(href_list[VV_HK_MODIFY_TRANSFORM] && check_rights(R_VAREDIT))
		var/result = input(usr, "Choose the transformation to apply","Transform Mod") as null|anything in list("Scale","Translate","Rotate")
		var/matrix/M = transform
		switch(result)
			if("Scale")
				var/x = input(usr, "Choose x mod","Transform Mod") as null|num
				var/y = input(usr, "Choose y mod","Transform Mod") as null|num
				if(!isnull(x) && !isnull(y))
					transform = M.Scale(x,y)
			if("Translate")
				var/x = input(usr, "Choose x mod","Transform Mod") as null|num
				var/y = input(usr, "Choose y mod","Transform Mod") as null|num
				if(!isnull(x) && !isnull(y))
					transform = M.Translate(x,y)
			if("Rotate")
				var/angle = input(usr, "Choose angle to rotate","Transform Mod") as null|num
				if(!isnull(angle))
					transform = M.Turn(angle)
	if(href_list[VV_HK_EDIT_FILTERS] && check_rights(R_VAREDIT))
		var/client/C = usr.client
		C?.open_filter_editor(src)
	if(href_list[VV_HK_EDIT_COLOR_MATRIX] && check_rights(R_VAREDIT))
		var/client/C = usr.client
		C?.open_color_matrix_editor(src)
	if(href_list[VV_HK_EDIT_ARMOR] && check_rights(R_VAREDIT))
		// todo: tgui armor editor?
		var/list/pickerlist = list()
		var/list/armorlist = fetch_armor().to_list()
		for (var/i in armorlist)
			pickerlist += list(list("value" = armorlist[i], "name" = i))
		var/list/result = presentpicker(usr, "Modify armor", "Modify armor: [src]", Button1="Save", Button2 = "Cancel", Timeout=FALSE, inputtype = "text", values = pickerlist, width = 300, height = 800)
		if(!islist(result) || result["button"] == 2) // 2 is cancel
			return
		var/list/built = list()
		for(var/key in result["values"])
			built[key] = text2num(result["values"][key])
		set_armor(armor.overwritten(built))
		log_admin("[key_name(usr)] modified the armor on [src] ([type]) to [armor.log_string()]")
		message_admins(SPAN_NOTICE("[key_name_admin(usr)] modified the armor on [src] ([type]) to [armor.log_string()]"))
		// todo: proper tgui for armor mods

/atom/vv_get_header()
	. = ..()
	if(!isliving(src))
		var/refid = REF(src)
		. += "[VV_HREF_TARGETREF_1V(refid, VV_HK_BASIC_EDIT, "<b id='name'>[src]", NAMEOF(src, name))]"
		. += "<br><font size='1'><a href='?_src_=vars;[HrefToken()];rotatedatum=[refid];rotatedir=left'><<</a> <a href='?_src_=vars;[HrefToken()];datumedit=[refid];varnameedit=dir' id='dir'>[dir2text(dir) || dir]</a> <a href='?_src_=vars;[HrefToken()];rotatedatum=[refid];rotatedir=right'>>></a></font>"
