/**
 * Returns all crosslinked z indices
 */
/datum/controller/subsystem/mapping/proc/crosslinked_levels()
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/space_level/L as anything in ordered_levels)
		if(L.linkage_mode == Z_LINKAGE_CROSSLINKED)
			. += L.z_value
