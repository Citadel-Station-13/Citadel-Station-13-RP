/datum/map_template/lateload
	allow_duplicates = FALSE
	var/associated_map_datum

/datum/map_template/lateload/on_map_loaded(z)
	if(!associated_map_datum || !ispath(associated_map_datum))
		log_game("Extra z-level [src] has no associated map datum")
		return

	new associated_map_datum(GLOB.using_map, z)

/datum/map_level/lateload
	z = 0

/datum/map_level/lateload/New(var/datum/map/station/map, mapZ)
	if(mapZ && !z)
		z = mapZ
	return ..(map)
