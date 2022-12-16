/proc/get_overmap_sector(var/z)
	if(using_map_legacy.use_overmap)
		return map_sectors["[z]"]
	else
		return null
