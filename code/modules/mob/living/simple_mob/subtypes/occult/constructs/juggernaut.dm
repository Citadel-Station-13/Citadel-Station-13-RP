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


	movement_cooldown = 6 //Not super fast, but it might catch up to someone in armor who got punched once or twice.

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
