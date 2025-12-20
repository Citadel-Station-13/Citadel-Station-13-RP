/mob/living/simple_mob/mechanical/derelict/minuteman/hornet
	name = "minuteman hornet"
	desc = "A medium sized automaton that flies low above the ground. It looks like it can take a few good hits, but most alarmingly is the multitude of pincers and syringes on the tendrils beneath it. You see spiked particles in one of its syringes."

	icon_state = "hornet"
	icon_living = "hornet"

	health = 170
	maxHealth = 170
	movement_base_speed = 10 / 3
	hovering = TRUE
	evasion = 10

	base_attack_cooldown = 12
	legacy_melee_damage_upper = 20
	legacy_melee_damage_lower = 20


	var/shredding_poison_type = "fast_shredding_nanites"
	var/shredding_poison_chance = 100
	var/shredding_poison_per_bite = 5

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive

/mob/living/simple_mob/mechanical/derelict/minuteman/hornet/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.reagents)
			var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				inject_poison1(L, target_zone)


/mob/living/simple_mob/mechanical/derelict/minuteman/hornet/proc/inject_poison1(mob/living/L, target_zone1)
	if(prob(shredding_poison_chance))
		to_chat(L, "<span class='warning'>Something burns in your veins!</span>")
		L.reagents.add_reagent(shredding_poison_type, shredding_poison_per_bite)
