//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/gun/projectile/ballistic/microbattery/should_attack_self_switch_firemodes()
	return TRUE

/obj/item/gun/projectile/ballistic/microbattery/auto_inhand_switch_firemodes(datum/event_args/actor/e_args)
	if(length(firemodes))
		return ..()
	#warn swap / cycle ammo in mag
