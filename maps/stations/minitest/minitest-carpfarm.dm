/datum/map/minitest_carpfarm
	id = "minitest-carpfarm"
	name = "Minitest Sector - Carpfarm"
	levels = list(
		/datum/map_level/minitest_carpfarm,
	)
	width = 100
	height = 100

/datum/map_level/minitest_carpfarm
	persistence_allowed = TRUE
	id = "minitest-carpfarm"
	name = "Minitest - Carpfarm"
	display_id = "!debug-sector-1"
	display_name = "Minitest Debugging Map - Carpfarm"
	path = "maps/stations/minitest/levels/minitest-carpfarm.dmm"
	base_turf = /turf/simulated/floor/plating
	flags = LEGACY_LEVEL_STATION | LEGACY_LEVEL_CONTACT | LEGACY_LEVEL_PLAYER | LEGACY_LEVEL_CONSOLES

