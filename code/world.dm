
//This file is just for the necessary /world definition
//Try looking in game/world.dm
/world
	mob = /mob/new_player
	turf = /turf/space
	area = /area/space
	view = "15x15"
	cache_lifespan = 7
	hub = "Exadv1.spacestation13"
	hub_password = "kMZy3U5jJHSiBQjr"
	name = "Citadel Station 13 - HRP"
	status = "ERROR: Default status"
	visibility = TRUE
	fps = 20
#ifdef FIND_REF_NO_CHECK_TICK
	loop_checks = FALSE
#endif
