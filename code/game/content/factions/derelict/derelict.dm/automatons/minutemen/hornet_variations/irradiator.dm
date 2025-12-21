/mob/living/simple_mob/mechanical/derelict/minuteman/hornet/irradiator
	name = "minuteman irradiator hornet"
	desc = "A medium sized automaton that flies low above the ground. It looks like it can take a few good hits, but most alarmingly is the multitude of pincers and syringes on the tendrils beneath it. This one reeks of ozone."

	icon_state = "irradiator_hornet"
	icon_living = "irradiator_hornet"

	health = 170
	maxHealth = 170
	movement_base_speed = 10 / 3
	hovering = TRUE

	base_attack_cooldown = 12
	legacy_melee_damage_upper = 20
	legacy_melee_damage_lower = 20


	var/poison_type = "fast_irradiated_nanites"
	var/poison_chance = 100
	var/poison_per_bite = 10


/mob/living/simple_mob/mechanical/derelict/minuteman/hornet/irradiator/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.reagents)
			var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				inject_poison(L, target_zone)


/mob/living/simple_mob/mechanical/derelict/minuteman/hornet/irradiator/proc/inject_poison(mob/living/L, target_zone)
	if(prob(poison_chance))
		to_chat(L, "<span class='warning'>You taste pennies.</span>")
		L.reagents.add_reagent(poison_type, poison_per_bite)
