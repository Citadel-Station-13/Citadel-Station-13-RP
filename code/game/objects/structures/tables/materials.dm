/obj/structure/table/update_material_multi(list/parts)
	var/datum/prototype/material/structure = material_base
	if(isnull(structure)) // we're not normal
		update_connections()
		update_appearance()
		return
	var/datum/prototype/material/reinforcing = material_reinforcing
	var/amount = structure.relative_integrity * 100 + reinforcing?.relative_integrity * 50
	set_full_integrity(amount, amount)
	// the () is to block the list() from making it a string
	set_armor(SSmaterials.reinforcing_materials_armor(list(
		(structure) = MATERIAL_SIGNIFICANCE_TABLE_STRUCTURE,
		(reinforcing) = MATERIAL_SIGNIFICANCE_TABLE_REINFORCEMENT,
	)))
	// sigh
	if(SSatoms.atom_init_status == ATOM_INIT_IN_NEW_REGULAR)
		update_connections(TRUE)
		update_appearance()

/obj/structure/table/material_get_parts()
	return list(
		"base" = material_base,
		"reinf" = material_reinforcing,
	)

/obj/structure/table/material_get_part(part)
	switch(part)
		if("base")
			return material_base
		if("reinf")
			return material_reinforcing

/obj/structure/table/material_set_part(part, datum/prototype/material/material)
	var/datum/prototype/material/old
	var/primary = FALSE
	switch(part)
		if("base")
			primary = TRUE
			old = material_base
			material_base = material
		if("reinf")
			old = material_reinforcing
			material_reinforcing = material
	if(material != old)
		unregister_material(old, primary)
		register_material(material, primary)

/obj/structure/table/material_init_parts()
	material_base = RSmaterials.fetch(material_base)
	material_reinforcing = RSmaterials.fetch(material_reinforcing)
	register_material(material_base, TRUE)
	register_material(material_reinforcing, FALSE)
