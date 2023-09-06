//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/rig
	name = "rig control module"
	desc = "A control module for some kind of suit."

	//* Activation
	/// activation state
	var/activation_state = RIG_ACTIVATION_OFFLINE

	//* Appearance (Self)
	var/state_worn_sealed
	var/state_worn_unsealed
	var/state_sealed
	var/statE_unsealed

	//* Legacy - to be made into dynamic data once components/modules are done.
	var/datum/armor/suit_armor
	var/min_pressure_protect
	var/max_pressure_protect
	var/min_pressure_protect
	var/max_pressure_protect

	//* Pieces
	/// list of /datum/component/rig_piece's
	var/list/datum/component/rig_piece/piece_components
	/// direct access cache to the items held by those pieces
	var/list/obj/item/piece_items

	//* Theme
	/// default theme
	var/theme_initial = /datum/rig_theme/station/civilian/standard
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


/obj/item/rig/Initialize(mapload, datum/rig_theme/theme_like)
	. = ..()
	if(isnull(theme_like))
		theme_like = theme_initial
	if(ispath(theme_like))
		theme_initial = theme_like
	else
		init_theme(theme_like)

/obj/item/rig/Destroy()
	hard_reset()
	wipe_everything()
	return ..()

/obj/item/rig/proc/hard_reset()
	#warn get everything back inside and set activation to deactivated

/obj/item/rig/proc/wipe_everything()
	#warn impl
