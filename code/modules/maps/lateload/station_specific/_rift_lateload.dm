/datum/map_template/lateload/rift
	allow_duplicates = FALSE
	var/associated_map_datum

/datum/map_template/lateload/rift/on_map_loaded(z)
	if(!associated_map_datum || !ispath(associated_map_datum))
		log_game("Extra z-level [src] has no associated map datum")
		return

	new associated_map_datum(GLOB.using_map, z)

/datum/map_z_level/rift_lateload
	z = 0
	flags = MAP_LEVEL_SEALED

/datum/map_z_level/rift_lateload/New(var/datum/map/map, mapZ)
	if(mapZ && !z)
		z = mapZ
	return ..(map)




