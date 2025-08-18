/datum/map/sector/solars_station
	id = "solars_station"
	name = "Sector - Lythios 43 solar station"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/solars_station,
		/datum/map_level/sector/solars_station/under,
		/datum/map_level/sector/solars_station/upper,
	)

	legacy_assert_shuttle_datums = list(
		/datum/shuttle/autodock/overmap/trade/salvager,
	)

/datum/map_level/sector/solars_station
	id = "Solarstation"
	name = "Sector - Lythios 43 Star"
	display_name = "Lythios 43 Star"
	path = "maps/sectors/solars_station/levels/solars_station_1.dmm"
	base_turf = /turf/space
	base_area = /area/space
	link_below = /datum/map_level/sector/solars_station/under
	link_above = /datum/map_level/sector/solars_station/upper

/datum/map_level/sector/solars_station/under
	id = "Solarstation2"
	name = "Sector - Lythios 43 Star Lower"
	display_name = "Lythios 43 Star Lower"
	path = "maps/sectors/solars_station/levels/solars_station_0.dmm"
	base_turf = /turf/space
	base_area = /area/space
	link_above = /datum/map_level/sector/solars_station

/datum/map_level/sector/solars_station/upper
	id = "Solarstation3"
	name = "Sector - Lythios 43 Star Upper"
	display_name = "Lythios 43 Star Upper"
	path = "maps/sectors/solars_station/levels/solars_station_2.dmm"
	base_turf = /turf/space
	base_area = /area/space
	link_below = /datum/map_level/sector/solars_station
