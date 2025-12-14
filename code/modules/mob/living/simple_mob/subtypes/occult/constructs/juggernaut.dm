////////////////////////////
//		Juggernaut
////////////////////////////

/datum/category_item/catalogue/fauna/construct/juggernaut
	name = "Constructs - Juggernaut"
	desc = "An absolute behemoth, the Juggernaut is feared by \
	many, and revered by some. Imposing, heavily armored, and powerful, \
	the Juggernaut relies only on its massive hands to do damage - they \
	are usually more than sufficient. The statue's thick armor makes it \
	immensely resilient. Direct combat with a Juggernaut is not advised."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/construct/juggernaut
	name = "Juggernaut"
	real_name = "Juggernaut"
	construct_type = "juggernaut"
	desc = "A possessed suit of armour driven by the will of the restless dead"
	icon_state = "behemoth"
	icon_living = "behemoth"
	maxHealth = 200
	health = 200
	response_harm   = "harmlessly punches"
	harm_intent_damage = 0
	legacy_melee_damage_lower = 30
	legacy_melee_damage_upper = 40
	attack_armor_pen = 60 //Being punched by a living, floating statue.
	attacktext = list("smashed their armoured gauntlet into")
	friendly = list("pats")
	mob_size = MOB_HUGE
	catalogue_data = list(/datum/category_item/catalogue/fauna/construct/juggernaut)


	movement_base_speed = 10 / 6 //Not super fast, but it might catch up to someone in armor who got punched once or twice.

//	environment_smash = 2	// Whatever this gets renamed to, Juggernauts need to break things

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/destructive


	attack_sound = 'sound/weapons/heavysmash.ogg'
	status_flags = 0
	construct_spells = list(/spell/aoe_turf/conjure/forcewall/lesser,
							/spell/targeted/fortify,
							/spell/targeted/construct_advanced/slam
							)

	armor_legacy_mob = list(
				"melee" = 70,
				"bullet" = 30,
				"laser" = 30,
				"energy" = 30,
				"bomb" = 10,
				"bio" = 100,
				"rad" = 100)

/mob/living/simple_mob/construct/juggernaut/Life(seconds, times_fired)
	set_paralyzed(0)
	return ..()

/mob/living/simple_mob/construct/juggernaut/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/horror_aura/strong)

/mob/living/simple_mob/construct/juggernaut/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	var/reflectchance = 80 - round(proj.damage_force/3)
	if(prob(reflectchance) && !istype(src, /mob/living/simple_mob/construct/juggernaut/behemoth))
		var/damage_mod = rand(2,4)
		var/projectile_dam_type = proj.damage_type
		var/incoming_damage = (round(proj.damage_force / damage_mod) - (round((proj.damage_force / damage_mod) * 0.3)))
		var/armorcheck = run_armor_check(null, proj.damage_flag)
		var/soakedcheck = get_armor_soak(null, proj.damage_flag)
		if(!(istype(proj, /obj/projectile/energy) || istype(proj, /obj/projectile/beam)))
			visible_message("<span class='danger'>The [proj.name] bounces off of [src]'s shell!</span>", \
						"<span class='userdanger'>The [proj.name] bounces off of [src]'s shell!</span>")
			new /obj/item/material/shard/shrapnel(src.loc)
			if(!(proj.damage_type == DAMAGE_TYPE_BRUTE || proj.damage_type == DAMAGE_TYPE_BURN))
				projectile_dam_type = DAMAGE_TYPE_BRUTE
				incoming_damage = round(incoming_damage / 4) //Damage from strange sources is converted to brute for physical projectiles, though severely decreased.
			apply_damage(incoming_damage, projectile_dam_type, null, armorcheck, soakedcheck, is_sharp(proj), has_edge(proj), proj)
			return ..()
		else
			visible_message("<span class='danger'>The [proj.name] gets reflected by [src]'s shell!</span>", \
						"<span class='userdanger'>The [proj.name] gets reflected by [src]'s shell!</span>")
			damage_mod = rand(3,5)
			incoming_damage = (round(proj.damage_force / damage_mod) - (round((proj.damage_force / damage_mod) * 0.3)))
			if(!(proj.damage_type == DAMAGE_TYPE_BRUTE || proj.damage_type == DAMAGE_TYPE_BURN))
				projectile_dam_type = DAMAGE_TYPE_BURN
				incoming_damage = round(incoming_damage / 4) //Damage from strange sources is converted to burn for energy-type projectiles, though severely decreased.
			apply_damage(incoming_damage, proj.damage_type, null, armorcheck, soakedcheck, is_sharp(proj), has_edge(proj), proj)

		// Find a turf near or on the original location to bounce to
		if(proj.starting)
			var/new_x = proj.starting.x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
			var/new_y = proj.starting.y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
			var/turf/curloc = get_turf(src)

			// redirect the projectile
			proj.legacy_redirect(new_x, new_y, curloc, src)
			proj.reflected = 1

		return PROJECTILE_IMPACT_REFLECT
	return ..()

/*
 * The Behemoth. Admin-allowance only, still try to keep it in some guideline of 'Balanced', even if it means Security has to be fully geared to be so.
 */

