/turf/simulated/wall/proc/set_material(datum/material/newmaterial, datum/material/newrmaterial, datum/material/newgmaterial, defer_icon)
	material = newmaterial
	reinf_material = newrmaterial
	if(!newgmaterial)
		girder_material = MAT_STEEL
	else
		girder_material = newgmaterial
	if(!defer_icon)
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)
	update_material(TRUE)

/turf/simulated/wall/proc/update_material(defer_icon)
	if(!material)
		return

	if(reinf_material)
		construction_stage = 6
	else
		construction_stage = null
	if(!material)
		material = get_material_by_name(MAT_STEEL)
	if(material)
		explosion_resistance = material.explosion_resistance
	if(reinf_material && reinf_material.explosion_resistance > explosion_resistance)
		explosion_resistance = reinf_material.explosion_resistance

	if(reinf_material)
		name = "reinforced [material.display_name] wall"
		desc = "It seems to be a section of hull reinforced with [reinf_material.display_name] and plated with [material.display_name]."
	else
		name = "[material.display_name] wall"
		desc = "It seems to be a section of hull plated with [material.display_name]."

	SSradiation.resistance_cache.Remove(src)
	if(!defer_icon)
		update_icon()
