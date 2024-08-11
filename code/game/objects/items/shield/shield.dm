//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/passive_parry/shield
	parry_arc = 135
	parry_frame = /datum/parry_frame/shield

/datum/parry_frame/shield
	parry_sfx = /datum/soundbyte/grouped/block_metal_with_metal


/obj/item/shield
	name = "shield"
	passive_parry = /datum/passive_parry/shield{
		parry_chance_default = 50;
	}

#warn how do we do output text
