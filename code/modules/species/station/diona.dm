/datum/physiology_modifier/intrinsic/species/diona
	carry_strength_add = CARRY_STRENGTH_ADD_DIONA
	carry_strength_factor = CARRY_FACTOR_MOD_DIONA

/datum/species/diona
	uid = SPECIES_ID_DIONA
	id = SPECIES_ID_DIONA
	name = SPECIES_DIONA
	name_plural = "Dionaea"
	//primitive_form = "Nymph"
	mob_physiology_modifier = /datum/physiology_modifier/intrinsic/species/diona

	icobase      = 'icons/mob/species/diona/body.dmi'
	deform       = 'icons/mob/species/diona/deformed_body.dmi'
	preview_icon = 'icons/mob/species/diona/preview.dmi'

	max_additional_languages = 2
	name_language = LANGUAGE_ID_DIONA
	base_skin_colours = list(
		"Standard"  = null,
		"Alternate" = "alt",
	)

	intrinsic_languages = list(
		LANGUAGE_ID_DIONA,
		LANGUAGE_ID_DIONA_HIVEMIND
	)
	assisted_langs   = list(LANGUAGE_VOX)	// Diona are weird, let's just assume they can use basically any language.

	movement_base_speed = 3
	light_slowdown = -0.5
	dark_slowdown = 3
	snow_movement  = -2 // Ignore light snow
	water_movement = -4 // Ignore shallow water
	siemens_coefficient = 0.3
	show_ssd = "completely quiescent"
	health_hud_intensity = 2.5
	item_slowdown_mod = 0.1

	max_age = 300


	blurb = {"
	Commonly referred to (erroneously) as 'plant people', the Dionaea are a strange space-dwelling collective
	species hailing from Epsilon Ursae Minoris. Each 'diona' is a cluster of numerous cat-sized organisms called nymphs;
	there is no effective upper limit to the number that can fuse in gestalt, and reports exist	of the Epsilon Ursae
	Minoris primary being ringed with a cloud of singing space-station-sized entities.

	The Dionaea coexist peacefully with all known species, especially the Skrell. Their communal mind makes them
	slow to react, and they have difficulty understanding even the simplest concepts of other minds. Their alien
	physiology allows them survive happily off a diet of nothing but light, water and other radiation.
	"}
	wikilink = "https://citadel-station.net/wikiRP/index.php?title=Race:_Dionea"
	catalogue_data = list(/datum/category_item/catalogue/fauna/dionaea)
	//rarity_value   = 3

	has_organ = list(
		O_NUTRIENT = /obj/item/organ/internal/diona/nutrients,
		O_STRATA   = /obj/item/organ/internal/diona/strata,
		O_BRAIN    = /obj/item/organ/internal/brain/cephalon,
		O_RESPONSE = /obj/item/organ/internal/diona/node,
		O_GBLADDER = /obj/item/organ/internal/diona/bladder,
		O_POLYP    = /obj/item/organ/internal/diona/polyp,
		O_ANCHOR   = /obj/item/organ/internal/diona/ligament,
	)
	vision_organ = O_BRAIN

	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/diona/chest),
		BP_GROIN  = list("path" = /obj/item/organ/external/diona/groin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/no_eyes/diona),
		BP_L_ARM  = list("path" = /obj/item/organ/external/diona/arm),
		BP_R_ARM  = list("path" = /obj/item/organ/external/diona/arm/right),
		BP_L_LEG  = list("path" = /obj/item/organ/external/diona/leg),
		BP_R_LEG  = list("path" = /obj/item/organ/external/diona/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/diona/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/diona/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/diona/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/diona/foot/right),
	)

	dispersed_eyes = TRUE//Its a bunch of nymphes that means it has eyes everywhere

	unarmed_types = list(
		/datum/melee_attack/unarmed/stomp,
		/datum/melee_attack/unarmed/kick,
		/datum/melee_attack/unarmed/diona,
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/diona_split_nymph,
		/mob/living/carbon/human/proc/regenerate,
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

	species_flags = NO_MINOR_CUT | IS_PLANT | NO_SCAN | NO_PAIN | NO_SLIP | NO_HALLUCINATION | NO_BLOOD | CONTAMINATION_IMMUNE
	species_spawn_flags = SPECIES_SPAWN_CHARACTER | SPECIES_SPAWN_WHITELISTED
	species_appearance_flags = HAS_BASE_SKIN_COLOR

	blood_color = "#004400"
	flesh_color = "#907E4A"
	base_color = "#ffffff"

	reagent_tag = IS_DIONA

	genders = list(PLURAL)

	//* Inventory *//

	inventory_slots = list(
		/datum/inventory_slot/inventory/back::id,
		/datum/inventory_slot/inventory/suit::id = list(
			INVENTORY_SLOT_REMAP_MAIN_AXIS = 0,
			INVENTORY_SLOT_REMAP_CROSS_AXIS = 1,
		),
		/datum/inventory_slot/inventory/suit_storage::id,
		/datum/inventory_slot/inventory/uniform::id,
		/datum/inventory_slot/inventory/ears/left::id = list(
			INVENTORY_SLOT_REMAP_MAIN_AXIS = 2,
			INVENTORY_SLOT_REMAP_CROSS_AXIS = 2,
		),
		/datum/inventory_slot/inventory/ears/right::id,
		/datum/inventory_slot/inventory/pocket/left::id,
		/datum/inventory_slot/inventory/pocket/right::id,
		/datum/inventory_slot/inventory/id::id,
		/datum/inventory_slot/inventory/head::id = list(
			INVENTORY_SLOT_REMAP_MAIN_AXIS = 1,
			INVENTORY_SLOT_REMAP_CROSS_AXIS = 1,
		),
	)

/datum/species/diona/can_understand(mob/other)
	var/mob/living/carbon/alien/diona/D = other
	if(istype(D))
		return TRUE
	return FALSE

/datum/species/diona/handle_death(mob/living/carbon/human/H)

	var/mob/living/carbon/alien/diona/S = new(get_turf(H))

	if(H.mind)
		H.mind.transfer(S)

	if(H.isSynthetic())
		H.visible_message(SPAN_DANGER("\The [H] collapses into parts, revealing a solitary diona nymph at the core."))
		H.set_species(SScharacters.resolve_species_path(/datum/species/human), skip = TRUE, force = TRUE)

		for(var/obj/item/organ/internal/diona/Org in H.internal_organs) // Remove Nymph organs.
			qdel(Org)

		// Purge the diona verbs.
		remove_verb(H, /mob/living/carbon/human/proc/diona_split_nymph)
		remove_verb(H, /mob/living/carbon/human/proc/regenerate)

		return

	for(var/mob/living/carbon/alien/diona/D in H.contents)
		if(D.client)
			D.forceMove(get_turf(H))
		else
			qdel(D)

	H.visible_message(
		SPAN_DANGER("\The [H] splits apart with a wet slithering noise!"),
		SPAN_NOTICE("You split apart with a wet slithering noise!"),
		SPAN_HEAR("You hear a wet slithering noise!"),
	)

/datum/species/diona/handle_environment_special(mob/living/carbon/human/H, datum/gas_mixture/environment, dt)
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

		if(H.nutrition > max_nutrition)
			H.nutrition = max_nutrition
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
