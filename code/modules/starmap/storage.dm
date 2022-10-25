/datum/starmap/proc/assert_storage()
	var/path = path()
	if(!fexists(path))
		// serialize a blank one (if we aren't blank then someone was a dumbass and i don't care)
		var/list/theoretically_blank = serialize_data()
		WRITE_FILE(file(path), json_encode(theoretically_blank))

/datum/starmap/proc/load_file()
	ASSERT(volatile)
	var/path = path()
	var/list/decoded
	if(!fexists(path))
		decoded = list()
	else
		decoded = json_encode(file2text(file(path)))
	deserialize_data(decoded)

/datum/starmap/proc/save_file()
	ASSERT(volatile)
	var/list/serialized = serialize_data()
	var/path = path()
	if(fexists(path))
		fdel(path)
	var/handle = file(path)
	WRITE_FILE(handle, json_encode(serialized))

/datum/starmap/proc/path()
	return "data/starmaps/[save_key].json"

/datum/starmap/proc/serialize_data()
	var/list/data = list()
	data["center_x"] = overall_center_x
	data["center_y"] = overall_center_y
	data["edge_dist"] = overall_edge_dist
	var/list/serialized_entities = list()
	for(var/id in entity_by_id)
		var/datum/starmap_entity/E = entity_by_id[id]
		serialized_entities += list(entity_to_data(E))
	data["entities"] = serialized_entities
	return data

/datum/starmap/proc/deserialize_data(list/data)
	var/center_x = data["center_x"]
	var/center_y = data["center_y"]
	var/edge_dist = data["edge_dist"]
	var/list/entity_lists = data["entities"]

	overall_center_x = isnum(center_x)? center_x : initial(overall_center_x)
	overall_center_y = isnum(center_y)? center_y : initial(overall_center_y)
	overall_edge_dist = isnum(edge_dist)? edge_dist : initial(overall_edge_dist)

	for(var/list/L in entity_lists)
		entity_from_data(L)

/datum/starmap/proc/entity_from_data(list/data)
	var/datum/starmap_entity/E = new
	E.deserialize_data(data)
	if(!E.verify())
		SSstarmaps.subsystem_log("error during entity insert for map [src.id] entity [E.id]; discarding.")
		return FALSE
	return insert_entity(E)

/datum/starmap/proc/entity_to_data(datum/starmap_entity/E)
	return E.serialize_data()
