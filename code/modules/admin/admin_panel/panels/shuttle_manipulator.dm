//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Shuttle manipulation panel
 *
 * * Allows high-level overview of all shuttles
 * * Allows opening a shuttle's controller
 * * Allows spawning and creating new shuttle templates
 */
/datum/admin_panel/shuttle_manipulator
	name = "Shuttle Manipulator"
	tgui_interface = "AdminShuttleManipulator"
	tgui_autoupdate = FALSE

#warn impl UI

/datum/admin_panel/shuttle_manipulator/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["shuttles"] = encode_shuttles()
	.["shuttleTemplates"] = encode_shuttle_templates()

/datum/admin_panel/shuttle_manipulator/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	var/datum/admins/admin_holder = usr.client.holder
	var/shuttle_id = params["shuttleId"]
	var/datum/shuttle/shuttle = shuttle_id && SSshuttle.shuttle_registry[shuttle_id]

	switch(action)
		if("openShuttleController")
			if(!shuttle)
				return TRUE
			admin_holder.open_admin_modal(/datum/admin_modal/shuttle_controller, shuttle)
			return TRUE
		if("refresh")
			push_shuttles()
			return TRUE
		if("reloadTemplates")
			// oh boy here comes the free fucking lag
			push_shuttle_templates()
			return TRUE
		if("instantiateTemplate")
			var/target_template_id = params["id"]
			if(!istext(target_template_id))
				return TRUE
			var/datum/shuttle_template/target_template = SSshuttle.templates_by_id[target_template_id]
			if(!target_template)
				return TRUE
			admin_holder.open_admin_modal(/datum/admin_modal/instantiate_shuttle_template, target_template)
			return TRUE
		if("uploadTemplate")
			admin_holder.open_admin_modal(/datum/admin_modal/upload_shuttle_template)
			return TRUE

/datum/admin_panel/shuttle_manipulator/proc/encode_shuttles()
	. = list()
	for(var/datum/shuttle/shuttle in SSshuttle.shuttle_registry)
		.[shuttle.id] = encode_shuttle(shuttle)

/datum/admin_panel/shuttle_manipulator/proc/encode_shuttle(datum/shuttle/shuttle)
	var/list/encoded_location = list(
		"coords" = null,
		"map" = null,
		"docked" = null,
	)
	if(shuttle.anchor)
		var/z_level = get_z(shuttle.anchor)
		encoded_location["coords"] = list(
			"x" = shuttle.anchor.x,
			"y" = shuttle.anchor.y,
			"z" = shuttle.anchor.z,
		)
		if(z_level)
			var/datum/map_level/level = SSmapping.ordered_levels[z_level]
			if(level?.parent_map)
				encoded_location["map"] = level.parent_map.name
	if(shuttle.docked)
		encoded_location["docked"] = shuttle.docked.name
	var/list/encoded = list(
		"id" = shuttle.id,
		"name" = shuttle.name,
		"desc" = shuttle.desc,
		"templateId" = shuttle.template.id,
		"location" = encoded_location,
	)
	return encoded

/datum/admin_panel/shuttle_manipulator/proc/push_shuttles()
	push_ui_data(data = list("shuttles" = encode_shuttles()))

/datum/admin_panel/shuttle_manipulator/proc/encode_shuttle_templates()
	. = list()
	for(var/datum/shuttle_template/template in SSshuttle.templates_by_id)
		.[template.id] = encode_shuttle_template(template)

/datum/admin_panel/shuttle_manipulator/proc/encode_shuttle_template(datum/shuttle_template/template)
	var/list/encoded = list(
		"id" = template.id,
		"name" = template.name,
		"desc" = template.desc,
		"display_name" = template.display_name,
		"fluff" = template.fluff,
		"category" = template.category,
		subcategory = template.subcategory,
	)
	return encoded

/datum/admin_panel/shuttle_manipulator/proc/push_shuttle_templates()
	push_ui_data(data = list("shuttleTemplates" = encode_shuttle_templates()))
