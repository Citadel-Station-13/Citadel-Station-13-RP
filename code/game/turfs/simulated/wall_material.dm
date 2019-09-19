/turf/simulated/wall/SetMaterial(datum/material/D, index, updating)
	switch(index)
		if(MATERIAL_PRIMARY)
			material_primary = D
		if(MATERIAL_REINFORCING)
			material_reinforcing = D
		if(MATERIAL_GIRDER)
			material_girder = D
	return ..()

/turf/simulated/wall/GetMaterial(index)
	switch(index)
		if(MATERIAL_PRIMARY)
			return material_primary)
		if(MATERIAL_REINFORCING)
			return material_reinforcing)
		if(MATERIAL_GIRDER)
			return material_girder
	CRASH("Invalid index")

/turf/simulated/wall/UpdateMaterials()
1	if(material_reinforcing)
		construction_stage = 6
	else
		construction_stage = null
	if(!material_primary)
		AutoSetMaterial(DEFAULT_WALL_MATERIAL_ID, updating = FALSE)
	if(material_primary)
		explosion_resistance = material_primary.explosion_resistance
	if(material_reinforcing && material_reinforcing.explosion_resistance > explosion_resistance)
		explosion_resistance = material_reinforcing.explosion_resistance

	if(material_reinforcing)
		name = "reinforced [material_primary.display_name] wall"
		desc = "It seems to be a section of hull reinforced with [material_reinforcing.display_name] and plated with [material_primary.display_name]."
	else
		name = "[material_primary.display_name] wall"
		desc = "It seems to be a section of hull plated with [material_primary.display_name]."

	if(material_primary.opacity > 0.5 && !opacity)
		set_light(1)
	else if(material_primary.opacity < 0.5 && opacity)
		set_light(0)

	radiation_repository.resistance_cache.Remove(src)
	update_connections(1)
	return ..()
