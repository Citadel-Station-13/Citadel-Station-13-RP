/**
 * where the ship goes upon FTL end
 */
/datum/ftl_destination
	/// name
	var/name = "unknown"
	/// desc
	var/desc = "Where are we going?"

/**
 * moves the object to a location
 */
/datum/ftl_destination/proc/Shunt(atom/movable/overmap_object/object)
	return FTL_DESTINATION_SHUNT_FAILED
