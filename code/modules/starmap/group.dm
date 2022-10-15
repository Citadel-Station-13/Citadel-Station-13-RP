/**
 * simple struct to hold group data
 */
/datum/starmap_group
	var/id
	var/name
	var/color
	var/desc

/datum/starmap_group/New(id, color, name, desc)
	src.id = id
	src.color = color
	src.name = name
	src.desc = desc

/datum/starmap_group/proc/verify()
	return sanitize() && istext(id) && length(id)

/datum/starmap_group/proc/sanitize()
	if(!istext(name))
		name = null
	if(!istext(desc))
		desc = null
	color = sanitize_hexcolor(color, 6, TRUE, rgb(255, 255, 255))

/datum/starmap_group/proc/serialize_data()
	return list(
		"id" = id,
		"name" = name,
		"color" = color,
		"desc" = desc
	)

/datum/starmap_group/proc/deserialize_data(list/data)
	id = data["id"]
	name = data["name"]
	color = data["color"]
	desc = data["desc"]
