/datum/starmap_entity/group
	enum = STARMAP_ENTITY_GROUP
	var/name
	var/color
	var/desc

#warn group flags

/datum/starmap_entity/group/New(id, color, name, desc)
	..(id)
	src.color = color
	src.name = name
	src.desc = desc

/datum/starmap_entity/group/sanitize()
	. = ..()
	if(!istext(name))
		name = null
	if(!istext(desc))
		desc = null
	color = sanitize_hexcolor(color, 6, TRUE, rgb(255, 255, 255))

/datum/starmap_entity/group/map_data()
	. = ..()
	.["name"] = name
	.["desc"] = desc
	.["color"] = color

/datum/starmap_entity/group/serialize_data()
	. = ..()
	.["name"] = name
	.["desc"] = desc
	.["color"] = color

/datum/starmap_entity/group/deserialize_data(list/data)
	. = ..()
	name = data["name"]
	color = data["color"]
	desc = data["desc"]
