SUBSYSTEM_DEF(materials)
	name = "Materials"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_MATERIALS

	/// material by id
	var/list/material_lookup
	/// legacy material lookup *vomit
	var/list/legacy_material_lookup

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
	material_lookup = list()
	legacy_material_lookup = list()

	for(var/path in subtypesof(/datum/material))
		var/datum/material/mat_ref = path
		if(initial(mat_ref.abstract_type) == path)
			continue

		mat_ref = new path
		// Initialize the material. It'll return TRUE if everything went well.
		if(!mat_ref.Initialize())
			CRASH("Failed to initialize material [mat_ref.name]!")

		// why are we doing initial() here? because the unit test checks for initial.
		material_lookup[initial(mat_ref.id)] = mat_ref
		legacy_material_lookup[lowertext(mat_ref.name)] = mat_ref

/**
 * fetches material instance
 *
 * please use typepaths whenever possible at compile-time for compiler sanity checking support
 * ids are acceptable on maps
 *
 * @params
 * id_or_path - id or typepath
 */
/datum/controller/subsystem/materials/proc/get_material(datum/material/id_or_path)
	if(istext(id_or_path))
		// yay it's an id
		return material_lookup[id_or_path]
	else if(ispath(id_or_path))
		// yay it's a path
		return material_lookup[initial(id_or_path.id)]
	else
		// what
		// yes you get a runtime if you pass null in, the subsystem shouldn't have to sanitycheck for you.
		CRASH("tried to fetch neither a text string (id) or a typepath (compiled in material type)")

/**
 * returns all material datums
 *
 * expensive (duh) use sparingly
 */
/datum/controller/subsystem/materials/proc/all_materials()
	RETURN_TYPE(/list)
	. = list()
	for(var/id in material_lookup)
		. += material_lookup[id]

/**
 * drop a material sheet
 */
/datum/controller/subsystem/materials/proc/drop_sheets(datum/material/id_or_path, amount, atom/where)
	var/datum/material/mat = get_material(id_or_path)
	mat.place_sheet(where, amount)

/**
 * ! DEPRECATED
 * todo: REMOVE
 *
 * DO NOT USE THIS PROC
 * Use SSmaterials.get_material()!
 */
/proc/get_material_by_name(name)
	return SSmaterials.legacy_material_lookup[name]
