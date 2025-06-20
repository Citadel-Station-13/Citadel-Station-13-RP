//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/event_args/examine_output
	/// our name
	/// * As a raw HTML line
	var/name
	/// our desc
	/// * As a raw HTML line
	var/desc
	/// appearance
	/// * as something render-able
	var/render

	/// worn descriptors
	/// * For things visible from outside separately, like mech components, someone's clothing, etc
	/// * As raw HTML lines
	/// * Lazy list
	var/list/worn
	/// visible descriptors
	/// * For misc visible things
	/// * As raw HTML lines
	/// * Lazy list
	var/list/visible

#warn impl all
