SUBSYSTEM_DEF(materials)
	name = "Materials"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_MATERIALS

	/// material by id
	var/list/material_by_id

	// todo: Recover() should keep procedural materials
	// however, i can't be assed to write Recover() until we do procedural materials
	// thus, dealing with it later :^)

/datum/controller/subsystem/materials/Initialize()
	initialize_materials()
	return ..()

/datum/controller/subsystem/materials/Recover()
	initialize_materials()
	return ..()

/datum/controller/subsystem/materials/proc/initialize_materials()
	material_by_id = list()
	for(var/path in subtypesof(/datum/material))
		var/datum/material/M = path
		if(initial(M.abstract_type) == path)
			continue
		M = new path
		// todo: why are we doing initial() here? because the unit test checks for initial.
		material_by_id[initial(M.id)] = M

/datum/controller/subsystem/materials/proc/get_material(datum/material/id_or_path)
	if(istext(id_or_path))
		// yay it's an id
		return material_by_id[id_or_path]
	else if(ispath(id_or_path))
		// yay it's a path
		return material_by_id[initial(id_or_path.id)]
	else
		// what
		CRASH("what?")
