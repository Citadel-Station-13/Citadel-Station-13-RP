//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/rig_theme/nanotrasen
	abstract_type = /datum/rig_theme/nanotrasen

/datum/rig_theme/nanotrasen/asset_protection
	name = "deathsquad rig"
	base_state = "deathsquad"
	base_icon = 'icons/modules/rigsuits/suits/factions/nanotrasen_military.dmi'
	display_name = "asset protection"
	visible_name = "Asset Protection"
	control_sealed_append = ""
	desc = "TBD"
	fluff_desc = "TBD"
	#warn impl

/datum/rig_theme/nanotrasen/officer
	name = "centcom rig"
	base_state = "responsory"
	base_icon = 'icons/modules/rigsuits/suits/factions/nanotrasen.dmi'
	display_name = "officer"
	visible_name = "Officer"
	control_sealed_append = ""
	desc = "TBD"
	fluff_desc = "TBD"
	#warn impl

/datum/rig_theme/nanotrasen/inquisition
	name = "inquisition rig"
	base_state = "inquisitory"
	base_icon = 'icons/modules/rigsuits/suits/factions/nanotrasen.dmi'
	display_name = "pmd"
	visible_name = "PMD"
	control_sealed_append = ""
	desc = "TBD"
	fluff_desc = "TBD"
	#warn impl


/datum/rig_theme/nanotrasen/response
	abstract_type = /datum/rig_theme/nanotrasen/response
	control_sealed_append = ""

/datum/rig_theme/nanotrasen/response/commander
	name = "ert commander rig"
	base_state = "commander"
	base_icon = 'icons/modules/rigsuits/suits/factions/nanotrasen_response.dmi'
	display_name = "command"
	visible_name = "Command"
	control_sealed_append = ""
	desc = "TBD"
	fluff_desc = "TBD"
	#warn impl

/datum/rig_theme/nanotrasen/response/medic
	name = "ert medic rig"
	base_state = "medic"
	base_icon = 'icons/modules/rigsuits/suits/factions/nanotrasen_response.dmi'
	display_name = "rescue"
	visible_name = "Rescue"
	control_sealed_append = ""
	desc = "TBD"
	fluff_desc = "TBD"
	#warn impl

/datum/rig_theme/nanotrasen/response/engineer
	name = "ert engineer rig"
	base_state = "engineer"
	base_icon = 'icons/modules/rigsuits/suits/factions/nanotrasen_response.dmi'
	display_name = "engineering"
	visible_name = "Engineering"
	control_sealed_append = ""
	desc = "TBD"
	fluff_desc = "TBD"
	#warn impl

/datum/rig_theme/nanotrasen/response/security
	name = "ert security rig"
	base_state = "security"
	base_icon = 'icons/modules/rigsuits/suits/factions/nanotrasen_response.dmi'
	display_name = "officer"
	visible_name = "Officer"
	control_sealed_append = ""
	desc = "TBD"
	fluff_desc = "TBD"
	#warn impl
