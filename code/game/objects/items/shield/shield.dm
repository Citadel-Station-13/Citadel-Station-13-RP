//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/passive_parry/shield
	parry_arc = 135
	#warn default sound

/obj/item/shield
	name = "shield"
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi',
	)
	passive_parry = /datum/passive_parry/shield{
		parry_chance_default = 50;
	}

#warn how do we do output text
