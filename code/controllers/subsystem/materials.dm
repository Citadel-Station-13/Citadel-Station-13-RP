SUBSYSTEM_DEF(materials)
	name = "Materials"
	subsystem_flags = NONE
	init_order = INIT_ORDER_MATERIALS
	wait = 2 SECONDS

	/// material by id
	var/list/material_lookup
	/// material trait by path
	var/list/material_traits
	/// legacy material lookup *vomit
	var/list/legacy_material_lookup
	/// material recipes
	var/list/datum/stack_recipe/material/material_stack_recipes

	// todo: Recover() should keep procedural materials
	// however, i can't be assed to write Recover() until we do procedural materials
	// thus, dealing with it later :^)

	/// ticked atoms
	var/list/ticking = list()
	/// currentrun
	var/list/currentrun

	/// layered armor cache
	var/list/layered_armor_cache = list()
	/// combined armor cache
	var/list/combined_armor_cache = list()
	/// wall armor cache
	var/list/wall_armor_cache = list()

/datum/controller/subsystem/materials/Initialize()
	initialize_material_traits()
	initialize_materials()
	initialize_material_recipes()
	return ..()

/datum/controller/subsystem/materials/Recover()
	initialize_material_traits()
	initialize_materials()
	initialize_material_recipes()
	if(islist(SSmaterials.ticking))
		// todo: better sanitization
		src.ticking = SSmaterials.ticking
	else
		src.ticking = list()
	return ..()

/datum/controller/subsystem/materials/proc/add_ticked_object(atom/A)
	if(A.atom_flags & ATOM_MATERIALS_TICKING)
		return
	A.atom_flags |= ATOM_MATERIALS_TICKING
	ticking += A

/datum/controller/subsystem/materials/proc/remove_ticked_object(atom/A)
	if(!(A.atom_flags & ATOM_MATERIALS_TICKING))
		return
	A.atom_flags &= ~ATOM_MATERIALS_TICKING
	ticking -= A

/datum/controller/subsystem/materials/fire(resumed)
	if(!resumed)
		src.currentrun = ticking.Copy()
	var/list/currentrun = src.currentrun
	var/atom/A
	var/dt = (subsystem_flags & SS_TICKER)? (wait * world.tick_lag) : max(world.tick_lag, wait * 0.1)
	var/i
	var/datum/material_trait/trait
	for(i in length(currentrun) to 1 step -1)
		A = currentrun[A]
		if(length(A.material_traits))
			for(trait as anything in A.material_traits)
				if(!(trait.material_trait_flags & MATERIAL_TRAIT_TICKING))
					continue
				trait.tick(A, A.material_traits[trait], dt)
		else
			trait = A.material_traits
			trait.tick(A, A.material_traits_data, dt)
		if(MC_TICK_CHECK)
			break
	currentrun.len -= (length(currentrun) - i + 1)

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

/datum/controller/subsystem/materials/proc/initialize_material_traits()
	material_traits = list()
	for(var/path in subtypesof(/datum/material_trait))
		var/datum/material/mat_trait = path
		if(initial(mat_trait.abstract_type) == path)
			continue
		mat_trait = new path
		material_traits[path] = mat_trait

/datum/controller/subsystem/materials/proc/initialize_material_recipes()
	material_stack_recipes = list()
	for(var/path in subtypesof(/datum/stack_recipe/material))
		var/datum/stack_recipe/material/this = path
		if(initial(this.abstract_type) == path)
			continue
		material_stack_recipes += new path

/**
 * fetches material instance
 *
 * please use typepaths whenever possible at compile-time for compiler sanity checking support
 * ids are acceptable on maps
 *
 * @params
 * id_or_path - id or typepath; if this is already a material instance, it will be returned as-is.
 */
/datum/controller/subsystem/materials/proc/resolve_material(datum/material/id_or_path)
	if(istext(id_or_path))
		// yay it's an id
		return material_lookup[id_or_path]
	else if(istype(id_or_path))
		return id_or_path
	else if(ispath(id_or_path))
		// yay it's a path
		return material_lookup[initial(id_or_path.id)]
	else if(isnull(id_or_path))
		return
	CRASH("what?")

