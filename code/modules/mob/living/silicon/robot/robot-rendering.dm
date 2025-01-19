/mob/living/silicon/robot/update_icon()
	cut_overlays()

	. = ..()

	// render state & variation
	var/datum/robot_iconset_variation/active_variation
	if(IS_DEAD(src))
		var/datum/robot_iconset_variation/dead_variation = iconset?.variations?[/datum/robot_iconset_variation/dead::id]
		if(dead_variation.icon_state)
			icon_state = dead_variation.icon_state
		else
			icon_state = "[base_icon_state][dead_variation.icon_state_append]"
		active_variation = dead_variation
	else
		icon_state = base_icon_state

	// render panel
	if(opened)
		var/using_panel_state
		if(active_variation)
			if(active_variation.icon_state_cover)
				using_panel_state = active_variation.icon_state_cover
			else if(active_variation.icon_state_cover_append)
				using_panel_state = "[base_icon_state][active_variation.icon_state_cover]"
		else
			using_panel_state = iconset.icon_state_cover
		if(using_panel_state)
			if(wiresexposed)
				add_overlay("[using_panel_state]-wires")
			else if(cell)
				add_overlay("[using_panel_state]-cell")
			else
				add_overlay("[using_panel_state]-empty")

#warn below
/mob/living/silicon/robot/updateicon()
	if (dogborg)
		// Resting dogborgs don't get overlays.
		if (stat == CONSCIOUS && resting)
			if(sitting)
				icon_state = "[module_sprites[icontype]]-sit"
			else if(bellyup)
				icon_state = "[module_sprites[icontype]]-bellyup"
			else
				icon_state = "[module_sprites[icontype]]-rest"
			return

	if(stat == CONSCIOUS)
		if(!shell || deployed) // Shell borgs that are not deployed will have no eyes.
			add_overlay(list(
				"eyes-[module_sprites[icontype]]",
				emissive_appearance(icon, "eyes-[module_sprites[icontype]]")
			))
