// -- Datums -- //

/obj/effect/overmap/visitable/sector/debrisfield_vr
	name = "Debris Field"
	desc = "Space junk galore."
	scanner_desc = @{"[i]Transponder[/i]: Various faint signals
[b]Notice[/b]: Warning! Significant field of space debris detected. May be salvagable."}
	icon_state = "dust1"
	known = FALSE
	color = "#ee3333" //Redish, so it stands out against the other debris-like icons
	initial_generic_waypoints = list("debrisfield_se", "debrisfield_nw")

// -- Objs -- //


/obj/effect/step_trigger/teleporter/debrisfield_vr_loop/north/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = 2
	teleport_z = z

/obj/effect/step_trigger/teleporter/debrisfield_vr_loop/south/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = world.maxy - 1
	teleport_z = z

/obj/effect/step_trigger/teleporter/debrisfield_vr_loop/west/Initialize(mapload)
	. = ..()
	teleport_x = world.maxx - 1
	teleport_y = y
	teleport_z = z

/obj/effect/step_trigger/teleporter/debrisfield_vr_loop/east/Initialize(mapload)
	. = ..()
	teleport_x = 2
	teleport_y = y
	teleport_z = z

/area/tether_away/debrisfield_vr
	name = "Away Mission - Debris Field"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "dark"

/area/tether_away/debrisfield_vr/shuttle_buffer //For space around shuttle landmarks to keep submaps from generating to block them
	icon_state = "debrisexplored"
	name = "\improper Space"
	requires_power = 1
	always_unpowered = 1
	dynamic_lighting = 0
	has_gravity = 0
	power_light = 0
	power_equip = 0
	power_environ = 0
	ambience = AMBIENCE_SPACE

/area/submap/debrisfield_vr
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "debrisunexplored"

/area/submap/debrisfield_vr/derelict
	icon_state = "debrisexplored"
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/horror.ogg')

//TFF 26/12/19 - Sub-areas for the APCs.

/area/submap/debrisfield_vr/derelict/ai_access_port
	name = "POI - Abandoned Derelict AI Acess Port"

/area/submap/debrisfield_vr/derelict/ai_access_starboard
	name = "POI - Abandoned Derelict AI Access Starboard"

/area/submap/debrisfield_vr/derelict/ai_chamber
	name = "POI - Abandoned Derelict AI Chamber"

/area/submap/debrisfield_vr/derelict/bridge
	name = "POI - Abandoned Derelict Bridge"

/area/submap/debrisfield_vr/derelict/interior
	name = "POI - Abandoned Derelict Interior"

/area/submap/debrisfield_vr/foodstand
	name = "POI - Foodstand"

/area/submap/debrisfield_vr/sci_overrun
	name = "POI - Overrun Science Ship"
	requires_power = 0

/area/submap/debrisfield_vr/old_sat
	name = "POI - Old Satellite"

/area/submap/debrisfield_vr/old_tele
	name = "POI - Old Teleporter"

/area/submap/debrisfield_vr/mining_drone_ship
	name = "POI - Disabled Mining Drone"
	requires_power = 0

/area/submap/debrisfield_vr/mining_outpost
	name = "POI - Destroyed Mining Outpost"

/area/submap/debrisfield_vr/tinyshuttle
	// secret_name = 0

/area/submap/debrisfield_vr/tinyshuttle/crew
	name = "Crew Bay"

/area/submap/debrisfield_vr/tinyshuttle/bridge
	name = "Bridge"

/area/submap/debrisfield_vr/tinyshuttle/hangar
	name = "Hangar"
	has_gravity = 0

/area/submap/debrisfield_vr/tinyshuttle/engine
	name = "Systems Bay"

/area/submap/debrisfiled_vr/clownshuttle
	name = "POI - Covert Clown Shuttle"

/area/submap/debrisfiled_vr/clownshuttle/cockpit
	name = "Cockpit"

/area/submap/debrisfiled_vr/clownshuttle/engine
	name = "Engine"

/area/submap/debrisfiled_vr/clownshuttle/atmos
	name = "Atmospherics"
/area/submap/debrisfiled_vr/clownshuttle/cargo
	name = "Cargo"

/area/submap/debrisfiled_vr/clownshuttle/bunk
	name = "Bunks"

/datum/shuttle/autodock/overmap/tinycarrier
	name = "Debris Carrier"
	warmup_time = 0
	current_location = "debris_field_carrier_start"
	docking_controller_tag = "debris_carrier_docker"
	shuttle_area = list(/area/submap/debrisfield_vr/tinyshuttle/crew, /area/submap/debrisfield_vr/tinyshuttle/bridge, /area/submap/debrisfield_vr/tinyshuttle/hangar, /area/submap/debrisfield_vr/tinyshuttle/engine)
	fuel_consumption = 3
	defer_initialisation = TRUE
	move_direction = WEST

/obj/effect/shuttle_landmark/shuttle_initializer/tinycarrier
	name = "Debris Field"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "debris_field_carrier_start"
	shuttle_type = /datum/shuttle/autodock/overmap/tinycarrier

/obj/effect/shuttle_landmark/shuttle_initializer/tinycarrier/Initialize(mapload)
	var/obj/effect/overmap/visitable/O = get_overmap_sector(get_z(src)) //make this into general system some other time
	LAZYINITLIST(O.initial_restricted_waypoints)
	O.initial_restricted_waypoints["Debris Carrier"] = list(landmark_tag)
	. = ..()

/obj/effect/overmap/visitable/ship/landable/tinycarrier
	scanner_name = "TBD"
	scanner_desc = "TBD"
	vessel_mass = 12000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Debris Carrier"
	fore_dir = WEST

/obj/effect/overmap/visitable/ship/landable/tinycarrier/Initialize(mapload)
	. = ..()
	var/datum/lore/organization/O = GLOB.loremaster.organizations[/datum/lore/organization/other/sysdef]
	var/newname = "SDV [pick(O.ship_names)]"
	scanner_name = newname
	scanner_desc = {"\[i\]Registration\[/i\]: [newname]
\[i\]Class\[/i\]: Light Escort Carrier
\[i\]Transponder\[/i\]: Transmitting (MIL), Weak Signal
\[b\]Notice\[/b\]: Registration Expired"}
	rename_areas(newname)

/obj/effect/overmap/visitable/ship/landable/tinycarrier/proc/rename_areas(newname)
	var/datum/shuttle/S = SSshuttle.shuttles[shuttle]
	for(var/area/A in S.shuttle_area)
		A.name = "[newname] [initial(A.name)]"
		if(A.apc)
			A.apc.name = "[A.name] APC"
		A.air_vent_names = list()
		A.air_scrub_names = list()
		A.air_vent_info = list()
		A.air_scrub_info = list()
		for(var/obj/machinery/alarm/AA in A)
			AA.name = "[A.name] Air Alarm"

/obj/machinery/computer/shuttle_control/explore/tinycarrier
	shuttle_tag = "Debris Carrier"
	req_one_access = list()


/obj/mecha/combat/fighter/baron/loaded/busted
/*
	starting_components = list(
		/obj/item/mecha_parts/component/hull/lightweight,
		/obj/item/mecha_parts/component/actuator/hispeed,
		/obj/item/mecha_parts/component/armor,
		/obj/item/mecha_parts/component/gas,
		/obj/item/mecha_parts/component/electrical/high_current
		)

/obj/mecha/combat/fighter/baron/loaded/busted/Initialize(mapload)
	. = ..()
	health = round(rand(50,120))
	cell?.charge = 0
	for(var/slot in internal_components)
		var/obj/item/mecha_parts/component/comp = internal_components[slot]
		if(!istype(comp))
			continue
		comp.adjust_integrity(-(round(rand(comp.max_integrity - 10, 0))))

	setInternalDamage(MECHA_INT_SHORT_CIRCUIT)
*/

/obj/structure/fuel_port/empty_tank/Initialize(mapload)
	. = ..()
	var/obj/item/tank/phoron/T = locate() in src
	if(T)
		T.air_contents.remove(T.air_contents.total_moles)

/area/submap/debrisfield_vr/misc_debris //for random bits of debris that should use dynamic lights
	requires_power = 1
	always_unpowered = 1
	has_gravity = 0
	power_light = 0
	power_equip = 0
	power_environ = 0
