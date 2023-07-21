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

	reinf_material = rmaterialtype
	if(ispath(reinf_material, /datum/material))
		reinf_material = SSmaterials.resolve_material(reinf_material)
	else if(!istype(reinf_material))
		reinf_material = null

	girder_material = girdertype
	if(ispath(girder_material, /datum/material))
		girder_material = SSmaterials.resolve_material(girder_material)
	else if(!istype(girder_material))
		girder_material = SSmaterials.resolve_material(/datum/material/steel)

	if(reinf_material)
		construction_stage = 6
	else
		construction_stage = null

	if(reinf_material)
		name = "reinforced [material.display_name || material.name] wall"
		desc = "It seems to be a section of hull reinforced with [reinf_material.display_name || reinf_material.name] and plated with [material.display_name || material.name]."
	else
		name = "[material.display_name || material.name] wall"
		desc = "It seems to be a section of hull plated with [material.display_name || material.name]."

	update_appearance()
