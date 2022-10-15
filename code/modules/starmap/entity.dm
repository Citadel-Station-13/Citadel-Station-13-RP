/**
 * simple struct to hold entity data
 */
/datum/starmap_entity
	//! intrinsics
	var/id
	var/x
	var/y

	//! fluff
	var/name
	var/group
	var/desc

/datum/starmap_entity/New(id, x, y, name, group, desc)
	src.id = id
	src.x = x
	src.y = y
	src.name = name
	src.group = group
	src.desc = desc

/datum/starmap_entity/proc/verify()
	return sanitize() && isnum(x) && isnum(y) && istext(id) && length(id)

/datum/starmap_entity/proc/sanitize()
	if(!istext(name))
		name = null
	if(!istext(desc))
		desc = null
	if(!istext(group))
		group = null
	return TRUE

/datum/starmap_entity/proc/map_data()
	return list(
		"id" = id,
		"x" = x,
		"y" = y,
		"name" = name,
		"group" = group,
		"desc" = desc
	)

/datum/starmap_entity/proc/serialize_data()
	return map_data()

/datum/starmap_entity/proc/deserialize_data(list/data)
	name = data["name"]
	desc = data["desc"]
	x = data["x"]
	y = data["y"]
	group = data["group"]
	id = data["id"]