/mob/living/simple_mob/construct/juggernaut/behemoth
	name = "Behemoth"
	real_name = "Behemoth"
	desc = "The pinnacle of occult technology, Behemoths are nothing shy of both an Immovable Object, and Unstoppable Force."
	maxHealth = 600
	health = 600
	speak_emote = list("rumbles")
	legacy_melee_damage_lower = 50
	legacy_melee_damage_upper = 50
	attacktext = list("brutally crushed")
	friendly = list("pokes") //Anything nice the Behemoth would do would still Kill the Human. Leave it at poke.
	attack_sound = 'sound/weapons/heavysmash.ogg'
	icon_scale_x = 2
	icon_scale_y = 2
	var/energy = 0
	var/max_energy = 1000
	armor_legacy_mob = list(
				"melee" = 60,
				"bullet" = 60,
				"laser" = 60,
				"energy" = 30,
				"bomb" = 10,
				"bio" = 100,
				"rad" = 100)
	construct_spells = list(/spell/aoe_turf/conjure/forcewall/lesser,
							/spell/targeted/fortify,
							/spell/targeted/construct_advanced/slam
							)

/mob/living/simple_mob/construct/juggernaut/behemoth/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	var/reflectchance = 80 - round(proj.damage_force/3)
	if(prob(reflectchance))
		visible_message("<span class='danger'>The [proj.name] gets reflected by [src]'s shell!</span>", \
						"<span class='userdanger'>The [proj.name] gets reflected by [src]'s shell!</span>")

		// Find a turf near or on the original location to bounce to
		if(proj.starting)
			var/new_x = proj.starting.x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
			var/new_y = proj.starting.y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
			var/turf/curloc = get_turf(src)

			// redirect the projectile
			proj.legacy_redirect(new_x, new_y, curloc, src)
			proj.reflected = 1

		return PROJECTILE_IMPACT_REFLECT
	return ..()

/datum/category_item/catalogue/fauna/construct/cyclops
	name = "Constructs - Cyclops"
	desc = "Far worse then even the dreaded Juggernaut \
	the Cyclops is power construct capable of casting deadly \
	beams from its eye. Seemingly designed only for combat \
	this tank makes up for its lack of speed with devastating firepower. \
	When its eye focuses it is capable of producing a beam which annhilates \
	all in its path."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/construct/juggernaut/cyclops
	name = "Cyclops"
	real_name = "Cyclops"
	desc = "A creature of deadly gaze who brings oblivion to whatever crosses its site."
	icon_state = "cyclops"
	icon_living = "cyclops"
	special_attack_min_range = 1
	special_attack_max_range = 7
	special_attack_cooldown = 15 SECONDS

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/aggressive/blood_hunter
	projectiletype = /obj/projectile/beam/inversion/heavy

/mob/living/simple_mob/construct/juggernaut/cyclops/should_special_attack(atom/A)
	var/mob_count = 0				// Are there enough mobs?
	var/turf/T = get_turf(A)
	for(var/mob/M in range(T, 2))
		if(shares_iff_faction(M))
			return FALSE
		if(M in oview(src, special_attack_max_range))
			if(!M.stat)
				mob_count ++
	if(mob_count < 2)
		return FALSE
	else
		return TRUE

/mob/living/simple_mob/construct/juggernaut/cyclops/do_special_attack(atom/target)
	set waitfor = FALSE

	// Warm-up
	Beam(target, icon_state = "sat_beam", time = 2 SECONDS, maxdistance = INFINITY)
	visible_message(SPAN_WARNING( "The [src]'s eye begins to glow.!"))
	playsound(src, 'sound/hallucinations/i_see_you1.ogg', 100, 1)
	sleep(2 SECONDS)

	for(var/i = 1 to 12)
		if(target)
			var/turf/T = get_turf(target)
			if(T)
				visible_message(SPAN_WARNING( "[src] discharges a beam of concentrated energy!"))
				face_atom(T)
				var/obj/projectile/beam/inversion/oblivion/beam = new(loc)
				beam.old_style_target(T, src)
				beam.fire()
				sleep(0.25 SECONDS)

	visible_message(SPAN_WARNING( "The [src]'s eye dims."))
	playsound(src, 'sound/hallucinations/growl1.ogg', 50, 1)

/obj/projectile/beam/inversion/heavy
	name = "inversion beam"
	icon_state = "invert_heavy"
	fire_sound = 'sound/weapons/spiderlunge.ogg'
	damage_force = 30
	damage_tier = 6
	light_range = 3
	light_power = -3

	legacy_muzzle_type = /obj/effect/projectile/muzzle/inversion_heavy
	legacy_tracer_type = /obj/effect/projectile/tracer/inversion_heavy
	legacy_impact_type = /obj/effect/projectile/impact/inversion_heavy



/obj/projectile/beam/inversion/oblivion
	name = "oblivion beam"
	icon_state = "oblivion"
	fire_sound = 'sound/weapons/spiderlunge.ogg'
	damage_force = 50
	damage_tier = 6
	light_range = 4
	light_power = -4

	legacy_muzzle_type = /obj/effect/projectile/muzzle/oblivion
	legacy_tracer_type = /obj/effect/projectile/tracer/oblivion
	legacy_impact_type = /obj/effect/projectile/impact/oblivion

