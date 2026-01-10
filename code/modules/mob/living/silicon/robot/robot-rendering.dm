/mob/living/silicon/robot/update_icon()
	cut_overlays()

	. = ..()

	// resolve variation & set icon state
	var/datum/robot_iconset_variation/active_variation
	if(IS_DEAD(src))
		var/datum/robot_iconset_variation/dead_variation = iconset?.variations?[/datum/robot_iconset_variation/dead::id]
		if(dead_variation)
			if(dead_variation.icon_state)
				icon_state = dead_variation.icon_state
			else
				icon_state = "[base_icon_state][dead_variation.icon_state_append]"
			active_variation = dead_variation
	else if(resting)
		if(picked_resting_variation)
			active_variation = iconset?.variations?[picked_resting_variation]
		if(!active_variation)
			active_variation = iconset?.variations?[/datum/robot_iconset_variation/resting::id]
	else
		icon_state = base_icon_state

	// render indicator lighting
	if(IS_CONSCIOUS(src) && (!shell || deployed))
		var/indicator_state
		if(active_variation)
			if(active_variation.icon_state_indicator)
				indicator_state = active_variation.icon_state_indicator
			else if(active_variation.icon_state_indicator_append)
				indicator_state = "[icon_state][active_variation.icon_state_indicator_append]"
		else if(iconset.icon_state_indicator)
			indicator_state = iconset.icon_state_indicator
		var/image/indicator = image(icon, indicator_state)
		switch(iconset.indicator_lighting_coloration_mode)
			if(COLORATION_MODE_MULTIPLY)
				indicator.color = iconset.indicator_lighting_coloration_packed
		add_overlay(indicator)

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
