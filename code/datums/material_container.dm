/datum/material_container
    /// solid materials (so usually sheets), keyed by ID
    var/list/stored
    /// space available for materials - list with ids for specific, null for infinite, just a number for combined
    var/list/capacity

/datum/material_container/New(list/materials_capacity)
	src.capacity = materials_capacity

/**
 * dumps everything out
 *
 * @params
 * * where - where to put everything
 */
/datum/material_container/proc/dump_everything(atom/where)
	for(var/mat_id in stored)
		var/datum/material/M = SSmaterials.get_material(mat_id)
		if(isnull(M))
			continue
		var/safety = 50
		var/sheets = round(stored[mat_id] / SHEET_MATERIAL_AMOUNT)
		stored[mat_id] -= sheets * SHEET_MATERIAL_AMOUNT
		var/obj/item/stack/stack_type = M.stack_type
		if(!stack_type)
			continue
		var/stack_size = initial(stack_type.max_amount)
		if(!stack_size)
			continue
		while(sheets > 0)
			var/wanted = min(stack_size, sheets)
			M.place_sheet(where, wanted)
			sheets -= wanted
			if(!--safety)
				break
		// if we somehow have remaining, which we shouldn't
		stored[mat_id] += sheets * SHEET_MATERIAL_AMOUNT

/**
 * Inserts sheets
 *
 * Will use() / delete the sheets as needed
 *
 * If you want to just tick materials up, directly access the lists.
 *
 * @params
 * * inserting - sheets
 * * amount - max to insert
 * * force - ignore capacity
 *
 * @return sheets consumed
 */
/datum/material_container/proc/insert_sheets(obj/item/stack/material/inserting, amount = INFINITY, force = FALSE)
	if(!istype(inserting))
		return 0
	var/datum/material/mat = inserting.material
	var/allowed = capacity_material_sheets(mat)
	var/inserted = min(allowed, inserting.amount)
	inserting.use(inserted)
	stored[mat.id] += inserted * SHEET_MATERIAL_AMOUNT
	return inserted

/**
 * has space for sheets
 *
 * @return sheets remaining of capacity
 */
/datum/material_container/proc/capacity_sheets(obj/item/stack/material/inserting)
	if(!istype(inserting))
		return 0
	var/datum/material/mat = inserting.material
	return capacity_material_sheets(mat)

/**
 * is this sheet instance allowed
 */
/datum/material_container/proc/allowed_sheets(obj/item/stack/material/inserting)
	if(!istype(inserting))
		return 0
	return allowed_material(inserting.material)

/**
 * has space for material
 *
 * @params
 * * mat - material instance
 *
 * @return number of sheets allowed
 */
/datum/material_container/proc/capacity_material_sheets(datum/material/mat)
	if(isnull(capacity))
		return INFINITY
	if(isnum(capacity))
		return max(0, round((capacity - total_stored()) / SHEET_MATERIAL_AMOUNT))
	if(islist(capacity))
		var/cap = capacity[mat.id]
		var/cur = stored[mat.id]
		if(isnull(cap))
			return 0
		return max(0, round((cap - cur) / SHEET_MATERIAL_AMOUNT))
	CRASH("what?")

/**
 * is this material allowed
 */
/datum/material_container/proc/allowed_material(datum/material/mat)
	return isnull(capacity) || isnum(capacity) || !isnull(capacity[mat.id])

/**
 * total utilization in units, not sheets
 */
/datum/material_container/proc/total_stored()
	. = 0
	for(var/key in stored)
		. += stored[key]

/**
 * uses the given resources, failing if not enough
 *
 * @params
 * * sheets - units of sheets to use
 *
 * @return TRUE / FALSE based on success / fail
 */
/datum/material_container/proc/checked_use(list/using)
	if(!has(using))
		return FALSE
	return use(using)

/**
 * uses the given resources
 *
 * @params
 * * sheets - units of sheets to use
 */
/datum/material_container/proc/use(list/using)
	for(var/key in using)
		if(isnull(stored[key]))
			continue
		stored[key] = max(0, stored[key] - using[key])
	return TRUE

/**
 * checks if we have the given resources
 *
 * @params
 * * sheets - units of sheets
 */
/datum/material_container/proc/has(list/wanted)
	for(var/key in wanted)
		if(stored?[key] < wanted[key])
			return FALSE
	return TRUE
