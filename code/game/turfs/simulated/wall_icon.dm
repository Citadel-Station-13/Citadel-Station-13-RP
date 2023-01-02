/**
 * generates damage overlays
 */
/proc/generate_wall_damage_overlays()
	// arbitrary, hardcoded number for now: 16
	var/amt = 16
	var/alpha_inc = 256 / 16
	var/list/generated = list()
	generated.len = amt
	. = generated
	for(var/i in 1 to 16)
		var/image/I = image(icon = 'icons/turf/walls/damage_masks.dmi', icon_state = "overlay_damage")
		I.blend_mode = BLEND_MULTIPLY
		I.alpha = (i * alpha_inc) - 1
		generated[i] = I

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
	// Just in case we use a preview in another icon file.
	if(icon_state == initial(icon_state))
		icon_state = "wall-0"

/turf/simulated/wall/update_overlays()
	. = ..()
	if(!istype(reinf_material))
		return

	// handle fakewalls
	// TODO: MAKE FAKEWALLS NOT TURFS WTF
	if(!density)
		var/mutable_appearance/appearance = mutable_appearance(get_wall_icon(), "fwall_open")
		appearance.color = material.icon_colour
		. += appearance
		return


	//! Wall Overlays
	if (apply_reinf_overlay())
		// Reinforcement Construction
		if (construction_stage != null && construction_stage < 6)
			var/mutable_appearance/appearance = mutable_appearance('icons/turf/walls/_construction_overlays.dmi', "reinf_construct-[construction_stage]")
			appearance.color = reinf_material.icon_colour
			appearance.appearance_flags |= RESET_COLOR
			. += appearance

		// Directional Reinforcements.
		else if(reinf_material.icon_reinf_directionals)
			var/mutable_appearance/appearance = mutable_appearance(reinf_material.icon_base, icon_state)
			appearance.appearance_flags |= RESET_COLOR
			. += appearance

		// Standard Reinforcements.
		else
			var/mutable_appearance/appearance = mutable_appearance(reinf_material.icon_reinf, "reinforced")
			appearance.appearance_flags |= RESET_COLOR
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

			. += mutable_appearance(damage_overlays[overlay])
