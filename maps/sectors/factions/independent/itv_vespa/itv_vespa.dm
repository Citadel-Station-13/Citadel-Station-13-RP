/datum/map/sector/itv_vespa
	id = "itv_vespa"
	name = "Sector - ITV Vespa"
	width = 140
	height = 140
	levels = list(
		/datum/map_level/sector/itv_vespa,
	)

	overmap_initializer = /datum/overmap_initializer/map{
		legacy_entity_type = /obj/overmap/entity/visitable/ship/itv_vespa;
	}

/datum/map_level/sector/itv_vespa
	id = "itv_vespa"
	name = "Sector - ITV Vespa"
	display_name = "ITV Vespa"
	display_id = "itv_vespa_main"
	path = "maps/sectors/factions/independent/itv_vespa/levels/itv_vespa.dmm"
