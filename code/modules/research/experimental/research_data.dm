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

/datum/research_data/clone()
	var/datum/research_data/cloned = new
	cloned.set_r_fabricator_data(r_fabricator_data?.clone())
	cloned.set_r_techweb_data(r_techweb_data?.clone())
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

/datum/research_data/proc/create_r_fabricator_data()
	set_r_fabricator_data(new /datum/research_data_fabricator)

/datum/research_data/proc/set_r_fabricator_data(datum/research_data_fabricator/new_holder)
	if(r_fabricator_data)
		unset_r_fabricator_data()
	r_fabricator_data = new_holder

/datum/research_data/proc/unset_r_fabricator_data()
	if(!r_fabricator_data)
		return
	r_fabricator_data = null

/datum/research_data/proc/create_r_techweb_data()
	set_r_techweb_data(new /datum/research_data_techweb)

/datum/research_data/proc/set_r_techweb_data(datum/research_data_fabricator/new_holder)
	var/list/datum/prototype/techweb_node/old_nodes = list()
	if(r_techweb_data)
		old_nodes = r_techweb_data.nodes
		unset_r_techweb_data()
	var/list/datum/prototype/techweb_node/new_nodes = list()
	if(new_holder)
		r_techweb_data = new_holder
		new_nodes = r_techweb_data.nodes
		RegisterSignal(new_holder, COMSIG_RESEARCH_DATA_TECHWEB_MODIFIED, PROC_REF(on_r_techweb_modified))
	var/list/datum/prototype/techweb_node/added_nodes = new_nodes - old_nodes
	var/list/datum/prototype/techweb_node/removed_nodes = old_nodes - new_nodes
	SEND_SIGNAL(src, COMSIG_RESEARCH_DATA_TECHWEB_MODIFIED, added_nodes, removed_nodes)

/datum/research_data/proc/unset_r_techweb_data()
	if(!r_techweb_data)
		return
	UnregisterSignal(r_techweb_data, COMSIG_RESEARCH_DATA_TECHWEB_MODIFIED)
	r_techweb_data = null

/datum/research_data/proc/on_r_techweb_modified(datum/source, list/datum/prototype/techweb_node/added, list/datum/prototype/techweb_node/removed)
	// relay signal up
	SEND_SIGNAL(src, COMSIG_RESEARCH_DATA_TECHWEB_MODIFIED, added, removed)

/datum/research_data/nt_default

/datum/research_data/nt_default/New()
	create_r_fabricator_data()
	create_r_techweb_data()
	..()
	var/list/datum/prototype/techweb_node/auto_learn = list()
	auto_learn += RStechweb_nodes.fetch_subtypes_immutable(/datum/prototype/techweb_node/faction_intrinsic/nanotrasen)
	auto_learn += RStechweb_nodes.fetch_subtypes_immutable(/datum/prototype/techweb_node/spacer_intrinsic)

	for(var/datum/prototype/techweb_node/auto_learning as anything in auto_learn)
		r_techweb_data.unlock_node(auto_learn)
