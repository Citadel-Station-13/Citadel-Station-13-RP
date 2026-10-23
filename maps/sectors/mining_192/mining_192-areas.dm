
// Class G world areas
/area/sector/class_g
	name = "Class G World"
	icon_state = "away"
	requires_power = 1
	dynamic_lighting = 1

/area/sector/class_g/explored
	name = "Class G World - Explored (E)"
	icon_state = "red"
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/horror.ogg')
	allow_worldgen_overwrite = TRUE

/area/sector/class_g/unexplored
	name = "Class G World - Unexplored (UE)"
	icon_state = "yellow"
	allow_worldgen_overwrite = TRUE
