/datum/starmap/proc/assert_storage()

/datum/starmap/proc/load_file()

/datum/starmap/proc/save_file()

/datum/starmap/proc/serialize_data()
	var/list/data = list()
	data["center_x"] = overall_center_x
	data["center_y"] = overall_center_y
	data["edge_dist"] = overall_edge_dist
	var/list/serialized_entities = list()
	for(var/id in entity_by_id)
		var/datum/starmap_entity/E = entity_by_id[id]
		serialized_entities += list(entity_to_data(E))
	var/list/serialized_groups = list()
	for(var/id in group_by_id)
		var/datum/starmap_group/G = group_by_id[id]
		serialized_groups += list(group_to_data(G))
	data["entities"] = serialized_entities
	data["groups"] = serialized_groups
	return data

/datum/starmap/proc/deserialize_data(list/data)
	var/center_x = data["center_x"]
	var/center_y = data["center_y"]
	var/edge_dist = data["edge_dist"]
	var/list/entity_lists = data["entities"]
	var/list/group_lists = data["group_lists"]

	overall_center_x = isnum(center_x)? center_x : 0
	overall_center_y = isnum(center_y)? center_y : 0
	overall_edge_dist = isnum(edge_dist)? edge_dist : 0

	for(var/list/L in entity_lists)
		entity_from_data(L)
	for(var/list/L in group_lists)
		group_from_data(L)

/datum/starmap/proc/entity_from_data(list/data)
	var/datum/starmap_entity/E = new
	E.deserialize_data(data)
	if(!E.verify())
		SSstarmaps.subsystem_log("error during entity insert for map [src.id] entity [E.id]; discarding.")
		return FALSE
	return insert_entity(E)

/datum/starmap/proc/entity_to_data(datum/starmap_entity/E)
	return E.serialize_data()

/datum/starmap/proc/group_from_data(list/data)
	var/datum/starmap_group/G = new
	G.deserialize_data(data)
	if(!G.verify())
		SSstarmaps.subsystem_log("error during group insert for map [src.id] entity [G.id]; discarding.")
		return FALSE
	return register_group(G)

/datum/starmap/proc/group_to_data(datum/starmap_group/G)
	return G.serialize_data()
