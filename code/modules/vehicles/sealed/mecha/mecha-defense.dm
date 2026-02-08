//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/vehicle/sealed/mecha/inflict_damage_instance(damage, damage_type, damage_tier, damage_flag, damage_mode, attack_type, attack_source, shieldcall_flags, hit_zone, list/additional)
	. = ..()
	if(.[SHIELDCALL_ARG_DAMAGE] > 2)
		if(prob(.[SHIELDCALL_ARG_DAMAGE] * 5))
			spark_system?.start()

/obj/vehicle/sealed/mecha/run_armorcalls(list/shieldcall_args, fake_attack)
	var/original_damage = shieldcall_args[SHIELDCALL_ARG_DAMAGE]

	// -- EXTERIOR --
	// run against armor; if pierced, goes to hull
	if(comp_armor)
		comp_armor.handle_inbound_vehicle_damage_instance(shieldcall_args, fake_attack)
		if(shieldcall_args[SHIELDCALL_ARG_DAMAGE] <= DAMAGE_PRECISION)
			return

	// -- end --

	// -- INTERIOR --
	// run against hull & components based on how damaged hull is

	if(comp_hull)
		comp_hull.handle_inbound_vehicle_damage_instance(shieldcall_args, fake_attack)
		if(shieldcall_args[SHIELDCALL_ARG_DAMAGE] <= DAMAGE_PRECISION)
			return
	#warn hit components

	// -- end --

	// -- CHASSIS --
	// run against occupant & chassis

	// the occupant(s) are considered a soak source
	// that said, you need a powerful enough, piercing attack
	if(!fake_attack)
		var/run_against_occupants = FALSE
		switch(shieldcall_args[SHIELDCALL_ARG_DAMAGE_FLAG])
			if(ARMOR_BULLET)
				// need sharp + high tier
				if(shieldcall_args[SHIELDCALL_ARG_DAMAGE_MODE] & DAMAGE_MODE_PIERCE)
					var/pierce_chance = min(50, 20 + shieldcall_args[SHIELDCALL_ARG_DAMAGE] * shieldcall_args[SHIELDCALL_ARG_DAMAGE_TIER * 0.5])
					if(prob(pierce_chance))
						run_against_occupants = TRUE
			if(ARMOR_MELEE)
				// need sharp + high tier
				if(shieldcall_args[SHIELDCALL_ARG_DAMAGE_MODE] & DAMAGE_MODE_PIERCE)
					var/pierce_chance = min(50, 15 + shieldcall_args[SHIELDCALL_ARG_DAMAGE] * shieldcall_args[SHIELDCALL_ARG_DAMAGE_TIER * 0.5])
					if(prob(pierce_chance))
						run_against_occupants = TRUE
		if(run_against_occupants)
			// give a flat chance per occupant; clown cars are hard to break
			// but everyone inside is probably going to die
			for(var/mob/living/victim in occupants)
				// don't use dead people as soak sources or the meta will be
				// piling corpses into your mech
				if(victim.stat != CONSCIOUS)
					if(prob(80))
						continue
				// low probability in the first place
				if(prob(65))
					continue
				// they're the victim, send the entire hit through them
				// but also fully
				var/ratio = shieldcall_args[SHIELDCALL_ARG_DAMAGE] / original_damage
				switch(shieldcall_args[SHIELDCALL_ARG_ATTACK_TYPE])
					if(ATTACK_TYPE_PROJECTILE)
						var/obj/projectile/source = shieldcall_args[SHIELDCALL_ARG_ATTACK_SOURCE]
						if(source && !source.impacted[victim])
							victim.bullet_act(source, NONE, null, ratio)
						// soaked
						return
					if(ATTACK_TYPE_MELEE)
						var/datum/event_args/actor/clickchain/source = shieldcall_args[SHIELDCALL_ARG_ATTACK_SOURCE]
						if(source?.using_melee_attack)
							var/datum/event_args/actor/clickchain/cloned = source.clone()
							cloned.attack_melee_multiplier *= ratio
							cloned.attack_contact_multiplier *= ratio
							cloned.using_melee_attack.perform_attack_message(
								cloned.performer,
								victim,
								FALSE,
								cloned.using_melee_weapon,
								cloned,
								CLICKCHAIN_REDIRECTED,
							)
							cloned.using_melee_attack.perform_attack_impact(
								cloned.performer,
								victim,
								FALSE,
								cloned.using_melee_weapon,
								cloned,
								CLICKCHAIN_REDIRECTED,
							)
							cloned.using_melee_attack.perform_attack_sound(
								cloned.performer,
								victim,
								FALSE,
								cloned.using_melee_weapon,
								cloned,
								CLICKCHAIN_REDIRECTED,
							)
						// soaked
						return
	// -- end --

	// whatever's left goes to chassis
	..()

/obj/vehicle/sealed/mecha/emp_act(severity)
	..()
	// TODO: automatic EMP hit throttling
	if(prob(80 / severity))
		fault_add(/datum/mecha_fault/calibration_lost, (4 / severity), 16)
	if(prob(40 / severity))
		fault_add(/datum/mecha_fault/temperature_control, 5, 40)

/obj/vehicle/sealed/mecha/tesla_act(power)
	. = ..()
	#warn damage
