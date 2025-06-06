/*
	A corrupted maintenance drone, produced from what seems like a bad factory.
	They also tend to dodge while in melee range.
	Code "borrowed" from viscerator drones. <3
*/

/datum/category_item/catalogue/technology/drone/corrupt_maint_drone
	name = "Drone - Corrupted Maintenance Drone"
	desc = "This drone appears to be a station maintenance drone, produced by some sort of corrupt fab. \
	Now this drone seems to target any organic life it comes across, working with others of its kind to overwhelm \
	larger foes. If one is found, a swarm of others are not too far away.\
	<br><br>\
	The drone struggles to harm large targets, due to it's small size, yet it possesses a welder, which allows \
	it to **ERROR** inject it's targets, in addition to the small slashes from it's skittering claws. \
	The simplistic AI inside attempts to attack and then run, as it is aware that it is fairly weak, \
	using evasive tactics to avoid harm."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/mechanical/corrupt_maint_drone
	name = "Corrupt Maintenance Drone"
	desc = "A small, normal-looking drone. It looks like one you'd find on station, except... IT'S COMING AT YOU!"
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/corrupt_maint_drone)

	icon = 'icons/mob/robots.dmi'
	icon_state = "corrupt-repairbot"
	icon_living = "corrupt-repairbot"
	hovering = FALSE // Can trigger landmines.

	iff_factions = MOB_IFF_FACTION_HIVEBOT
	maxHealth = 25
	health = 25
	movement_base_speed = 6.66
	movement_sound = 'sound/effects/servostep.ogg'

	pass_flags = ATOM_PASS_TABLE
	mob_swap_flags = 0
	mob_push_flags = 0

	legacy_melee_damage_lower = 6 // Approx 12 DPS.
	legacy_melee_damage_upper = 6
	base_attack_cooldown = 2.5 // Four attacks per second.
	attack_sharp = 1
	attack_edge = 1
	attack_sound = 'sound/weapons/bladeslice.ogg'
	attacktext = list("cut", "sliced")

	var/poison_type = "fuel"	// The reagent that gets injected when it attacks.
	var/poison_chance = 35			// Chance for injection to occur.
	var/poison_per_bite = 5			// Amount added per injection.

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive


/mob/living/simple_mob/mechanical/corrupt_maint_drone/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.reagents)
			var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				inject_poison(L, target_zone)

// Does actual poison injection, after all checks passed.
/mob/living/simple_mob/mechanical/corrupt_maint_drone/proc/inject_poison(mob/living/L, target_zone)
	if(prob(poison_chance))
		to_chat(L, "<span class='warning'>Something burns in your veins.</span>")
		L.reagents.add_reagent(poison_type, poison_per_bite)


/mob/living/simple_mob/mechanical/corrupt_maint_drone/death()
	..(null,"is smashed into pieces!")
	qdel(src)

/mob/living/simple_mob/mechanical/corrupt_maint_drone/weak_no_poison
	name = "Derelict Maintenance Drone"
	base_attack_cooldown = 8 // Slower attack rate
	legacy_melee_damage_lower = 4	// Slightly less DPS for this version
	poison_chance = 0	// No welding fuel poison
//	pass_flags = Null // Lets see if this stops the bastards from going under barricades


/mob/living/simple_mob/mechanical/corrupt_maint_drone/matriarch
	name = "Corrupt Matriarch Drone"
	desc = "A not so small, normal-looking drone. It looks like one you'd find on station, except... IT'S COMING AT YOU!"
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/corrupt_maint_drone)

	icon_state = "corrupt-matriarch"
	icon_living = "corrupt-matriarch"

	maxHealth = 50
	health = 50

	legacy_melee_damage_lower = 12 // Approx 12 DPS.
	legacy_melee_damage_upper = 12
	base_attack_cooldown =  5 // Two attacks per second.

