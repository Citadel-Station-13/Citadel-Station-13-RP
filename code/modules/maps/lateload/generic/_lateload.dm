/datum/map_template/lateload
	allow_duplicates = FALSE
	var/associated_map_datum

/datum/map_template/lateload/on_map_loaded(z)
	if(!associated_map_datum || !ispath(associated_map_datum))
		log_game("Extra z-level [src] has no associated map datum")
		return

	new associated_map_datum(LEGACY_MAP_DATUM, z)
