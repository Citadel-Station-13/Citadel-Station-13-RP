//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/rig_theme/station/cargo
	abstract_type = /datum/rig_theme/station/cargo
	base_icon = 'icons/modules/rigsuits/suits/cargo.dmi'

AUTO_RIG_THEME(/station/cargo/asteroid)
/datum/rig_theme/station/cargo/asteroid
	name = "salvage rig"
	base_state = "salvage"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "salvage"
	visible_name = "Salvage"
	#warn impl

AUTO_RIG_THEME(/station/cargo/mining)
/datum/rig_theme/station/cargo/mining
	name = "mining rig"
	base_state = "mining"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "mining"
	visible_name = "Mining"
	#warn impl

AUTO_RIG_THEME(/station/cargo/loader)
/datum/rig_theme/station/cargo/loader
	name = "loader rig"
	base_state = "loader"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "loader"
	visible_name = "Loader"
	#warn impl
