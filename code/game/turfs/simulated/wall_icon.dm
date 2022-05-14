/**
 * generates damage overlays
 */
/turf/simulated/wall/proc/generate_damage_overlays()
	// arbitrary, hardcoded number for now: 16
	var/amt = 16
	var/alpha_inc = 256 / 16
	var/list/generated = list()
	generated.len = mat
	. = generated
	for(var/i in 1 to 16)
		var/image/I = imiage(icon = 'icons/turf/wall/damage_masks.dmi')
		I.blend_mode = BLEND_MULTIPLY
		I.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = I

// funny thing
// we nowadays hijack tg's smoothing for our own purposes.
// we can be faster with entirely our own code but this is more generic.

// overridden find type
/turf/simulated/wall/find_type_in_direction(direction)
	if(!material)
		return NO_ADJ_FOUND
	var/turf/simulated/wall/T = get_step(src, direction)
	if(!T || !T.material)
		return NULLTURF_BORDER
	return (istype(T) && (material.icon_base == T.material.icon_base))? NO_ADJ_FOUND : ADJ_FOUND

/turf/simulated/wall/custom_smooth(dirs)
	smoothing_junction = dirs
	update_icon()

/turf/simulated/wall/update_overlays()
	. = ..()

	// materrialless walls don't use this system.
	if(!material)
		return

	cut_overlays()

	var/image/I

	// handle fakewalls
	// TODO: MAKE FAKEWALLS NOT TURFS WTF
	if(!density)
		I = image('icons/turf/wall_masks.dmi', "[material.icon_base]fwall_open")
		I.color = material.icon_colour
		add_overlay(I)
		return

	// modern smoothiing when
	// sigh
	// i need to learn how to use the icon cutter
	// anyways, 1 to 4 means NORTH SOUTH EAST WEST
	var/dir
	for(var/i in 0 to 3)
		dir = (1 << i)


	for(var/i in 1 to 4)
		I = image('icons/turf/wall_masks.dmi', "[material.icon_base][wall_connections[i]]", dir = 1<<(i-1))
		I.color = material.icon_colour
		add_overlay(I)

	if(reinf_material)
		if(construction_stage != null && construction_stage < 6)
			I = image('icons/turf/wall_masks.dmi', "reinf_construct-[construction_stage]")
			I.color = reinf_material.icon_colour
			add_overlay(I)
		else
			if("[reinf_material.icon_reinf]0" in icon_states('icons/turf/wall_masks.dmi'))
				// Directional icon
				for(var/i = 1 to 4)
					I = image('icons/turf/wall_masks.dmi', "[reinf_material.icon_reinf][wall_connections[i]]", dir = 1<<(i-1))
					I.color = reinf_material.icon_colour
					add_overlay(I)
			else
				I = image('icons/turf/wall_masks.dmi', reinf_material.icon_reinf)
				I.color = reinf_material.icon_colour
				add_overlay(I)

	// handle damage overlays
	if(damage != 0)
		var/integrity = material.integrity
		if(reinf_material)
			integrity += reinf_material.integrity

		var/overlay = round(damage / integrity * damage_overlays.len) + 1
		if(overlay > damage_overlays.len)
			overlay = damage_overlays.len

		add_overlay(damage_overlays[overlay])
