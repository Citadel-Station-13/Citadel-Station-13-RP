//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

REPOSITORY_DEF(poster_designs)
	name = "Repository - Poster Designs"
	expected_type = /datum/prototype/poster_design

/**
 * @params
 * * tags - POSTER_TAG_*, list of POSTER_TAG_*, or null for **fetch all**.
 */
/datum/controller/repository/poster_designs/proc/fetch_by_tag(tags)
	#warn impl
