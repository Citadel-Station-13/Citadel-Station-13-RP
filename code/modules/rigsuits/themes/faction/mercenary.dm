//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * generic bad-or-maybe-bad guy suits
 */
/datum/rig_theme/mercenary
	abstract_type = /datum/rig_theme/mercenary
	// bye-bye security
	siemens_coefficient = 0.5

DECLARE_RIG_THEME(/mercenary/gorlex)
/datum/rig_theme/mercenary/gorlex
	abstract_type = /datum/rig_theme/mercenary/gorlex
	base_icon = 'icons/modules/rigsuits/suits/factions/military_gorlex.dmi'

DECLARE_RIG_THEME(/mercenary/gorlex/raider)
/datum/rig_theme/mercenary/gorlex/raider
	name = "nukeops rig"
	base_state = "syndicate"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "operator"
	visible_name = "Operator"
	#warn impl

	preset_additional_descriptors = list(
		/obj/item/rig_module/gun/energy_gun,
		/obj/item/rig_module/chem_injector,
		/obj/item/rig_module/resource_store/reagent_tank/single_router/advanced_meds,
		/obj/item/rig_module/basic/power_sink,
	)

DECLARE_RIG_THEME(/mercenary/gorlex/infiltrator)
/datum/rig_theme/mercenary/gorlex/infiltrator
	name = "contractor rig"
	base_state = "infiltrator"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "streamlined"
	visible_name = "Streamlined"
	#warn impl

	preset_additional_descriptors = list(
		/obj/item/rig_module/gun/energy_gun,
		/obj/item/rig_module/chem_injector,
		/obj/item/rig_module/resource_store/reagent_tank/single_router/advanced_meds,
		/obj/item/rig_module/basic/power_sink,
	)

DECLARE_RIG_THEME(/mercenary/gorlex/assault)
/datum/rig_theme/mercenary/gorlex/assault
	name = "elite nukeops rig"
	base_state = "elite"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "battle"
	visible_name = "Battle"
	#warn impl

	preset_additional_descriptors = list(
		/obj/item/rig_module/gun/energy_gun,
		/obj/item/rig_module/chem_injector,
		/obj/item/rig_module/resource_store/reagent_tank/single_router/advanced_meds,
		/obj/item/rig_module/basic/power_sink,
	)

DECLARE_RIG_THEME(/mercenary/marine)
/datum/rig_theme/mercenary/marine
	base_icon = 'icons/modules/rigsuits/suits/factions/military_marine.dmi'
	name = "marine rig"
	base_state = "marine"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "marine"
	visible_name = "Marine"
	control_sealed_append = ""
	#warn impl

	preset_additional_descriptors = list(
		/obj/item/rig_module/gun/energy_gun,
		/obj/item/rig_module/chem_injector,
		/obj/item/rig_module/resource_store/reagent_tank/single_router/advanced_meds,
		/obj/item/rig_module/basic/power_sink,
	)

/datum/armor/rigsuit/pmc
	melee = 0.45
	melee_tier = 4
	bullet = 0.325
	bullet_tier = 4
	laser = 0.35
	laser_tier = 4
	energy = 0.25
	bomb = 0.5
	bio = 1.0
	rad = 0.95
	fire = 0.7
	acid = 0.9

/datum/rig_theme/mercenary/pmc
	abstract_type = /datum/rig_theme/mercenary/pmc
	base_icon = 'icons/modules/rigsuits/suits/factions/military_pmc.dmi'
	armor = /datum/armor/rigsuit/pmc
	control_sealed_append = ""
	pieces = list(
		/datum/rig_theme_piece/helmet{
			worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_SKRELL);
		},
		/datum/rig_theme_piece/chestplate,
		/datum/rig_theme_piece/gloves{
			piece_base_state = "pmc";
		},
		/datum/rig_theme_piece/boots{
			piece_base_state = "pmc";
		},
	)

DECLARE_RIG_THEME(/mercenary/pmc/commander)
/datum/rig_theme/mercenary/pmc/commander
	name = "pmc commander rig"
	base_state = "commander"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "leader"
	visible_name = "Leader"
	#warn impl

	preset_additional_descriptors = list(
		/obj/item/rig_module/gun/energy_gun,
		/obj/item/rig_module/chem_injector,
		/obj/item/rig_module/resource_store/reagent_tank/single_router/basic_meds,
		/obj/item/rig_module/item_deploy/simple/toolset/engineering/full,
		/obj/item/rig_module/basic/power_sink,
	)

DECLARE_RIG_THEME(/mercenary/pmc/medic)
/datum/rig_theme/mercenary/pmc/medic
	name = "pmc medic rig"
	base_state = "medic"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "corpsman"
	visible_name = "Corpsman"
	#warn impl

	preset_additional_descriptors = list(
		/obj/item/rig_module/chem_injector,
		/obj/item/rig_module/resource_store/reagent_tank/single_router/advanced_meds,
		/obj/item/rig_module/basic/power_sink,
	)


DECLARE_RIG_THEME(/mercenary/pmc/engineer)
/datum/rig_theme/mercenary/pmc/engineer
	name = "pmc engineer rig"
	base_state = "engineer"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "sapper"
	visible_name = "Sapper"
	#warn impl

	preset_additional_descriptors = list(
		/obj/item/rig_module/chem_injector,
		/obj/item/rig_module/resource_store/reagent_tank/single_router/basic_meds,
		/obj/item/rig_module/basic/power_sink,
		/obj/item/rig_module/item_deploy/simple/toolset/engineering/industrial,
	)


DECLARE_RIG_THEME(/mercenary/pmc/security)
/datum/rig_theme/mercenary/pmc/security
	name = "pmc security rig"
	base_state = "security"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "officer"
	visible_name = "Officer"
	#warn impl

	preset_additional_descriptors = list(
		/obj/item/rig_module/gun/energy_gun,
		/obj/item/rig_module/chem_injector,
		/obj/item/rig_module/resource_store/reagent_tank/single_router/basic_meds,
		/obj/item/rig_module/basic/power_sink,
	)

DECLARE_RIG_THEME(/mercenary/sleek)
/datum/rig_theme/mercenary/sleek
	base_icon = 'icons/modules/rigsuits/suits/factions/military_sleek.dmi'
	name = "sleek combat rig"
	base_state = "sleek"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "combat"
	visible_name = "Combat"
	control_sealed_append = ""
	#warn impl

	preset_additional_descriptors = list(
		/obj/item/rig_module/gun/energy_gun,
		/obj/item/rig_module/chem_injector,
		/obj/item/rig_module/resource_store/reagent_tank/single_router/advanced_meds,
		/obj/item/rig_module/basic/power_sink,
	)
