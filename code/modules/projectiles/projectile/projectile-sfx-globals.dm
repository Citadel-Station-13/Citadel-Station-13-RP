//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * this file is proof that VV fanaticism was a mistake
 */

GLOBAL_LIST_INIT(projectile_impact_sfx_lut, list(
	COMBAT_IMPACT_FX_GENERIC = list(
		PROJECTILE_IMPACT_SOUNDS_ENERGY = /datum/soundbyte/grouped/projectile_impact_energy_on_flesh,
		PROJECTILE_IMPACT_SOUNDS_KINETIC = /datum/soundbyte/grouped/projectile_impact_kinetic_on_flesh,
	),
	COMBAT_IMPACT_FX_FLESH = list(
		PROJECTILE_IMPACT_SOUNDS_ENERGY = /datum/soundbyte/grouped/projectile_impact_energy_on_flesh,
		PROJECTILE_IMPACT_SOUNDS_KINETIC = /datum/soundbyte/grouped/projectile_impact_kinetic_on_flesh,
	),
	COMBAT_IMPACT_FX_WOOD = list(
		PROJECTILE_IMPACT_SOUNDS_ENERGY = /datum/soundbyte/grouped/projectile_impact_energy_on_flesh,
		PROJECTILE_IMPACT_SOUNDS_KINETIC = /datum/soundbyte/grouped/projectile_impact_kinetic_on_flesh,
	),
	COMBAT_IMPACT_FX_METAL = list(
		PROJECTILE_IMPACT_SOUNDS_ENERGY = /datum/soundbyte/grouped/projectile_impact_energy_on_metal,
		PROJECTILE_IMPACT_SOUNDS_KINETIC = /datum/soundbyte/grouped/projectile_impact_kinetic_on_metal,
	),
))
