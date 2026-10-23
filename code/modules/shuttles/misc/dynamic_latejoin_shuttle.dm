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
	/// * auto-loaded from template `display_name` if available
	var/name
	/// *short* description
	/// * auto-loaded from template `display_desc` if available
	var/desc
	/// long fluff
	/// * auto-loaded from template `fluff` if available
	var/fluff
	/// category
	/// * auto-loaded from template `category` if available
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

/datum/dyanmic_latejoin_shuttle/New()
	auto_load_from_template()

/datum/dynamic_latejoin_shuttle/proc/auto_load_from_template()
	var/datum/shuttle_template/template = SSshuttle.fetch_template(shuttle_template_id)
	if(!template)
		return
	if(!name)
		name = template.display_name || template.name
	if(!desc)
		desc = template.display_desc || template.desc
	if(!fluff)
		fluff = template.fluff
	if(!category)
		category = template.category

/datum/dynamic_latejoin_shuttle/ftu_vevalia_salvage
	shuttle_template_id = /datum/shuttle_template/factions/ftu/vevalia_salvage::id
	available_to_public = TRUE

/datum/dynamic_latejoin_shuttle/ftu_udang
	shuttle_template_id = /datum/shuttle_template/factions/ftu/udang::id
	available_to_public = TRUE

/datum/dynamic_latejoin_shuttle/ftu_scoophead
	shuttle_template_id = /datum/shuttle_template/factions/ftu/scoophead::id
	available_to_public = TRUE
