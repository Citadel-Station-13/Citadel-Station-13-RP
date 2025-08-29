//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/rig_theme/station/security
	abstract_type = /datum/rig_theme/station/security
	base_icon = 'icons/modules/rigsuits/suits/security.dmi'
	// combat rigs
	siemens_coefficient = 0.65

DECLARE_RIG_THEME(/station/security/standard)
/datum/rig_theme/station/security/standard
	name = "security rig"
	base_state = "security"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "security"
	visible_name = "Security"
	#warn impl

	preset_additional_descriptors = list(
		/obj/item/rig_module/launcher/grenade/container/loaded/combat,
		/obj/item/rig_module/gun/taser,
	)

DECLARE_RIG_THEME(/station/security/)
/datum/rig_theme/station/security/safeguard
	name = "safeguard rig"
	base_state = "safeguard"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "safeguard"
	visible_name = "Safeguard"
	#warn impl

	preset_additional_descriptors = list(
		/obj/item/rig_module/launcher/grenade/container/loaded/combat,
		/obj/item/rig_module/gun/energy_gun,
	)
