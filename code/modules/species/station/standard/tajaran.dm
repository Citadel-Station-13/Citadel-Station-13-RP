/datum/physiology_modifier/intrinsic/species/tajaran
	carry_strength_add = CARRY_STRENGTH_ADD_TAJARAN
	carry_strength_factor = CARRY_FACTOR_MOD_TAJARAN

/datum/species/tajaran
	uid = SPECIES_ID_TAJARAN
	id = SPECIES_ID_TAJARAN
	name = SPECIES_TAJ
	name_plural = "Tajaran"
	category = "Tajaran"
	default_bodytype = BODYTYPE_TAJARAN
	mob_physiology_modifier = /datum/physiology_modifier/intrinsic/species/tajaran

	icobase      = 'icons/mob/species/tajaran/body_greyscale.dmi'
	deform       = 'icons/mob/species/tajaran/deformed_body_greyscale.dmi'
	preview_icon = 'icons/mob/species/tajaran/preview.dmi'
	husk_icon    = 'icons/mob/species/tajaran/husk.dmi'

	sprite_accessory_defaults = list(
		SPRITE_ACCESSORY_SLOT_TAIL = /datum/sprite_accessory/tail/bodyset/tajaran,
	)

	max_additional_languages = 3
	name_language = /datum/prototype/language/tajaran
	intrinsic_languages = /datum/prototype/language/tajaran
	whitelist_languages = list(
		/datum/prototype/language/tajaran,
		/datum/prototype/language/tajaranakhani,
		/datum/prototype/language/tajsign
	)

	vision_innate = /datum/vision/baseline/species_tier_2
	vision_organ = O_EYES

	snow_movement = -1 //Ignores half of light snow

	brute_mod = 1.1
	burn_mod  = 1.1
	flash_mod = 1.1

	metabolic_rate = 1.1
	gluttonous = 0
	hunger_factor = 0.1

	color_mult = 1
	health_hud_intensity = 2.5

	max_age = 80


	blurb = {"
	The Tajara are a race of humanoids that possess markedly felinoid traits that include
	a semi-prehensile tail, a body covered in fur of varying shades, and padded, digitigrade feet.
	They are a naturally superstitious species, with the new generations growing up with tales of the struggles of surviving a great ice age.
	This spirit has led them forward to the reconstruction and advancement of their society to what they are today.
	Their pride for the struggles they went through is heavily tied to their spiritual beliefs.

	Recent discoveries have jump started the progression of highly advanced cybernetic technology, causing a culture shock within Tajaran society.
	 "}
	wikilink = "https://citadel-station.net/wikiRP/index.php?title=Race:_Tajara"
	catalogue_data = list(/datum/category_item/catalogue/fauna/tajaran)

	body_temperature = 320.15 //Even more cold resistant, even more flammable

	cold_level_1 = 200
	cold_level_2 = 140
	cold_level_3 = 80

	breath_cold_level_1 = 180
	breath_cold_level_2 = 100
	breath_cold_level_3 = 60

	heat_level_1 = 340
	heat_level_2 = 380
	heat_level_3 = 800

	breath_heat_level_1 = 360
	breath_heat_level_2 = 430
	breath_heat_level_3 = 1000

	primitive_form = SPECIES_MONKEY_TAJ

	species_spawn_flags = SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color  = "#333333"

	reagent_tag = IS_TAJARA

	move_trail = /obj/effect/debris/cleanable/blood/tracks/paw

	heat_discomfort_level   = 295 //Prevents heat discomfort spam at 20c
	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches.",
	)

	cold_discomfort_level = 275

	has_organ = list( //No appendix.
		O_HEART     = /obj/item/organ/internal/heart,
		O_LUNGS     = /obj/item/organ/internal/lungs,
		O_VOICE     = /obj/item/organ/internal/voicebox,
		O_LIVER     = /obj/item/organ/internal/liver,
		O_KIDNEYS   = /obj/item/organ/internal/kidneys,
		O_BRAIN     = /obj/item/organ/internal/brain,
		O_EYES      = /obj/item/organ/internal/eyes,
		O_STOMACH   = /obj/item/organ/internal/stomach,
		O_INTESTINE = /obj/item/organ/internal/intestine,
	)

	unarmed_types = list(
		/datum/melee_attack/unarmed/stomp,
		/datum/melee_attack/unarmed/kick,
		/datum/melee_attack/unarmed/claws,
		/datum/melee_attack/unarmed/bite/sharp,
	)

	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/hide_horns,
		/mob/living/carbon/human/proc/hide_wings,
		/mob/living/carbon/human/proc/hide_tail,
	)

/datum/species/tajaran/apply_racial_gear(mob/living/carbon/for_target, list/into_box, list/into_inv)
	var/footwear_type = /obj/item/clothing/shoes/sandal
	if(for_target && !for_target.inventory?.get_slot_single(/datum/inventory_slot/inventory/shoes))
		var/obj/item/footwear_instance = new footwear_type
		if(!for_target.inventory.equip_to_slot_if_possible(footwear_instance, /datum/inventory_slot/inventory/shoes))
			into_inv += footwear_instance
	else
		into_inv += footwear_type
	return ..()
