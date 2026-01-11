//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Organ in charge of handling all rig functionality for a protean.
 * * Technically, this is not protean-specific. If someone wanted to give a random human
 *   a deployable internal rig, this is how you do it.
 * * Organ handles all the needs of binding / modifying rig functions.
 * * The rig will always (for now) be wirelessly controllable by the organ's host.
 * * The can optionally allow the user to deploy themselves as the rig around someone else
 *   (yes protean suiting is now generalized)
 * * This can optionally allow the user to userless-deploy the rig as a drone.
 * * Internally, the subcore binds the rig with an unremoveable module.
 *   This does mean future expansion can share the code and/or allow for other shenanigans.
 * * The rig's controller is never deployed, neither to the host nor to others if it's
 *   a remote control situation. You are, pretty much, the rigsuit.
 * * Internally, the rig exists inside a person if it's suited around another, but not
 *   in their inventory.
 */
/obj/item/organ/internal/rig_subcore
	// TODO: biology rework
	robotic = ORGAN_ROBOT
	biology_type = BIOLOGY_TYPE_SYNTH

	/// rig theme; set to type or id to initialize
	var/datum/rig_theme/rig_theme = /datum/rig_theme/station/civilian/standard
	/// stored rig
	/// * this is nulled if the rig isn't in ourselves. we resolve our rig through
	///   the control binder module.
	var/obj/item/rig/rig_stored
	/// should the stored rig start with preset modules?
	var/rig_is_equipped = TRUE
	/// additional modules to mount into the rig
	var/list/rig_additional_module_descriptors
	/// control binder
	var/obj/item/rig_module/control_binder/rig_subcore/rig_binder

	/// allow user to rig-suit around someone (moving themselves into the suit in the process)
	/// * do not turn on other than for proteans, this is pretty much dangerously unpredictable
	///   due to how rig control API handles multi-user shenanigans. there's a reason
	///   AI control isn't added yet.
	/// * currently cannot be changed at runtime
	//  TODO: allow runtime modifications, modify how organ actions work to allow add/remove
	//        while inserted.
	var/allow_suit_around_other = FALSE
	/// allow userless deploy
	/// * currently cannot be changed at runtime
	//  TODO: allow runtime modifications, modify how organ actions work to allow add/remove
	//        while inserted.
	var/allow_suit_drone_mode = FALSE

/obj/item/organ/internal/rig_subcore/ensure_organ_actions_loaded()
	..()
	if(organ_actions && !islist(organ_actions))
		organ_actions = list(organ_actions)
	if(allow_suit_around_other)
		#warn action
	if(allow_suit_drone_mode)
		#warn action

/obj/item/organ/internal/rig_subcore/on_insert(mob/owner, initializing)
	. = ..()

/obj/item/organ/internal/rig_subcore/on_remove(mob/owner)
	. = ..()

/obj/item/organ/internal/rig_subcore/proc/create_rig_instance()

/obj/item/organ/internal/rig_subcore/proc/initialize_rig()



#warn impl

/obj/item/organ/internal/rig_subcore/protean
	rig_theme = /datum/rig_theme/species/protean
	allow_suit_around_other = TRUE
	allow_suit_drone_mode = FALSE
