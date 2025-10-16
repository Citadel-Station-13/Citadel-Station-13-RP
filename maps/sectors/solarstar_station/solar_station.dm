/datum/map/sector/solars_station
	id = "solars_station"
	name = "Sector - Lythios 43 solar station"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/solars_station/above,
		/datum/map_level/sector/solars_station/under,
	)

/datum/map_level/sector/solars_station
	base_area = /area/space

/datum/map_level/sector/solars_station/above
	id = "Solar_station"
	name = "Sector - Lythios 43 Star"
	display_name = "Lythios 43 Star"
	path = "maps/sectors/solarstar_station/levels/solars_station.dmm"
	base_turf = /turf/simulated/open
	link_below = /datum/map_level/sector/solars_station/under

/datum/map_level/sector/solars_station/under
	id = "Solar_station_under"
	name = "Sector - Lythios 43 Star Lower"
	display_name = "Lythios 43 Star Lower"
	path = "maps/sectors/solarstar_station/levels/solars_station_under.dmm"
	base_turf = /turf/space
	link_above = /datum/map_level/sector/solars_station/above

