var/datum/species/shapeshifter/promethean/prometheans

// Species definition follows.
/datum/species/shapeshifter/promethean
	name = SPECIES_PROMETHEAN
	uid = SPECIES_ID_PROMETHEAN
	name_plural = "Prometheans"
	category = "Special"
	default_bodytype = BODYTYPE_PROMETHEAN

	blurb = {"
	Prometheans (Macrolimus artificialis) are a species of artificially-created gelatinous humanoids, chiefly characterized
	by their primarily liquid bodies and ability to change their bodily shape and color in order to mimic many forms of life.
	Derived from the Aetolian giant slime (Macrolimus vulgaris) inhabiting the warm, tropical planet of Aetolus, they are a
	relatively new lab-created sapient species, and as such many things about them have yet to be comprehensively studied.

	What has Science done?
	"}

	wikilink = "N/A"
	catalogue_data = list(/datum/category_item/catalogue/fauna/promethean)

	max_additional_languages = 4
	assisted_langs   = list(LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX) // Prometheans are weird, let's just assume they can use basically any language.

	show_ssd = "totally quiescent"
	death_message = "rapidly loses cohesion, splattering across the ground..."
	knockout_message = "collapses inwards, forming a disordered puddle of goo."
	remains_type = /obj/effect/debris/cleanable/ash

	hunger_factor = 0.07 //As of writing, original was 0.1 - Slows hunger rate (some more)
	reagent_tag = IS_SLIME
	mob_size   = MOB_MEDIUM
	bump_flag  = SLIME
	push_flags = ~HEAVY
	swap_flags = ~HEAVY

	species_flags = NO_SCAN | NO_SLIP | NO_MINOR_CUT | NO_HALLUCINATION | NO_INFECT
	species_appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_HAIR_COLOR | RADIATION_GLOWS | HAS_UNDERWEAR
	species_spawn_flags = SPECIES_SPAWN_ALLOWED

	health_hud_intensity = 2

	color_mult  = 1
	blood_color = "#05FF9B"
	flesh_color = "#05FFFB"

	blood_name = "gelatinous ooze"
	blood_volume = 560
	breath_type = null
	poison_type = null

	speech_bubble_appearance = "slime"

	male_cough_sounds   = list('sound/effects/slime_squish.ogg')
	female_cough_sounds = list('sound/effects/slime_squish.ogg')

	max_age = 80

	economic_modifier = 3

	gluttonous = 0
	virus_immune = TRUE
	slowdown = -0.2
	brute_mod = 0.5
	burn_mod  = 2
	oxy_mod   = 0
	flash_mod = 0.5 //No centralized, lensed eyes.
	item_slowdown_mod = 0.66

	cloning_modifier = /datum/modifier/cloning_sickness/promethean

	cold_level_1 = 280
	cold_level_2 = 220
	cold_level_3 = 130

	heat_level_1 = 320
	heat_level_2 = 370
	heat_level_3 = 600

	heat_discomfort_strings = list("You feel too warm.")
	cold_discomfort_strings = list("You feel too cool.")

	body_temperature = T20C	// Room temperature

	rarity_value = 5
	siemens_coefficient = 1 //As of writing, original was 0.4 (bad)

	genders = list(MALE, FEMALE, NEUTER, PLURAL)

	unarmed_types = list(/datum/unarmed_attack/slime_glomp)

	has_organ = list(
		O_BRAIN    = /obj/item/organ/internal/brain/slime,
		O_HEART    = /obj/item/organ/internal/heart/grey/colormatch/slime,
		O_REGBRUTE = /obj/item/organ/internal/regennetwork,
		O_REGBURN  = /obj/item/organ/internal/regennetwork/burn,
		O_REGOXY   = /obj/item/organ/internal/regennetwork/oxy,
		O_REGTOX   = /obj/item/organ/internal/regennetwork/tox,
	)

	dispersed_eyes = TRUE

	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest/unbreakable/slime),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin/unbreakable/slime),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/unbreakable/slime),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm/unbreakable/slime),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right/unbreakable/slime),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg/unbreakable/slime),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right/unbreakable/slime),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/unbreakable/slime),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/unbreakable/slime),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/unbreakable/slime),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/unbreakable/slime),
	)

	inherent_verbs = list(
		/mob/living/proc/eat_trash,
		/mob/living/proc/set_size,
		/mob/living/carbon/human/proc/promethean_select_opaqueness,
		/mob/living/carbon/human/proc/prommie_blobform,
		/mob/living/carbon/human/proc/regenerate,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_ears,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_tail,
		/mob/living/carbon/human/proc/shapeshifter_select_wings,
		/mob/living/carbon/human/proc/slime_feed,
		/mob/living/carbon/human/proc/succubus_drain_finalize,
		/mob/living/carbon/human/proc/succubus_drain_lethal,
		/mob/living/carbon/human/proc/succubus_drain,
	)

	valid_transform_species = list(
		SPECIES_HUMAN, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_SKRELL,
		SPECIES_DIONA, SPECIES_TESHARI, SPECIES_MONKEY, SPECIES_SERGAL,
		SPECIES_AKULA, SPECIES_NEVREAN, SPECIES_ZORREN_HIGH,
		SPECIES_ZORREN_FLAT, SPECIES_VULPKANIN, SPECIES_VASILISSAN,
		SPECIES_RAPALA, SPECIES_MONKEY_SKRELL, SPECIES_MONKEY_UNATHI,
		SPECIES_MONKEY_TAJ, SPECIES_MONKEY_AKULA, SPECIES_MONKEY_VULPKANIN,
		SPECIES_MONKEY_SERGAL, SPECIES_MONKEY_NEVREAN,
	)

	active_regen_mult = 0.66 //As of writing, original was 1 (good)
	heal_rate = 0.35
	trashcan = TRUE //They have goopy bodies. They can just dissolve things within them.

