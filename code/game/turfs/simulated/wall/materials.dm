/turf/simualted/wall/proc/init_materials(datum/material/outer = material_outer, datum/material/reinforcing = material_reinf, datum/material/girder = material_girder)
	outer = SSmaterials.resolve_material(outer)
	reinforcing = SSmaterials.resolve_material(reinforcing)
	girder = SSmaterials.resolve_material(girder)

	set_materials(outer, reinforcing, girder)

/turf/simualted/wall/proc/set_materials(datum/material/outer, datum/material/reinforcing, datum/material/girder)
	MATERIAL_UNREGISTER(material_outer)
	material_outer = outer
	MATERIAL_REGISTER(material_outer)
	MATERIAL_UNREGISTER(material_reinf)
	material_reinf = reinforcing
	MATERIAL_REGISTER(material_reinf)
	MATERIAL_UNREGISTER(material_girder)
	material_girder = girder
	MATERIAL_REGISTER(material_girder)

	update_materials()

/turf/simulated/wall/proc/set_outer_material(datum/material/material)
	MATERIAL_UNREGISTER(material_outer)
	material_outer = outer
	MATERIAL_REGISTER(material_outer)

	update_materials()

/turf/simulated/wall/proc/set_reinforcing_material(datum/material/material)
	MATERIAL_UNREGISTER(material_reinf)
	material_reinf = reinforcing
	MATERIAL_REGISTER(material_reinf)

	update_materials()

/turf/simulated/wall/proc/set_girder_material(datum/material/material)
	MATERIAL_UNREGISTER(material_girder)
	material_girder = girder
	MATERIAL_REGISTER(material_girder)

	update_materials()

/turf/simulated/wall/proc/update_materials()
	if(material_reinf)
		construction_stage = 6
		name = "reinforced [material.display_name || material.name] wall"
		desc = "It seems to be a section of hull reinforced with [material_reinf.display_name || material_reinf.name] and plated with [material.display_name || material.name]."
	else
		construction_stage = null
		name = "[material.display_name || material.name] wall"
		desc = "It seems to be a section of hull plated with [material.display_name || material.name]."

	update_appearance()
