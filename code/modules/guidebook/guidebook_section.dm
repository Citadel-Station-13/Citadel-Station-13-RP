/datum/prototype/guidebook_section
	abstract_type = /datum/prototype/guidebook_section

	/// tgui guidebook module to load
	var/tgui_module

/**
 * data to be sent to module - static
 *
 * this is the only one, for now
 *
 * todo: add dynamic data support
 */
/datum/prototype/guidebook_section/proc/static_data()
	. = list()