/datum/species/shapeshifter/promethean/New()
	..()
	prometheans = src

/datum/species/shapeshifter/promethean/equip_survival_gear(mob/living/carbon/human/H)
	var/boxtype = pick(list(
		/obj/item/storage/toolbox/lunchbox,
		/obj/item/storage/toolbox/lunchbox/heart,
		/obj/item/storage/toolbox/lunchbox/cat,
		/obj/item/storage/toolbox/lunchbox/nt,
		/obj/item/storage/toolbox/lunchbox/mars,
		/obj/item/storage/toolbox/lunchbox/cti,
		/obj/item/storage/toolbox/lunchbox/nymph,
		/obj/item/storage/toolbox/lunchbox/syndicate
	))	//Only pick the empty types

	var/obj/item/storage/toolbox/lunchbox/L = new boxtype(get_turf(H))
	new /obj/item/reagent_containers/food/snacks/candy/proteinbar(L)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(L, /datum/inventory_slot_meta/abstract/hand/right)
	else
		H.equip_to_slot_or_del(L, /datum/inventory_slot_meta/abstract/put_in_backpack)

/datum/species/shapeshifter/promethean/hug(mob/living/carbon/human/H, mob/living/target)

	if(H.zone_sel.selecting == "head" || H.zone_sel.selecting == "r_hand" || H.zone_sel.selecting == "l_hand")
		return ..()
	var/t_him = "them"
	if(ishuman(target))
		var/mob/living/carbon/human/T = target
		switch(T.identifying_gender)
			if(MALE)
				t_him = "him"
			if(FEMALE)
				t_him = "her"
	else
		switch(target.gender)
			if(MALE)
				t_him = "him"
			if(FEMALE)
				t_him = "her"

	H.visible_message(
		SPAN_NOTICE("\The [H] glomps [target] to make [t_him] feel better!"),
		SPAN_NOTICE("You glomp [target] to make [t_him] feel better!"),
	)

	H.apply_stored_shock_to(target)

/datum/species/shapeshifter/promethean/handle_death(mob/living/carbon/human/H)
	spawn(1)
		if(H)
			H.gib()

/datum/species/shapeshifter/promethean/get_blood_colour(mob/living/carbon/human/H)
	return (H ? rgb(H.r_skin, H.g_skin, H.b_skin) : ..())

/datum/species/shapeshifter/promethean/get_flesh_colour(mob/living/carbon/human/H)
	return (H ? rgb(H.r_skin, H.g_skin, H.b_skin) : ..())

/datum/species/shapeshifter/promethean/get_additional_examine_text(mob/living/carbon/human/H)

	if(!stored_shock_by_ref["\ref[H]"])
		return

	var/t_she = "She is"
	if(H.identifying_gender == MALE)
		t_she = "He is"
	else if(H.identifying_gender == PLURAL)
		t_she = "They are"
	else if(H.identifying_gender == NEUTER)
		t_she = "It is"
	else if(H.identifying_gender == HERM)
		t_she = "Shi is"

	switch(stored_shock_by_ref["\ref[H]"])
		if(1 to 10)
			return SPAN_NOTICE("[t_she] flickering gently with a little electrical activity.")
		if(11 to 20)
			return SPAN_NOTICE("[t_she] glowing gently with moderate levels of electrical activity.\n")
		if(21 to 35)
			return SPAN_WARNING("[t_she] glowing brightly with high levels of electrical activity.")
		if(35 to INFINITY)
			return SPAN_DANGER("[t_she] radiating massive levels of electrical activity!")

/mob/living/carbon/human/proc/prommie_blobform()
	set name = "Toggle Blobform"
	set desc = "Switch between amorphous and humanoid forms."
	set category = "Abilities"
	set hidden = FALSE

	var/atom/movable/to_locate = temporary_form || src
	if(!isturf(to_locate.loc))
		to_chat(to_locate, SPAN_WARNING("You need more space to perform this action!"))
		return

	//Human form
	else if(stat || paralysis || stunned || weakened || restrained())
		to_chat(src, SPAN_WARNING("You can only do this while not stunned."))
		return
	else
		prommie_intoblob()
