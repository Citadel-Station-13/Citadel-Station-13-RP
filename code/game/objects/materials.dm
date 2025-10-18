//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//? TL;DR
//?
//? Three ways of using materials
//?
//? 1. You only need one material
//? - set material_parts to MATERIAL_DEFAULT_NONE or a material typepath / id
//? - set material_costs to a number to indicate how much cm3 of the material is in there
//? - for items that can be made of multiple materials (most items), set material_constraints to a set of MATERIAL_CONSTRAINT flags that indicate the required constraint_flags on the material. combined flags are stricter
//? - on update, update_material_single will be called; hook modifications to this
//? - on init, the system will call update_material_single for you.
//
//?
//? 2. You need multiple materials, and your item is rare enough there isn't more than a few hundred of it
//? - set material_parts to a k-v list.
//?   note that the key needs to be player-readable
//?
//?   example: material_parts = list("structure" = /datum/prototype/material/steel, "reinforcement" = /datum/prototype/material/wood)
//?
//? - set material_costs to an ordered list of costs
//?
//?   example: list(2000, 1000) = 1 sheet of steel and 0.5 sheets of wood as per above
//?
//? - set material_constraints to an ordered list of constraints corresponding to the parts
//?
//?   example: list(MATERIAL_CONSTRAINT_RIGID, MATERIAL_CONSTRAINT_UNCONSTRAINED)
//?
//? - update_material_multi will be called with list of keys to instances as values
//?   so you can implement your behaviors there
//?
//? 3. You need multiple materials, and your object is spammed on the map and you need it to be more efficient
//? - Define material vars yourself. a hard-coded material variable is more than 10x as efficient as setting it
//?   in material_parts list.
//? - Override the procs in the abstraction API to point to and use those variables.
//? - See [code/game/objects/structures/girder.dm] for an example.
//? - The system will still call update_material_multi for you as long as you call the
//?   parts API instead of the abstraction API directly. It will, however, not call it with list/parts.
//? - **Do not ever call the abstraction API directly.**

//* Base API
//! Override these procs to implement behavior.
//! Do not skip parent calls, as these are not meant to be overridden

/obj/get_materials(respect_multiplier)
	. = isnull(materials_base)? list() : materials_base.Copy()
	if(islist(material_parts))
		for(var/i in 1 to length(material_parts))
			var/datum/prototype/material/mat = material_parts[material_parts[i]]
			.[mat.id] += material_costs[i]
	else if(material_parts == MATERIAL_DEFAULT_DISABLED)
	else if(material_parts == MATERIAL_DEFAULT_ABSTRACTED)
		var/list/got = material_get_parts()
		for(var/i in 1 to length(got))
			var/key = got[i]
			var/datum/prototype/material/mat = got[key]
			.[mat.id] += material_costs[i]
	else
		var/datum/prototype/material/mat = material_parts
		.[mat.id] += material_costs
	if(respect_multiplier && material_multiplier != 1)
		for(var/key in .)
			.[key] *= material_multiplier

/**
 * sets our base materials
 *
 * * note that this takes material ids, not instances, unlike set_material_part(s).
 *
 * @params
 * * materials - material ids associated to costs
 */
/obj/proc/set_materials_base(list/materials)
	obj_flags |= OBJ_MATERIALS_MODIFIED
	materials_base = materials.Copy()

/**
 * get base material amounts
 */
/obj/proc/get_base_material_amounts(respect_multiplier)
	. = isnull(materials_base)? list() : materials_base.Copy()
	if(respect_multiplier && material_multiplier != 1)
		for(var/key in .)
			.[key] *= material_multiplier

//* Parts API
//! These cannot be overridden, and instead call the abstraction API.
//! This restriction is for code organization reasons.

/**
 * initialize materials
 */
/obj/proc/init_material_parts()
	SHOULD_NOT_OVERRIDE(TRUE)
	obj_flags |= OBJ_MATERIAL_INITIALIZED
	if(islist(material_parts))
		var/list/parts = list()
		for(var/key in material_parts)
			var/datum/prototype/material/result = RSmaterials.fetch_or_defer(key)
			switch(result)
				if(REPOSITORY_FETCH_DEFER)
					// todo: handle this
					result = null
			parts[key] = result
		update_material_multi(parts)
	else if(material_parts == MATERIAL_DEFAULT_DISABLED)
	else if(material_parts == MATERIAL_DEFAULT_ABSTRACTED)
		material_init_parts()
		// skip specifying parts because abstracted
		update_material_multi()
	else
		var/datum/prototype/material/result = RSmaterials.fetch_or_defer(material_parts)
		switch(result)
			if(REPOSITORY_FETCH_DEFER)
				// todo: handle this
				result = null
		update_material_single((material_parts = result))

