//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * @params
 * * type - modal type
 * * actor - actor doing it
 * * status - (optional) override ui status with callback called with (mob/user, datum/tgui_input_modal/modal)
 * * params - additional args to pass to initialize()
 *
 * @return modal or null if failed to open
 */
/proc/open_tgui_actor_modal(type, datum/event_args/actor/actor, datum/callback/status, list/params)
	var/datum/tgui_actor_modal/modal_type = type
	if(modal_type.no_type_dupe)
		var/mob/initiator = actor.initiator
		var/trait = TRAIT_MOB_ACTOR_MODAL_INITIATOR(modal_type, actor.performer)
		if(HAS_TRAIT(initiator, trait))
			return

	var/datum/tgui_actor_modal/modal = new type(actor, status)

	if(modal.no_dupe_for_key)
		var/trait = TRAIT_MOB_ACTOR_MODAL_INITIATOR(modal_type.no_dupe_for_key, actor.performer)
		var/their_ref = ref(modal)
		if(HAS_TRAIT_NOT_FROM(initiator, trait, their_ref))
			qdel(modal)
			return

	if(!modal.initialize(arglist(params)))
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
	/// actor initiator-performer pair
	var/datum/event_args/actor/actor
	/// check to see if we can still do it; useful if we're remote controlling or something
	var/datum/callback/status
	/// only one type on initiator-performer pair, period
	/// * only checked for compile time value
	var/no_type_dupe = FALSE
	/// dedupe key; checked on and after New()
	var/no_dupe_for_key
	/// which tgui interface to open
	var/tgui_interface
	/// only initiator can access this ui; by default,
	/// we use always_state and initiator-only
	var/lock_to_initiator = TRUE

/datum/tgui_actor_modal/New(datum/event_args/actor/actor, datum/callback/status)
	var/mob/initiator = actor.initiator
	var/trait = TRAIT_MOB_ACTOR_MODAL_INITIATOR(type, actor.performer)
	ADD_TRAIT(initiator, trait, ref(src))
	if(src.no_dupe_for_key)
		var/trait = TRAIT_MOB_ACTOR_MODAL_INITIATOR(src.no_dupe_for_key, actor.performer)
		ADD_TRAIT(initiator, trait, ref(src))
	src.actor = actor
	src.status = status

/datum/tgui_actor_modal/Destroy()
	var/mob/initiator = actor.initiator
	var/trait = TRAIT_MOB_ACTOR_MODAL_INITIATOR(type, actor.performer)
	REMOVE_TRAIT(initiator, trait, ref(src))
	if(src.no_dupe_for_key)
		var/trait = TRAIT_MOB_ACTOR_MODAL_INITIATOR(src.no_dupe_for_key, actor.performer)
		REMOVE_TRAIT(initiator, trait, ref(src))
	actor = null
	status = null
	return ..()

/**
 * @return FALSE to reject opening
 */
/datum/tgui_actor_modal/proc/initialize()
	return TRUE

/datum/tgui_actor_modal/ui_state(mob/user)
	return GLOB.always_state

/datum/tgui_actor_modal/ui_status(mob/user, datum/ui_state/state)
	if(lock_to_initiator)
		if(user != actor.initiator)
			return UI_CLOSE
	var/status_override = status?.invoke_no_sleep(user, src)
	if(!isnull(status_override))
		return status_override
	return ..()

/datum/tgui_actor_modal/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, tgui_interface)
		ui.set_autoupdate(FALSE)
		ui.open()
	// cleanup if it didn't open
	spawn(2 SECONDS)
		if(!QDELETED(src) && !length(open_uis))
			qdel(src)

/datum/tgui_actor_modal/on_ui_close(mob/user, datum/tgui/ui, embedded)
	..()
	qdel(src)

/datum/tgui_actor_modal/on_ui_transfer(mob/old_mob, mob/new_mob, datum/tgui/ui, embedded)
	. = ..()
	// if we're transferring to a new mob, we need to update the trait ownership
	if(old_mob != new_mob)
		var/trait = TRAIT_MOB_ACTOR_MODAL_INITIATOR(type, actor.performer)
		REMOVE_TRAIT(old_mob, trait, ref(src))
		ADD_TRAIT(new_mob, trait, ref(src))
		if(src.no_dupe_for_key)
			var/dupe_trait = TRAIT_MOB_ACTOR_MODAL_INITIATOR(src.no_dupe_for_key, actor.performer)
			REMOVE_TRAIT(old_mob, dupe_trait, ref(src))
			ADD_TRAIT(new_mob, dupe_trait, ref(src))
