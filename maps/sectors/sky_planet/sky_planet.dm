/datum/map/sector/sky_planet
	id = "Lythias 43a"
	name = "Sector - Sky Planet"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/
	)

/datum/map_level/sector/sky_planet
	traits = list(
		ZTRAIT_GRAVITY,
	)

/datum/map_level/sector/sky_planet/sky_upper_west
	id = "Skyplanetupperwest"
	name = "Sector - Lythios43a : Upper West"
	display_name = "Lythios43a - Upper West"
	path = "maps/sectors/sky_planet/levels/sky_planet_upper_sky_west.dmm"
	base_turf = /turf/simulated/open
	link_east =
	link_below =
	air_outdoors = /datum/atmosphere/planet/sky_planet/sky
	planet_path = /datum/planet/sky_planet



/datum/map_level/sector/sky_planet/sky_west
	id = "Skyplanetskywest"
	name = "Sector - Lythios43a : Sky West"
	display_name = "Lythios43a - Sky West"
	path = "maps/sectors/sky_planet/levels/sky_planet_sky_west.dmm"
	base_turf = /turf/simulated/open
	link_east =
	link_below =
	link_above =
	air_outdoors = /datum/atmosphere/planet/sky_planet/sky


/datum/map_level/sector/sky_planet/ground_west
	id = "Skyplanetgroundwest"
	name = "Sector - Lythios43a : Ground West"
	display_name = "Lythios43a - Ground West"
	path = "maps/sectors/sky_planet/levels/sky_planet_ground_west.dmm"
	base_turf =
	link_east =
	link_below =
	link_above =
	air_outdoors = /datum/atmosphere/planet/sky_planet/ground

/datum/map_level/sector/sky_planet/sky_upper_east
	id = "Skyplanetuppereast"
	name = "Sector - Lythios43a : Upper east"
	display_name = "Lythios43a - Upper east"
	path = ""
	base_turf =
	link_east =
	link_below =
	air_outdoors = /datum/atmosphere/planet/sky_planet/sky
	planet_path = /datum/planet/sky_planet
	base_turf = /turf/simulated/open

/datum/map_level/sector/sky_planet/sky_upper_east/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	. = ..()
	additional_generation?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			225,
			/area/sector/sky_planet/sky/unexplored,
			/datum/map_template/submap/sky_planet_rigs,
		)
	)

/datum/map_level/sector/sky_planet/sky_east
	id = "Skyplanetskyeast"
	name = "Sector - Lythios43a : Sky east"
	display_name = "Lythios43a - Sky east"
	path = ""
	base_turf =
	link_east =
	link_below =
	link_above =
	air_outdoors = /datum/atmosphere/planet/sky_planet/sky
	base_turf = /turf/simulated/fake_sky

/datum/map_level/sector/sky_planet/ground_upper_east
	id = "Skyplanetgroundeast"
	name = "Sector - Lythios43a : Upper Ground east"
	display_name = "Lythios43a - Upper Ground east"
	path = ""
	base_turf =
	link_east =
	link_below =
	link_above =
	air_outdoors = /datum/atmosphere/planet/sky_planet/ground
	base_turf = /turf/simulated/open

/datum/map_level/sector/sky_planet/ground_east
	id = "Skyplanetgroundeast"
	name = "Sector - Lythios43a : Ground east"
	display_name = "Lythios43a - Ground east"
	path = ""
	base_turf =
	link_east =
	link_below =
	link_above =
	air_outdoors = /datum/atmosphere/planet/sky_planet/ground
