
/client/proc/change_next_map()
	set name = "Change Map"
	set desc = "Change the next map."
	set category = "Server"

	var/list/built = list()

	for(var/id in SSmapping.keyed_maps)
		var/datum/map/station/M = SSmapping.keyed_maps[id]
		if(!istype(M))
			continue
		built[M.name] = M.id

	var/picked = input(src, "Choose the map for the next round", "Map Rotation", SSmapping.loaded_station.name) as null|anything in built

	if(isnull(picked))
		return

	var/datum/map/station/changing_to = SSmapping.keyed_maps[built[picked]]
	var/datum/map/station/was = SSmapping.next_station || SSmapping.loaded_station

	log_and_message_admins("[key_name(src)] is changing the next map from [was.name] ([was.id]) to [changing_to.name] ([changing_to.id])")

	SSmapping.next_station = changing_to
	SSmapping.write_next_map(changing_to)
