//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/rig
	name = "rig control module"
	desc = "A control module for some kind of suit."

	//* Activation
	/// activation state
	var/activation_state = RIG_ACTIVATION_OFFLINE

	//* Pieces
	/// list of /datum/component/rig_piece's
	var/list/datum/component/rig_piece/piece_components
	/// direct access cache to the items held by those pieces
	var/list/obj/item/piece_items

	//* Theme
	/// The theme we're using - set to path to load at init
	var/datum/rig_theme/theme
	/// Is our theme initialized?
	var/theme_initialized = FALSE

	//* UI
	/// update timerid
	var/ui_queued_timer
	/// core systems awaiting update
	var/ui_queued_general = FALSE
	/// piece + component + module list awaiting update
	var/ui_queued_reflists = FALSE
	/// such a big change has happened that everything is queued
	var/ui_queued_everything = FALSE
	/// pieces awaiting update
	var/list/datum/component/rig_piece/ui_queued_pieces
	/// components awaiting update
	var/list/obj/item/rig_component/ui_queued_components
	/// modules awaiting update
	var/list/obj/item/rig_module/ui_queued_modules

	//* Wearer
	/// Our wearer
	var/mob/wearer

#warn impl all


/obj/item/rig/proc/hard_reset()
	#warn get everything back inside and set activation to deactivated
