/datum/map/sector/abductor_cruiser
	id = "abductor_cruiser"
	name = "Sector - Abductor Cruiser"
	width = 140
	height = 140
	levels = list(
		/datum/map_level/sector/abductor_cruiser,
	)

	overmap_initializer = /datum/overmap_initializer/map{
		legacy_entity_type = /obj/overmap/entity/visitable/ship/abductor;
	}

/datum/map_level/sector/abductor_cruiser
	id = "AbductorCruiser"
	name = "Sector - Abductor Cruiser"
	// TODO: proper unknown handling for ic
	display_name = "Alien Cruiser"
	display_id = "unkw"
	path = "maps/sectors/abductor_cruiser/levels/abductor_cruiser.dmm"
