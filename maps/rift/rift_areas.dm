//Debug areas
/area/rift/surfacebase
	name = "Rift Debug Surface"

/area/rift/transit
	name = "Rift Debug Transit"
	requires_power = 0

/area/rift/space
	name = "Rift Debug Space"
	requires_power = 0

// Elevator areas.
/area/turbolift
	delay_time = 1 SECONDS
//	forced_ambience = list('sound/music/elevator.ogg')
	dynamic_lighting = FALSE //Temporary fix for elevator lighting

/area/turbolift/runder/level2
	name = "under (level 2)"
	lift_floor_label = "Underground 2"
	lift_floor_name = "Engineering, Supermatter"
	lift_announce_str = "Arriving at underground level two."
	base_turf = /turf/simulated/floor/plating

/area/turbolift/runder/level1
	name = "under (level 1)"
	lift_floor_label = "Underground 1"
	lift_floor_name = "Engineering, Atmospherics, Storage"
	lift_announce_str = "Arriving at underground level one."

/area/turbolift/rsurface/level1
	name = "surface (level 0)"
	lift_floor_label = "Surface 0"
	lift_floor_name = "Storage, Cargo, Surface EVA"
	lift_announce_str = "Arriving at surface level zero."

/area/turbolift/rsurface/level2
	name = "surface (level 1)"
	lift_floor_label = "Surface 1"
	lift_floor_name = "Level 1"
	lift_announce_str = "Arriving at surface level one."

/*
/area/turbolift/t_station/level1
	name = "asteroid (level 1)"
	lift_floor_label = "Asteroid 1"
	lift_floor_name = "Eng, Bridge, Park, Cryo"
	lift_announce_str = "Arriving at Station Level 1."
*/
/*
/area/vacant/vacant_restaurant_upper
	name = "\improper Vacant Restaurant"
	icon_state = "vacant_site"

/area/vacant/vacant_restaurant_lower
	name = "\improper Vacant Restaurant"
	icon_state = "vacant_site"

/area/engineering/hallway
	name = "\improper Engineering Hallway"
	icon_state = "engineering"

/area/engineering/shaft
	name = "\improper Engineering Electrical Shaft"
	icon_state = "substation"

/area/vacant/vacant_office
	name = "\improper Vacant Office"
	icon_state = "vacant_site"
*/
