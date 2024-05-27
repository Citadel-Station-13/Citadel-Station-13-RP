//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/proc/create_maploader_context(
	mangling_id,
)
	RETURN_TYPE(/datum/maploader_context)
	var/datum/maploader_context/context = new
	context.mangling_id = mangling_id
	return context

/**
 * something accessible to all atoms during preloading_instance
 */
/datum/maploader_context
	/// mangling id - if non-null, atoms under this context should
	/// use this to mangle their obfuscation IDs appropriately
	/// if they're meant to link to other devices on the same map
	var/mangling_id