/**
 * forces a material update
 */
/obj/proc/update_material_parts()
	if(islist(material_parts))
		update_material_multi(material_parts)
	else if(material_parts == MATERIAL_DEFAULT_DISABLED)
	else if(material_parts == MATERIAL_DEFAULT_ABSTRACTED)
		update_material_multi()
	else
		update_material_single(material_parts)

/**
 * @return key-value list of material part keys to ids
 */
/obj/proc/get_material_part_ids()
	SHOULD_NOT_OVERRIDE(TRUE)
	. = material_get_parts()
	for(var/key in .)
		var/datum/prototype/material/mat = .[key]
		if(isnull(mat))
			continue
		.[key] = mat.id

/**
 * @return material id of part key. null if part doesn't exist.
 */
/obj/proc/get_material_part_id(part)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/datum/prototype/material/mat = material_get_part(part)
	return mat?.id

/**
 * @return key-value list of material part keys to instances
 */
/obj/proc/get_material_parts()
	SHOULD_NOT_OVERRIDE(TRUE)
	return material_get_parts()

/**
 * @return material instance
 */
/obj/proc/get_material_part(part)
	SHOULD_NOT_OVERRIDE(TRUE)
	RETURN_TYPE(/datum/prototype/material)
	return material_get_part(part)

/**
 * sets a single material part
 *
 * @params
 * * part - part key. **undefined behavior if it does not exist.**
 * * material - material. ids and paths are not allowed for performance reasons.
 */
/obj/proc/set_material_part(part, datum/prototype/material/material)
	SHOULD_NOT_OVERRIDE(TRUE)
	obj_flags |= OBJ_MATERIAL_PARTS_MODIFIED
	material_set_part(part, material)
	if(obj_flags & OBJ_MATERIAL_INITIALIZED)
		update_material_parts()

/**
 * sets our material parts to a list by key / value. values should be material datums.
 * ids and typepaths are not allowed in part_instances for performance reasons.
 */
/obj/proc/set_material_parts(list/part_instances)
	SHOULD_NOT_OVERRIDE(TRUE)
	obj_flags |= OBJ_MATERIAL_PARTS_MODIFIED
	for(var/key in part_instances)
		material_set_part(key, part_instances[key])
	if(obj_flags & OBJ_MATERIAL_INITIALIZED)
		update_material_parts()

/**
 * do we use material parts system?
 */
/obj/proc/uses_material_parts()
	SHOULD_NOT_OVERRIDE(TRUE)
	return material_parts != MATERIAL_DEFAULT_DISABLED

/**
 * Get primary material, or first material. Can return null.
 * Determined by [material_primary]
 *
 * This should be the most 'useful' or plentiful material and is used in and only used in general heuristic checks.
 */
/obj/proc/get_primary_material()
	SHOULD_NOT_OVERRIDE(TRUE)
	RETURN_TYPE(/datum/prototype/material)
	return isnull(material_primary)? null : material_get_part(material_primary)

/**
 * Get primary material ID, or first material ID. Can return null.
 * Determined by [material_primary]
 *
 * This should be the most 'useful' or plentiful material and is used in and only used in general heuristic checks.
 */
/obj/proc/get_primary_material_id()
	SHOULD_NOT_OVERRIDE(TRUE)
	return isnull(material_primary)? null : material_get_part(material_primary)?.id

/**
 * sets our primary material to something
 *
 * if we have more than one material part (as determined by material_parts),
 * this sets the first one.
 * if we don't, this sets our only material.
 *
 * ids and typepaths are not allowed in part_instances for performance reasons.
 */
/obj/proc/set_primary_material(datum/prototype/material/material)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(isnull(material_primary))
		return
	obj_flags |= OBJ_MATERIAL_PARTS_MODIFIED
	material_set_part(material_primary, material)
	if(obj_flags & OBJ_MATERIAL_INITIALIZED)
		update_material_parts()

/**
 * get material amounts of parts
 */
