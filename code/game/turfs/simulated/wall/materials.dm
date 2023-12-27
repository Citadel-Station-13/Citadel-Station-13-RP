/turf/simulated/wall/proc/init_materials(datum/material/outer = material_outer, datum/material/reinforcing = material_reinf, datum/material/girder = material_girder)
	outer = SSmaterials.resolve_material(outer)
	reinforcing = SSmaterials.resolve_material(reinforcing)
	girder = SSmaterials.resolve_material(girder)

	if(!isnull(outer))
		material_outer = outer
		register_material(material_outer, TRUE)
	if(!isnull(reinforcing))
		material_reinf = reinforcing
		register_material(material_reinf, FALSE)
	if(!isnull(girder))
		material_girder = girder
		register_material(material_girder, FALSE)

	update_materials()

/turf/simulated/wall/proc/set_materials(datum/material/outer, datum/material/reinforcing, datum/material/girder)
	unregister_material(material_outer, TRUE)
	material_outer = outer
	register_material(material_outer, TRUE)
	unregister_material(material_reinf, FALSE)
	material_reinf = reinforcing
	register_material(material_reinf, FALSE)
	unregister_material(material_girder, FALSE)
	material_girder = girder
	register_material(material_girder, FALSE)

	update_materials()

/turf/simulated/wall/proc/set_outer_material(datum/material/material)
	unregister_material(material_outer, TRUE)
	material_outer = material
	register_material(material_outer, TRUE)

	update_materials()

/turf/simulated/wall/proc/set_reinforcing_material(datum/material/material)
	unregister_material(material_reinf, FALSE)
	material_reinf = material
	register_material(material_reinf, FALSE)

	update_materials()

/turf/simulated/wall/proc/set_girder_material(datum/material/material)
	unregister_material(material_girder, FALSE)
	material_girder = material
	register_material(material_girder, FALSE)

	update_materials()

/turf/simulated/wall/proc/update_materials()
	if(material_reinf)
		construction_stage = 6
		name = "reinforced [material_outer.display_name] wall"
		desc = "It seems to be a section of hull reinforced with [material_reinf.display_name] and plated with [material_outer.display_name]."
	else if(material_outer)
		construction_stage = null
		name = "[material_outer.display_name] wall"
		desc = "It seems to be a section of hull plated with [material_outer.display_name]."
	else
		construction_stage = null
		name = "wall"
		desc = "It seems to be a section of hull."

	var/integrity_factor = (isnull(material_outer)? 1 : material_outer.relative_integrity) * 0.75
	integrity_factor += (isnull(material_girder)? 1 : material_girder.relative_integrity) * 0.25
	integrity_factor += (isnull(material_reinf)? 0 : material_reinf.relative_integrity) * 0.5

	set_multiplied_integrity(integrity_factor, FALSE)

	var/datum/armor/grabbed = SSmaterials.wall_materials_armor(list((material_girder) = MATERIAL_SIGNIFICANCE_WALL_GIRDER, (material_reinf) = MATERIAL_SIGNIFICANCE_WALL_REINF, (material_outer) = MATERIAL_SIGNIFICANCE_WALL))
	set_armor(grabbed)

	rad_insulation = 1 / ((material_girder?.density * 0.1 + material_outer?.density * 1.2 + material_reinf?.density * 0.5) / 8 * 1.7)

	update_appearance()
