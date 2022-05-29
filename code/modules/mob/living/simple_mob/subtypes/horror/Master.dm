/datum/category_item/catalogue/fauna/horror/Master
	name = "&^DOCTO***ELIX!!%%"
	desc = "%WARNING% PROCESSING FAILURE! RETURN SCANNER TO A CENTRAL \
	ADMINISTRATOR FOR IMMEDIATE MAINTENANCE! %ERROR%"
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/horror/Master
	name = "Dr. Helix"
	desc = "A massive pile of grotesque flesh and bulging tumor like growths. Every inch of its skin is undulating in every direction possible, bringing a literal definition to 'Skin Crawling.' Stuck in the middle of this monstrosity is a large AI core with a bloodied, emaciated man sewn into its circuitry."

	icon_state = "Helix"
	icon_living = "Helix"
	icon_dead = "m_dead"
	icon_rest = "Helix"
	faction = "horror"
	icon = 'icons/mob/horror_show/master.dmi'
	icon_gib = "generic_gib"
	anchored = 1
	catalogue_data = list(/datum/category_item/catalogue/fauna/horror/Master)

	attack_sound = 'sound/h_sounds/shitty_tim.ogg'

	maxHealth = 400
	health = 400

	melee_damage_lower = 5
	melee_damage_upper = 8
	grab_resist = 100

	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = list("smushes")
	friendly = list("nuzzles", "boops", "bumps against", "leans on")

	ai_holder_type = null

	meat_amount = 4
	meat_type = /obj/item/reagent_containers/food/snacks/meat/human
	bone_amount = 2
	hide_amount = 2
	exotic_amount = 2

/mob/living/simple_mob/horror/Master/death()
	playsound(src, 'sound/h_sounds/imbeciles.ogg', 50, 1)
	..()

/mob/living/simple_mob/horror/Master/bullet_act()
    playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
    ..()

/mob/living/simple_mob/horror/Master/attack_hand()
    playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
    ..()

/mob/living/simple_mob/horror/Master/hitby()
    playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
    ..()

/mob/living/simple_mob/horror/Master/attackby()
    playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
    ..()
