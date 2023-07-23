//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* Init

/**
 * initialize materials
 */
/obj/proc/init_material_parts()
	obj_flags |= OBJ_MATERIAL_INITIALIZED
	if(islist(material_parts))
		var/list/parts = list()
		for(var/key in material_parts)
			parts[key] = SSmaterials.resolve_material(key)
		update_material_parts(parts)
	else if(material_parts == MATERIAL_DEFAULT_DISABLED)
	else
		update_material_single(SSmaterials.resolve_material(material_parts))

/**
 * do we use material parts system?
 */
/obj/proc/uses_material_parts()
	return material_parts != MATERIAL_DEFAULT_DISABLED

//* Get

/obj/get_materials(respect_multiplier)
	. = isnull(materials_base)? list() : materials_base.Copy()
	if(islist(material_parts))
		for(var/i in 1 to length(material_parts))
			.[material_parts[i]] = material_costs[i]
	else if(material_parts == MATERIAL_DEFAULT_DISABLED)
	else
		.[material_parts] = material_costs
	if(respect_multiplier && material_multiplier != 1)
		for(var/key in .)
			.[key] *= material_multiplier

/**
 * get base material amounts
 */
/obj/proc/get_base_material_amounts(respect_multiplier)
	. = isnull(materials_base)? list() : materials_base.Copy()
	if(respect_multiplier && material_multiplier != 1)
		for(var/key in .)
			.[key] *= material_multiplier

/**
 * get the only material we're made out of, or first material part
 *
 * @return material instance
 */
/obj/proc/get_primary_material()
	if(material_parts == MATERIAL_DEFAULT_DISABLED)
		. = null
	else
		. = islist(material_parts)? material_parts[1] : material_parts
	if(isnull(.))
		return
	return SSmaterials.resolve_material(.)

/**
 * get the only material we're made out of, or first material part
 */
/obj/proc/get_primary_material_id()
	if(material_parts == MATERIAL_DEFAULT_DISABLED)
		. = null
	else
		. = islist(material_parts)? material_parts[1] : material_parts

/**
 * get material part
 *
 * @return material instance
 */
/obj/proc/get_material_part(part)
	if(material_parts == MATERIAL_DEFAULT_DISABLED)
		. = null
	if(islist(material_parts))
		. = material_parts[part]
	else
		. = (part == MATERIAL_PART_DEFAULT)? material_parts : null
	if(isnull(.))
		return
	return SSmaterials.resolve_material(.)

/**
 * get material part
 */
/obj/proc/get_material_part_id(part)
	if(material_parts == MATERIAL_DEFAULT_DISABLED)
		. = null
	if(islist(material_parts))
		. = material_parts[part]
	else
		. = (part == MATERIAL_PART_DEFAULT)? material_parts : null

/**
 * get material parts
 *
 * @return keys to instances
 */
/obj/proc/get_material_parts()
	if(islist(material_parts))
		var/list/resolving = list()
		for(var/key in material_parts)
			resolving[key] = isnull(material_parts[key])? null : SSmaterials.resolve_material(material_parts[key])
		return resolving
	else if(material_parts == MATERIAL_DEFAULT_DISABLED)
		return list()
	else
		if(isnull(material_parts))
			return list(MATERIAL_PART_DEFAULT = null)
		return list(MATERIAL_PART_DEFAULT = SSmaterials.resolve_material(material_parts))

/**
 * get material parts
 */
/obj/proc/get_material_part_ids()
	if(islist(material_parts))
		return material_parts.Copy()
	else if(material_parts == MATERIAL_DEFAULT_DISABLED)
		return list()
	else
		return list(MATERIAL_PART_DEFAULT = material_parts)

/**
 * get material amounts of parts
 */
/obj/proc/get_material_part_amounts(respect_multiplier)
	if(material_parts == MATERIAL_DEFAULT_DISABLED)
		return list()
	else if(islist(material_parts))
		. = list()
		if(!islist(material_costs))
			return
		for(var/i in 1 to length(material_parts))
			var/key = material_parts[i]
			.[key] = material_costs[i]
	else
		. = list(MATERIAL_PART_DEFAULT = material_costs)
	if(respect_multiplier && material_multiplier != 1)
		for(var/key in .)
			.[key] *= material_multiplier

//* Set

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
 * sets a single material part
 *
 * @params
 * * part - part key
 * * material_like - material. ids and paths are not allowed for performance reasons
 */
/obj/proc/set_material_part(part, datum/material/material)
	obj_flags |= OBJ_MATERIAL_PARTS_MODIFIED
	#warn impl

/**
 * sets our material parts to a list by key / value. values should be material datums.
 * ids and typepaths are not allowed in part_instances for performance reasons.
 */
/obj/proc/set_material_parts(list/part_instances)
	obj_flags |= OBJ_MATERIAL_PARTS_MODIFIED
	#warn impl

/**
 * sets our material costs, for.. whatever reason?
 * ids and typepaths are not allowed in part_instances for performance reasons.
 */
/obj/proc/set_material_costs(list/part_costs)
	obj_flags |= OBJ_MATERIAL_COSTS_MODIFIED
	#warn impl

/**
 * sets our primary material to something
 *
 * if we have more than one material part (as determined by material_parts),
 * this sets the first one.
 * if we don't, this sets our only material.
 *
 * ids and typepaths are not allowed in part_instances for performance reasons.
 */
/obj/proc/set_primary_material(datum/material/material)
	obj_flags |= OBJ_MATERIAL_PARTS_MODIFIED
	#warn impl
	return length(material_parts)? set_material_part(material_parts[1], material) : set_material_part(MATERIAL_PART_DEFAULT, material)

//* Update

/**
 * update material parts
 *
 * only called if material_parts is in list format.
 *
 * @params
 * * parts - list of key-value key to material id.
 */
/obj/proc/update_material_parts(list/parts)
	return

/**
 * update material default part
 *
 * only called if material_parts is in singleton format
 */
/obj/proc/update_material_single(datum/material/material)
	return

//* Lathe Autodetect

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
	if(material_parts == MATERIAL_DEFAULT_DISABLED)
		return list()
	else if(islist(material_parts))
		. = list()
		if(!islist(material_costs))
			return
		for(var/i in 1 to length(material_parts))
			var/key = material_parts[i]
			.[key] = material_costs[i]
		return
	else
		return list(MATERIAL_PART_DEFAULT = material_costs)

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
	return isnull(materials_base)? materials_base.Copy() : list()
