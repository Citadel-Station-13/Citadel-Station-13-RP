//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/rig_theme/station/exploration
	abstract_type = /datum/rig_theme/station/exploration
	base_icon = 'icons/modules/rigsuits/suits/exploration.dmi'
	pieces = list(
		/datum/rig_theme_piece/helmet,
		/datum/rig_theme_piece/chestplate,
		/datum/rig_theme_piece/gloves,
		/datum/rig_theme_piece/boots{
			piece_base_state = "";
		},
	)
	control_base_state_worn = ""
	control_sealed_append = ""

AUTO_RIG_THEME(/station/exploration/standard)
/datum/rig_theme/station/exploration/standard
	name = "excursion rig"
	base_state = "explo"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "excursion"
	visible_name = "excursion"
	#warn impl

AUTO_RIG_THEME(/station/exploration/pathfinder)
/datum/rig_theme/station/exploration/pathfinder
	name = "pathfinder rig"
	base_state = "pf"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "pathfinder"
	visible_name = "pathfinder"
	control_base_state_worn = null
	#warn impl

AUTO_RIG_THEME(/station/exploration/medic)
/datum/rig_theme/station/exploration/medic
	name = "field medic rig"
	base_state = "medic"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "medic"
	visible_name = "medic"
	#warn impl

AUTO_RIG_THEME(/station/exploration/pilot)
/datum/rig_theme/station/exploration/pilot
	name = "pilot rig"
	base_state = "pilot"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "pilot"
	visible_name = "pilot"
	#warn impl
