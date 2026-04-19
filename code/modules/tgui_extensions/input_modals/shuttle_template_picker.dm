.//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Shuttle template picker.
 * * Used by anything that requires someone to pick a shuttle template.
 * * Not used by superuser-admin UIs to load shuttles, generally; they operate on their own thing.
 */
/datum/tgui_input_modal/shuttle_template_picker
	tgui_interface = "input_modal/ShuttleTemplatePicker"
	no_type_dupe = TRUE

	var/list/allowed_shuttle_ids = list()

/datum/tgui_input_modal/shuttle_template_picker/New(datum/event_args/actor/actor, datum/callback/validity, list/allowed_shuttle_ids)
	. = ..()
	if(allowed_shuttle_ids)
		src.allowed_shuttle_ids = allowed_shuttle_ids.Copy()

/datum/tgui_input_modal/shuttle_template_picker/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	var/list/encoded_templates = list()
	#warn impl

/datum/tgui_input_modal/shuttle_template_picker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)
		if("pick")
			var/shuttle_template_id = params["shuttleTemplateId"]
			if(!istext(shuttle_template_id))
				return TRUE
			var/datum/shuttle_template/target_template = SSshuttle.templates_by_id[shuttle_template_id]
			if(!target_template)
				return TRUE
			submit_result(target_template.id)
			qdel(src)
			return TRUE

#warn impl ui?
