//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/soundbyte/parry_start
	name = "Active Parry (Start)"
	is_sfx = TRUE
	path = 'sound/soundbytes/effects/combat/parry-cycle.ogg'

/datum/soundbyte/grouped/metal_parry
	name = "Parry (Metal-Metal)"
	is_sfx = TRUE
	path = list(
		'sound/soundbytes/effects/combat/parry-metal1.ogg',
		'sound/soundbytes/effects/combat/parry-metal2.ogg',
	)

/datum/soundbyte/grouped/wood_parry
	name = "Parry (Wood-Wood)"
	is_sfx = TRUE
	path = list(
		'sound/soundbytes/effects/combat/parry-wood1.ogg',
		'sound/soundbytes/effects/combat/parry-wood2.ogg',
	)

/datum/soundbyte/grouped/block_metal_with_wood
	name = "Block (Metal-Wood)"
	is_sfx = TRUE
	path = list(
		'sound/soundbytes/effects/combat/block-metal-on-wood-1.ogg',
		'sound/soundbytes/effects/combat/block-metal-on-wood-2.ogg',
	)

/datum/soundbyte/grouped/block_metal_with_metal
	name = "Block (Metal-Metal)"
	is_sfx = TRUE
	path = list(
		'sound/soundbytes/effects/combat/block-metal-on-metal-1.ogg',
		'sound/soundbytes/effects/combat/block-metal-on-metal-2.ogg',
	)

/datum/soundbyte/grouped/block_wood_with_wood
	name = "Block (Wood-Wood)"
	is_sfx = TRUE
	path = list(
		'sound/soundbytes/effects/combat/block-wood-on-wood-1.ogg',
		'sound/soundbytes/effects/combat/block-wood-on-wood-2.ogg',
	)
