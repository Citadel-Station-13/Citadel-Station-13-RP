//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// TODO: get rid of grouped, put into defs

/datum/soundbyte/parry_start
	name = "Active Parry (Start)"
	is_sfx = TRUE
	id = "parry-start"
	path = 'sound/soundbytes/effects/combat/parry-cycle.ogg'

/datum/soundbyte/grouped/metal_parry
	name = "Parry (Metal-Metal)"
	is_sfx = TRUE
	id = "parry-metal"
	path = list(
		'sound/soundbytes/effects/combat/parry-metal1.ogg',
		'sound/soundbytes/effects/combat/parry-metal2.ogg',
	)

/datum/soundbyte/grouped/wood_parry
	name = "Parry (Wood-Wood)"
	is_sfx = TRUE
	id = "parry-wood"
	path = list(
		'sound/soundbytes/effects/combat/parry-wood1.ogg',
		'sound/soundbytes/effects/combat/parry-wood2.ogg',
	)

/datum/soundbyte/grouped/block_metal_with_wood
	name = "Block (Metal-Wood)"
	is_sfx = TRUE
	id = "block-metal-on-wood"
	path = list(
		'sound/soundbytes/effects/combat/block-metal-on-wood-1.ogg',
		'sound/soundbytes/effects/combat/block-metal-on-wood-2.ogg',
	)

/datum/soundbyte/grouped/block_metal_with_metal
	name = "Block (Metal-Metal)"
	is_sfx = TRUE
	id = "block-metal-on-metal"
	path = list(
		'sound/soundbytes/effects/combat/block-metal-on-metal-1.ogg',
		'sound/soundbytes/effects/combat/block-metal-on-metal-2.ogg',
	)

/datum/soundbyte/grouped/block_wood_with_wood
	name = "Block (Wood-Wood)"
	is_sfx = TRUE
	id = "block-wood-on-wood"
	path = list(
		'sound/soundbytes/effects/combat/block-wood-on-wood-1.ogg',
		'sound/soundbytes/effects/combat/block-wood-on-wood-2.ogg',
	)

/datum/soundbyte/grouped/projectile_impact_kinetic_on_flesh
	name = "Projectile Impact (Kinetic-Flesh)"
	is_sfx = TRUE
	id = "projectile-impact-kinetic-flesh"
	path = list(
		'sound/soundbytes/effects/combat/projectile_impact/kinetic-flesh-1.ogg',
		'sound/soundbytes/effects/combat/projectile_impact/kinetic-flesh-2.ogg',
		'sound/soundbytes/effects/combat/projectile_impact/kinetic-flesh-3.ogg',
		'sound/soundbytes/effects/combat/projectile_impact/kinetic-flesh-4.ogg',
	)

/datum/soundbyte/grouped/projectile_impact_kinetic_on_metal
	name = "Projectile Impact (Kinetic-Metal)"
	is_sfx = TRUE
	id = "projectile-impact-kinetic-metal"
	path = list(
		'sound/soundbytes/effects/combat/projectile_impact/kinetic-metal-1.ogg',
		'sound/soundbytes/effects/combat/projectile_impact/kinetic-metal-2.ogg',
		'sound/soundbytes/effects/combat/projectile_impact/kinetic-metal-3.ogg',
	)

/datum/soundbyte/grouped/projectile_impact_energy_on_flesh
	name = "Projectile Impact (Energy-Flesh)"
	is_sfx = TRUE
	id = "projectile-impact-energy-flesh"
	path = list(
		'sound/soundbytes/effects/combat/projectile_impact/energy-flesh-1.ogg',
		'sound/soundbytes/effects/combat/projectile_impact/energy-flesh-2.ogg',
	)

/datum/soundbyte/grouped/projectile_impact_energy_on_metal
	name = "Projectile Impact (Energy-Metal)"
	is_sfx = TRUE
	id = "projectile-impact-energy-metal"
	path = list(
		'sound/soundbytes/effects/combat/projectile_impact/energy-metal-1.ogg',
		'sound/soundbytes/effects/combat/projectile_impact/energy-metal-2.ogg',
	)
