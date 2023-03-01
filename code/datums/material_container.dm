/datum/material_container
    /// solid materials (so usually sheets), keyed by ID
    var/list/sheets
    /// space available for materials - list with ids for specific, null for infinite, just a number for combined
    var/list/capacity

/datum/material_container/New(atom/container, materials_capacity)

/datum/material_container/Destroy()
	#warn impl
	return ..()

/**
 * dumps everything out
 *
 * @params
 * * where - where to put everything
 */
/datum/material_container/proc/dump_everything(atom/where)

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

/**
 * uses the given resources, failing if not enough
 *
 * @params
 * * sheets - units of sheets to use
 *
 * @return TRUE / FALSE based on success / fail
 */
/datum/material_container/proc/checked_use(list/sheets)


/**
 * uses the given resources
 *
 * @params
 * * sheets - units of sheets to use
 */
/datum/material_container/proc/use(list/sheets)


/**
 * checks if we have the given resources
 *
 * @params
 * * sheets - units of sheets
 */
/datum/material_container/proc/has(list/sheets)

