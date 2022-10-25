/datum/starmap_entity/system
	var/x
	var/y
	var/name
	var/desc
	var/group

/datum/starmap_entity/system/New(id, x, y, name, group, desc)
	..(id)
	src.x = x
	src.y = y
	src.name = name
	src.group = group
	src.desc = desc

/datum/starmap_entity/system/verify()
	return ..() && isnum(x) && isnum(y)

/datum/starmap_entity/system/sanitize()
	. = ..()
	if(!.)
		return
	if(!istext(name))
		name = null
	if(!istext(desc))
		desc = null
	if(!istext(group))
		group = null

/datum/starmap_entity/system/map_data()
	. = ..()
	.["x"] = x
	.["y"] = y
	.["name"] = name
	.["desc"] = desc
	.["group"] = group

/datum/starmap_entity/system/serialize_data()
	. = ..()
	.["x"] = x
	.["y"] = y
	.["name"] = name
	.["desc"] = desc
	.["group"] = group

/datum/starmap_entity/system/deserialize_data(list/data)
	. = ..()
	name = data["name"]
	desc = data["desc"]
	x = data["x"]
	y = data["y"]
	group = data["group"]