/obj/proc/get_material_part_amounts(respect_multiplier)
	if(material_parts == MATERIAL_DEFAULT_DISABLED)
		return list()
	else if(material_parts == MATERIAL_DEFAULT_ABSTRACTED)
		. = list()
		var/list/parts = material_get_parts()
		if(isnull(material_costs))
			return
		for(var/i in 1 to length(parts))
			.[parts[i]] = material_costs[i]
	else if(islist(material_parts))
		. = list()
		if(isnull(material_costs))
			return
		for(var/i in 1 to length(material_parts))
			var/key = material_parts[i]
			.[key] = material_costs[i]
	else
		. = list(MATERIAL_PART_DEFAULT = material_costs || 0)
	if(respect_multiplier && material_multiplier != 1)
		for(var/key in .)
			.[key] *= material_multiplier

//* Abstraction API
//! Override these procs to implement more efficient material systems.
//! If your subtype has more than a few hundred instances on the map,
//! it's a good sign you should do so.
//!
//! Don't forget to set material_parts to MATERIAL_DEFAULT_ABSTRACTED.

/**
 * @return key-value list of material part keys to instances
 */
/obj/proc/material_get_parts()
	PROTECTED_PROC(TRUE) // Do not ever call directly.
	switch(material_parts)
		if(MATERIAL_DEFAULT_ABSTRACTED)
			CRASH("abstracted hit base")
		if(MATERIAL_DEFAULT_DISABLED)
			return list()
	if(islist(material_parts))
		return material_parts.Copy()
	return list(MATERIAL_PART_DEFAULT = material_parts)

/**
 * @return material instance
 */
/obj/proc/material_get_part(part)
	RETURN_TYPE(/datum/prototype/material)
	PROTECTED_PROC(TRUE) // Do not ever call directly.
	if(islist(material_parts))
		return material_parts[part]
	return istext(material_parts) ? null : material_parts

/**
 * sets a single material part
 *
 * undefined behavior if part does not exist in material parts when material parts is a list..
 *
 * @params
 * * part - part key
 * * material - material. ids and paths are not allowed for performance reasons.
 */
/obj/proc/material_set_part(part, datum/prototype/material/material)
	PROTECTED_PROC(TRUE) // Do not ever call directly.
	var/datum/prototype/material/old
	if(islist(material_parts))
		old = material_parts[part]
		material_parts[part] = material
	else if(part == MATERIAL_PART_DEFAULT)
		old = material_parts
		material_parts = material
	else if(part == material_primary) //if we're not MATERIAL_PART_DEFAULT but our primary isn't MATERIAL_PART_DEFAULT, we need to check for that.
		old = material_parts
		material_parts = material
	if(material != old)
		if(part == material_primary)
			unregister_material(old, TRUE)
			register_material(material, TRUE)
		else
			unregister_material(old, FALSE)
			register_material(material, FALSE)

/**
 * Called to initialize material parts.
 */
/obj/proc/material_init_parts()
	PROTECTED_PROC(TRUE) // Do not ever call directly.
	CRASH("unimplemented abstracted material_init_parts even when abstraction is enabled")

//* User API
//! Override these to implement the actual behaviors your object uses with materials.

/**
 * update material parts
 *
 * only called if material_parts is in list format, or materials is using the abstraction system
 *
 * @params
 * * parts - list of key-value key to material id. if material_parts is abstracted, parts is null
 */
/obj/proc/update_material_multi(list/parts)
	return

/**
 * update material default part
 *
 * only called if material_parts is in singleton format
 */
/obj/proc/update_material_single(datum/prototype/material/material)
	return

//* Lathe Autodetect
//! Do not override these. These are automatic based on the APIs.

/**
 * autodetect proc used by lathes
 * called only right after init
 * should never be called after materials are mutated in any way, including by init.
 *
 * returned list is a copy
 *
 * @return key-value associative list of part name to cost
 */
/obj/proc/detect_material_part_costs()
	return get_material_part_amounts()

/**
 * autodetect proc used by lathes
 * called only right after init
 * should never be called after materials are mutated in any way, including by init.
 *
 * returned list is a coy
 *
 * @return key-value associative list of our *own* baseline materials, without material parts.
 */
/obj/proc/detect_material_base_costs()
	return isnull(materials_base)? list() : materials_base.Copy()
