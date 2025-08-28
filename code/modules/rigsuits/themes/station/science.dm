//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/rig_theme/station/science
	abstract_type = /datum/rig_theme/station/science
	base_icon = 'icons/modules/rigsuits/suits/science.dmi'

DECLARE_RIG_THEME(/station/science/standard)
/datum/rig_theme/station/science/standard
	name = "prototype rig"
	base_state = "prototype"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "prototype"
	visible_name = "Prototype"
	#warn impl

	preset_additional_descriptors = list(
		/obj/item/rig_module/item_mount/single/pickaxe/drill,
		/obj/item/rig_module/item_deploy/simple/xenoarch_toolset,
	)

DECLARE_RIG_THEME(/station/science/anomaly)
/datum/rig_theme/station/science/anomaly
	name = "anomaly rig"
	base_state = "apocryphal"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "AMI"
	visible_name = "AMI"
	#warn impl

	preset_jetpack_type = /obj/item/rig_module/locomotion/jetpack/gas/ion
	preset_additional_descriptors = list(
		/obj/item/rig_module/item_mount/single/pickaxe/plasma_cutter,
		/obj/item/rig_module/item_mount/single/pickaxe/drill,
		/obj/item/rig_module/item_deploy/simple/xenoarch_toolset,
	)
