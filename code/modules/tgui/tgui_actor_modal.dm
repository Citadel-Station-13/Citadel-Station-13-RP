//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/proc/open_tgui_actor_modal(modal_type, datum/event_args/actor/actor, modal_timeout, datum/modal_target)
	var/datum/tgui_actor_modal/modal = new modal_type(actor, modal_timeout, modal_target)
	if(!modal.initialize())
		qdel(modal)
		return
	modal.ui_interact(actor.initiator)
	return modal

/**
 * generalized tgui modals with procs for checking things like activity
 * and validity
 *
 * * not to be confused with `/datum/admin_modal`; these have a specific
 *   user and target, usually
 * * these should be in `tgui/interfaces/actor_modal` ideally.
 */
/datum/tgui_actor_modal
	var/datum/event_args/actor/actor
	var/timeout
	var/datum/target

#warn impl


/datum/tgui_actor_modal/New(datum/event_args/actor/actor, timeout, datum/target)

/datum/tgui_actor_modal/Destroy()
	cleanup()
	actor = null
	timeout = null
	target = null
	return ..()

/**
 * @return FALSE to reject opening
 */
/datum/tgui_actor_modal/proc/initialize()

/datum/tgui_actor_modal/proc/cleanup()


