//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * abstract superholder for all research data
 */
/datum/research_data
	/// * Nullable, if we don't support this.
	var/datum/research_data_fabricator/r_fabricator_data
	/// * Nullable, if we don't support this.
	var/datum/research_data_techweb/r_techweb_data

/**
 * Get a list of designs we provide, associated to number of times it's duplicated.
 */
/datum/research_data/proc/compute_projected_designs() as /list
	. = list()
	var/list/techweb_out = r_techweb_data?.compute_projected_designs()
	for(var/datum/prototype/techweb_node/node in techweb_out)
		.[node] += techweb_out[node]

/datum/research_data/clone()
	var/datum/research_data/cloned = new
	cloned.r_fabricator_data = r_fabricator_data?.clone()
	cloned.r_techweb_data = r_techweb_data?.clone()
	return cloned

/datum/research_data/serialize()
	. = list()
	if(r_fabricator_data)
		.["r_fabricator"] = r_fabricator_data.serialize()
	if(r_techweb_data)
		.["r_techweb"] = r_techweb_data.serialize()

/datum/research_data/deserialize(list/data)
	if(data["r_fabricator"])
		var/datum/research_data_fabricator/deserialized_fabricator_data = new
		deserialized_fabricator_data.deserialize(data["r_fabricator"])
		r_fabricator_data = deserialized_fabricator_data
	if(data["r_techweb"])
		var/datum/research_data_techweb/deserialized_techweb_data = new
		deserialized_techweb_data.deserialize(data["r_techweb"])
		r_techweb_data = deserialized_techweb_data

/datum/research_data/nt_default

/datum/research_data/nt_default/New()
	r_fabricator_data = new
	r_techweb_data = new
	..()
	var/list/datum/prototype/techweb_node/auto_learn = list()
	auto_learn += RStechweb_nodes.fetch_subtypes_immutable(/datum/prototype/techweb_node/faction_intrinsic/nanotrasen)
	auto_learn += RStechweb_nodes.fetch_subtypes_immutable(/datum/prototype/techweb_node/spacer_intrinsic)

	for(var/datum/prototype/techweb_node/auto_learning as anything in auto_learn)
		r_techweb_data.unlock_node(auto_learn)
