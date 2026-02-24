
/datum/shuttle/autodock/overmap/tinycarrier
	name = "Debris Carrier"
	warmup_time = 0
	current_location = "debris_field_carrier_start"
	docking_controller_tag = "debris_carrier_docker"
	shuttle_area = list(/area/shuttle/debrisfield_vr/tinyshuttle/crew, /area/shuttle/debrisfield_vr/tinyshuttle/bridge, /area/shuttle/debrisfield_vr/tinyshuttle/hangar, /area/shuttle/debrisfield_vr/tinyshuttle/engine)
	fuel_consumption = 3
	defer_initialisation = TRUE
	move_direction = WEST

/obj/effect/shuttle_landmark/shuttle_initializer/tinycarrier
	name = "Debris Field"
	shuttle_type = /datum/shuttle/autodock/overmap/tinycarrier

/obj/effect/shuttle_landmark/shuttle_initializer/tinycarrier/Initialize(mapload)
	var/obj/overmap/entity/visitable/O = get_overmap_entity(get_z(src)) //make this into general system some other time
	LAZYINITLIST(O.initial_restricted_waypoints)
	O.initial_restricted_waypoints["Debris Carrier"] = list(landmark_tag)
	. = ..()

/obj/overmap/entity/visitable/ship/landable/tinycarrier
	scanner_name = "SDF Birdcage"
	scanner_desc = {"\[i\]Registration\[/i\]: SDV Birdcage
\[i\]Class\[/i\]: Light Escort Carrier
\[i\]Transponder\[/i\]: Transmitting (MIL), Weak Signal
\[b\]Notice\[/b\]: Registration Expired"}
	vessel_mass = 12000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Debris Carrier"
	fore_dir = WEST

/*
/obj/overmap/entity/visitable/ship/landable/tinycarrier/Initialize(mapload)
	. = ..()
	var/datum/lore/organization/O = SSlegacy_lore.organizations[/datum/lore/organization/other/sysdef]
	var/newname = "SDV [pick(O.ship_names)]"
	scanner_name = "SDF Birdcage
	scanner_desc = {"\[i\]Registration\[/i\]: SDV Birdcage
\[i\]Class\[/i\]: Light Escort Carrier
\[i\]Transponder\[/i\]: Transmitting (MIL), Weak Signal
\[b\]Notice\[/b\]: Registration Expired"}
	return INITIALIZE_HINT_LATELOAD

/obj/overmap/entity/visitable/ship/landable/tinycarrier/LateInitialize()
	. = ..()
	rename_areas(scanner_name)

/obj/overmap/entity/visitable/ship/landable/tinycarrier/proc/rename_areas(newname)
	var/datum/shuttle/S = SSshuttle.shuttles[shuttle]
	for(var/area/A in S.shuttle_area)
		A.name = "[newname] [initial(A.name)]"
		if(A.apc)
			A.apc.name = "[A.name] APC"
		for(var/obj/machinery/air_alarm/AA in A)
			AA.name = "[A.name] Air Alarm"
*/
