//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

GLOBAL_LIST_INIT(dynamic_latejoin_shuttles, init_dynamic_latejoin_shuttles())

/proc/init_dynamic_latejoin_shuttles()
	. = list()
	for(var/datum/dynamic_latejoin_shuttle/path as anything in subtypesof(/datum/dynamic_latejoin_shuttle))
		if(initial(path.abstract_type) == path)
			continue
		var/datum/dynamic_latejoin_shuttle/instance = new(path)
		. += instance

/**
 * Denotes a shuttle template that may be used as a freely-used latejoin shuttle for travelers.
 * * Did I say traveler? No, this is technically going to probably be used for more than just
 *   traveler. Think "group joins", readying up as a group, etc.
 */
/datum/dynamic_latejoin_shuttle
	/// shuttle template id
	var/shuttle_template_id

	/// name
	var/name
	/// *short* description
	var/desc
	/// long fluff
	var/fluff
	/// category
	var/category

	/// freely joinable?
	/// * we don't actually know what this does other than stop travelers from picking it.
	///   it's mostly so people can flag this for their stuff.
	var/available_to_public = TRUE
	/// restrict to ckeys?
	/// * used for custom shuttles
	/// * we don't actually enforce this on admins or anything else, this is only
	///   a recommendation lol
	var/list/restrict_to_ckeys

#warn impl

