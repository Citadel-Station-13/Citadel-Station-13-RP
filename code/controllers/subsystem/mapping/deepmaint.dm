/**
 * mapgens queued deepmaint generators
 */
/datum/controller/subsystem/mapping/proc/mapgen_deepmaint()
	return	// WIP

/**
 * adds a marker of an id
 */
/datum/controller/subsystem/mapping/proc/add_deepmaint_marker(obj/landmark/deepmaint_marker/generation/M, id)

/**
 * removes a marker of an id
 */
/datum/controller/subsystem/mapping/proc/remove_deepmaint_marker(obj/landmark/deepmaint_marker/generation/M, id)

/**
 * gets markers of an id
 */
/datum/controller/subsystem/mapping/proc/get_deepmaint_markers(id)
	if(!deepmaint_markers_by_id[id])
		return list()
	var/list/obj/landmark/deepmaint_marker/generation/markers = deepmaint_markers_by_id[id]
	return markers.Copy()
