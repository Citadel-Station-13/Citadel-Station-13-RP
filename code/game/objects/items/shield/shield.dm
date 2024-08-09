//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/passive_parry/shield
	parry_arc = 135
	#warn default sound

/obj/item/shield
	name = "shield"
	passive_parry = /datum/passive_parry/shield{
		parry_chance_default = 50;
	}

#warn how do we do output text
