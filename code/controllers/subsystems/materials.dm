SUBSYSTEM_DEF(materials)
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_MATERIALS
	var/list/datum/material/all_materials
	var/list/materials_by_id

/datum/controller/subsystem/materials/Initialize()
	initialize_materials()
	return ..()

/datum/controller/subsystem/materials/proc/initialize_materials()
	all_materials = list()
	materials_by_id = list()
	for(var/path in subtypesof(/datum/material))
		var/datum/material/M = path
		if((initial(M.abstract_type) != path) && initial(M.auto_init))
			M = new
			all_materials += M
			materials_by_id[M.id] = M
	//Might add checks for collisions but better off in unit tests, meh.

/datum/controller/subsystem/materials/proc/material_by_id(id)
	return materials_by_id(id)

/datum/controller/subsystem/materials/proc/material_display_name_by_id(id)
	var/datum/material/M = id_to_material(id)
	return M?.display_name
