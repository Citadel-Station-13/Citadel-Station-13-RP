//Debug areas
/area/triumph/surfacebase
	name = "Triumph Debug Surface"

/area/triumph/transit
	name = "Triumph Debug Transit"
	requires_power = 0

/area/triumph/space
	name = "Triumph Debug Space"
	requires_power = 0

/area/maintenance/bar/catwalk
	name = "Bar Maintenance Catwalk"
	icon_state = "maint_bar"

// Elevator areas.
/area/turbolift
	delay_time = 2 SECONDS
	forced_ambience = list('sound/music/elevator.ogg')
	dynamic_lighting = FALSE //Temporary fix for elevator lighting

	requires_power = FALSE

/area/turbolift/t_ship/level1
	name = "Deck 1"
	lift_floor_label = "Deck 1"
	lift_floor_name = "Engineering, Reactor, Telecomms, Trash Pit, Atmospherics"
	lift_announce_str = "Arriving at Deck 2."
	base_turf = /turf/simulated/floor/plating


/area/turbolift/t_ship/level2
	name = "Deck 2"
	lift_floor_label = "Deck 2"
	lift_floor_name = "Dorms, Mining, Bar, Cafe, Solars, Shops"
	lift_announce_str = "Arriving at Deck 2."
	base_turf = /turf/simulated/floor/plating

/area/turbolift/t_ship/level3
	name = "Deck 3"
	lift_floor_label = "Deck 3"
	lift_floor_name = "Medical, Science, Holo Deck, Teleporter"
	lift_announce_str = "Arriving at Deck 3."

/area/turbolift/t_ship/level4
	name = "Deck 4"
	lift_floor_label = "Deck 4"
	lift_floor_name = "Exploration, Arrivals & Departures, Security, Command, Chapel, Sauna, Docking Arm, Library, Garden, Tool Storage"
	lift_announce_str = "Arriving at Deck 4."


/area/vacant/vacant_restaurant_upper
	name = "\improper Vacant Restaurant"
	icon_state = "vacant_site"
	flags = null

/area/vacant/vacant_restaurant_lower
	name = "\improper Vacant Restaurant"
	icon_state = "vacant_site"
	flags = null

/area/engineering/engineering_airlock
	name = "\improper Engineering Airlock"
	icon_state = "engine_eva"

/area/engineering/hallway
	name = "\improper Engineering Hallway"
	icon_state = "engineering"

/area/engineering/shaft
	name = "\improper Engineering Electrical Shaft"
	icon_state = "substation"

/area/vacant/vacant_office
	name = "\improper Vacant Office"
	icon_state = "vacant_site"

/area/medical/psych_ward
	name = "\improper Psych Ward"
	icon_state = "psych_ward"