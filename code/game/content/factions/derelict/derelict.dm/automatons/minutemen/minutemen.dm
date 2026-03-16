/mob/living/simple_mob/mechanical/derelict/minuteman
	icon = 'code/game/content/factions/derelict/derelict.dmi/automatons/minutemen.dmi'
	iff_factions = MOB_IFF_FACTION_DERELICT_AUTOMATONS
	color = "#cac8c8"

/mob/living/simple_mob/mechanical/derelict/minuteman/death()
	..()
	visible_message(SPAN_WARNING("\The [src] suddenly explodes into a shower of gore and metal!"))
	new /obj/effect/debris/cleanable/blood/gibs(src.loc)
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)


	// Automatons //

/mob/living/simple_mob/mechanical/derelict/minuteman/wasp
	name = "minuteman wasp"
	desc = "A small drone that hovers over the ground. Its frame appears small and delicate, however it twitches and moves around incessantly."

	icon_state = "wasp"
	icon_living = "wasp"


	health = 120
	maxHealth = 120
	movement_base_speed = 10 / 2
	density = 0
	hovering = TRUE


	base_attack_cooldown = 6
	legacy_melee_damage_upper = 15
	legacy_melee_damage_lower = 15

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/event


/mob/living/simple_mob/mechanical/derelict/minuteman/hornet
	name = "minuteman hornet"
	desc = "A medium sized automaton that flies low above the ground. It looks like it can take a few good hits, but most alarmingly is the multitude of pincers and syringes on the tendrils beneath it. You see spiked particles in one of its syringes."

	icon_state = "hornet"
	icon_living = "hornet"
	color = "#808080"

	health = 170
	maxHealth = 170
	movement_base_speed = 10 / 3
	hovering = TRUE
	evasion = 10

	base_attack_cooldown = 12
	legacy_melee_damage_upper = 20
	legacy_melee_damage_lower = 20


	var/poison_type = "fast_shredding_nanites"
	var/poison_chance = 100
	var/poison_per_bite = 5

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive

/mob/living/simple_mob/mechanical/derelict/minuteman/hornet/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.reagents)
			var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				inject_poison(L, target_zone)


/mob/living/simple_mob/mechanical/derelict/minuteman/hornet/proc/inject_poison(mob/living/L, target_zone1)
	if(prob(poison_chance))
		to_chat(L, "<span class='warning'>Something burns in your veins!</span>")
		L.reagents.add_reagent(poison_type, poison_per_bite)



/mob/living/simple_mob/mechanical/derelict/minuteman/dragonfly
	name = "minuteman dragonfly"
	desc = "A lithe hovering automaton. It sports an array of mechanical 'wings', which seems to allow it greater mobility. This one appears fitted with some sort of odd energy weapon."

	icon_state = "dragonfly"
	icon_living = "dragonfly"

	health = 200
	maxHealth = 200
	movement_base_speed = 10 / 3
	hovering = TRUE
	evasion = 20


	base_attack_cooldown = 12
	projectiletype = /obj/projectile/energy/darkmatter/dragonfly
	legacy_melee_damage_upper = 15
	legacy_melee_damage_lower = 15


	ai_holder_type = /datum/ai_holder/polaris/hostile/ranged/robust


/mob/living/simple_mob/mechanical/derelict/minuteman/mantis
	name = "minuteman mantis"
	desc = "An imposing automaton. It hovers over the ground, and appears capable of packing quite a punch. It's covered in what appears to be armored plating."

	icon_state = "mantis"
	icon_living = "mantis"

	health = 250
	maxHealth = 250
	armor_legacy_mob = list(
		"melee" = 60,
		"bullet" = 30,
		"laser" = 25,
		"energy" = 30,
		"bomb" = 20,
		"bio" = 100,
		"rad" = 100,
	)
	movement_base_speed = 10 / 3
	hovering = TRUE


	base_attack_cooldown = 12
	legacy_melee_damage_upper = 30
	legacy_melee_damage_lower = 30


	ai_holder_type = /datum/ai_holder/polaris/hostile/ranged/robust

/mob/living/simple_mob/mechanical/derelict/minuteman/mantis/apply_melee_effects(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.mob_size <= MOB_MEDIUM)
			visible_message(SPAN_DANGER("\The [src] sends \the [L] flying with their heavy fists!"))
			playsound(src, "sound/mobs/biomorphs/breaker_slam.ogg", 50, 1)
			var/throw_dir = get_dir(src, L)
			var/throw_dist = L.incapacitated(INCAPACITATION_DISABLED) ? 4 : 1
			L.throw_at_old(get_edge_target_turf(L, throw_dir), throw_dist, 1, src)
		else
			to_chat(L, SPAN_WARNING( "\The [src] punches you with incredible force, but you remain in place."))
