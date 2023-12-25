//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/rig_theme/station/engineering
	abstract_type = /datum/rig_theme/station/engineering
	base_icon = 'icons/modules/rigsuits/suits/engineering.dmi'

DECLARE_RIG_THEME(/station/engineering/standard)
	name = "engineering rig"
	base_state = "engineering"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "engineering"
	visible_name = "Engineering"
	#warn impl

DECLARE_RIG_THEME(/station/engineering/atmospherics)
	name = "atmospherics rig"
	base_state = "atmospheric"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "atmospherics"
	visible_name = "Atmospherics"
	#warn impl

DECLARE_RIG_THEME(/station/engineering/advanced)
	name = "advanced rig"
	base_state = "advanced"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "advanced"
	visible_name = "Advanced"
	#warn impl
