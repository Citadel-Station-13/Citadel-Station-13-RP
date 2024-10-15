//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * a locale in the world
 */
/datum/world_location
	abstract_type = /datum/world_location

	/// location name
	var/name
	/// short description
	var/desc
	/// id - must be unique for world locations
	var/id
