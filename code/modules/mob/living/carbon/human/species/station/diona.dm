
/datum/species/diona
	name = SPECIES_DIONA
	name_plural = "Dionaea"
	icobase = 'icons/mob/human_races/r_diona.dmi'
	deform = 'icons/mob/human_races/r_def_plant.dmi'
	language = LANGUAGE_ROOTLOCAL
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/diona)
	//primitive_form = "Nymph"
	slowdown = 2.5
	snow_movement = -2 	//Ignore light snow
	water_movement = -4	//Ignore shallow water
	rarity_value = 3
	hud_type = /datum/hud_data/diona
	siemens_coefficient = 0.3
	show_ssd = "completely quiescent"
	health_hud_intensity = 2.5
	item_slowdown_mod = 0.1

	num_alternate_languages = 2
	name_language = LANGUAGE_ROOTLOCAL
	species_language = LANGUAGE_ROOTLOCAL
	secondary_langs = list(LANGUAGE_ROOTGLOBAL)
	assisted_langs = list(LANGUAGE_VOX)	// Diona are weird, let's just assume they can use basically any language.
	min_age = 18
	max_age = 300

	economic_modifier = 4

	blurb = "Commonly referred to (erroneously) as 'plant people', the Dionaea are a strange space-dwelling collective \
	species hailing from Epsilon Ursae Minoris. Each 'diona' is a cluster of numerous cat-sized organisms called nymphs; \
	there is no effective upper limit to the number that can fuse in gestalt, and reports exist	of the Epsilon Ursae \
	Minoris primary being ringed with a cloud of singing space-station-sized entities.<br/><br/>The Dionaea coexist peacefully with \
	all known species, especially the Skrell. Their communal mind makes them slow to react, and they have difficulty understanding \
	even the simplest concepts of other minds. Their alien physiology allows them survive happily off a diet of nothing but light, \
	water and other radiation."
	catalogue_data = list(/datum/category_item/catalogue/fauna/dionaea)

	has_organ = list(
		O_NUTRIENT = /obj/item/organ/internal/diona/nutrients,
		O_STRATA   = /obj/item/organ/internal/diona/strata,
		O_BRAIN    = /obj/item/organ/internal/brain/cephalon,
		O_RESPONSE = /obj/item/organ/internal/diona/node,
		O_GBLADDER = /obj/item/organ/internal/diona/bladder,
		O_POLYP    = /obj/item/organ/internal/diona/polyp,
		O_ANCHOR   = /obj/item/organ/internal/diona/ligament
		)

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/diona/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/diona/groin),
		BP_HEAD  =  list("path" = /obj/item/organ/external/head/no_eyes/diona),
		BP_L_ARM =  list("path" = /obj/item/organ/external/diona/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/diona/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/diona/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/diona/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/diona/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/diona/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/diona/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/diona/foot/right)
		)

	dispersed_eyes = TRUE//Its a bunch of nymphes that means it has eyes everywhere

	inherent_verbs = list(
		/mob/living/carbon/human/proc/diona_split_nymph,
		/mob/living/carbon/human/proc/regenerate
		)

	warning_low_pressure = 10
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 2000
	heat_level_2 = 3000
	heat_level_3 = 4000

	body_temperature = T0C + 15		//make the plant people have a bit lower body temperature, why not
	hunger_factor = 0//Handled in handle_environment_special()

	flags = NO_MINOR_CUT | IS_PLANT | NO_SCAN | NO_PAIN | NO_SLIP | NO_HALLUCINATION | NO_BLOOD | CONTAMINATION_IMMUNE
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_WHITELIST_SELECTABLE

	blood_color = "#004400"
	flesh_color = "#907E4A"

	reagent_tag = IS_DIONA

	genders = list(PLURAL)

	wikilink="https://wiki.vore-station.net/Diona"

/datum/species/diona/can_understand(var/mob/other)
	var/mob/living/carbon/alien/diona/D = other
	if(istype(D))
		return 1
	return 0

/datum/species/diona/equip_survival_gear(var/mob/living/carbon/human/H)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/flashlight/flare(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/flashlight/flare(H.back), slot_in_backpack)

/datum/species/diona/handle_post_spawn(var/mob/living/carbon/human/H)
	H.gender = NEUTER
	return ..()

/datum/species/diona/handle_death(var/mob/living/carbon/human/H)

	var/mob/living/carbon/alien/diona/S = new(get_turf(H))

	if(H.mind)
		H.mind.transfer_to(S)

	if(H.isSynthetic())
		H.visible_message("<span class='danger'>\The [H] collapses into parts, revealing a solitary diona nymph at the core.</span>")

		H.species = GLOB.all_species[SPECIES_HUMAN] // This is hard-set to default the body to a normal FBP, without changing anything.

		for(var/obj/item/organ/internal/diona/Org in H.internal_organs) // Remove Nymph organs.
			qdel(Org)

		// Purge the diona verbs.
		H.verbs -= /mob/living/carbon/human/proc/diona_split_nymph
		H.verbs -= /mob/living/carbon/human/proc/regenerate

		return

	for(var/mob/living/carbon/alien/diona/D in H.contents)
		if(D.client)
			D.forceMove(get_turf(H))
		else
			qdel(D)

	H.visible_message("<span class='danger'>\The [H] splits apart with a wet slithering noise!</span>")

/datum/species/diona/handle_environment_special(var/mob/living/carbon/human/H)
	if(H.inStasisNow())
		return

	var/obj/item/organ/internal/diona/node/light_organ = locate() in H.internal_organs

	if(light_organ && !light_organ.is_broken())
		var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
		if(isturf(H.loc)) //else, there's considered to be no light
			var/turf/T = H.loc
			light_amount = T.get_lumcount() * 10
		H.nutrition += light_amount
		H.shock_stage -= light_amount

		if(H.nutrition > 300)
			H.nutrition = 300
		if(light_amount >= 3 && H.nutrition >= 100) //if there's enough light, heal
			H.adjustBruteLoss(-(round(light_amount/2)))
			H.adjustFireLoss(-(round(light_amount/2)))
			H.adjustToxLoss(-(light_amount))
			H.adjustOxyLoss(-(light_amount))
			//TODO: heal wounds, heal broken limbs.

	else if(H.nutrition < 100)
		H.take_overall_damage(2,0)

		//traumatic_shock is updated every tick, incrementing that is pointless - shock_stage is the counter.
		//Not that it matters much for diona, who have NO_PAIN.
		H.shock_stage++
