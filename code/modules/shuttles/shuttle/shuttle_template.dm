//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * the shuttle templates in charge of holding definitions of shuttles.
 *
 * each can be instantiated multiple times unless otherwise stated.
 */
/datum/shuttle_template
	abstract_type = /datum/shuttle_template

	//* Basics
	/// unique ID - use snake_case, must be unique & stable, including across rounds.
	/// this means hardcoded ones shouldn't be changed willy-nilly.
	var/id

	//* Identity
	/// Full name
	var/name
	/// Full description
	var/desc
	/// lore fluff
	var/fluff

	//* File
	/// absolute path to file
	var/absolute_path
	/// relative path to file from current directory
	var/relative_path

	//* Flight (overmaps / web)
	/// mass in kilotons
	//  todo: in-game mass calculations? only really relevant for drone tbh
	var/mass = 5
	/// if set to false, this is absolute-ly unable to land on a planet
	var/allow_atmospheric_landing = TRUE

	//* Jumps (ferry & moving to/from overmaps)
	/// engine charging time when starting a move
	//  todo: should have support for being based on in game machinery (?)
	var/jump_charging_time = 10 SECONDS
	/// time spent in transit when performing a move
	var/jump_move_time = 10 SECONDS

	//* .dmm
	/// should we keep parsed map once first loaded?w
	var/cache_parsed_map = FALSE
	/// our parsed map
	var/datum/dmm_parsed/parsed_map
	/// direction the shuttle is facing, in the map
	/// please try to map shuttles in facing north.
	var/facing_dir = NORTH

	//* Internals
	/// shuttle datum type to make
	var/shuttle_type = /datum/shuttle

/datum/shuttle_template/New(map_resource, use_dir)
	if(map_resource)
		absolute_path = map_resource
		facing_dir = use_dir || NORTH
	else
		if(relative_path && !absolute_path)
			var/our_file = __FILE__
			var/our_directory = copytext_char(our_file, 1, findlasttext_char(our_file, "/"))
			absolute_path = "[our_directory]/[relative_path]"

	if(cache_parsed_map)
		parsed_map = new(get_file())

/datum/shuttle_template/proc/get_file()
	return isfile(absolute_path)? absolute_path : file(absolute_path)

/**
 * Do not directly use. Use create_shuttle() on SSshuttles!
 * This will not automatically register the shuttle with the subsystem.
 */
/datum/shuttle_template/proc/instance(shuttle_type = src.shuttle_type)
	RETURN_TYPE(/datum/shuttle)

	var/datum/dmm_parsed/parsed_map = src.parsed_map
	if(isnull(parsed_map))
		parsed_map = new(get_file())
		parsed_map
		if(cache_parsed_map)
			src.parsed_map = parsed_map

	var/datum/shuttle/instance = new shuttle_type
	var/width = parsed_map.width
	var/height = parsed_map.height

	// make reservation
	var/datum/turf_reservation/reservation = SSmapping.request_block_reservation(
		width + 2,
		height + 2,
		/datum/turf_reservation,
	)

	// load into reservation
	var/list/loaded_bounds = parsed_map.load(
		reservation.bottom_left_coords[1] + 1,
		reservation.bottom_left_coords[2] + 1,
		reservation.bottom_left_coords[3],
	)

	// let shuttle do black magic first
	instance.before_bounds_init(reservation, src)

	// init the bounds
	SSatoms.init_map_bounds(loaded_bounds)

	// let shuttle do post-init things
	instance.after_bounds_init(reservation, src)

	// set vars on shuttle
	instance
	instance.template_id = id

	return instance

/datum/map_template/shuttle
	abstract_type = /datum/map_template/shuttle
