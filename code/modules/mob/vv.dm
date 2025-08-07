/mob/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	if(raw_edit)
		return ..()
	switch(var_name)
		if(NAMEOF(src, shift_pixel_x))
			set_pixel_shift_x(var_value)
			return TRUE
		if(NAMEOF(src, shift_pixel_y))
			set_pixel_shift_y(var_value)
			return TRUE
	return ..()

/mob/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(null, "-----")
	VV_DROPDOWN_OPTION(VV_HK_ADD_PHYSIOLOGY_MODIFIER, "Add Physiology Modifier")
	VV_DROPDOWN_OPTION(VV_HK_REMOVE_PHYSIOLOGY_MODIFIER, "Remove Physiology Modifier")
	VV_DROPDOWN_OPTION(VV_HK_TRIGGER_OFFER_MOB_TO_GHOSTS, "Offer Mob To Ghosts")

/mob/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_ADD_PHYSIOLOGY_MODIFIER])
		// todo: this should be able to be done globally via admin panel and then added to mobs

		var/datum/physiology_modifier/modifier = ask_admin_for_a_physiology_modifier(usr)

		if(isnull(modifier))
			return
		if(QDELETED(src))
			return

		log_admin("[key_name(usr)] --> [key_name(src)] - added physiology modifier [json_encode(modifier.serialize())]")
		add_physiology_modifier(modifier)
		return TRUE

	if(href_list[VV_HK_REMOVE_PHYSIOLOGY_MODIFIER])
		var/list/assembled = list()
		var/i = 0
		for(var/datum/physiology_modifier/modifier as anything in physiology_modifiers)
			assembled["[modifier.name] (#[++i])"] = modifier
		var/picked = input(usr, "Which modifier to remove? Please do not do this unless you know what you are doing.", "Remove Physiology Modifier") as null|anything in assembled
		var/datum/physiology_modifier/removing = assembled[picked]
		if(!(removing in physiology_modifiers))
			return TRUE
		log_admin("[key_name(usr)] --> [key_name(src)] - removed physiology modifier [json_encode(removing.serialize())]")
		remove_physiology_modifier(removing)
		return TRUE

	if(href_list[VV_HK_TRIGGER_OFFER_MOB_TO_GHOSTS])
		offer_control(src)
