/proc/get_overmap_sector(var/z)
	if(SSmapping.legacy_map_config.use_overmap)
		return map_sectors["[z]"]
	else
		return null
