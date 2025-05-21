//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/gun/projectile/energy/should_attack_self_switch_firemodes()
	if(..())
		return TRUE
	for(var/obj/item/gun_component/particle_array/maybe_array in modular_components)
		return TRUE
	return FALSE

/obj/item/gun/projectile/energy/auto_inhand_switch_firemodes(datum/event_args/actor/e_args)
	if(length(firemodes))
		return ..()
	user_swap_particle_array(e_args)
	return TRUE
