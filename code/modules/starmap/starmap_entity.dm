/datum/starmap_entity
	var/id
	var/x
	var/y
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

/datum/starmap_entity/proc/map_data()
	return list(
		"id" = id,
		"x" = x,
		"y" = y,
		"name" = name,
		"group" = group,
		"desc" = desc
	)

/datum/starmap_entity/proc/map_act(mob/user, action, mode, list/params, datum/host)
