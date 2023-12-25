//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/rig_theme/station/medical
	abstract_type = /datum/rig_theme/station/medical
	base_icon = 'icons/modules/rigsuits/suits/medical.dmi'

AUTO_RIG_THEME(/station/medical/standard)
/datum/rig_theme/station/medical/standard
	name = "medical rig"
	base_state = "medical"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "medical"
	visible_name = "Medical"
	pieces = list(
		/datum/rig_piece/helmet{
			worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TAJARAN, BODYTYPE_SKRELL, BODYTYPE_UNATHI, BODYTYPE_UNATHI_DIGI, BODYTYPE_IPC);
		},
		/datum/rig_piece/chestplate{
			worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TAJARAN, BODYTYPE_UNATHI, BODYTYPE_UNATHI_DIGI, BODYTYPE_IPC);
		},
		/datum/rig_piece/gloves{
			worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TAJARAN, BODYTYPE_IPC);
		},
		/datum/rig_piece/boots{
			worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TAJARAN, BODYTYPE_IPC);
		},
	)
	#warn impl

AUTO_RIG_THEME(/station/medical/advanced)
/datum/rig_theme/station/medical/advanced
	name = "chief medical rig"
	base_state = "corpsman"
	desc = "TBD"
	fluff_desc = "TBD"
	display_name = "rescue"
	visible_name = "Rescue"
	#warn impl
