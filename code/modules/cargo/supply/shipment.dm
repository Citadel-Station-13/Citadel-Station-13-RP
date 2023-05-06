/**
 * an individual instance of a supply export
 */
/datum/supply_shipment
	/// structured contents list - cleared after processing
	/// basically, item = list(stuff in it = list(stuff in it = ...)), this way we can get a
	/// *really* neat manifest.
	var/list/cached_structure
	/// where we got sent to
	var/destination
	/// are we processed?
	var/processed = FALSE
	/// did we get denied by the destination? null for no, string for reason
	var/denied
	/// source
	var/datum/supply_system/source
	/// destination name - used for UI
	var/destination_name


#warn impl

/**
 * lazy construct() that auto-unpacks certain storage types.
 */
/datum/supply_shipment/proc/auto_construct(datum/supply_system/system, list/atom/atoms, destination)
	var/list/unpacked = list()
	for(var/atom/A as anything in atoms)
		unpacked[A] = A.export_recurse()
	return construct(system, unpacked, destination)

/**
 * construct us from a list of atoms to export, and a list of exports to apply to those atoms
 *
 * you are expected to unpack container-type atoms like crates beforehand!
 */
/datum/supply_shipment/proc/construct(datum/supply_system/system, list/structured, destination)
	#warn impl

/**
 * send and process this shipment
 */
/datum/supply_shipment/proc/ship()
	var/datum/target = SSsupply.resolve_destination(destination)
	if(istype(target, /datum/supply_faction))
		var/datum/supply_faction/faction = target
	else if(istype(target, /datum/supply_bounty))
		var/datum/supply_bounty/bounty = target


/**
 * returns objects to be exported other than ourselves
 * this is recursively called
 *
 * @return list or null
 */
/atom/proc/export_recurse()
	return
