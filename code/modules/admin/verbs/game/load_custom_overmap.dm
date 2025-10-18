//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

ADMIN_VERB_DEF(load_custom_overmap, R_ADMIN, "Load Custom Overmap", "Load a custom overmap.", VERB_CATEGORY_GAME)
	var/are_you_sure = tgui_alert(
		invoking,
		"Instantiating overmaps is an advanced feature. \
		The uploaded file is placed and instantiated as an overmap; only overmap tiles, overmap entities, and overmap tile entities \
		should exist in the file, or you may have funny things happen and the server explode. Furthermore, you will have to link the new \
		overmap yourself, as the standard overmap will not be able to traverse to it normally. \
		Are you sure you know what you are doing?",
		"Load Custom Overmap",
		list("No", "Yes"),
	)
	if(are_you_sure != "Yes")
		return

	var/map = input(invoking, "Select overmap .dmm", "Instantiate Overmap") as file|null
	if(!map)
		return

	var/datum/dmm_parsed/parsed_map = parse_map(map)

	if(!parsed_map.parsed)
		tgui_alert(invoking, "Failed to parse map.", "Parse Error")
		return

	var/max_x = world.maxx - TURF_CHUNK_RESOLUTION * 2
	var/max_y = world.maxy - TURF_CHUNK_RESOLUTION * 2

	if(parsed_map.width >= max_x || parsed_map.height >= max_y)
		tgui_alert(invoking, "Your map is too big for the current world size. Yours was [parsed_map.width]x[parsed_map.height], but maximum is: [max_x]x[max_y]", "Improper Dimensions")
		return

	var/are_you_really_sure = tgui_alert(
		invoking,
		"Loading an overmap with size [parsed_map.width]x[parsed_map.height]. Does everything look okay?",
		"Load Custom Overmap",
		list("No", "Yes"),
	)
	if(are_you_really_sure != "Yes")
		return

	// give the tgui popup time to be removed
	sleep(5)

	log_and_message_admins("is loading a new overmap with dimensions [parsed_map.width]x[parsed_map.height]", invoking)
	var/start_time = REALTIMEOFDAY
	// welcome to hell
	// allocate turf reservation and load at offset
	// from this point on, if we crash, we don't warn the user, because it shouldn't be possible to crash
	var/datum/overmap_template/template = new
	template.width = parsed_map.width
	template.height = parsed_map.height
	var/datum/overmap/creating = new("loaded-[rand(1, 1000000)]", template)
	creating.initialize()
	// loaded, load the map template in there
	var/datum/dmm_context/loaded_context = parsed_map.load(
		creating.reservation.bottom_left_coords[1],
		creating.reservation.bottom_left_coords[2],
		creating.reservation.bottom_left_coords[3],
		area_cache = list(
			(/area/overmap) = creating.area,
		),
	)
	// initialize
	SSatoms.init_map_bounds(loaded_context.loaded_bounds)
	var/llx = loaded_context.loaded_bounds[MAP_MINX]
	var/lly = loaded_context.loaded_bounds[MAP_MINY]
	var/llz = loaded_context.loaded_bounds[MAP_MINZ]
	// re-initialize inner
	creating.initialize_inner_turfs()
	// announce
	var/end_time = REALTIMEOFDAY
	log_and_message_admins("has loaded overmap [creating.id] with dimensions [creating.width]x[creating.height] at LL-bounds [llx], [lly], [llz] in [round((end_time - start_time) * 0.1, 0.1)] seconds", invoking)
