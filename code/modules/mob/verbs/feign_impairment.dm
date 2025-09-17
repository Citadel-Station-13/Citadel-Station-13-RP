//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

GLOBAL_LIST_INIT(feign_impairment_types, init_feign_impairment_types())

/proc/init_feign_impairment_types()
	. = list()
	var/list/component_collision_check = list()
	for(var/datum/feign_impairment/path as anything in subtypesof(/datum/feign_impairment))
		if(initial(path.abstract_type) == path)
			continue
		var/datum/feign_impairment/instance = new path
		if(component_collision_check[instance.component_type])
			stack_trace("collision between [component_collision_check[instance.component_type]:type] and [instance.type] on component type [instance.component_type]")
			continue
		component_collision_check[instance.component_type] = instance
		.[path] = instance

// todo: this is better than the old, but still a dumpster fire. impairments
//       need to be datums so we can have a single tracking system
//       and a single /datum/component/mob_feign_impairment
//       to track everything, instead of this crap.

/datum/feign_impairment
	abstract_type = /datum/feign_impairment
	var/name
	var/adjective
	var/component_type
	var/power_min = 0
	var/power_max = 0

/datum/feign_impairment/slurring
	name = "Slurring"
	adjective = "slurring"
	component_type = /datum/component/mob_feign_impairment/slurring
	power_min = 10
	power_max = 500

/datum/feign_impairment/stutter
	name = "Stuttering"
	adjective = "stuttering"
	component_type = /datum/component/mob_feign_impairment/stutter
	power_min = 10
	power_max = 500

/datum/feign_impairment/jitter
	name = "Jittering"
	adjective = "jittering"
	component_type = /datum/component/mob_feign_impairment/jitter
	power_min = 10
	power_max = 2000

// todo: DECLARE_MOB_VERB
/mob/verb/feign_impairment()
	set name = "Feign Impairment"
	set category = VERB_CATEGORY_IC
	set desc = "Pretend like you're slurring, stuttering, jittering, and more."

	var/list/name_to_type = list()
	for(var/datum/feign_impairment/path as anything in subtypesof(/datum/feign_impairment))
		if(initial(path.abstract_type) == path)
			continue
		var/is_active = impairments_feigned?[path]
		name_to_type["[initial(path.name)] (Currently: [is_active ? "Active" : "Inactive"])"] = path

	var/choice = tgui_input_list(src, "Choose an impairment to toggle.", "Feign Impairment", name_to_type)
	if(!choice)
		return

	var/path = name_to_type[choice]
	var/new_active = !impairments_feigned?[path]
	var/datum/feign_impairment/impairment = GLOB.feign_impairment_types[path]

	var/power

	if(new_active)
		if(GetComponent(impairment.component_type))
			to_chat(src, SPAN_WARNING("You are already pretending to be [impairment.adjective]."))
			return
		power = tgui_input_number(
			src,
			"What power? ([impairment.power_min] - [impairment.power_max])",
			"Feign Impairment",
			impairment.power_min,
			impairment.power_max,
			impairment.power_min,
			round_value = TRUE,
		)
	else
		if(!GetComponent(impairment.component_type))
			return

	// todo: better logging
	log_game("[key_name(src)] toggled [impairment] to [new_active ?"on, with power [power]" : "off"]")

	if(new_active)
		AddComponent(impairment.component_type, power)
	else
		qdel(GetComponent(impairment.component_type))

	to_chat(src, SPAN_NOTICE("You are now <b>[new_active ? "pretending" : "no longer pretending"]</b> to be [impairment.adjective]. This will be automatically reset should you lose consciousness."))

/mob/proc/clear_feign_impairment()
	QDEL_LIST_ASSOC_VAL(impairments_feigned)
	impairments_feigned = null
