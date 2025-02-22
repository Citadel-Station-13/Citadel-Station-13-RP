//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/character_setup/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/character_setup/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/character_setup/ui_asset_injection(datum/tgui/ui, list/immediate, list/deferred)
	// inject necessary asset packs
	deferred += /datum/asset_pack/json/character_appearance
	deferred += /datum/asset_pack/json/character_background
	deferred += /datum/asset_pack/json/character_loadout
	deferred += /datum/asset_pack/json/character_setup
	deferred += /datum/asset_pack/spritesheet/bodyset_markings
	deferred += /datum/asset_pack/spritesheet/bodysets
	deferred += /datum/asset_pack/spritesheet/loadout
	deferred += /datum/asset_pack/spritesheet/species
	deferred += /datum/asset_pack/spritesheet/sprite_accessories

//* Character List *//
