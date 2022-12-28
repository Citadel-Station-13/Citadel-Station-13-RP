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

// funny thing
// we nowadays hijack tg's smoothing for our own purposes.
// we can be faster with entirely our own code but this is more generic.

// overridden find type
/turf/simulated/wall/find_type_in_direction(direction)
	if(!istype(material))
		return NO_ADJ_FOUND
	var/turf/simulated/wall/T = get_step(src, direction)
	if(!T)
		return NULLTURF_BORDER
	return (istype(T) && (material.icon_base == T.material?.icon_base))? ADJ_FOUND : NO_ADJ_FOUND

/turf/simulated/wall/custom_smooth(dirs)
	smoothing_junction = dirs
	update_icon()

/turf/simulated/wall/update_overlays()
	. = ..()
	// materrialless walls don't use this system.
	if(!istype(material))
		return

	cut_overlays()

	var/image/I
	var/base_color = material.icon_colour
	var/material_icon_base = get_wall_icon()

	// handle fakewalls
	// TODO: MAKE FAKEWALLS NOT TURFS WTF
	if(!density)
		var/mutable_appearance/appearance = mutable_appearance(material_icon_base, "fwall_open")
		appearance.color = base_color
		. += appearance
		return


	//! Base wall.
	for (var/i in 0 to 3)
		var/mutable_appearance/appearance = mutable_appearance(material_icon_base, "[get_corner_state_using_junctions(i)]")
		appearance.color = base_color
		appearance.dir = (1<<i)
		. += appearance

	//! Wall Overlays
	if (apply_reinf_overlay())
		// Reinforcement Construction
		if (construction_stage != null && construction_stage < 6)
			var/mutable_appearance/appearance = mutable_appearance('icons/turf/walls/_construction_overlays.dmi', "reinf_construct-[construction_stage]")
			appearance.color = reinf_material.icon_colour
			. += appearance

		// Directional Reinforcements.
		else if(reinf_material.icon_reinf_directionals)
			for(var/i in 0 to 3)
				var/mutable_appearance/appearance = mutable_appearance(reinf_material.icon_reinf, "[get_corner_state_using_junctions(i)]")
				appearance.color = base_color
				appearance.dir = (1<<i)
				. += appearance

		// Standard Reinforcements.
		else
			var/mutable_appearance/appearance = mutable_appearance(reinf_material.icon_reinf, "reinforced")
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
