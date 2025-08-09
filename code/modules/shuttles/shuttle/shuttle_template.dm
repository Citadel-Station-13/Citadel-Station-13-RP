//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * the shuttle templates in charge of holding definitions of shuttles.
 *
 * each can be instantiated multiple times unless otherwise stated.
 */
/datum/shuttle_template
	abstract_type = /datum/shuttle_template

	//* Basics *//
	/// unique ID - use snake_case, must be unique & stable, including across rounds.
	/// this means hardcoded ones shouldn't be changed willy-nilly.
	var/id

	//* Identity *//
	/// Full name
	var/name
	/// Full description
	var/desc
	/// lore fluff
	var/fluff

	//* File *//
	/// Absolute path to the map .dmm file.
	///
	/// This is determined with regards to the context of the load.
	///
	/// * Hardcoded shuttle templates will be the path from the server's working directory.
	var/path

	//* Functionality
	/// our shuttle typepath
	///
	/// * yeah uh you probably shouldn't mess with this unless you know what you're doing
	var/shuttle_type = /datum/shuttle
	/// our descriptor, used for cross-interaction with other systems
	/// this should not be a cached typepath, as opposed to a directly made typepath
	/// or an instance.
	///
	/// * because we intentionally don't cache typepaths, anonymous typepaths are allowed **and encouraged**.
	///
	/// typepaths will be initialized.
	/// instances will be cloned.
	var/datum/shuttle_descriptor/descriptor = /datum/shuttle_descriptor

	//* .dmm
	/// should we keep parsed map once first loaded?
	var/cache_parsed_map = FALSE
	/// our parsed map
	var/datum/dmm_parsed/parsed_map
	/// direction the shuttle is facing, in the map
	/// please try to map shuttles in facing north.
	var/facing_dir = NORTH

/datum/shuttle_template/New(map_resource, use_dir)
	if(map_resource)
		path = map_resource
		facing_dir = use_dir || NORTH

	if(cache_parsed_map)
		parsed_map = new(get_file())

/datum/shuttle_template/proc/get_file()
	return isfile(path)? path : file(path)

/**
 * Do not directly use. Use create_shuttle() on SSshuttles!
 * This will not automatically register the shuttle with the subsystem.
 */
/datum/shuttle_template/proc/instance(list/datum/map_injection/map_injections)
	RETURN_TYPE(/datum/shuttle)

	var/datum/dmm_parsed/parsed_map = src.parsed_map
	if(isnull(parsed_map))
		parsed_map = new(get_file())
		if(cache_parsed_map)
			src.parsed_map = parsed_map

	var/datum/shuttle/instance = new shuttle_type
	var/width = parsed_map.width
	var/height = parsed_map.height

	// make reservation
	var/datum/map_reservation/reservation = SSmapping.request_block_reservation(
		width + 2,
		height + 2,
		/datum/map_reservation,
	)

	// create context
	var/datum/dmm_context/context = new
	context.mangling_id = generate_mangling_id()
	for(var/datum/map_injection/injection as anything in map_injections)
		context.register_injection(injection)

	// load into reservation
	var/datum/dmm_context/loaded_context = parsed_map.load(
		reservation.bottom_left_coords[1] + 1,
		reservation.bottom_left_coords[2] + 1,
		reservation.bottom_left_coords[3],
		context = context,
	)
	var/list/loaded_bounds = loaded_context.loaded_bounds

	// set descriptor
	instance.descriptor = instance_descriptor()

	// let shuttle do black magic first
	// instance.before_bounds_init(reservation, src)

	// init the bounds
	SSatoms.init_map_bounds(loaded_bounds)

	// let shuttle do post-init things
	// instance.after_bounds_init(reservation, src)

	// set vars on shuttle
	instance.template_id = id

	return instance

/datum/shuttle_template/proc/instance_descriptor()
	if(istype(descriptor))
		return descriptor.clone()
	else if(IS_ANONYMOUS_TYPEPATH(descriptor))
		return new descriptor
	else if(ispath(descriptor, /datum/shuttle_descriptor))
		return new descriptor
	CRASH("what? [descriptor] ([REF(descriptor)])")

/datum/shuttle_template/proc/generate_mangling_id()
	var/static/notch = 0
	if(notch >= SHORT_REAL_LIMIT)
		stack_trace("how the hell are we at this number?")
	return "shuttle-[++notch]-[SSmapping.round_global_descriptor]"

/datum/map_template/shuttle
	abstract_type = /datum/map_template/shuttle
