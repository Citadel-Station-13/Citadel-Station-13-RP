//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * @params
 * * type - modal type
 * * user - the user
 * * validity - (optional) additional validity checks
 * * ... - additional args to pass to initialize()
 *
 * @return modal or null if failed to open
 */
/proc/open_tgui_input_modal(type, mob/user, datum/callback/validity, ...)
	#warn rework this logic . all of it. it's just a copy from actor modal.
	var/datum/tgui_input_modal/modal_type = type
	if(modal_type.no_type_dupe)
		var/mob/initiator = user
		var/trait = TRAIT_MOB_ACTOR_MODAL_INITIATOR(modal_type, initiator, user)
		if(HAS_TRAIT(initiator, trait))
			return
	var/datum/tgui_input_modal/modal = new type(user, validity)
	if(!modal.initialize(arglist(args.Copy(4))))
		qdel(modal)
		return
	modal.ui_interact(user)
	return modal

/**
 * generalized tgui modals with procs for checking things like activity
 * and validity
 *
 * * not to be confused with `/datum/admin_modal`; these have a specific
 *   user and target, usually
 * * these should be in `tgui/interfaces/input_modal` ideally.
 */
/datum/tgui_input_modal
	/// intended user
	var/mob/user
	/// check to see if we can still do it; useful if we're remote controlling or something
	var/datum/callback/validity
	/// only one type on initiator-performer pair, period
	/// * only checked for compile time value
	var/no_type_dupe = FALSE
	/// which tgui interface to open
	var/tgui_interface
	/// only initiator can access this ui; by default,
	/// we use always_state and initiator-only
	var/lock_to_initiator = TRUE

	var/result
	var/blocking_on_result = 0

/datum/tgui_input_modal/New(mob/user, datum/callback/validity)
	var/mob/initiator = user
	var/trait = TRAIT_MOB_ACTOR_MODAL_INITIATOR(type, initiator, user)
	ADD_TRAIT(initiator, trait, ref(src))
	src.user = user
	src.validity = validity

/datum/tgui_input_modal/Destroy()
	var/mob/initiator = user
	var/trait = TRAIT_MOB_ACTOR_MODAL_INITIATOR(type, initiator, user)
	REMOVE_TRAIT(initiator, trait, ref(src))
	user = null
	validity = null
	return ..()

/**
 * @return FALSE to reject opening
 */
/datum/tgui_input_modal/proc/initialize()
	return TRUE

/datum/tgui_input_modal/ui_state(mob/user)
	return GLOB.always_state

/datum/tgui_input_modal/ui_status(mob/user, datum/ui_state/state)
	if(lock_to_initiator)
		if(user != src.user)
			return UI_CLOSE
	return ..()

/datum/tgui_input_modal/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, tgui_interface)
		ui.set_autoupdate(FALSE)
		ui.open()
	// cleanup if it didn't open
	spawn(2 SECONDS)
		if(!QDELETED(src) && !length(open_uis))
			qdel(src)

/datum/tgui_input_modal/on_ui_close(mob/user, datum/tgui/ui, embedded)
	..()
	qdel(src)

/datum/tgui_input_modal/proc/submit_result(result)
	src.result = result
	qdel(src)
	if(!blocking_on_result)
		src.result = null

/datum/tgui_input_modal/proc/block_on_result(timeout = INFINITY)
	++blocking_on_result
	var/start_time = world.time
	UNTIL(result || (world.time > (start_time + timeout)) || QDELETED(src))
	--blocking_on_result
	. = result
	if(!blocking_on_result)
		// un-reference if nothing else needs it
		result = null
