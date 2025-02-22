//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Contains:
 *
 * * Bodysets
 * * Bodyset Markings
 * * Sprite Accessories
 *
 * Requires:
 *
 * * asset_pack/spritesheet/sprite_accessories
 * * asset_pack/spritesheet/bodysets
 * * asset_pack/spritesheet/bodyset_markings
 */
/datum/asset_pack/json/character_appearance
	name = "CharacterAppearance"

/datum/asset_pack/json/character_appearance/generate()
	. = list()

	var/list/assemble_sprite_accessories = list()
	#warn this; need to repository it
	.["keyedSpriteAccessories"] = assemble_sprite_accessories

	var/list/assemble_bodysets = list()
	// todo: bodysets
	.["keyedBodysets"] = assemble_bodysets

	var/list/assemble_bodyset_markings = list()
	// todo: bodyset markings
	.["keyedBodysetMarkings"] = assemble_bodyset_markings
