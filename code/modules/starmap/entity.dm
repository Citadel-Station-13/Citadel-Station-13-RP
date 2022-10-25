/**
 * simple struct to hold data
 */
/datum/starmap_entity
	//! intrinsics
	/// id - must be unique; usually number or string
	var/id
	/// entity type
	var/enum

/datum/starmap_entity/New(id)
	src.id = id

/datum/starmap_entity/proc/verify()
	return sanitize() && istext(id) && length(id)

/datum/starmap_entity/proc/sanitize()
	return TRUE

/datum/starmap_entity/proc/map_data()
	return list(
		"id" = id,
		"enum" = enum
	)

/datum/starmap_entity/proc/serialize_data()
	return list("id" = id, "enum" = enum)

/datum/starmap_entity/proc/deserialize_data(list/data)
	id = data["id"]
	enum = data["enum"]
