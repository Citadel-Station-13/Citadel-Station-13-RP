//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * generic bad-or-maybe-bad guy suits
 */
/datum/rig_theme/mercenary
	abstract_type = /datum/rig_theme/mercenary
	// bye-bye security
	siemens_coefficient = 0.5

AUTO_RIG_THEME(/mercenary/gorlex)
/datum/rig_theme/mercenary/gorlex
	abstract_type = /datum/rig_theme/mercenary/gorlex
	base_icon = 'icons/modules/rigsuits/suits/factions/military_gorlex.dmi'

AUTO_RIG_THEME(/mercenary/gorlex_raider)
/datum/rig_theme/mercenary/gorlex_raider
	name = "nukeops rig"
	base_state = "syndicate"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "operator"
	visible_name = "Operator"
	#warn impl

AUTO_RIG_THEME(/mercenary/gorlex_infiltrator)
/datum/rig_theme/mercenary/gorlex_infiltrator
	name = "contractor rig"
	base_state = "infiltrator"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "streamlined"
	visible_name = "Streamlined"
	#warn impl

AUTO_RIG_THEME(/mercenary/gorlex_assault)
/datum/rig_theme/mercenary/gorlex_assault
	name = "elite nukeops rig"
	base_state = "elite"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "battle"
	visible_name = "Battle"
	#warn impl

AUTO_RIG_THEME(/mercenary/marine)
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

/datum/rig_theme/mercenary/pmc
	abstract_type = /datum/rig_theme/mercenary/pmc
	base_icon = 'icons/modules/rigsuits/suits/factions/military_pmc.dmi'
	control_sealed_append = ""
	pieces = list(
		/datum/rig_piece/helmet{
			worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_SKRELL);
		},
		/datum/rig_piece/chestplate,
		/datum/rig_piece/gloves{
			piece_base_state = "pmc";
		},
		/datum/rig_piece/boots{
			piece_base_state = "pmc";
		},
	)

AUTO_RIG_THEME(/mercenary/pmc/commander)
/datum/rig_theme/mercenary/pmc/commander
	name = "pmc commander rig"
	base_state = "commander"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "leader"
	visible_name = "Leader"
	#warn impl

AUTO_RIG_THEME(/mercenary/pmc/medic)
/datum/rig_theme/mercenary/pmc/medic
	name = "pmc medic rig"
	base_state = "medic"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "corpsman"
	visible_name = "Corpsman"
	#warn impl


AUTO_RIG_THEME(/mercenary/pmc/engineer)
/datum/rig_theme/mercenary/pmc/engineer
	name = "pmc engineer rig"
	base_state = "engineer"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "sapper"
	visible_name = "Sapper"
	#warn impl


AUTO_RIG_THEME(/mercenary/pmc/security)
/datum/rig_theme/mercenary/pmc/security
	name = "pmc security rig"
	base_state = "security"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "officer"
	visible_name = "Officer"
	#warn impl

AUTO_RIG_THEME(/mercenary/sleek)
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
