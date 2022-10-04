/**
 * lightweight datums that load
 * prototype data based on type
 * and do some processing on them to get
 * important tidbits out, as well as
 * doing semantic linking when needed.
 */
/datum/prototype
	/// type but we can't call it type :(
	var/domain
	/// id
	var/id

/datum/prototype/New(id, list/data)
	src.id = id
	Initialize(data)

/datum/prototype/proc/Initialize(list/data)
	return
