//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/rig/proc/zone_datums_for_bits(bits)
	. = list()
	if(bits & RIG_ZONE_HEAD)
		. += z_head
	if(bits & RIG_ZONE_CHEST)
		. += z_chest
	if(bits & RIG_ZONE_LEFT_ARM)
		. += z_left_arm
	if(bits & RIG_ZONE_RIGHT_ARM)
		. += z_right_arm
	if(bits & RIG_ZONE_LEFT_LEG)
		. += z_left_leg
	if(bits & RIG_ZONE_RIGHT_LEG)
		. += z_right_leg

/obj/item/rig/proc/zone_datums_for_enum(enum)
	. = zone_datums_for_bits(global.rig_zone_to_bit[enum])

/obj/item/rig/proc/zone_datum_for_enum(enum)
	switch(enum)
		if(RIG_ZONE_HEAD)
			return z_head
		if(RIG_ZONE_CHEST)
			return z_chest
		if(RIG_ZONE_LEFT_ARM)
			return z_left_arm
		if(RIG_ZONE_RIGHT_ARM)
			return z_right_arm
		if(RIG_ZONE_LEFT_LEG)
			return z_left_leg
		if(RIG_ZONE_RIGHT_LEG)
			return z_right_leg

/obj/item/rig/proc/reset_zones()
	var/list/datum/rig_zone/zones = list(
		z_head,
		z_chest,
		z_left_arm,
		z_right_arm,
		z_left_leg,
		z_right_leg,
	)
	for(var/datum/rig_zone/zone as anything in zones)
		zone.brute_damage = zone.burn_damage = 0
		zone.complexity_used = zone.volume_used = 0
	#warn retally module volume/complexity
