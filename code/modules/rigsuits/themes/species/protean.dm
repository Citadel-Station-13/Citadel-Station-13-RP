//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

DECLARE_RIG_THEME(/species/protean)
/datum/rig_theme/species/protean
	name = "protean rig"
	base_icon = 'icons/modules/rigsuits/suits/species/protean.dmi'
	base_state = "nanosuit"
	desc = "A sleek, form-fitting hardsuit made out of some kind of alloy."
	fluff_desc = "Unlike other hardsuits, this one is missing the usual seams, bolts, and reinforcements. \
	Its motions are unnaturally fluid - the internals are likely not made out of the usual mechanisms."
	display_name = "Nanocluster"
	visible_name = "Sleek"
	insulated_gloves = TRUE
	siemens_coefficient = 0.75
	armor = /datum/armor/rigsuit/species/protean
	#warn encumbrance

	preset_jetpack_type = /obj/item/rig_module/locomotion/jetpack/gas/ion
	preset_additional_descriptors = list(
		/obj/item/rig_module/item_deploy/simple/toolset/engineering/industrial,
		/obj/item/rig_module/basic/power_sink,
	)

/datum/armor/rigsuit/species/protean
	melee = 0.3
	melee_tier = 3
	melee_soak = 0
	melee_deflect = 5
	bullet = 0.2
	bullet_tier = 3
	bullet_soak = 0
	bullet_deflect = 5
	laser = 0.3
	laser_tier = 3
	laser_soak = 3
	laser_deflect = 0
	energy = 0.225
	bomb = 0.3
	bio = 1.0
	rad = 0.75
	fire = 1.0
	acid = 1.0
