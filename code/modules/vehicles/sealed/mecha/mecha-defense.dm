//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/vehicle/sealed/mecha/inflict_damage_instance(damage, damage_type, damage_tier, damage_flag, damage_mode, attack_type, attack_source, shieldcall_flags, hit_zone, list/additional)
	. = ..()
	if(.[SHIELDCALL_ARG_DAMAGE] > 2)
		if(prob(.[SHIELDCALL_ARG_DAMAGE] * 5))
			spark_system?.start()

#warn impl

/obj/vehicle/sealed/mecha/run_armorcalls(list/shieldcall_args, fake_attack)
	// -- EXTERIOR --
	// run against armor; if pierced, goes to hull
	if(comp_armor)
		comp_armor.run_inbound_vehicle_damage_instance(shieldcall_args, fake_attack)
		if(shieldcall_args[SHIELDCALL_ARG_DAMAGE] <= DAMAGE_PRECISION)
			return

	// -- INTERIOR --
	// run against hull & components based on how damaged hull is

	if(comp_hull)
		shieldcall_args = comp_hull.run_inbound_vehicle_damage_instance(shieldcall_args, fake_attack)
		if(shieldcall_args[SHIELDCALL_ARG_DAMAGE] <= DAMAGE_PRECISION)
			return
	. = ..()

	#warn armor
	#warn hull

	// -- CHASSIS --
	// run against occupant & chassis

	// the occupant is considered a soak source
	// give a flat chance per occupant; clown cars are hard to break
	// but everyone inside is probably going to die
	for(var/mob/living/victim in occupants)
		// don't use dead people as soak sources or the meta will be
		// piling corpses into your mech
		if(victim.stat != STAT_IS_CONSCIOUS)
			if(prob(80))
				continue
		// low probability in the first place
		if(prob(65))
			continue
		// they're the victim, send the entire hit through them
		// but also fully

	// whatever's left goes to chassis
	..()
