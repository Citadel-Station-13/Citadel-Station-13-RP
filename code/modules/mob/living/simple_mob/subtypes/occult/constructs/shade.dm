////////////////////////////
//			Shade
////////////////////////////

/datum/category_item/catalogue/fauna/construct/shade
	name = "%#ERROR#%"
	desc = "%ERROR% SCAN DATA REDACTED. RETURN SCANNER TO A \
	CENTRAL ADMINISTRATOR FOR IMMEDIATE MAINTENANCE. %ERROR%"
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/construct/shade
	name = "Shade"
	real_name = "Shade"
	desc = "A bound spirit"
	icon_state = "shade"
	icon_living = "shade"
	icon_dead = "shade_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/construct/shade)

	response_help  = "puts their hand through"
	response_disarm = "flails at"
	response_harm   = "punches"

	melee_damage_lower = 5
	melee_damage_upper = 15
	attack_armor_pen = 100	//It's a ghost/horror from beyond, I ain't gotta explain 100 AP
	attacktext = list("drained the life from")

	minbodytemp = 0
	maxbodytemp = 4000
	min_oxy = 0
	max_co2 = 0
	max_tox = 0

	universal_speak = 1

	loot_list = list(/obj/item/ectoplasm = 100)

	ai_holder_type = /datum/ai_holder/simple_mob/melee

/mob/living/simple_mob/construct/shade/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/horror_aura/weak)

/mob/living/simple_mob/construct/shade/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/soulstone))
		var/obj/item/soulstone/S = O;
		S.transfer_soul("SHADE", src, user)
		return
	..()

/mob/living/simple_mob/construct/shade/death()
	..()
	for(var/mob/M in viewers(src, null))
		if((M.client && !( M.blinded )))
			M.show_message("<font color='red'>[src] lets out a contented sigh as their form unwinds.</font>")

	ghostize()
	qdel(src)
	return

//Lavaland Shades
/mob/living/simple_mob/construct/shade/surt
	name = "Lingering Shade"
	real_name = "Lingering Shade"
	desc = "This spirit was bound to this planet ages ago. Its masters have long since passed, and the war it served in has been forgotten. The energies binding it remain."

	heat_resist = 1
