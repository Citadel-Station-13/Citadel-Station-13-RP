SUBSYSTEM_DEF(materials)
	name = "Materials"
	subsystem_flags = NONE
	init_order = INIT_ORDER_MATERIALS
	wait = 2 SECONDS

	/// material recipes
	var/list/datum/stack_recipe/material/material_stack_recipes

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
	initialize_material_recipes()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/materials/Recover()
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
	var/dt = nominal_dt_s
	var/i
	var/datum/prototype/material_trait/trait
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

/datum/controller/subsystem/materials/proc/initialize_material_recipes()
	material_stack_recipes = list()
	for(var/path in subtypesof(/datum/stack_recipe/material))
		var/datum/stack_recipe/material/this = path
		if(initial(this.abstract_type) == path)
			continue
		material_stack_recipes += new path

/**
 * ensures a list is full of material ids for keys
 *
 * if key is not a valid material or is null, it will be nulled.
 */
/datum/controller/subsystem/materials/proc/preprocess_flat_keys_to_ids(list/L)
	// todo: optimize
	. = list()
	for(var/i in 1 to length(L))
		var/datum/prototype/material/resolved = RSmaterials.fetch(L[i])
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
		var/datum/prototype/material/resolved = RSmaterials.fetch(L[i])
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
		var/datum/prototype/material/key = L[i]
		var/value = L[key]
		if(istype(key))
			key = key.id
		else if(ispath(key))
			key = initial(key.id)
		else if(istext(key))
		else
			CRASH("what? '[key]'")
		.[key] = value

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
		var/value = L[key]
		var/datum/prototype/material/resolved = RSmaterials.fetch_or_defer(key)
		switch(resolved)
			if(null)
				continue
			if(REPOSITORY_FETCH_DEFER)
				// todo: handle this
				continue
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
		var/datum/prototype/material/value = L[key]
		if(istype(value))
			value = value.id
		else if(ispath(value))
			value = initial(value.id)
		else if(istext(value))
		else
			CRASH("what? '[value]'")
		.[key] = value

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
		var/datum/prototype/material/resolved = RSmaterials.fetch_or_defer(value)
		switch(resolved)
			if(REPOSITORY_FETCH_DEFER)
				// todo: handle this
			else
				value = resolved
		.[key] = resolved

/**
 * returns all material datums
 *
 * expensive (duh) use sparingly
 */
/datum/controller/subsystem/materials/proc/all_materials()
	RETURN_TYPE(/list)
	return RSmaterials.fetch_subtypes_immutable(/datum/prototype/material):Copy()

/**
 * drop a material sheet
 */
/datum/controller/subsystem/materials/proc/drop_sheets(datum/prototype/material/id_or_path, amount, atom/where)
	var/datum/prototype/material/mat = RSmaterials.fetch(id_or_path)
	mat.place_sheet(where, amount)

/**
 * ! DEPRECATED
 * todo: REMOVE
 *
 * DO NOT USE THIS PROC
 * Use RSmaterials.fetch()!
 */
/proc/get_material_by_name(name)
	if(istype(name, /datum/prototype/material))
		return name
	return RSmaterials.legacy_material_lookup[name]

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
	for(var/id in ids || RSmaterials.id_lookup)
		var/datum/prototype/material/mat = RSmaterials.fetch(id)
		var/list/built = list(
			"name" = mat.display_name || mat.name,
			"id" = mat.id,
			"iconKey" = mat.tgui_icon_key,
			"sheetAmount" = SHEET_MATERIAL_AMOUNT,
		)
		if(full)
			built["relative_integrity"] = mat.relative_integrity
			built["hardness"] = mat.hardness
			built["toughness"] = mat.toughness
			built["refraction"] = mat.refraction
			built["absorption"] = mat.absorption
			built["nullification"] = mat.nullification
			built["density"] = mat.density
			built["weight_multiplier"] = mat.weight_multiplier
			built["relative_conductivity"] = mat.relative_conductivity
			built["relative_reactivity"] = mat.relative_reactivity
			built["relative_permeability"] = mat.relative_permeability
			built["melting_point"] = mat.melting_point
			built["opacity"] = mat.opacity
			built["tags"] = mat.material_tags

			var/list/constraint_list = list()
			var/datum/bitfield_legacy/single/constraint_bf = new /datum/bitfield_legacy/single/material_constraints
			constraint_list += mat.material_constraints //Add the unified constraint
			for(var/key in constraint_bf.flags)
				if(constraint_bf.flags[key] & mat.material_constraints)
					constraint_list += constraint_bf.flags[key] //And the individual constraints. This is because we'll be using js' .Includes() to check if a constraint bitflag is present.
					//We do this instead of passing the direct flags to JS for the following reasons and using bitwise and because:

					//E.g if your material is MATERIAL_CONSTRAINT_RIGID | MATERIAL_CONSTRAINT_TRANSPARENT (e.g clear plastic)
					//you want it to pass checks for both MATERIAL_CONSTRAINT_RIGID, MATERIAL_CONSTRAINT_TRANSPARENT and (MATERIAL_CONSTRAINT_RIGID | MATERIAL_CONSTRAINT_TRANSPARENT)


					//TODO: Reconstruction of combined bitfields
					//Because if your material is RIGID | CONDUCTIVE | CRYSTALLINE
					//you should be able to use it in RIGID | CONDUCTIVE applications, but not RIGID | CONDUCTIVE | CRYSTALLINE | RADIOACTIVE
					//But right now, you can't.



			built["constraints"] = constraint_list
		data[mat.id] = built
	// todo: per-material sheetAmount
	return list(
		"materials" = data,
		"sheetAmount" = SHEET_MATERIAL_AMOUNT,
	)
