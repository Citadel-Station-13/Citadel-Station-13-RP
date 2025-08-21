/datum/map/sector/solars_station
	id = "solars_station"
	name = "Sector - Lythios 43 solar station"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/solars_station,
		/datum/map_level/sector/solars_station/under,
	)

	legacy_assert_shuttle_datums = list(
		/datum/shuttle/autodock/overmap/trade/salvager,
	)

/datum/map_level/sector/solars_station
	id = "Solar_station"
	name = "Sector - Lythios 43 Star"
	display_name = "Lythios 43 Star"
	path = "maps/sectors/solarstar_station/levels/solars_station.dmm"
	base_turf = /turf/space
	base_area = /area/space
	link_below = /datum/map_level/sector/solars_station/under
	link_above = /datum/map_level/sector/solars_station/upper

/datum/map_level/sector/solars_station/under
	id = "Solar_station_under"
	name = "Sector - Lythios 43 Star Lower"
	display_name = "Lythios 43 Star Lower"
	path = "maps/sectors/solarstar_station/levels/solars_station_under.dmm"
	base_turf = /turf/space
	base_area = /area/space
	link_above = /datum/map_level/sector/solars_station

