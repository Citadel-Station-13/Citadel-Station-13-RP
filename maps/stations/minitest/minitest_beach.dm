/datum/map/minitest_beach
	id = "minitest-beach"
	name = "Minitest Sector - Beach"
	levels = list(
		/datum/map_level/minitest_beach,
	)
	width = 100
	height = 100

/datum/map_level/minitest_beach
	persistence_allowed = TRUE
	id = "minitest-beach"
	name = "Minitest - Beach"
	display_id = "!debug-sector-2"
	display_name = "Minitest Debugging Map - Beach"
	path = "maps/stations/minitest/levels/minitest-beach.dmm"
	base_turf = /turf/simulated/floor/plating
	flags = LEGACY_LEVEL_STATION | LEGACY_LEVEL_CONTACT | LEGACY_LEVEL_PLAYER | LEGACY_LEVEL_CONSOLES

/obj/overmap/entity/visitable/sector/citadel_minitest/beach
	name = "Beach Planet"
	desc = "A beach in space.  Or on a planet.  Its a hack."
	in_space = 0
	start_x = 8
	start_y = 16
