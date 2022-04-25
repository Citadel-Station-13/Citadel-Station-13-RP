/**
 * gets the overmap object this atom is in
 */
/atom/proc/get_overmap_object()
	return loc.get_overmap_object()

/area/get_overmap_object()
	#warn check shuttle area

/turf/get_overmap_object()
	#warn check area, then level


// /proc/get_overmap_sector(var/z)
// 	if(GLOB.using_map.use_overmap)
// 		return map_sectors["[z]"]
// 	else
// 		return null
