//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

REPOSITORY_DEF(roles)
	name = "Repository - Roles"
	expected_type = /datum/prototype/role

	/**
	 * Jobs by title.
	 * * Only populated for /role/job for legacy lookups.
	 */
	var/list/legacy_job_title_lookup = list()

/datum/controller/repository/roles/load(datum/prototype/role/instance)
	. = ..()
	if(!.)
		return
	if(istype(instance, /datum/prototype/role/job))
		var/datum/prototype/role/job/casted_job = instance
		if(legacy_job_title_lookup[casted_job.title])
			stack_trace("collision on '[casted_job.title]' job title between [casted_job.type] and [legacy_job_title_lookup[casted_job.title]:title]")
		else
			legacy_job_title_lookup[casted_job.title] = casted_job


/datum/controller/repository/roles/unload(datum/prototype/role/instance)
	. = ..()
	if(!.)
		return
	if(istype(instance, /datum/prototype/role/job))
		var/datum/prototype/role/job/casted_job = instance
		if(legacy_job_title_lookup[casted_job.title] == casted_job)
			legacy_job_title_lookup -= casted_job.title

/**
 * Only returns /datum/prototype/role/job
 */
/datum/controller/repository/roles/proc/legacy_job_by_title(title) as /datum/prototype/role/job
	return legacy_job_title_lookup[title]

/**
 * Only returns /datum/prototype/role/job
 */
/datum/controller/repository/roles/proc/legacy_job_by_id(id) as /datum/prototype/role/job
	return fetch_local_or_throw(id)

/**
 * Only returns /datum/prototype/role/job
 */
/datum/controller/repository/roles/proc/legacy_job_by_type(type) as /datum/prototype/role/job
	return fetch_local_or_throw(type)

/**
 * Only returns /datum/prototype/role/job
 */
/datum/controller/repository/roles/proc/legacy_all_job_ids(filter_faction) as /list
	. = list()
	for(var/datum/prototype/role/job/r as anything in fetch_subtypes_immutable(/datum/prototype/role/job))
		. += r.id

/**
 * Only returns /datum/prototype/role/job
 */
/datum/controller/repository/roles/proc/legacy_all_job_types(filter_faction) as /list
	. = list()
	for(var/datum/prototype/role/job/r as anything in fetch_subtypes_immutable(/datum/prototype/role/job))
		. += r.type

/**
 * Only returns /datum/prototype/role/job
 */
/datum/controller/repository/roles/proc/legacy_all_job_titles(filter_faction) as /list
	. = list()
	for(var/datum/prototype/role/job/r as anything in fetch_subtypes_immutable(/datum/prototype/role/job))
		. += r.title

/**
 * Only returns /datum/prototype/role/job
 */
/datum/controller/repository/roles/proc/legacy_all_job_datums(filter_faction) as /list
	. = list()
	for(var/datum/prototype/role/job/r as anything in fetch_subtypes_immutable(/datum/prototype/role/job))
		. += r

/**
 * Only returns /datum/prototype/role/job
 */
/datum/controller/repository/roles/proc/legacy_all_sorted_job_datums(filter_faction) as /list
	. = legacy_all_job_datums(filter_faction)
	tim_sort(., /proc/cmp_job_datums)
