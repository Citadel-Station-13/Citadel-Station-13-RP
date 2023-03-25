/proc/get_overmap_sector(var/z)
	RETURN_TYPE(/obj/effect/overmap/visitable)
	if(GLOB.using_map.use_overmap)
		return map_sectors["[z]"]
	else
		return null
