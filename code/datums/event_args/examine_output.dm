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
	var/list/out_worn_descriptors = list()
	/// visible descriptors
	/// * For misc visible things
	/// * As raw HTML lines
	/// * Lazy list
	var/list/out_visible_descriptors = list()
	/// 'things you notice' descriptors
	/// * For misc things you notice
	/// * As raw HTML lines
	/// * Lazy list
	var/list/out_noticed_descriptors = list()
	/// interaction descriptors
	/// * For things like counting their pulse automatically, etc
	/// * Can contain links, and is considered interactive.
	/// * As raw HTML lines
	/// * Lazy list
	var/list/out_interacted_descriptors = list()
	/// analysis descriptors
	/// * For things like HUD, flavor text, etc
	/// * Can contain links, and is considered interactive.
	/// * As raw HTML lines
	/// * Lazy list
	var/list/out_analysis_descriptors = list()
	/// analysis descriptors
	/// * For things like character directory, etc
	/// * Can contain links, and is considered interactive.
	/// * As raw HTML lines
	/// * Lazy list
	var/list/out_ooc_descriptors = list()

	/// list of appearances to render to clients for them to be able to view them with native image ref'ing
	var/list/appearance/required_appearances = list()

#warn impl all


/datum/examine_output/proc/send_required_resources(client/to_client)

