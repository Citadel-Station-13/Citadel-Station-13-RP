//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/armor/rigsuit/station/science
	melee = 0.15
	melee_tier = MELEE_TIER_MEDIUM
	melee_soak = 0
	melee_deflect = 5
	bullet = 0.15
	bullet_tier = BULLET_TIER_MEDIUM
	bullet_soak = 0
	bullet_deflect = 3
	laser = 0.05
	laser_tier = LASER_TIER_HIGH
	laser_soak = 5
	laser_deflect = 5
	energy = 0.45
	bomb = 0.75
	bio = 1.0
	rad = 1.0
	fire = 0.95
	acid = 1.0

/datum/rig_theme/station/science
	abstract_type = /datum/rig_theme/station/science
	armor = /datum/armor/rigsuit/station/science
	base_icon = 'icons/modules/rigsuits/suits/science.dmi'

AUTO_RIG_THEME(/station/science/standard)
/datum/rig_theme/station/science/standard
	name = "prototype rig"
	base_state = "prototype"
	desc = "A prototype RIG used by scientists hailing from the Trans-Stellar Corporations."
	fluff_desc = "A distant offshoot of one of Nanotrasen's first forays into powered EVA gear, the \
	colloquially named 'prototype rig' is now in its eleventh generation. In exchange for knowing that \
	your life is in the hands of what's essentially a late-stage field test, this suit has Nanotrasen's \
	latest and greatest innovations, including concussive absorption and full-body protection from \
	exotic fields. This suit is generally worn by field science personnel, and tends to not be well-armored \
	otherwise."
	display_name = "prototype"
	visible_name = "Prototype"
	base_weight = 20
	offline_encumbrance = 60
	online_encumbrance = 40 // it's a bombsuit.

/datum/armor/rigsuit/station/science/anomaly
	melee = 0.05
	melee_tier = MELEE_TIER_HEAVY
	bullet = 0.05
	bullet_tier = BULLET_TIER_HIGH
	laser_soak = 5
	energy = 0.55

AUTO_RIG_THEME(/station/science/anomaly)
/datum/rig_theme/station/science/anomaly
	name = "anomaly rig"
	base_state = "apocryphal"
	desc = "An improved EVA suit worn by some of Nanotrasen's best and brightest."
	fluff_desc = "An experimental design based off of Nanotrasen's prototype excursion suits, this \
	unreasonably expensive suit packs the latest in materials science. The AMI suit boasts a relatively \
	thin and light package with pilot-grade deflection plating, at the cost of much of its padding."
	display_name = "AMI"
	visible_name = "AMI"
	armor = /datum/armor/rigsuit/station/science/anomaly
	base_weight = 22.5
	offline_encumbrance = 60
	online_encumbrance = 37.5
