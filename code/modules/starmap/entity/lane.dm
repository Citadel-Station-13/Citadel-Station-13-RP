/datum/starmap_entity/lane
	var/x1
	var/y1
	var/x2
	var/y2
	var/name
	var/desc
	var/group

/datum/starmap_entity/lane/New(id, x1, y1, x2, y2, name, group, desc)
	..(id)
	src.x1 = x1
	src.y1 = y1
	src.x2 = x2
	src.y2 = y2
	src.name = name
	src.group = group
	src.desc = desc

/datum/starmap_entity/lane/verify()
	return ..() && isnum(x1) && isnum(y1) && isnum(x2) && isnum(y2)

/datum/starmap_entity/lane/sanitize()
	. = ..()
	if(!.)
		return
	if(!istext(name))
		name = null
	if(!istext(desc))
		desc = null
	if(!istext(group))
		group = null

/datum/starmap_entity/lane/map_data()
	. = ..()
	.["x1"] = x1
	.["y1"] = y1
	.["x2"] = x2
	.["y2"] = y2
	.["name"] = name
	.["desc"] = desc
	.["group"] = group

/datum/starmap_entity/lane/serialize_data()
	. = ..()
	.["x1"] = x1
	.["y1"] = y1
	.["x2"] = x2
	.["y2"] = y2
	.["name"] = name
	.["desc"] = desc
	.["group"] = group

/datum/starmap_entity/lane/deserialize_data(list/data)
	. = ..()
	name = data["name"]
	desc = data["desc"]
	x1 = data["x1"]
	y1 = data["y1"]
	x2 = data["x2"]
	y2 = data["y2"]
	group = data["group"]
