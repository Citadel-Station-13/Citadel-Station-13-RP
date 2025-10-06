/turf/simulated/wall/proc/init_materials(datum/prototype/material/outer = material_outer, datum/prototype/material/reinforcing = material_reinf, datum/prototype/material/girder = material_girder)
	if(!material_system)
		return FALSE
	outer = RSmaterials.fetch_local_or_throw(outer)
	reinforcing = RSmaterials.fetch_local_or_throw(reinforcing)
	girder = RSmaterials.fetch_local_or_throw(girder)

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
	return TRUE

/turf/simulated/wall/proc/set_materials(datum/prototype/material/outer, datum/prototype/material/reinforcing, datum/prototype/material/girder)
	if(!material_system)
		return FALSE

	unregister_material(material_outer, TRUE)
	unregister_material(material_reinf, FALSE)
	unregister_material(material_girder, FALSE)

	material_outer = outer
	material_reinf = reinforcing
	material_girder = girder

	register_material(material_outer, TRUE)
	register_material(material_reinf, FALSE)
	register_material(material_girder, FALSE)

	update_materials()
	return TRUE

/turf/simulated/wall/proc/set_outer_material(datum/prototype/material/material)
	if(!material_system)
		return FALSE

	unregister_material(material_outer, TRUE)
	material_outer = material
	register_material(material_outer, TRUE)

	update_materials()
	return TRUE

/turf/simulated/wall/proc/set_reinforcing_material(datum/prototype/material/material)
	if(!material_system)
		return FALSE

	unregister_material(material_reinf, FALSE)
	material_reinf = material
	register_material(material_reinf, FALSE)

	update_materials()
	return TRUE

/turf/simulated/wall/proc/set_girder_material(datum/prototype/material/material)
	if(!material_system)
		return FALSE

	unregister_material(material_girder, FALSE)
	material_girder = material
	register_material(material_girder, FALSE)

	update_materials()
	return TRUE

/turf/simulated/wall/proc/update_materials()
	if(!material_system)
		return FALSE

	if(material_reinf)
		construction_stage = 6
	else
		construction_stage = null


	if(!isnull(material_reinf))
		icon = material_reinf.icon_reinf
	else if(!isnull(material_outer))
		icon = material_outer.icon_base
	else
		icon = 'icons/turf/walls/solid_wall.dmi'

	stripe_icon = material_outer.wall_stripe_icon
	material_color = material_outer.icon_colour


	var/integrity_factor = (material_outer ? material_outer.relative_integrity : 1) * 0.75
	integrity_factor += (material_girder ? material_girder.relative_integrity : 1) * 0.25
	integrity_factor += (material_reinf ? material_reinf.relative_integrity : 0) * 0.5


	set_multiplied_integrity(integrity_factor, FALSE)

	set_armor(SSmaterials.wall_materials_armor(list(
		(material_girder) = MATERIAL_SIGNIFICANCE_WALL_GIRDER,
		(material_reinf) = MATERIAL_SIGNIFICANCE_WALL_REINF,
		(material_outer) = MATERIAL_SIGNIFICANCE_WALL)
	))

	rad_insulation = 1 / ((material_girder?.density * 0.1 + material_outer?.density * 1.2 + material_reinf?.density * 0.5) / 8 * 1.7)

	update_appearance()
	return TRUE
