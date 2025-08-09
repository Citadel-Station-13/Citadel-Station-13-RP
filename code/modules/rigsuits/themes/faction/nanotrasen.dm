//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/rig_theme/nanotrasen
	abstract_type = /datum/rig_theme/nanotrasen
	// bye-bye security
	siemens_coefficient = 0.5

DECLARE_RIG_THEME(/nanotrasen/asset_protection)
/datum/rig_theme/nanotrasen/asset_protection
	name = "deathsquad rig"
	base_state = "deathsquad"
	base_icon = 'icons/modules/rigsuits/suits/factions/nanotrasen_military.dmi'
	display_name = "asset protection"
	visible_name = "Asset Protection"
	control_sealed_append = ""
	desc = "A heavy voidsuit used by corporate marines."
	fluff_desc = "The polar opposite to the Gorlex Marauder's combat armor, this is nonetheless still a great \
	example of Trans-Stellar Corporations having all too much power out on the frontiers. The Nanotrasen \
	Asset Protection hardsuit is rarely something seen on exonet marketing streams - and rarely something one \
	sees in person while still living to tell the tale."
	armor = /datum/armor/rigsuit/nanotrasen/asset_protection
	// bye-bye security
	siemens_coefficient = 0.35
	#warn encumbrance

/datum/armor/rigsuit/nanotrasen/asset_protection
	melee = 0.55
	melee_tier = MELEE_TIER_HEAVY
	melee_soak = 0
	melee_deflect = 5
	bullet = 0.55
	bullet_tier = BULLET_TIER_HIGH
	bullet_soak = 0
	bullet_deflect = 5
	laser = 0.55
	laser_tier = LASER_TIER_HIGH
	laser_soak = 0
	laser_deflect = 5
	energy = 0.45
	bomb = 0.55
	bio = 1.0
	rad = 0.7
	fire = 0.75
	acid = 1.0

DECLARE_RIG_THEME(/nanotrasen/officer)
/datum/rig_theme/nanotrasen/officer
	name = "centcom rig"
	base_state = "responsory"
	base_icon = 'icons/modules/rigsuits/suits/factions/nanotrasen.dmi'
	display_name = "officer"
	visible_name = "Officer"
	control_sealed_append = ""
	desc = "A relatively drab, but rugged looking hardsuit."
	fluff_desc = "Based off of a semi-visor design, this looks vaguely like an even more boring modification of \
	an inner system civilian hardsuit. Clearly, though, the armor on this thing has been enhanced; in-fact, \
	every facet of this suit seems to have been redone with heavier internals. The quite-literal silver \
	linings does point towards the holder of this suit having some rank, or perhaps wishes for such."
	armor = /datum/armor/rigsuit/nanotrasen/officer
	#warn encumbrance

/datum/armor/rigsuit/nanotrasen/officer
	melee = 0.45
	melee_tier = MELEE_TIER_MEDIUM
	melee_soak = 0
	melee_deflect = 5
	bullet = 0.45
	bullet_tier = BULLET_TIER_MEDIUM
	bullet_soak = 0
	bullet_deflect = 5
	laser = 0.45
	laser_tier = LASER_TIER_MEDIUM
	laser_soak = 0
	laser_deflect = 5
	energy = 0.35
	bomb = 0.45
	bio = 1.0
	rad = 0.55
	fire = 0.75
	acid = 1.0

DECLARE_RIG_THEME(/nanotrasen/inquisition)
/datum/rig_theme/nanotrasen/inquisition
	name = "inquisition rig"
	base_state = "inquisitory"
	base_icon = 'icons/modules/rigsuits/suits/factions/nanotrasen.dmi'
	display_name = "pmd"
	visible_name = "PMD"
	control_sealed_append = ""
	desc = "A strange, modified officer hardsuit rigged with what looks like silver paneling."
	fluff_desc = "This looks like a heavily modified officer's hardsuit. Perhaps whoever did it has a \
	serious superstition of vampires and werewolves. There's silver paneling everywhere on it, including a \
	rather gaudy cap on the top. How ridiculous."
	armor = /datum/armor/rigsuit/nanotrasen/inquisition
	#warn encumbrance

/datum/armor/rigsuit/nanotrasen/inquisition
	melee = 0.35
	melee_tier = MELEE_TIER_HEAVY
	melee_soak = 0
	melee_deflect = 5
	bullet = 0.35
	bullet_tier = BULLET_TIER_HIGH
	bullet_soak = 0
	bullet_deflect = 5
	laser = 0.35
	laser_tier = LASER_TIER_HIGH
	laser_soak = 0
	laser_deflect = 5
	energy = 0.35
	bomb = 0.55
	bio = 1.0
	rad = 0.7
	fire = 0.75
	acid = 1.0

/datum/rig_theme/nanotrasen/response
	abstract_type = /datum/rig_theme/nanotrasen/response
	control_sealed_append = ""
	armor = /datum/armor/rigsuit/nanotrasen/response
	desc = "The insignia'd hardsuits of Nanotrasen's emergency responders."
	fluff_desc = "Made with a joint, heavily publicized effort with Hephaestus Industries, these heavily \
	reinforced hardsuits are used by Nanotrasen's Emergency Responders. Reception to the sight of these \
	tends to be mixed, given that something usually will have went down for responders to be sent."
	#warn encumbrance

/datum/armor/rigsuit/nanotrasen/response
	melee = 0.35
	melee_tier = MELEE_TIER_HEAVY
	melee_soak = 0
	melee_deflect = 5
	bullet = 0.35
	bullet_tier = BULLET_TIER_HIGH
	bullet_soak = 0
	bullet_deflect = 5
	laser = 0.35
	laser_tier = LASER_TIER_HIGH
	laser_soak = 0
	laser_deflect = 5
	energy = 0.35
	bomb = 0.55
	bio = 1.0
	rad = 0.7
	fire = 0.75
	acid = 1.0

DECLARE_RIG_THEME(/nanotrasen/response/commander)
/datum/rig_theme/nanotrasen/response/commander
	name = "ert commander rig"
	base_state = "commander"
	base_icon = 'icons/modules/rigsuits/suits/factions/nanotrasen_response.dmi'
	display_name = "command"
	visible_name = "Command"
	control_sealed_append = ""

DECLARE_RIG_THEME(/nanotrasen/response/medic)
/datum/rig_theme/nanotrasen/response/medic
	name = "ert medic rig"
	base_state = "medic"
	base_icon = 'icons/modules/rigsuits/suits/factions/nanotrasen_response.dmi'
	display_name = "rescue"
	visible_name = "Rescue"
	control_sealed_append = ""

DECLARE_RIG_THEME(/nanotrasen/response/engineer)
/datum/rig_theme/nanotrasen/response/engineer
	name = "ert engineer rig"
	base_state = "engineer"
	base_icon = 'icons/modules/rigsuits/suits/factions/nanotrasen_response.dmi'
	display_name = "engineering"
	visible_name = "Engineering"
	control_sealed_append = ""

DECLARE_RIG_THEME(/nanotrasen/response/security)
/datum/rig_theme/nanotrasen/response/security
	name = "ert security rig"
	base_state = "security"
	base_icon = 'icons/modules/rigsuits/suits/factions/nanotrasen_response.dmi'
	display_name = "officer"
	visible_name = "Officer"
	control_sealed_append = ""
