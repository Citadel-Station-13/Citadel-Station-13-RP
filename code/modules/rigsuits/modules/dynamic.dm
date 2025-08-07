//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// TODO: file unticked for now, we need to figure this out later.

/**
 * 'Dynamic' modules
 *
 * These allow for a custom schema-list definition for the UI, so that the implementor doesn't
 * have to write their own TGUI templates.
 */
/obj/item/rig_module/dynamic
	tgui_interface = "Dynamic"
	#warn impl

	/// by type
	var/static/list/cached_schema_by_type = list()
	/// our schema, set on new
	var/datum/rig_dynamic_schema/schema

/obj/item/rig_module/dynamic/Initialize(mapload)
	if(isnull(schema))
		schema = get_schema()
	return ..()

/obj/item/rig_module/dynamic/proc/get_schema()
	if(isnull(cached_schema_by_type[type]))
		var/datum/rig_dynamic_schema/schema = new
		construct_schema(schema)
		schema.compile()
		cached_schema_by_type = schema
	return cached_schema_by_type[type]

/obj/item/rig_module/dynamic/proc/construct_schema(datum/rig_dynamic_schema/schema)
	return TRUE

/obj/item/rig_module/dynamic/proc/config_adjust()
	#warn impl

/obj/item/rig_module/dynamic/proc/action_trigger()
	#warn impl

/obj/item/rig_module/dynamic/rig_static_data()
	. = ..()
	.["schema"] = schema.schema_data()

#warn impl all

/**
 * schema for ui
 */
/datum/rig_dynamic_schema
	/// storage list
	var/list/fragments = list()
	/// constraint / data list for key
	var/list/config = list()
	/// buttons left in section
	var/section_remaining = 0

/datum/rig_dynamic_schema/proc/schema_data()
	return list(
		"fragments" = fragments,
		"config" = config,
	)

/datum/rig_dynamic_schema/proc/compile()
	. = FALSE
	ASSERT(!section_remaining)
	return TRUE

/datum/rig_dynamic_schema/proc/validate_config_input(key, value)
	var/list/data = config[key]
	if(isnull(data))
		return null
	switch(data["type"])
		if("toggle")
			return !!value
		if("number")
			return round(clamp(value, data["min"], data["max"]), data["round"])
		if("string")
			. = copytext_char(value, 1, data["maxLength"] + 1)
			if(data["alphanumeric"])
				. = string_filter_to_alphanumeric(.)

/datum/rig_dynamic_schema/proc/with_config_toggle(name = "Option", key = "?")
	config[++config.len] = list(
		"key" = key,
		"name" = name,
		"type" = "toggle",
	)

/datum/rig_dynamic_schema/proc/with_config_number(name = "Option", key = "?", min = -INFINITY, max = INFINITY, round_to = null)
	config[++config.len] = list(
		"key" = key,
		"name" = name,
		"type" = "number",
		"min" = min,
		"max" = max,
		"round" = round_to,
	)

/datum/rig_dynamic_schema/proc/with_config_string(name = "Option", key = "?", max_length = 32, alphanumeric_only = FALSE)
	config[++config.len] = list(
		"key" = key,
		"name" = name,
		"type" = "string",
		"maxLength" = max_length,
		"alphanumeric" = alphanumeric_only,
	)

/datum/rig_dynamic_schema/proc/with_action(name = "Action", key = "?", icon = null, confirm = FALSE, bindable = FALSE, confirm_text = null, confirm_icon = null)
	var/list/action = list(
		"name" = name,
		"key" = key,
		"icon" = icon,
		"confirm" = confirm,
		"bindable" = bindable,
		"confirmText" = confirm_text,
		"confirmIcon" = confirm_icon,
	)
	if(section_remaining)
		var/list/actions = fragments[fragments.len]["actions"]
		actions.Add(action)
		--section_remaining
	else
		fragments[++fragments.len] = action

/datum/rig_dynamic_schema/proc/create_section(number_of_actions = 3)
	ASSERT(!section_remaining)
	section_remaining = number_of_actions
	fragments[++fragments.len] = list(
		"type" = "section",
		"actions" = list(),
	)
