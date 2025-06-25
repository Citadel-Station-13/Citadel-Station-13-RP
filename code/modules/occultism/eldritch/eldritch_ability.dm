//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/prototype/eldritch_ability
	/// our name
	var/name = "???"
	/// our interface desc
	var/desc = "An ability granted by the infinite plane."
	/// ability type to instance
	var/ability_type = /datum/ability/eldritch_ability

	/// ui icon
	var/ui_icon
	/// ui icon state
	var/ui_icon_state

/datum/prototype/eldritch_ability/proc/create_ability(datum/eldritch_holder/for_holder)
	return new ability_type(for_holder)

/datum/prototype/eldritch_ability/proc/ui_serialize_ability()
	var/serialized_icon = ui_icon && ui_icon_state ? icon2base64(icon(ui_icon, ui_icon_state)) : null
	return list(
		"id" = id,
		"name" = name,
		"desc" = desc,
		"iconAsBase64" = serialized_icon,
	)

/datum/ability/eldritch_ability
	category = "Eldritch"

	/// bound holder, if any
	var/datum/eldritch_holder/eldritch

	/// list of knowledge ids we were granted from
	/// * not serialized
	var/tmp/list/granted_from_knowledge_ids

/datum/ability/eldritch_ability/New(datum/eldritch_holder/bind_to_holder)
	if(bind_to_holder)
		src.eldritch = bind_to_holder

/datum/ability/eldritch_ability/proc/ui_serialize_ability_context()
	return list()
