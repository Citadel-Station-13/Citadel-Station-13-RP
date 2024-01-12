//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * the shuttle templates in charge of holding definitions of shuttles.
 *
 * each can be instantiated multiple times unless otherwise stated.
 */
/datum/shuttle_template
	abstract_type = /datum/shuttle_template

	/// Full name
	var/name
	/// Full description
	var/desc
	/// lore fluff
	var/fluff

	/// direction the shuttle is facing, in the map
	/// please try to map shuttles in facing north.
	var/facing_dir = NORTH

	/// unique ID - use CamelCase, must be unique & stable, including across rounds.
	/// this means hardcoded ones shouldn't be changed willy-nilly.
	var/id

	/// forbid multi-instancing
	/// if you have to turn this on you probably fucked up somewhere
	var/allow_only_one_instance = FALSE

	/// absolute path to file
	var/absolute_path
	/// relative path to file from current directory
	var/relative_path
	#warn impl with __FILE__

	/// mass in kilotons
	var/mass = 5
	/// if set to false, this is absolute-ly unable to land on a planet
	var/allow_atmospheric_landing = TRUE

	/// our map template
	var/datum/map_template/shuttle/map_template

#warn impl all

/datum/shuttle_template/New(map_resource, use_dir)
	#warn uhh

/datum/map_template/shuttle
	abstract_type = /datum/map_template/shuttle
