//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun/projectile/energy/is_preferred_firemode(datum/firemode/energy/firemode)
	return ..() && (lethal_safety ? !firemode.considered_lethal : TRUE)

/obj/item/gun/projectile/energy/proc/has_lethal_firemode()
	for(var/datum/firemode/energy/firemode as anything in firemodes)
		if(firemode.considered_lethal)
			return TRUE
	return FALSE
