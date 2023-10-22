//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* WELCOME TO THE SEVENTH CIRCLE OF WEBDEV HELL
/// For efficiency, rigs will internally track and cache what needs to update.
/// We heavily abuse the TGUI modules system to selectively update data
/// with the module system's 2-deep reducer.

/obj/item/rig/proc/ui_queue()
	#warn impl

/obj/item/rig/proc/ui_queue_piece(datum/component/rig_piece/piece)
	#warn impl

/obj/item/rig/proc/ui_queue_component(obj/item/rig_component/component)
	CRASH("not implemented")

/obj/item/rig/proc/ui_queue_module(obj/item/rig_module/module)
	CRASH("not implemented")

/obj/item/rig/proc/ui_queue_reflists()
	#warn impl

/obj/item/rig/proc/ui_queue_everything()
	#warn impl

/obj/item/rig/proc/ui_flush()
	#warn impl


#warn impl all

/obj/item/rig/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/obj/item/rig/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/obj/item/rig/ui_module_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/obj/item/rig/ui_module_static(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/obj/item/rig/ui_module_act(action, list/params, datum/tgui/ui, id)
	. = ..()

/obj/item/rig/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/obj/item/rig/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/obj/item/rig/ui_state(mob/user, datum/tgui_module/module)
	// give always state because we manually override all of this in ui_status
	return GLOB.always_state

/obj/item/rig/ui_status(mob/user, datum/ui_state/state, datum/tgui_module/module)
	// "guys, I swear I have a reason to reimplement all of this"
	// rigs use a very complicated status system so things like AI control can be done
	// it'd be a better idea to use state datums but i don't care

	// if they're admin abusing, give full control
	if(is_admin_interactive(user, src))
		return UI_INTERACTIVE

	// check if they should be able to view
	var/can_observe = isobserver(user) && user.client?.roughly_within_render_distance(src)

	#warn impl - default state behaviors

/*
	var/src_object = ui_host(user)
	. = UI_CLOSE
	if(!state)
		return

	if(isobserver(user))
		// If they turn on ghost AI control, admins can always interact.
		if(IsAdminGhost(user))
			. = max(., UI_INTERACTIVE)

		// Regular ghosts can always at least view if in range.
		if(user.client)
			// todo: in view range for zooming
			if(get_dist(src_object, user) < max(CEILING(user.client.current_viewport_width / 2, 1), CEILING(user.client.current_viewport_height / 2, 1)))
				. = max(., UI_UPDATE)

	// Check if the state allows interaction
	var/result = state.can_use_topic(src_object, user)
	. = max(., result)
*/w
