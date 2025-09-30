////////////////////////////
//			Alpha Wraith
////////////////////////////

/mob/living/simple_mob/construct/nuclear/alphawraith
	name = "Alphawraith"
	real_name = "alphawraith"
	desc = "A creature composed of four skulls glowing a bright pink. The two brighter skulls hurt to look at directly."
	icon_state = "alphawraith"
	icon_living = "alphawraith"
	icon_dead = "atomic_dead"
	maxHealth = 100
	health = 100
	catalogue_data = list(/datum/category_item/catalogue/fauna/nuclear_spirits/alphawraith)

	response_help  = "glows menacingly at"
	response_disarm = "flails at"
	response_harm   = "swipes"

	legacy_melee_damage_lower = 5
	legacy_melee_damage_upper = 15
	attacktext = list("headbutts", "bites")

	minbodytemp = 0
	maxbodytemp = 4000
	min_oxy = 0
	max_co2 = 0
	max_tox = 0

	universal_speak = 1

	loot_list = list(/obj/effect/debris/cleanable/greenglow = 100)

	projectiletype = /obj/projectile/beam/alpha_rad
	projectilesound = 'sound/items/geiger/ext3.ogg'

	base_attack_cooldown = 20
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged

/datum/category_item/catalogue/fauna/nuclear_spirits/alphawraith
	name = "%#ERROR#%"
	desc = "%ERROR% RADIATION DETECTED DATA CORRUPTED. %ERROR%"
	value = CATALOGUER_REWARD_TRIVIAL


/mob/living/simple_mob/construct/nuclear/alphawraith/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/horror_aura)
	AddComponent(/datum/component/radioactive, 750 , 0, TRUE, RAD_FALLOFF_CONTAMINATION_NORMAL)

/mob/living/simple_mob/construct/nuclear/alphawraith/handle_light()
	. = ..()
	if(. == 0 && !is_dead())
		set_light(5, 1, COLOR_PINK)
		return 1

/mob/living/simple_mob/construct/nuclear/alphawraith/death()
	for(var/mob/M in viewers(src, null))
		if((M.client && !( M.has_status_effect(/datum/status_effect/sight/blindness) )))
			M.show_message("<font color='red'>[src] screeches and explodes in a green flash.</font>")
	playsound(src, 'sound/items/geiger/ext1.ogg', 100, 1)
	ghostize()
	qdel(src)

