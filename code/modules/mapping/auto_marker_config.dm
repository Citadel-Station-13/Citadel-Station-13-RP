//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Configuration that allows types to dynamically replace themselves on
 * mapload to dynamically retheme a room.
 */
/datum/auto_marker_config
	var/outdoors_floor_type = /turf/simulated/floor/tiled
	var/outdoors_floor_stripped_type = /turf/simulated/floor/plating
	var/outdoors_floor_very_stripped_type = /turf/simulated/floor/plating

	var/outdoors_rock_type = /turf/simulated/mineral
	var/outdoors_rock_dense_type = /turf/simulated/mineral
	var/outdoors_rock_very_dense_type = /turf/simulated/mineral

	var/outdoors_liquid_type = /turf/simulated/floor/water

	var/door_type = /obj/structure/simple_door/wood
	var/secure_door_type = /obj/structure/simple_door/iron
	var/external_door_type = /obj/structure/simple_door/wood

	var/airlock_type = /obj/machinery/door/airlock/glass
	var/secure_airlock_type = /obj/machinery/door/airlock/vault
	var/external_airlock_type = /obj/machinery/door/airlock/external

	var/window_type = /obj/structure/window
	var/reinforced_window_type = /obj/structure/window/reinforced
	var/borosillicate_window_type = /obj/structure/window/phoronreinforced

/datum/auto_marker_config/clone()
	var/datum/auto_marker_config/clone = new

	clone.outdoors_floor_type = src.outdoors_floor_type
	clone.outdoors_floor_stripped_type = src.outdoors_floor_stripped_type
	clone.outdoors_floor_very_stripped_type = src.outdoors_floor_very_stripped_type

	clone.outdoors_rock_type = src.outdoors_rock_type
	clone.outdoors_rock_dense_type = src.outdoors_rock_dense_type
	clone.outdoors_rock_very_dense_type = src.outdoors_rock_very_dense_type

	clone.outdoors_liquid_type = src.outdoors_liquid_type

	clone.door_type = src.door_type
	clone.secure_door_type = src.secure_door_type
	clone.external_door_type = src.external_door_type

	clone.airlock_type = src.airlock_type
	clone.secure_airlock_type = src.secure_airlock_type
	clone.external_airlock_type = src.external_airlock_type

	clone.window_type = src.window_type
	clone.reinforced_window_type = src.reinforced_window_type
	clone.borosillicate_window_type = src.borosillicate_window_type

	return clone
