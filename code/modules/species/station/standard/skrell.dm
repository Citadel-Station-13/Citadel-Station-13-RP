#define WETFLOOR_COST 50
/datum/species/skrell
	uid = SPECIES_ID_SKRELL
	id = SPECIES_ID_SKRELL
	name = SPECIES_SKRELL
	name_plural = SPECIES_SKRELL
	primitive_form = SPECIES_MONKEY_SKRELL
	category = "Skrell"
	icobase = 'icons/mob/species/skrell/body_greyscale.dmi'
	deform = 'icons/mob/species/skrell/deformed_body_greyscale.dmi'

	blurb = {"
	An amphibious species, Skrell come from the star system known as Qerr'Vallis, which translates
	to 'Star of the royals' or 'Light of the Crown'.

	Skrell are a highly advanced and logical race who live under the rule  of the Qerr'Katish, a
	caste within their society which keeps the empire of the Skrell running smoothly.  Skrell are
	herbivores on the whole and tend to be co-operative with the other species of the galaxy, although
	they rarely reveal the secrets of their empire to their allies.
	"}

	wikilink = "https://citadel-station.net/wikiRP/index.php?title=Skrell"
	catalogue_data = list(/datum/category_item/catalogue/fauna/skrell)

	max_additional_languages = 3
	name_language    = LANGUAGE_ID_SKRELL
	intrinsic_languages = LANGUAGE_ID_SKRELL
	whitelist_languages = list(
		LANGUAGE_ID_SKRELL,
		LANGUAGE_ID_SKRELL_ALT,
		LANGUAGE_ID_TESHARI
	)
	assisted_langs   = list(LANGUAGE_EAL, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX, LANGUAGE_PROMETHEAN)

	movement_base_speed = 5.5
	color_mult = 1
	health_hud_intensity = 2

	water_movement = -3

	max_age = 130

	vision_innate = /datum/vision/baseline/species_tier_2
	vision_organ = O_EYES

	flash_mod  = 1.2
	chemOD_mod = 0.9

	bloodloss_rate = 1.5

	ambiguous_genders = TRUE

	species_flags = NO_SLIP
	species_spawn_flags = SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#8CD7A3"
	blood_color = "#1D2CBF"
	base_color  = "#006666"

	cold_level_1 = 280
	cold_level_2 = 220
	cold_level_3 = 130

	breath_cold_level_1 = 250
	breath_cold_level_2 = 190
	breath_cold_level_3 = 120

	heat_level_1 = 420
	heat_level_2 = 480
	heat_level_3 = 1100

	breath_heat_level_1 = 400
	breath_heat_level_2 = 500
	breath_heat_level_3 = 1350

	reagent_tag = null

	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/skrell),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right),
	)

	unarmed_types = list(
		/datum/melee_attack/unarmed/punch,
	)

	abilities = list(
		/datum/ability/species/skrell/puddle
	)

/datum/species/skrell/can_breathe_water()
	return TRUE

/datum/ability/species/skrell
	abstract_type = /datum/ability/species/skrell
	category = "Skrell"
	always_bind = TRUE
	ability_check_flags = NONE
	action_icon = 'icons/screen/actions/actions.dmi'

	//cost in water, drink up skrellies
	var/hydration_cost

/datum/ability/species/skrell/check_trigger(mob/user, toggling)
	. = ..()
	if(!.)
		return
	if(!ishuman(owner))
		return FALSE
	if(istype(owner,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = owner

		if(hydration_cost > H.hydration)
			to_chat(user,"<span class = 'notice'>We are too dry! Drink more!</span>")
			return FALSE
		else
			return TRUE
	else
		return TRUE

/datum/ability/species/skrell/puddle
	name = "Puddle"
	desc = "Concentrate on all of your glands to leave a puddle of water on the ground."
	action_state = "pissbomb"
	cooldown = 5 SECONDS
	hydration_cost = WETFLOOR_COST //50

/datum/ability/species/skrell/puddle/on_trigger()
	. = ..()
	if(!ishuman(owner))
		return
	var/turf/T = get_turf(owner)
	if(T)
		var/datum/reagent_holder/R = new /datum/reagent_holder(10)
		R.add_reagent("water", 10)
		T.reagents = R
		T.clean(T, owner, 1)

		owner.visible_message(
		SPAN_WARNING("[owner] secretes a lot of liquid, wetting the floor underneath!"),
		SPAN_NOTICE("You strain all of your glands, releasing a splash of liquid right underneath you.")
		)
		playsound(T, 'sound/effects/slosh.ogg', 25, 1)
