//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/vehicle/sealed/mecha/inflict_damage_instance(damage, damage_type, damage_tier, damage_flag, damage_mode, attack_type, attack_source, shieldcall_flags, hit_zone, list/additional)
	. = ..()
	if(.[SHIELDCALL_ARG_DAMAGE] > 2)
		if(prob(.[SHIELDCALL_ARG_DAMAGE] * 5))
			spark_system?.start()

#warn impl

/obj/vehicle/sealed/mecha/run_armorcalls(list/shieldcall_args, fake_attack)
	. = ..()

	#warn armor
	#warn hull
