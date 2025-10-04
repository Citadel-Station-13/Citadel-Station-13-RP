//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

REPOSITORY_DEF(roles)
	name = "Repository - Roles"
	expected_type = /datum/prototype/role

	/**
	 * Jobs by title.
	 * * Only populated for /role/job for legacy lookups.
	 */
	var/list/legacy_job_title_lookup = list()

/datum/controller/repository/roles/load(datum/prototype/instance)
	. = ..()


/datum/controller/repository/roles/unload(datum/prototype/instance)
	. = ..()


#warn impl

/**
 * Only returns /role/job
 */
/datum/controller/repository/roles/proc/legacy_all_job_ids(filter_faction)
	#warn impl

/**
 * Only returns /role/job
 */
/datum/controller/repository/roles/proc/legacy_all_job_types(filter_faction)
	#warn impl

/**
 * Only returns /role/job
 */
/datum/controller/repository/roles/proc/legacy_all_job_titles(filter_faction)
	#warn impl

/**
 * Only returns /role/job
 */
/datum/controller/repository/roles/proc/legacy_all_job_datums(filter_faction)
	#warn impl
