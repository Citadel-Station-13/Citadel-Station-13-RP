DECLARE_SHUTTLE_TEMPLATE(/generic/military/xn_29)
	id = "military-xn_29"

#warn impl

// Map template for spawning the shuttle
/datum/map_template/shuttle/overmap/generic/hybrid
	name = "OM Ship - Hybrid Shuttle"
	desc = "A prototype human/alien tech hybrid shuttle."
	suffix = "hybridshuttle.dmm"
	annihilate = TRUE

// The shuttle's area(s)
/area/shuttle/blue_fo
// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/hybridshuttle
	name = "Origin - Hybrid Shuttle"
	shuttle_type = /datum/shuttle/autodock/overmap/hybridshuttle

// The 'shuttle'
/datum/shuttle/autodock/overmap/hybridshuttle
	name = "XN-29 Prototype Shuttle"
	current_location = "omship_spawn_hybridshuttle"
	docking_controller_tag = "hybrid_shuttle_docker"
	shuttle_area = /area/shuttle/blue_fo
	fuel_consumption = 0
	defer_initialisation = TRUE //We're not loaded until an admin does it

// The 'ship'
/obj/overmap/entity/visitable/ship/landable/hybridshuttle
	scanner_name = "XN-29 Prototype Shuttle"
	scanner_desc = @{"[i]Registration[/i]: UNKNOWN
[i]Class[/i]: Shuttle
[i]Transponder[/i]: Transmitting (MIL), Nanotrasen
[b]Notice[/b]: Experimental vessel"}
	color = "#00aaff" //Bluey
	vessel_mass = 3000
	shuttle = "XN-29 Prototype Shuttle"

#warn map
