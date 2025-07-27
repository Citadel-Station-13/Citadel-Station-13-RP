//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * abstract superholder for all research data
 */
/datum/research_data
	var/datum/research_data_fabricator/r_fabricator_data
	var/datum/research_data_techweb/r_techweb_data

#warn impl

/**
 * Get a list of designs we provide, associated to number of times it's duplicated.
 */
/datum/research_data/proc/compute_projected_designs() as /alist
	#warn impl
