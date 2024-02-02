//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/prototype/guidebook_section
	abstract_type = /datum/prototype/guidebook_section

	/// section title
	var/title = "Unknown"
	/// tgui guidebook module to load
	var/tgui_module

/**
 * data to be sent to module - static
 *
 * this is the only one, for now
 *
 * todo: add dynamic data support???
 */
/datum/prototype/guidebook_section/proc/section_data()
	. = list()

/datum/prototype/guidebook_section/proc/interface_data()
	return list(
		"$tgui" = tgui_module,
		"$src" = REF(src),
		"title" = title,
	) | section_data()
