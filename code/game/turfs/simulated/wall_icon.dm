/**
 * generates damage overlays
 */
/turf/simulated/wall/proc/generate_wall_damage_overlays()
	var/alpha_inc = 256 / damage_overlays.len

	for(var/i = 1; i <= damage_overlays.len; i++)
		var/image/img = image(icon = 'icons/turf/walls/damage_masks.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = img


/turf/simulated/wall/proc/get_wall_icon()
	. = (istype(material) && material.icon_base) || 'icons/turf/walls/solid.dmi'


/turf/simulated/wall/proc/apply_reinf_overlay()
	. = istype(reinf_material)


/turf/simulated/wall/update_appearance(updates)
	. = ..()
	if(!istype(material))
		return

	color = material.icon_colour


/turf/simulated/wall/update_icon()
	. = ..()

	if(icon == initial(icon))
		icon = get_wall_icon()


/turf/simulated/wall/update_icon_state()
	. = ..()

	// handle fakewalls
	// TODO: MAKE FAKEWALLS NOT TURFS WTF
	if(!density)
		cached_wall_state = icon_state
		icon_state = "fwall_open"
	else if(icon_state == "fwall_open")
		icon_state = cached_wall_state


/turf/simulated/wall/update_overlays()
	. = ..()

	if(!damage_overlays[1]) // Our list hasn't been populated yet.
		generate_wall_damage_overlays()

	if(!istype(reinf_material))
		return

	// handle fakewalls
	// TODO: MAKE FAKEWALLS NOT TURFS WTF
	if(!density)
		return


	//! Wall Overlays
	if (apply_reinf_overlay())
		// Reinforcement Construction
		if (construction_stage != null && construction_stage < 6)
			var/image/appearance = image('icons/turf/walls/_construction_overlays.dmi', "reinf_construct-[construction_stage]")
			appearance.appearance_flags = RESET_COLOR
			appearance.color = reinf_material.icon_colour
			. += appearance

		// Directional Reinforcements.
		else if(reinf_material.icon_reinf_directionals)
			var/image/appearance = image(reinf_material.icon_reinf, icon_state)
			appearance.appearance_flags = RESET_COLOR
			appearance.color = reinf_material.icon_colour
			. += appearance

		// Standard Reinforcements.
		else
			var/image/appearance = image(reinf_material.icon_reinf, "reinforced")
			appearance.appearance_flags = RESET_COLOR
			appearance.color = reinf_material.icon_colour
			. += appearance

	// handle damage overlays
	if (damage != 0)
		var/integrity = material.integrity
		if (reinf_material)
			integrity += reinf_material.integrity

		var/overlay = round(damage / integrity * damage_overlays.len) + 1
		if (overlay > damage_overlays.len)
			overlay = damage_overlays.len

		damage_overlay = damage_overlays[overlay]
		. += damage_overlay
