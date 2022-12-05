/turf/simulated/wall/proc/get_wall_color()
	var/wall_color = wall_paint
	if(!wall_color)
		var/datum/material/new_material = GET_MATERIAL_REF(material)
		wall_color = new_material.color
	return wall_color

/turf/simulated/wall/proc/get_stripe_color()
	var/stripe_color = stripe_paint
	if(!stripe_color)
		stripe_color = get_wall_color()
	return stripe_color

/turf/simulated/wall/proc/paint_wall(new_paint)
	wall_paint = new_paint
	update_appearance()

/turf/simulated/wall/proc/paint_stripe(new_paint)
	stripe_paint = new_paint
	update_appearance()

/turf/simulated/wall/proc/set_wall_information(new_material, new_reinf, new_girder, new_paint, new_stripe_paint)
	wall_paint = new_paint
	stripe_paint = new_stripe_paint
	set_materials(new_material, new_reinf, new_girder)

/turf/simulated/wall/proc/set_materials(new_material, new_reinf, new_girder)

	// Handle material
	if(!ispath(material, /datum/material))
		material = new_material || get_default_material()
	if(ispath(material, /datum/material))
		material = GET_MATERIAL_REF(material)

	// Handle reinf_material
	if(!ispath(reinf_material, /datum/material))
		reinf_material = new_reinf
	if(ispath(reinf_material, /datum/material))
		reinf_material = GET_MATERIAL_REF(reinf_material)

	// Handle girder_material
	if(ispath(girder_material, /datum/material))
		girder_material = GET_MATERIAL_REF(girder_material)

	if(new_reinf)
		construction_stage = 6
	else
		construction_stage = null

	SSradiation.resistance_cache.Remove(src)

	update_appearance()

/turf/simulated/wall/update_name(updates)
	. = ..()

	// if(rusted)
	// 	name = "rusted "
	if(reinf_material)
		name = "reinforced [material.display_name] wall"
	else
		name = "[material.display_name] wall"

/turf/simulated/wall/update_desc(updates)
	. = ..()

	if(reinf_material)
		desc = "It seems to be a section of hull reinforced with [reinf_material.display_name] and plated with [material.display_name]."
	else
		desc = "It seems to be a section of hull plated with [material.display_name]."
