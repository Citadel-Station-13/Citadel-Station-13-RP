////////////////////////////
//			Demoncore
////////////////////////////

/datum/category_item/catalogue/fauna/nuclear_spirits/demoncore
	name = "%#ERROR#%"
	desc = "%ERROR% RADIATION DETECTED DATA CORRUPTED. %ERROR%"
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/construct/nuclear/demoncore //A big ball of radiation, kills enemies by giving them radiation poisoning
	name = "Demon Core"
	real_name = "Demon Core"
	desc = "Floating in the sky appears to a plutonium sphere undergoing a perpetual criticality incident. It seems to desire to meet you closely."
	icon_state = "demoncore"
	icon_living = "demoncore"
	maxHealth = 200 //Tanky but not tough this thing just wants to be alive long enough to spread its radiation.
	health = 200
	response_harm = "viciously beaten"
	harm_intent_damage = 5
	legacy_melee_damage_lower = 20
	legacy_melee_damage_upper = 25 //Come to think of it this is probably real dense to be ramming people
	attack_armor_pen = 50
	attacktext = list("rammed")
	attack_sound = 'sound/effects/clang1.ogg'
	movement_base_speed = 10 / 4
	catalogue_data = list(/datum/category_item/catalogue/fauna/nuclear_spirits/demoncore)

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive

	armor_legacy_mob = list(
				"melee" = 70,
				"bullet" = 30,
				"laser" = 30,
				"energy" = 30,
				"bomb" = 10,
				"bio" = 100,
				"rad" = 100)

/mob/living/simple_mob/construct/nuclear/demoncore/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/horror_aura)
	AddComponent(/datum/component/radioactive, 1250 , 0, TRUE, RAD_FALLOFF_CONTAMINATION_NORMAL)

/mob/living/simple_mob/construct/nuclear/demoncore/handle_light()
	. = ..()
	if(. == 0 && !is_dead())
		set_light(6, 1, COLOR_BLUE)
		return 1

/mob/living/simple_mob/construct/nuclear/demoncore/death()
	for(var/mob/M in viewers(src, null))
		if((M.client && !( M.has_status_effect(/datum/status_effect/sight/blindness) )))
			M.show_message("<font color='red'>[src] screeches and explodes in a blue flash.</font>")
	playsound(src, 'sound/items/geiger/ext1.ogg', 100, 1)
	ghostize()
	qdel(src)

