//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/rig_theme/station/cargo
	abstract_type = /datum/rig_theme/station/cargo
	base_icon = 'icons/modules/rigsuits/suits/cargo.dmi'
	armor = /datum/armor/rigsuit/station/cargo

/datum/armor/rigsuit/station/cargo
	melee = 0.5
	melee_tier = 3
	melee_soak = 0
	melee_deflect = 5
	bullet = 0.35
	bullet_tier = 3
	bullet_soak = 0
	bullet_deflect = 5
	laser = 0.25
	laser_tier = 3
	laser_soak = 0
	laser_deflect = 0
	energy = 0.05
	bomb = 0.45
	bio = 1.0
	rad = 0.85
	fire = 0.75
	acid = 1.0

DECLARE_RIG_THEME(/station/cargo/asteroid)
/datum/rig_theme/station/cargo/asteroid
	name = "salvage rig"
	base_state = "salvage"
	desc = "A hardened salvage suit used by spacers and asteroid miners."
	fluff_desc = "A third-generation Hephaestus Industries salvage hardsuit with all the bells and whistles. \
	Often seen on the suit racks of corporations and more well-off frontiersmen, this suit is as hardy as it is \
	expensive. The <b>S-3</b> line of hardsuits boast significant improvements in mobility and versatility, \
	often being used in space and terrestrial environments alike."
	display_name = "salvage"
	visible_name = "Salvage"
	armor = /datum/armor/rigsuit/station/cargo/asteroid
	// sealed
	max_temperature_protect = HEAT_PROTECTION_INDUSTRIAL_VOIDSUIT
	#warn encumbrance

/datum/armor/rigsuit/station/cargo/asteroid

DECLARE_RIG_THEME(/station/cargo/mining)
/datum/rig_theme/station/cargo/mining
	name = "mining rig"
	base_state = "mining"
	desc = "A prototype, ash-like suit used by many a corporate spelunker."
	fluff_desc = "The Nanotrasen <b>Spelunker</b> line of terrestrial mining suits. Based off of prior designs given by \
	Hephaestus Industries, this suit incorporates some of the same technologies used in the proto-kinetic line of \
	mining prototypes. While lacking in seals, it offers far more mobility than most industrial RIGs."
	display_name = "mining"
	visible_name = "Mining"
	armor = /datum/armor/rigsuit/station/cargo/mining
	// non-ish-sealed
	min_pressure_protect = ONE_ATMOSPHERE
	max_pressure_protect = ONE_ATMOSPHERE
	min_temperature_protect = COLD_PROTECTION_HEAVY_WINTER_CLOTHING
	max_temperature_protect = HEAT_PROTECTION_LIGHT_FIRESUIT
	#warn encumbrance

/datum/armor/rigsuit/station/cargo/mining
	bullet = 0.35
	bullet_tier = 2
	laser = 0.35
	laser_tier = 2
	rad = 0.35

DECLARE_RIG_THEME(/station/cargo/loader)
/datum/rig_theme/station/cargo/loader
	name = "loader rig"
	base_state = "loader"
	desc = "An efficient, sleek suit used by logistics workers."
	fluff_desc = "The Hephaestus Industries <b>LL-9</b> series of assisted loader suits, used to provide underpaid \
	frontier workers just a bit more protection in their long toils aboard their freighters - as well as a <i>lot</i> more \
	comfort."
	display_name = "loader"
	visible_name = "Loader"
	armor = /datum/armor/rigsuit/station/cargo/loader
	// non-sealed
	min_pressure_protect = ONE_ATMOSPHERE
	max_pressure_protect = ONE_ATMOSPHERE
	min_temperature_protect = COLD_PROTECTION_MEDIUM_WINTER_CLOTHING
	max_temperature_protect = HEAT_PROTECTION_VERY_THICK_CLOTHING
	#warn encumbrance

/datum/armor/rigsuit/station/cargo/loader
	bullet = 0.25
	laser = 0.15
	rad = 0.1
