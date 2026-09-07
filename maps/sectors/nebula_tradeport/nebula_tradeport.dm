/datum/map/sector/nebula_tradeport
	id = "nebula_tradeport"
	name = "Sector - Nebula Trade Port (192x192)"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/nebula_tradeport,
	)

	// let everyone in
	access_default_require = null
	access_keyed_require = list(
		"trader" = list(
			/datum/access/faction/trader::access_value,
		),
	)

/datum/map_level/sector/nebula_tradeport
	id = "NebulaTradeport"
	name = "Sector - Nebula Trade Port (192x192)"
	display_name = "Nebula Gas Trade Hub"
	path = "maps/sectors/nebula_tradeport/levels/nebula_tradeport.dmm"
	base_turf = /turf/space
	base_area = /area/space
