//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/event_args/examine_output
	/// our name
	/// * As a raw HTML line
	var/entity_name
	/// our desc
	/// * As a raw HTML line
	var/entity_desc
	/// appearance
	/// * as raw appearance ref
	var/appearance/entity_appearance

	/// worn descriptors
	/// * For things visible from outside separately, like mech components, someone's clothing, etc
	/// * As raw HTML lines
	/// * Lazy list
	var/list/worn_descriptors = list()
	/// visible descriptors
	/// * For misc visible things
	/// * As raw HTML lines
	/// * Lazy list
	var/list/visible_descriptors = list()
	/// 'things you notice' descriptors
	/// * For misc things you notice
	/// * As raw HTML lines
	/// * Lazy list
	var/list/noticed_descriptors = list()
	/// analysis descriptors
	/// * For things like HUD, etc
	/// * As raw HTML lines
	/// * Lazy list
	var/list/analysis_descriptors = list()
	/// analysis descriptors
	/// * For things like character directory, etc
	/// * As raw HTML lines
	/// * Lazy list
	var/list/ooc_descriptors = list()

	/// list of appearances to render to clients for them to be able to view them with native image ref'ing
	var/list/appearance/required_appearances = list()

#warn impl all
