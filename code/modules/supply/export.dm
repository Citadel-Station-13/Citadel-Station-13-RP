/**
 * an individual instance of a supply export
 */
/datum/supply_export


#warn impl

/**
 * lazy construct() that auto-unpacks certain storage types.
 */
/datum/supply_export/proc/auto_construct(list/atom/atoms, list/datum/export/exports)


/**
 * construct us from a list of atoms to export, and a list of exports to apply to those atoms
 *
 * you are expected to unpack container-type atoms like crates beforehand!
 */
/datum/supply_export/proc/construct(list/atom/atoms, list/datum/export/exports)

/**
 * returns objects to be exported other than ourselves
 * this is recursively called
 *
 * @return list or null
 */
/atom/proc/export_recurse()
	return