/**
 * ensures a list is full of material ids for keys
 *
 * if key is not a valid material or is null, it will be nulled.
 */
/datum/controller/subsystem/materials/proc/preprocess_flat_keys_to_ids(list/L)
	// todo: optimize
	. = list()
	for(var/i in 1 to length(L))
		var/datum/material/resolved = resolve_material(L[i])
		. += resolved?.id

/**
 * ensures a list is full of material references for keys
 *
 * if key is not a valid material or is null, it will be nulled.
 */
/datum/controller/subsystem/materials/proc/preprocess_flat_keys_to_instances(list/L)
	// todo: optimize
	. = list()
	for(var/i in 1 to length(L))
		var/datum/material/resolved = resolve_material(L[i])
		. += resolved

/**
 * ensures a list is full of material ids for keys
 *
 * if key is not a valid material or is null, it will be dropped.
 * undefined behavior if there's duped ids / materials - this should never happen.
 */
/datum/controller/subsystem/materials/proc/preprocess_kv_keys_to_ids(list/L)
	// todo: optimize
	. = list()
	for(var/i in 1 to length(L))
		var/key = L[i]
		var/datum/material/resolved = resolve_material(key)
		if(isnull(resolved))
			continue
		var/value = L[key]
		.[resolved.id] = value

/**
 * ensures a list is full of material references for keys
 *
 * if key is not a valid material or is null, it will be dropped.
 * undefined behavior if there's duped ids / materials - this should never happen.
 */
/datum/controller/subsystem/materials/proc/preprocess_kv_keys_to_instances(list/L)
	// todo: optimize
	. = list()
	for(var/i in 1 to length(L))
		var/key = L[i]
		var/datum/material/resolved = resolve_material(key)
		if(isnull(resolved))
			continue
		var/value = L[key]
		.[resolved] = value

/**
 * ensures a list is full of material ids for values
 *
 * if value is not a valid material or is null, it will be nulled.
 */
/datum/controller/subsystem/materials/proc/preprocess_kv_values_to_ids(list/L)
	// todo: optimize
	. = list()
	for(var/i in 1 to length(L))
		var/key = L[i]
		var/value = L[key]
		var/datum/material/resolved = resolve_material(value)
		.[key] = resolved?.id

/**
 * ensures a list is full of material references for values
 *
 * if value is not a valid material or is null, it will be nulled.
 */
/datum/controller/subsystem/materials/proc/preprocess_kv_values_to_instances(list/L)
	// todo: optimize
	. = list()
	for(var/i in 1 to length(L))
		var/key = L[i]
		var/value = L[key]
		var/datum/material/resolved = resolve_material(value)
		.[key] = resolved

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
	var/datum/material/mat = resolve_material(id_or_path)
	mat.place_sheet(where, amount)

/**
 * ! DEPRECATED
 * todo: REMOVE
 *
 * DO NOT USE THIS PROC
 * Use SSmaterials.resolve_material()!
 */
/proc/get_material_by_name(name)
	if(istype(name, /datum/material))
		return name
	return SSmaterials.legacy_material_lookup[name]

/**
 * tgui materials context
 *
 * generates data for tgui/interfaces/common/Materials.tsx:
 * * MaterialsContext
 * * FullMaterialsContext
 *
 * @params
 * * ids - material ids. defaults to all.
 * * full - for FullMaterialsContext? usually not needed.
 */
/datum/controller/subsystem/materials/proc/tgui_materials_context(list/ids, full = FALSE)
	var/list/data = list()
	// a hack to make this default to all if not specified.
	for(var/id in ids || material_lookup)
		var/datum/material/mat = material_lookup[id]
		var/list/built = list(
			"name" = mat.display_name || mat.name,
			"id" = mat.id,
			"iconKey" = mat.tgui_icon_key,
			"sheetAmount" = SHEET_MATERIAL_AMOUNT,
		)
		data[mat.id] = built
	// todo: per-material sheetAmount
	return list(
		"materials" = data,
		"sheetAmount" = SHEET_MATERIAL_AMOUNT,
	)
