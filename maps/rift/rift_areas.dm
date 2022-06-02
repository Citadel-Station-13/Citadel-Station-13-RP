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
	dynamic_lighting = FALSE //Temporary fix for elevator lighting

/area/turbolift/runder/level2
	name = "under (level 2)"
	lift_floor_label = "Underground 2"
	lift_floor_name = "Atmospherics, Chapel, Mining, Bunker"
	lift_announce_str = "Arriving at underground level two."

/area/turbolift/runder/level1
	name = "under (level 1)"
	lift_floor_label = "Underground 1"
	lift_floor_name = "Engineering"
	lift_announce_str = "Arriving at underground level one."

/area/turbolift/rsurface/level1
	name = "surface (level 1)"
	lift_floor_label = "Surface 1"
	lift_floor_name = "Cargo, Tool Storage, EVA Equipment, Surface EVA"
	lift_announce_str = "Arriving at surface level one."

/area/turbolift/rsurface/level2
	name = "surface (level 2)"
	lift_floor_label = "Surface 2"
	lift_floor_name = "Medical, Security, Science, Dorms, Cafe"
	lift_announce_str = "Arriving at surface level two."

/area/turbolift/rsurface/level3
	name = "surface (level 3)"
	lift_floor_label = "Surface 3"
	lift_floor_name = "Bar, Kitchen, Bridge, Exploration, Arrivals"
	lift_announce_str = "Arriving at surface level two."

//Mining Elevator Area
/area/turbolift/rmine/surface
	name = "mining shaft (surface)"
	lift_floor_label = "Surface"
	lift_floor_name = "Cargo"
	lift_announce_str = "Arriving at Cargo Level."

/area/turbolift/rmine/under1
	name = "mining shaft (level -1)"
	lift_floor_label = "Undergound Level 1"
	lift_floor_name = "Maintnence"
	lift_announce_str = "Arriving at Maintnence Point."

/area/turbolift/rmine/under2
	name = "mining shaft (level -2)"
	lift_floor_label = "Undergound Level 2"
	lift_floor_name = "Mining Main"
	lift_announce_str = "Arriving at Mining Department."

/area/turbolift/rmine/under3
	name = "mining shaft (level -3)"
	lift_floor_label = "Undergound Level 3"
	lift_floor_name = "Mining Bottom"
	lift_announce_str = "Arriving at Lower Level."


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
