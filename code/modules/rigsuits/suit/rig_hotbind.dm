//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Holds data on an available hotbind created on a rigsuit.
 * * Hotbinds are removed from the rig when a piece is removed; they are stored on the piece in the
 *   current architecture and 'projected' into the host rigsuit.
 * * Hotbinds are just action button bindings. They don't support things like input. Handle it
 *   on the module side.
 */
/datum/rig_hotbind
	/// parent module
	var/obj/item/rig_module/module
	/// data field; this is something set by the module creating the binding, generally.
	/// this is read by the module to know what this hotbind is supposed to do without
	/// having to separately implement subtypes of rig_hotbind everywhere.
	VAR_PROTECTED/bind_action
	/// see [bind_action]
	VAR_PROTECTED/list/bind_params
	/// action button
	var/datum/action/action

/datum/rig_hotbind/New(obj/item/rig_module/module, action, list/params)
	src.module = module
	set_bind_action_params(action, params)
	#warn add to module

/datum/rig_hotbind/Destroy()
	bind_action = bind_params = null
	#warn clear from module
	QDEL_NULL(action)
	return ..()

/datum/rig_hotbind/proc/request_action() as /datum/action


/datum/rig_hotbind/proc/on_invoke(datum/event_args/actor/actor)


/datum/rig_hotbind/proc/render_button_appearance()

/**
 * @params
 * * action - string
 * * params - list; everything in the list, recursively, must be clone()-able or a primitive.
 */
/datum/rig_hotbind/proc/set_bind_action_params(action, list/params)
	src.bind_action = action
	src.bind_params = deep_clone_list(params)


#warn impl
