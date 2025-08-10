/datum/map/sector/solars_station
	id = "solars_station"
	name = "Sector - Lythios 43 solar station"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/solars_station_1.dmm,
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
	id = "Solarstation"
	name = "Sector - Lythios 43 Star"
	display_name = "Lythios 43 Star"
	path = "maps/sectors/solars_station/levels/solars_station_0.dmm"
	base_turf = /turf/space
	base_area = /area/space

/datum/map_level/sector/solars_station/upper
	id = "Solarstation"
	name = "Sector - Lythios 43 Star"
	display_name = "Lythios 43 Star"
	path = "maps/sectors/solars_station/levels/solars_station_2.dmm"
	base_turf = /turf/space
	base_area = /area/space
