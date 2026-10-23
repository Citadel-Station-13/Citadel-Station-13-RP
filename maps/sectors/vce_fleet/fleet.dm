/datum/map/sector/fleet
	id = "fleet"
	name = "Sector - Fleet"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/fleet,
	)

	legacy_assert_shuttle_datums = list(
		/datum/shuttle/autodock/overmap/fleet/trade,
		/datum/shuttle/autodock/overmap/fleet/trade/scoophead,
		/datum/shuttle/autodock/overmap/fleet/ani,
		/datum/shuttle/autodock/overmap/fleet/deneb,
		/datum/shuttle/autodock/overmap/fleet/caravan,
		/datum/shuttle/autodock/overmap/fleet/runabout,
		/datum/shuttle/autodock/overmap/fleet/starcutter,
		/datum/shuttle/autodock/overmap/fleet/cargoravana,
		/datum/shuttle/autodock/overmap/fleet/adventurer,
		/datum/shuttle/autodock/overmap/fleet/tug,
		/datum/shuttle/autodock/overmap/fleet/utilitymicro,
		/datum/shuttle/autodock/overmap/fleet/utilitymicro2,
		/datum/shuttle/autodock/overmap/fleet/colonial,
		/datum/shuttle/autodock/overmap/fleet/battlestar,
		/datum/shuttle/autodock/overmap/fleet/parabellum,
		/datum/shuttle/autodock/overmap/fleet/providence,
		/datum/shuttle/autodock/overmap/fleet/fleet/biodancy,
		/datum/shuttle/autodock/overmap/fleet/tour,
		/datum/shuttle/autodock/overmap/fleet/passenger,
		/datum/shuttle/autodock/overmap/fleet/bolt,
	)

/datum/map_level/sector/fleet
	id = "fleet"
	name = "Sector Crucis Expanse - Fleet"
	display_name = "Fleet space"
	path = "maps/sectors/vce_fleet/levels/fleet.dmm"
	base_turf = /turf/space
	base_area = /area/space
