/obj/structure/table/update_material_parts(list/parts)
	. = ..()
	var/datum/material/structure = parts[parts[1]]
	var/datum/material/reinforcing = parts[parts[2]]
	var/amount = structure.relative_integrity * 100 + reinforcing.relative_integrity * 50
	set_full_integrity(amount, amount)
	// the () is to block the list() from making it a string
	set_armor(SSmaterials.reinforcing_materials_armor(list(
		(structure) = 1,
		(reinforcing) = 2,
	)))
	update_appearance()
	update_connections()

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

/obj/structure/table/material_set_part(part, datum/material/material)
	var/datum/material/old
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
	if(!multi)
		update_appearance()
		update_connections()

/obj/structure/table/material_init_parts()
	material_base = SSmaterials.resolve_material(material_base)
	material_reinforcing = SSmaterials.resolve_material(material_reinforcing)
	register_material(material_base, TRUE)
	register_material(material_reinforcing, FALSE)
