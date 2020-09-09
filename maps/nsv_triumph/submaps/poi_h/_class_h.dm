//AWAY MISSION Init

/obj/away_mission_init/poi_h
	name = "away mission initializer -  Desert Planet"

/obj/away_mission_init/poi_h/Initialize()
	return INITIALIZE_HINT_QDEL

// Mining Planet world areas
/area/triumph_away/poi_h
	name = "Mining Planet"
	icon_state = "away"
	base_turf = /turf/simulated/mineral/floor/
	dynamic_lighting = 1
	dynamic_lighting = TRUE

/area/triumph_away/poi_h/explored
	name = "Mining Planet - Explored (E)"
	icon_state = "red"
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/horror.ogg')

/area/triumph_away/poi_h/unexplored
	name = "Mining Planet - Unexplored (UE)"
	icon_state = "yellow"


//Intializer
/obj/away_mission_init/poi_h/Initialize()

	return INITIALIZE_HINT_QDEL

/obj/away_mission_init/poi_h
	name = "away mission initializer -  Class h World"

/obj/away_mission_init/poi_h/Initialize()
	return INITIALIZE_HINT_QDEL

/area/shuttle/excursion/poi_h
	name = "Shuttle Landing Point"
	base_turf = /turf/simulated/floor/beach/sand/desert/classh
	flags = RAD_SHIELDED
	dynamic_lighting = 0

/area/triumph_away/poi_h
	name = "Class H World"
	base_turf = /turf/simulated/floor/beach/sand/desert/classh
	dynamic_lighting = 0
	dynamic_lighting = FALSE

/area/triumph_away/poi_h/POIs/WW_Town
	name = "Ghost Town"
	base_turf = /turf/simulated/floor/beach/sand/desert/classh
	dynamic_lighting = 0

/area/triumph_away/poi_h/POIs/landing_pad
	name = "Prefab Homestead"
	base_turf = /turf/simulated/floor/beach/sand/desert/classh
	dynamic_lighting = 0

/area/triumph_away/poi_h/POIs/solar_farm
	name = "Prefab Solar Farm"
	base_turf = /turf/simulated/floor/beach/sand/desert/classh
	dynamic_lighting = 0

/area/triumph_away/poi_h/POIs/dirt_farm
	name = "Abandoned Farmstead"
	base_turf = /turf/simulated/floor/beach/sand/desert/classh
	dynamic_lighting = 0

/area/triumph_away/poi_h/POIs/graveyard
	name = "Desert Graveyard"
	base_turf = /turf/simulated/floor/beach/sand/desert/classh
	dynamic_lighting = 0

/area/triumph_away/poi_h/POIs/goldmine
	name = "Desert Goldmine"
	base_turf = /turf/simulated/floor/beach/sand/desert/classh
	dynamic_lighting = 0


/area/triumph_away/poi_h/explored
	name = "Class H World - Explored (E)"
	icon_state = "explored"

/area/triumph_away/poi_h/unexplored
	name = "Class H World - Unexplored (UE)"
	icon_state = "unexplored"
