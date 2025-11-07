/datum/map/sector/sky_planet
	id = "lythios43a"
	name = "Sector - Sky Planet"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/sky_planet/sky_upper_west,
		/datum/map_level/sector/sky_planet/sky_west,
		/datum/map_level/sector/sky_planet/ground_west,
		/datum/map_level/sector/sky_planet/sky_upper_east,
		/datum/map_level/sector/sky_planet/sky_east,
		/datum/map_level/sector/sky_planet/ground_east,
	)

	legacy_assert_shuttle_datums = list(
		/datum/shuttle/autodock/overmap/voidline/redcomet,
		/datum/shuttle/autodock/overmap/voidline/bonnethead,
		/datum/shuttle/autodock/overmap/voidline/paripari,
		/datum/shuttle/autodock/overmap/voidline/crescend,
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
	base_turf = /turf/simulated/open/skyplanet
	struct_x = 0
	struct_y = 0
	struct_z = 2
	air_outdoors = /datum/atmosphere/planet/sky_planet
	planet_path = /datum/planet/sky_planet

/datum/map_level/sector/sky_planet/sky_west
	id = "Skyplanetskywest"
	name = "Sector - Lythios43a : Sky West"
	display_name = "Lythios43a - Sky West"
	path = "maps/sectors/sky_planet/levels/sky_planet_sky_west.dmm"
	base_turf = /turf/simulated/open
	struct_x = 0
	struct_y = 0
	struct_z = 1
	air_outdoors = /datum/atmosphere/planet/sky_planet/ground
	planet_path = /datum/planet/sky_planet

/datum/map_level/sector/sky_planet/ground_west
	id = "Skyplanetgroundwest"
	name = "Sector - Lythios43a : Ground West"
	display_name = "Lythios43a - Ground West"
	path = "maps/sectors/sky_planet/levels/sky_planet_ground_west.dmm"
	base_turf = /turf/simulated/floor/outdoors/rocks
	struct_x = 0
	struct_y = 0
	struct_z = 0
	air_outdoors = /datum/atmosphere/planet/sky_planet/ground
	planet_path = /datum/planet/sky_planet/ground

/datum/map_level/sector/sky_planet/ground_west/on_loaded_immediate(z_index, list/datum/callback/out_generation_callbacks)
	. = ..()
	out_generation_callbacks?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			225,
			/area/sector/sky_planet/ground/unexplored,
			/datum/map_template/submap/level_specific/sky_planet_ground,
		)
	)

/datum/map_level/sector/sky_planet/sky_upper_east
	id = "Skyplanetuppereast"
	name = "Sector - Lythios43a : Upper east"
	display_name = "Lythios43a - Upper east"
	path = "maps/sectors/sky_planet/levels/sky_planet_upper_sky_east.dmm"
	base_turf = /turf/simulated/open/skyplanet
	struct_x = 1
	struct_y = 0
	struct_z = 2
	air_outdoors = /datum/atmosphere/planet/sky_planet
	planet_path = /datum/planet/sky_planet

/datum/map_level/sector/sky_planet/sky_upper_east/on_loaded_immediate(z_index, list/datum/callback/out_generation_callbacks)
	. = ..()
	out_generation_callbacks?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			225,
			/area/sector/sky_planet/sky/unexplored,
			/datum/map_template/submap/level_specific/sky_planet_rigs,
		)
	)

/datum/map_level/sector/sky_planet/sky_east
	id = "Skyplanetskyeast"
	name = "Sector - Lythios43a : Sky east"
	display_name = "Lythios43a - Sky east"
	path = "maps/sectors/sky_planet/levels/sky_planet_sky_east.dmm"
	base_turf = /turf/simulated/open
	struct_x = 1
	struct_y = 0
	struct_z = 1
	air_outdoors = /datum/atmosphere/planet/sky_planet/ground
	base_turf = /turf/simulated/fake_sky

/datum/map_level/sector/sky_planet/ground_east
	id = "Skyplanetgroundeast"
	name = "Sector - Lythios43a : Ground east"
	display_name = "Lythios43a - Ground east"
	path = "maps/sectors/sky_planet/levels/sky_planet_ground_east.dmm"
	base_turf = /turf/simulated/floor/outdoors/rocks
	struct_x = 1
	struct_y = 0
	struct_z = 0
	air_outdoors = /datum/atmosphere/planet/sky_planet/ground
	planet_path = /datum/planet/sky_planet/ground

/datum/map_level/sector/sky_planet/ground_east/on_loaded_immediate(z_index, list/datum/callback/out_generation_callbacks)
	. = ..()
	out_generation_callbacks?.Add(
		CALLBACK(
			GLOBAL_PROC,
			GLOBAL_PROC_REF(seed_submaps),
			list(z_index),
			225,
			/area/sector/sky_planet/ground/unexplored,
			/datum/map_template/submap/level_specific/sky_planet_ground,
		)
	)
