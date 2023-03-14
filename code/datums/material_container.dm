/datum/material_container
    /// solid materials (so usually sheets), keyed by ID
    var/list/sheets
    /// space available for materials - list with ids for specific, null for infinite, just a number for combined
    var/list/capacity

/datum/material_container/New(list/materials_capacity)
	src.materials_capacity = materials_capacity

/**
 * dumps everything out
 *
 * @params
 * * where - where to put everything
 */
/datum/material_container/proc/dump_everything(atom/where)
	#warn impl

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
/datum/material_container/proc/insert_sheets(obj/item/stack/inserting, amount = INFINITY, force = FALSE)
	#warn impl

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
		if(isnull(sheets[key]))
			continue
		sheets[key] = max(0, sheets[key] - using[key])
	return TRUE

/**
 * checks if we have the given resources
 *
 * @params
 * * sheets - units of sheets
 */
/datum/material_container/proc/has(list/wanted)
	for(var/key in wanted)
		if(sheets?[key] < wanted[key])
			return FALSE
	return TRUE
