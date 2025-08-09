//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/rig_theme/station/medical
	abstract_type = /datum/rig_theme/station/medical
	base_icon = 'icons/modules/rigsuits/suits/medical.dmi'
	armor = /datum/armor/rigsuit/station/medical

/datum/armor/rigsuit/station/medical
	melee = 0.3
	melee_tier = MELEE_TIER_MEDIUM
	melee_soak = 3
	melee_deflect = 0
	bullet = 0.25
	bullet_tier = BULLET_TIER_LOW
	bullet_soak = 0
	bullet_deflect = 0
	laser = 0.3
	laser_tier = LASER_TIER_LOW
	laser_soak = 0
	laser_deflect = 0
	energy = 0.2
	bomb = 0.35
	bio = 1.0
	rad = 0.45
	fire = 0.575
	acid = 1.0

DECLARE_RIG_THEME(/station/medical/standard)
/datum/rig_theme/station/medical/standard
	name = "medical rig"
	base_state = "medical"
	desc = "A common search and rescue hardsuit used by frontier medics."
	fluff_desc = "One of the more common lineages of Vey-Med's rescue hardsuits, this design is a widely exported \
	gem used by many a doctor - albeit at a mildly hefty price. Optimized for speed and maneuverability, it does \
	lack some of the heavier shielding found on industrial spacesiuts."
	display_name = "medical"
	visible_name = "Medical"
	pieces = list(
		/datum/rig_theme_piece/helmet{
			worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TAJARAN, BODYTYPE_SKRELL, BODYTYPE_UNATHI, BODYTYPE_UNATHI_DIGI, BODYTYPE_IPC);
		},
		/datum/rig_theme_piece/chestplate{
			worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TAJARAN, BODYTYPE_UNATHI, BODYTYPE_UNATHI_DIGI, BODYTYPE_IPC);
		},
		/datum/rig_theme_piece/gloves{
			worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TAJARAN, BODYTYPE_IPC);
		},
		/datum/rig_theme_piece/boots{
			worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TAJARAN, BODYTYPE_IPC);
		},
	)
	#warn encumbrance

DECLARE_RIG_THEME(/station/medical/advanced)
/datum/rig_theme/station/medical/advanced
	name = "chief medical rig"
	base_state = "corpsman"
	desc = "An expensive, upgraded rescue hardsuit often used by frontier medical officers."
	fluff_desc = "An upgraded, and likely overpriced hardsuit straight from Vey-Med. Contains enhanced \
	plating and shielding - as much as can be packed without compromising its superior mobility. \
	Often found in the hands of corporate medical services, as well as more wealthy frontiersmen whom can \
	actually afford it."
	display_name = "rescue"
	visible_name = "Rescue"
	armor = /datum/armor/rigsuit/station/medical/advanced
	siemens_coefficient = 0.7
	#warn encumbrance

/datum/armor/rigsuit/station/medical/advanced
	melee = 0.35
	melee_tier = MELEE_TIER_MEDIUM
	bullet = 0.2
	bullet_tier = BULLET_TIER_MEDIUM
	laser = 0.3
	laser_tier = LASER_TIER_MEDIUM
	bomb = 0.4
