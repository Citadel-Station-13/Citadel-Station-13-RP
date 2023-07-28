/datum/species/xenohybrid
	name = SPECIES_XENOHYBRID
	name_plural = "Xenomorph Hybrids"
	uid = SPECIES_ID_XENOHYBRID
	id = SPECIES_ID_XENOHYBRID
	default_bodytype = BODYTYPE_XENOHYBRID

	icobase = 'icons/mob/species/xenohybrid/body.dmi'
	deform  = 'icons/mob/species/xenohybrid/deformed_body.dmi'

	base_skin_colours = list(
		"Standard"  = null,
		"Alternate" = "alt",
	)

	tail = "tail"
	icobase_tail = 1
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	max_additional_languages = 2

	max_age = 150//Xenomorphs probably get pretty old if not shot dead

	blurb = "Xenohybrids are descendens of an isolated Xenomorph Hive that lost its Hivemind. \
	Xenohybrids are civilised and capable of communicating with other species, without knowing their language. \
	Over the years crusading the stars xenomorphs gathered genetic material of almost all known species(and probably some unknown as well), \
	allowing Xenohybrids to reproduce with most other species. This reproduction is not as invasive as the facehuggers of their relatives, \
	but can still be dangerous to the host. Their chitinous exoskeleton allows them to endure low pressure and freezing cold \
	quite well, but leaves them vurnerable to fire and heat."
	catalogue_data = list(/datum/category_item/catalogue/fauna/xenohybrid)
	wikilink = "https://citadel-station.net/wikiRP/index.php?title=Race:_Neomorphs"

	intrinsic_languages = LANGUAGE_ID_XENOMORPH
	name_language = LANGUAGE_ID_XENOMORPH
	max_additional_languages = 3

	species_flags = NO_MINOR_CUT | CONTAMINATION_IMMUNE//Chitin like VASILISSANs should have the same flags
	species_spawn_flags = SPECIES_SPAWN_CHARACTER | SPECIES_SPAWN_WHITELISTED
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_BASE_SKIN_COLOR

	blood_color = "#12ff12"
	flesh_color = "#201730"
	base_color = "#201730"

	heat_discomfort_strings = list(
		"Your chitin feels extremely warm.",
		"You feel uncomfortably warm.",
		"Your chitin feels hot."
		)
	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/hide_horns,
		/mob/living/carbon/human/proc/hide_wings,
		/mob/living/carbon/human/proc/hide_tail,
		/mob/living/carbon/human/proc/psychic_whisper,
		)

	abilities = list(
		/datum/ability/species/sonar,
		/datum/ability/species/toggle_agility,
		/datum/ability/species/xenomorph_hybrid/regenerate,
	)
	total_health = 150	//Exoskeleton makes you tougher than baseline
	brute_mod = 0.95 // Chitin is somewhat hard to crack
	burn_mod = 1.5	// Natural enemy of xenomorphs is fire. Upgraded to Major Burn Weakness. Reduce to Minor if this is too harsh.
	blood_volume = 560	//Baseline
	vision_innate = /datum/vision/baseline/species_tier_2
	hunger_factor = 0.1 //In exchange, they get hungry a tad faster.

	slowdown = -0.2//Speedboost Tesh have -0.5

	warning_low_pressure = 30//lower than baseline
	hazard_low_pressure = -1//Vacuum proof

	warning_high_pressure = 325//Both baseline
	hazard_high_pressure = 550

	//Doesnt work, defaults are set at checks
	//breath_type = null	//they don't breathe
	//poison_type = null

	cold_level_1 = 90	//Space if fucking cold, so we need low temperature tolerance
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 350	//dont like the heat
	heat_level_2 = 400
	heat_level_3 = 700

	//Organ-List to remove need to breath(?)
	has_organ = list(
		O_HEART =		/obj/item/organ/internal/heart,
		O_VOICE = 		/obj/item/organ/internal/voicebox,
		O_LIVER =		/obj/item/organ/internal/liver,
		O_KIDNEYS =		/obj/item/organ/internal/kidneys,
		O_BRAIN =		/obj/item/organ/internal/brain,
		O_PLASMA =		/obj/item/organ/internal/xenos/plasmavessel/hunter,//Important for the xenomorph abilities, hunter to have a pretty small plasma capacity
		O_STOMACH =		/obj/item/organ/internal/stomach,
		O_INTESTINE =	/obj/item/organ/internal/intestine,
		O_RESIN =		/obj/item/organ/internal/xenos/resinspinner/hybrid,
		)
	vision_organ = O_BRAIN//Neomorphs have no (visible) Eyes, seeing without them should be possible.

	reagent_tag = IS_XENOHYBRID

	var/heal_rate = 0.5 //Lets just create a set number

/datum/species/xenohybrid/can_breathe_water()
	return TRUE	//they dont quite breathe

/datum/species/xenohybrid/proc/handle_healing_conditions(var/mob/living/carbon/human/H)
	var/healing_factor = 1
	if(H.lying)
		healing_factor *= 1.2
	if(H.active_regen)
		if(!H.lying)
			to_chat(H, SPAN_BOLDWARNING("You need to lie down to benefit from your enhanced regeneration"))
			H.active_regen = FALSE
		else if(H.nutrition < 50)
			to_chat(H, SPAN_BOLDWARNING("You are too hungry to benefit from your enhanced regeneration"))
			H.active_regen = FALSE
		healing_factor *= 4
	var/turf/T = get_turf(H)
	if(/obj/structure/alien/weeds in T.contents)
		healing_factor *= 1.1
	if(/obj/structure/bed/hybrid_nest in T.contents)
		healing_factor *= 1.2

	return healing_factor // highest value is 6,336

/datum/species/xenohybrid/handle_environment_special(mob/living/carbon/human/H)
	var/heal_amount = heal_rate * handle_healing_conditions(H)

	var/nutrition_debt = (H.getFireLoss() ? heal_rate : 0)//Heal rate and not heal_amount, since we want to reward taking the modifiers
	H.adjustFireLoss(-heal_amount)
	nutrition_debt += (H.getBruteLoss() ? heal_rate : 0)
	H.adjustBruteLoss(-heal_amount)
	nutrition_debt += (H.getToxLoss() ? heal_rate : 0)
	H.adjustToxLoss(-heal_amount)

	H.nutrition -= nutrition_debt
	if(H.nutrition < 100 || heal_amount <= 0.6)
		return

	if(H.vessel.get_reagent_amount("blood") <= blood_level_safe && H.try_take_nutrition(heal_amount * 4))
		H.vessel.add_reagent("blood", heal_amount)//instead of IB healing, they regenerate blood a lot faster

