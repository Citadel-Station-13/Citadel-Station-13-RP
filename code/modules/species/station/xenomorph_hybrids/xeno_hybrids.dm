/datum/species/xenohybrid
	name = SPECIES_XENOHYBRID
	name_plural = "Xenomorph Hybrids"
	uid = SPECIES_ID_XENOHYBRID
	default_bodytype = BODYTYPE_XENOHYBRID

	icobase = 'icons/mob/species/xenohybrid/body.dmi'
	deform  = 'icons/mob/species/xenohybrid/deformed_body.dmi'

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
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR

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
		/mob/living/proc/toggle_pass_table,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/sonar_ping,
		/mob/living/carbon/human/proc/psychic_whisper,
		/mob/living/carbon/human/proc/hybrid_resin,
		/mob/living/carbon/human/proc/hybrid_plant//replaced from the normal weed node to place a singular weed
		)

	total_health = 110	//Exoskeleton makes you tougher than baseline
	brute_mod = 0.95 // Chitin is somewhat hard to crack
	burn_mod = 1.5	// Natural enemy of xenomorphs is fire. Upgraded to Major Burn Weakness. Reduce to Minor if this is too harsh.
	blood_volume = 560	//Baseline
	darksight = 6 //Better hunters in the dark.
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
		O_RESIN =		/obj/item/organ/internal/xenos/resinspinner,
		)
	vision_organ = O_BRAIN//Neomorphs have no (visible) Eyes, seeing without them should be possible.

	reagent_tag = IS_XENOHYBRID

/datum/species/xenohybrid/can_breathe_water()
	return TRUE	//they dont quite breathe

/datum/species/xenohybrid/handle_environment_special(var/mob/living/carbon/human/H)
	var/heal_amount = min(H.nutrition, 200) / 50 //Not to much else we might as well give them a diona like healing
	H.nutrition = max(H.nutrition-heal_amount,0)

	if(H.resting)
		heal_amount *= 1.05//resting allows you to heal a little faster
	var/fire_damage = H.getFireLoss()
	if(fire_damage >= heal_amount)
		H.adjustFireLoss(-heal_amount)
		heal_amount = 0;
		return
	if(fire_damage < heal_amount)
		H.adjustFireLoss(-heal_amount)
		heal_amount -= fire_damage

	var/trauma_damage = H.getBruteLoss()
	if(trauma_damage >= heal_amount)
		H.adjustBruteLoss(-heal_amount)
		heal_amount = 0;
		return
	if(trauma_damage < heal_amount)
		H.adjustBruteLoss(-heal_amount)
		heal_amount -= trauma_damage

	var/posion_damage = H.getToxLoss()
	if(posion_damage >= heal_amount)
		H.adjustToxLoss(-heal_amount)
		heal_amount = 0;
		return
	if(posion_damage < heal_amount)
		H.adjustToxLoss(-heal_amount)
		heal_amount -= posion_damage

	H.nutrition += heal_amount
