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

/*
// Triumph Areas itself
/area/tether/surfacebase/tether
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "tether1"
/area/tether/transit/tether
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "tether2"
/area/tether/space/tether
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "tether3"

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
	lift_announce_str = "Arriving at Deck 1."
	base_turf = /turf/simulated/floor/plating


/area/turbolift/t_ship/level2
	name = "Deck 2"
	lift_floor_label = "Deck 2"
	lift_floor_name = "Dorms, Cargo, Mining, Bar, Cafe, Solars, Shops"
	lift_announce_str = "Arriving at Deck 2."

/area/turbolift/t_surface/level2
	name = "surface (level 2)"
	lift_floor_label = "Surface 2"
	lift_floor_name = "Atmos, Maintenance"
	lift_announce_str = "Arriving at Base Level 2."

/area/turbolift/t_surface/level3
	name = "surface (level 3)"
	lift_floor_label = "Surface 3"
	lift_floor_name = "Science, Bar, Pool"
	lift_announce_str = "Arriving at Base Level 3."

/area/turbolift/t_station/level1
	name = "asteroid (level 1)"
	lift_floor_label = "Asteroid 1"
	lift_floor_name = "Eng, Bridge, Park, Cryo"
	lift_announce_str = "Arriving at Station Level 1."

/area/turbolift/t_station/level2
	name = "asteroid (level 2)"
	lift_floor_label = "Asteroid 2"
	lift_floor_name = "Chapel, AI Core, EVA Gear"
	lift_announce_str = "Arriving at Station Level 2."

/area/turbolift/t_station/level3
	name = "asteroid (level 3)"
	lift_floor_label = "Asteroid 3"
	lift_floor_name = "Medical, Security, Cargo"
	lift_announce_str = "Arriving at Station Level 3."
*/

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