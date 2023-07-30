/turf/simulated/wall/proc/set_materials(materialtype, rmaterialtype, girdertype)
	// var/datum/material/plating_mat_ref
	// if(materialtype)
	// 	plating_mat_ref = SSmaterials.resolve_material(materialtype)
	// var/datum/material/reinf_mat_ref
	// if(rmaterialtype)
	// 	reinf_mat_ref = SSmaterials.resolve_material(rmaterialtype)
	// var/datum/material/girder_mat_ref
	// if(girdertype)
	// 	girder_mat_ref = SSmaterials.resolve_material(girdertype)

	material = materialtype
	if(ispath(material, /datum/material))
		material = SSmaterials.resolve_material(material)
	else if(!istype(material))
		material = SSmaterials.resolve_material(get_default_material())

	material_reinf = rmaterialtype
	if(ispath(material_reinf, /datum/material))
		material_reinf = SSmaterials.resolve_material(material_reinf)
	else if(!istype(material_reinf))
		material_reinf = null

	material_girder = girdertype
	if(ispath(material_girder, /datum/material))
		material_girder = SSmaterials.resolve_material(material_girder)
	else if(!istype(material_girder))
		material_girder = SSmaterials.resolve_material(/datum/material/steel)

	if(material_reinf)
		construction_stage = 6
	else
		construction_stage = null

	if(material_reinf)
		name = "reinforced [material.display_name || material.name] wall"
		desc = "It seems to be a section of hull reinforced with [material_reinf.display_name || material_reinf.name] and plated with [material.display_name || material.name]."
	else
		name = "[material.display_name || material.name] wall"
		desc = "It seems to be a section of hull plated with [material.display_name || material.name]."

	update_appearance()
