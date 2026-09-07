// Class D world areas
/area/sector/class_d
	name = "Class D World"
	icon_state = "away"
	requires_power = 1
	dynamic_lighting = 1

/area/sector/class_d/explored
	name = "Class D World - Explored (E)"
	icon_state = "explored"
	allow_worldgen_overwrite = TRUE

/area/sector/class_d/unexplored
	name = "Class D World - Unexplored (UE)"
	icon_state = "unexplored"
	allow_worldgen_overwrite = TRUE

/area/sector/class_d/unexplored/underground // Caves would be protected from weather. Still valid for POI generation do to being a dependent of /area/poi_d/unexplored

/area/sector/class_d/explored/underground

/area/sector/class_d/wildcat_mining_base
	name = "Abandoned Facility"
	icon_state = "blue"
	requires_power = TRUE

/area/sector/class_d/wildcat_mining_base/exterior_power
	name = "Exterior Power"

/area/sector/class_d/wildcat_mining_base/refueling_outbuilding
	name = "Refueling Outbuilding"

/area/sector/class_d/wildcat_mining_base/warehouse
	name = "Warehouse"

/area/sector/class_d/wildcat_mining_base/exterior_workshop
	name = "Exterior Workshop"

/area/sector/class_d/wildcat_mining_base/interior

/area/sector/class_d/wildcat_mining_base/interior/main_room
	name = "Main Room"

/area/sector/class_d/wildcat_mining_base/interior/utility_room
	name = "Utility Room"

/area/sector/class_d/wildcat_mining_base/interior/bunk_room
	name = "Bunk Room"

/area/sector/class_d/wildcat_mining_base/interior/bathroom
	name = "Bathroom"

/area/sector/class_d/POIs/ship
	name = "Crashed Ship Fragment"

/area/sector/class_d/plains
	name = "Plains"

/area/sector/class_d/crater
	name = "Crater"

/area/sector/class_d/Mountain
	name = "Mountain"

/area/sector/class_d/Crevices
	name = "Crevices"

/area/sector/class_d/POIs/solar_farm
	name = "Prefab Solar Farm"

/area/sector/class_d/POIs/landing_pad
	name = "Prefab Homestead"
	requires_power = FALSE

/area/sector/class_d/POIs/reactor
	name = "Prefab Reactor"
