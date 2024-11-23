//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

REPOSITORY_DEF(poster_designs)
	name = "Repository - Poster Designs"
	expected_type = /datum/prototype/poster_design

	/// by tag
	var/list/tag_lookup = list()

/datum/controller/repository/poster_designs/load(datum/prototype/poster_design/instance)
	. = ..()
	if(!.)
		return
	for(var/the_tag in instance.poster_tags)
		LAZYADD(tag_lookup[the_tag], instance)

/datum/controller/repository/poster_designs/unload(datum/prototype/poster_design/instance)
	. = ..()
	if(!.)
		return
	for(var/the_tag in instance.poster_tags)
		tag_lookup[the_tag] -= instance
		if(!length(tag_lookup[the_tag]))
			tag_lookup -= the_tag

/**
 * @params
 * * tags - POSTER_TAG_*, list of POSTER_TAG_*, or null for **fetch all**.
 */
/datum/controller/repository/poster_designs/proc/fetch_by_tag_mutable(tags)
	if(islist(tags))
		. = list()
		for(var/the_tag in tags)
			. |= tag_lookup[the_tag]
	else if(tags)
		. = tag_lookup[tags]?:Copy() || list()
	else
		. = fetch_subtypes_mutable(/datum/prototype/poster_design)
