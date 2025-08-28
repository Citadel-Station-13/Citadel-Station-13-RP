//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/rig_theme/station/engineering
	abstract_type = /datum/rig_theme/station/engineering
	base_icon = 'icons/modules/rigsuits/suits/engineering.dmi'
	armor = /datum/armor/rigsuit/station/engineering
	siemens_coefficient = 0.7

/datum/armor/rigsuit/station/engineering
	melee = 0.25
	melee_tier = 3
	melee_soak = 0
	melee_deflect = 5
	bullet = 0.15
	bullet_tier = 2
	bullet_soak = 0
	bullet_deflect = 0
	laser = 0.3
	laser_tier = 3
	laser_soak = 5
	laser_deflect = 0
	energy = 0.25
	bomb = 0.4
	bio = 1.0
	rad = 0.65
	fire = 0.75
	acid = 1.0

DECLARE_RIG_THEME(/station/engineering/standard)
/datum/rig_theme/station/engineering/standard
	name = "engineering rig"
	base_state = "engineering"
	desc = "A sleek suit used by corporate engineers."
	fluff_desc = "Originally an Aether Atmospherics & Recycling design, this sleek suit was 'appropriated' by \
	the Nanotrasen triad early into the corporate space race. While royalties are still paid to a marginal degree, \
	the designs for this suit has long been disseminated to many different benefactors - and elements of its \
	design can be seen in the internals of many similar voidsuits to this day."
	display_name = "engineering"
	visible_name = "Engineering"
	max_pressure_protect = ONE_ATMOSPHERE * 15
	max_temperature_protect = HEAT_PROTECTION_INDUSTRIAL_VOIDSUIT
	armor = /datum/armor/rigsuit/station/engineering/standard
	#warn encumbrance

	preset_additional_descriptors = list(
		/obj/item/rig_module/item_deploy/simple/engineering/industrial,
		/obj/item/rig_module/item_mount/single/pickaxe/plasma_cutter,
	)

/datum/armor/rigsuit/station/engineering/standard
	rad = 0.8

DECLARE_RIG_THEME(/station/engineering/atmospherics)
/datum/rig_theme/station/engineering/atmospherics
	name = "atmospherics rig"
	base_state = "atmospheric"
	desc = "A modified engineering suit sacrificing some degree of plating for enhanced atmospheric shielding"
	fluff_desc = "A modified version of the popular technician suits from AAR, this is used by industrial \
	life-support maintainers for those especially heated problems."
	display_name = "atmospherics"
	visible_name = "Atmospherics"
	max_pressure_protect = ONE_ATMOSPHERE * 20
	max_temperature_protect = HEAT_PROTECTION_ATMOS_VOIDSUIT
	armor = /datum/armor/rigsuit/station/engineering/atmospherics
	#warn encumbrance

	preset_jetpack_type = /obj/item/rig_module/locomotion/jetpack/gas/ion
	preset_additional_descriptors = list(
		/obj/item/rig_module/item_deploy/simple/engineering/industrial,
	)

/datum/armor/rigsuit/station/engineering/atmospherics
	fire = 1.0
	rad = 0.45

DECLARE_RIG_THEME(/station/engineering/advanced)
/datum/rig_theme/station/engineering/advanced
	name = "advanced rig"
	base_state = "advanced"
	desc = "A sleek, shiny, and obnoxiously expensive hardsuit used by high-end corporate engineers."
	fluff_desc = "The popular AAR technician suit modified by Hephaestus Industries, and given an once-over \
	by Nanotrasen for a more welcoming paintjob. This suit packs enhanced shielding, plating, and everything \
	in-between - though it tends to be more power-hungry than similar suits, thanks to the similarly 'enhanced' weight."
	display_name = "advanced"
	visible_name = "Advanced"
	max_pressure_protect = ONE_ATMOSPHERE * 20
	max_temperature_protect = HEAT_PROTECTION_ATMOS_VOIDSUIT
	armor = /datum/armor/rigsuit/station/engineering/advanced
	#warn encumbrance

	preset_jetpack_type = /obj/item/rig_module/locomotion/jetpack/gas/ion
	preset_additional_descriptors = list(
		/obj/item/rig_module/item_deploy/simple/engineering/industrial,
		/obj/item/rig_module/item_mount/single/pickaxe/plasma_cutter,
	)

/datum/armor/rigsuit/station/engineering/advanced
	fire = 1.0
	rad = 0.85
	melee = 0.3
	bullet_tier = 3
	laser_deflect = 5
