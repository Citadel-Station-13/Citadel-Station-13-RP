/datum/asset_pack/spritesheet/vending
	name = "vending"

/datum/asset_pack/spritesheet/vending/generate()
	for (var/atom/item as anything in GLOB.vending_products)
		if (!ispath(item, /atom))
			continue

		var/icon_state = initial(item.icon_state)
		var/has_gags = initial(item.greyscale_config) && initial(item.greyscale_colors)
		var/has_color = initial(item.color) && icon_state

		// GAGS (as SSgreyscale) and colored icons must be pregenerated
		// Otherwise we can rely on DMIcon, so skip it to save init time
		if(!has_gags && !has_color)
			continue

		if (PERFORM_ALL_TESTS(focus_only/invalid_vending_machine_icon_states))
			if (!has_gags && !icon_exists(initial(item.icon), icon_state))
				var/icon_file = initial(item.icon)
				var/icon_states_string
				for (var/an_icon_state in icon_states(icon_file))
					if (!icon_states_string)
						icon_states_string = "[json_encode(an_icon_state)]([text_ref(an_icon_state)])"
					else
						icon_states_string += ", [json_encode(an_icon_state)]([text_ref(an_icon_state)])"

				stack_trace("[item] does not have a valid icon state, icon=[icon_file], icon_state=[json_encode(icon_state)]([text_ref(icon_state)]), icon_states=[icon_states_string]")
				continue

		// pretend this is get_display_icon_for()
		var/icon_file
		if (initial(item.greyscale_colors) && initial(item.greyscale_config))
			icon_file = SSgreyscale.GetColoredIconByType(initial(item.greyscale_config), initial(item.greyscale_colors))
		else
			icon_file = initial(item.icon)
		var/icon/I

		var/icon_states_list = icon_states(icon_file)
		if(icon_state in icon_states_list)
			I = icon(icon_file, icon_state, SOUTH)
			var/c = initial(item.color)
			if (!isnull(c) && c != "#FFFFFF")
				I.Blend(c, ICON_MULTIPLY)
		else
			I = icon('icons/turf/floors.dmi', "", SOUTH)

		var/imgid = replacetext(replacetext("[item]", "/obj/item/", ""), "/", "-")
		Insert(imgid, I)
