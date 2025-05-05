/datum/map/sector/nebula_tradeport
	id = "nebula_tradeport"
	name = "Sector - Nebula Trade Port (192x192)"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/nebula_tradeport,
	)
	legacy_assert_shuttle_datums = list(
		/datum/shuttle/autodock/overmap/trade,
		/datum/shuttle/autodock/overmap/trade/udang,
		/datum/shuttle/autodock/overmap/trade/scoophead,
		/datum/shuttle/autodock/overmap/trade/arrowhead,
		/datum/shuttle/autodock/overmap/trade/caravan,
		/datum/shuttle/autodock/overmap/trade/adventurer,
		/datum/shuttle/autodock/overmap/trade/tug,
		/datum/shuttle/autodock/overmap/trade/utilitymicro,
		/datum/shuttle/autodock/overmap/trade/runabout,
	)

/datum/map_level/sector/nebula_tradeport
	id = "NebulaTradeport"
	name = "Sector - Nebula Trade Port (192x192)"
	display_name = "Nebula Gas Trade Hub"
	path = "maps/sectors/nebula_tradeport/levels/nebula_tradeport.dmm"
	base_turf = /turf/space
	base_area = /area/space

/datum/map_level/sector/nebula_tradeport/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			200,
			/area/submap/nebula_tradeport,
			/datum/map_template/submap/level_specific/nebula_tradeport,
		)
	)
