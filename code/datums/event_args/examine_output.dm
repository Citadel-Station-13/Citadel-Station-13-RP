//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/event_args/examine_output
	/// our name
	/// * As a raw HTML line
	var/name
	/// our desc
	/// * As a raw HTML line
	var/desc

	/// worn
	/// * For things visible from outside separately, like mech components, someone's clothing, etc
	/// * As raw HTML lines
	var/list/worn

#warn impl all
