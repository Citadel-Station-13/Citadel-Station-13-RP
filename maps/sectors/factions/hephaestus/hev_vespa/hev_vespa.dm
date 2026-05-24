/datum/map/sector/hev_vespa
	id = "hev_vespa"
	name = "Sector - HEV Vespa"
	width = 140
	height = 140
	levels = list(
		/datum/map_level/sector/hev_vespa,
	)
	overmap_initializer = /datum/overmap_initializer/map{
		legacy_entity_type = /obj/overmap/entity/visitable/ship/vespa,
	}

/datum/map_level/sector/hev_vespa
	id = "HEV_Vespa"
	name = "Sector - HEV Vespa"
	display_name = "HEV Vespa"
	display_id = "hev_vespa_main"
	path = "maps/sectors/factions/hephaestus/hev_vespa/levels/hev_vespa.dmm"
