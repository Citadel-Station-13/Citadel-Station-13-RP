
/area/sector/driftingplanet
	dynamic_lighting = 1
	requires_power = 1


/area/sector/driftingplanet/field
	name = "\improper Away Mission - Drifting Planet : Fields"
	icon_state = "away"
	initial_gas_mix = ATMOSPHERE_USE_OUTDOORS
	initial_outdoors = TRUE
	ambience = list('sound/ambience/driftinplanet.ogg')

/area/sector/driftingplanet/buildings
	name = "\improper Away Mission - Drifting Planet : Building"
	icon_state = "blue2"
	area_flags = AREA_RAD_SHIELDED
	sound_env = SMALL_ENCLOSED

/area/sector/driftingplanet/factory
	name = "\improper Away Mission - Drifting Planet : Factory"
	icon_state = "blue2"
	area_flags = AREA_RAD_SHIELDED
	sound_env = SMALL_ENCLOSED

/area/sector/driftingplanet/arena
	name = "\improper Away Mission - Drifting Planet : Arena"
	icon_state = "blue2"
	area_flags = AREA_RAD_SHIELDED
	sound_env = LARGE_ENCLOSED

/area/sector/driftingplanet/factory
	name = "\improper Away Mission - Drifting Planet : Factory"
	icon_state = "blue2"
	area_flags = AREA_RAD_SHIELDED
	sound_env = LARGE_ENCLOSED

/area/sector/driftingplanet/cave
	area_flags = AREA_RAD_SHIELDED
	initial_outdoors = FALSE

/area/sector/driftingplanet/cave/arena
	area_flags = AREA_RAD_SHIELDED
	initial_outdoors = FALSE
	icon_state = "blue2"
	sound_env = LARGE_ENCLOSED
