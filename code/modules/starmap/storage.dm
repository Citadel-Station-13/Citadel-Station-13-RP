/datum/starmap/proc/assert_storage()

/datum/starmap/proc/load_file()

/datum/starmap/proc/save_file()

/datum/starmap/proc/send_resources()

/datum/starmap/proc/serialize_data()

/datum/starmap/proc/deserialize_data()

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
	return register_group(E)

/datum/starmap/proc/group_to_data(datum/starmap_group/G)
	return G.serialize_data()
