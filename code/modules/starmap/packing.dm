/**
 * do any data optimizations before saving
 *
 * editing caches are available
 */
/datum/starmap/proc/repack()
	var/min_x = INFINITY
	var/min_y = INFINITY
	var/max_x = -INFINITY
	var/max_y = -INFINITY

	for(var/id in entity_by_id)
		var/datum/starmap_entity/E = entity_by_id[id]
		max_x = max(max_x, E.x)
		max_y = max(max_y, E.y)
		min_x = min(min_x, E.x)
		min_y = min(min_y, E.y)

	var/width = max_x - min_x
	var/height = max_y - min_y

	var/center_x = max_x - width / 2
	var/center_y = max_y - height / 2

	overall_center_x = center_x
	overall_center_y = center_y
	overall_edge_dist = max(width, height)
