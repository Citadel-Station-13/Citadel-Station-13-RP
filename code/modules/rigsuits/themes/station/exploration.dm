//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/rig_theme/station/exploration
	abstract_type = /datum/rig_theme/station/exploration
	base_icon = 'icons/modules/rigsuits/suits/exploration.dmi'
	pieces = list(
		/datum/rig_piece/helmet,
		/datum/rig_piece/chestplate,
		/datum/rig_piece/gloves,
		/datum/rig_piece/boots{
			piece_base_state = "";
		},
	)
	control_base_state_worn = ""
	control_sealed_append = ""

DECLARE_RIG_THEME(/station/exploration/standard)
	name = "excursion rig"
	base_state = "explo"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "excursion"
	visible_name = "excursion"
	#warn impl

DECLARE_RIG_THEME(/station/exploration/pathfinder)
	name = "pathfinder rig"
	base_state = "pf"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "pathfinder"
	visible_name = "pathfinder"
	control_base_state_worn = null
	#warn impl

DECLARE_RIG_THEME(/station/exploration/medic)
	name = "field medic rig"
	base_state = "medic"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "medic"
	visible_name = "medic"
	#warn impl

DECLARE_RIG_THEME(/station/exploration/pilot)
	name = "pilot rig"
	base_state = "pilot"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "pilot"
	visible_name = "pilot"
	#warn impl
