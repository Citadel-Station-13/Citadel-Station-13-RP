/turf/simulated/wall/proc/set_material(var/datum/material/newmaterial, var/datum/material/newrmaterial, var/datum/material/newgmaterial)
	material = newmaterial
	reinf_material = newrmaterial
	if(!newgmaterial)
		girder_material = MAT_STEEL
	else
		girder_material = newgmaterial
	update_material()

/turf/simulated/wall/proc/update_material()

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
	QUEUE_SMOOTH(src)
