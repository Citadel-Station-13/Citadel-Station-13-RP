/datum/species/adherent
	name = SPECIES_ADHERENT
	name_plural = "Adherents"
	uid = SPECIES_ID_ADHERENT
	default_bodytype = BODYTYPE_ADHERENT

	blurb = "The Vigil is a relatively loose association of machine-servitors, Adherents, \
	built by an extinct culture. They are devoted to the memory of their long-dead creators, \
	whose home system and burgeoning stellar empire was scoured to bedrock by a solar flare. \
	Physically, they are large, floating squidlike machines made of a crystalline composite."
//	hidden_from_codex = FALSE
//	silent_steps      = TRUE

	meat_type     = null
	// bone_material = null
	// skin_material = null

	genders = list(PLURAL)
//	cyborg_noun = null

	icon_template   = 'icons/mob/species/adherent/template.dmi'
	icobase         = 'icons/mob/species/adherent/body.dmi'
	deform          = 'icons/mob/species/adherent/body.dmi'
	preview_icon    = 'icons/mob/species/adherent/preview.dmi'
	damage_overlays = 'icons/mob/species/adherent/damage_overlay.dmi'
	damage_mask     = 'icons/mob/species/adherent/damage_mask.dmi'
	blood_mask      = 'icons/mob/species/adherent/blood_mask.dmi'

	siemens_coefficient  = 0
	rarity_value         = 6
	min_age              = 10000
	max_age              = 12000
	// antaghud_offset_y    = 14
	warning_low_pressure = 50
	hazard_low_pressure  = -1
	mob_size             = MOB_LARGE
	// strength             = STR_HIGH
	has_glowing_eyes     = TRUE

	speech_sounds = list('sound/voice/chime.ogg')
	speech_chance = 25

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 500
	heat_level_2 = 1000
	heat_level_3 = 2000

	species_flags = NO_SCAN | NO_SLIP | NO_MINOR_CUT | NO_HALLUCINATION | NO_INFECT | NO_PAIN
	species_spawn_flags = SPECIES_SPAWN_WHITELISTED | SPECIES_SPAWN_NO_FBP_CONSTRUCT | SPECIES_SPAWN_NO_FBP_SETUP | SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_EYE_COLOR | HAS_BASE_SKIN_COLOR

	intrinsic_languages = LANGUAGE_ID_ADHERENT
	max_additional_languages = 2

	blood_color = "#2de00d"
	flesh_color = "#90edeb"
	base_color  = "#066000"

	slowdown = -0.5

	hud_type = /datum/hud_data/adherent
/*
	available_cultural_info = list(
		TAG_CULTURE = list(
			CULTURE_ADHERENT
		),
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_ADHERENT,
			HOME_SYSTEM_ADHERENT_MOURNER
		),
		TAG_FACTION = list(
			FACTION_ADHERENT_PRESERVERS,
			FACTION_ADHERENT_LOYALISTS,
			FACTION_ADHERENT_SEPARATISTS
		),
		TAG_RELIGION =  list(
			RELIGION_OTHER
		)
	)
*/
	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest/crystal),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin/crystal),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/crystal),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm/crystal),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right/crystal),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/crystal),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/crystal),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg/tendril),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right/tendril/),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/tendril/),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/tendril),
	)

	has_organ = list(
		O_BRAIN        = /obj/item/organ/internal/brain/adherent,
		O_CELL         = /obj/item/organ/internal/cell/adherent,
		O_COOLING_FINS = /obj/item/organ/internal/powered/cooling_fins,
		O_EYES         = /obj/item/organ/internal/eyes/adherent,
		O_FLOAT        = /obj/item/organ/internal/powered/float,
		O_JETS         = /obj/item/organ/internal/powered/jets,
	)

	move_trail = /obj/effect/debris/cleanable/blood/tracks/snake

	base_skin_colours = list(
		"Turquoise"   = "", // First so it's default.
		"Amethyst"    = "_purple",
		"Emerald"     = "_green",
		"Jet"         = "_black",
		"Quartz"      = "_white",
		"Ruby"        = "_red",
		"Sapphire"    = "_blue",
		"Topaz"       = "_yellow",
	)

	wikilink = "N/A"

/datum/species/adherent/New()
	/*equip_adjust = list(
		"[SLOT_ID_LEFT_HAND]" = list("[NORTH]" = list("x" = 0, "y" = 14), "[EAST]" = list("x" = 0, "y" = 14), "[SOUTH]" = list("x" = 0, "y" = 14), "[WEST]" = list("x" = 0,  "y" = 14)),
		"[SLOT_ID_RIGHT_HAND]" = list("[NORTH]" = list("x" = 0, "y" = 14), "[EAST]" = list("x" = 0, "y" = 14), "[SOUTH]" = list("x" = 0, "y" = 14), "[WEST]" = list("x" = 0,  "y" = 14)),
		"[SLOT_ID_BACK]" =   list("[NORTH]" = list("x" = 0, "y" = 14), "[EAST]" = list("x" = 0, "y" = 14), "[SOUTH]" = list("x" = 0, "y" = 14), "[WEST]" = list("x" = 0,  "y" = 14)),
		"[SLOT_ID_BELT]" =   list("[NORTH]" = list("x" = 0, "y" = 14), "[EAST]" = list("x" = 0, "y" = 14), "[SOUTH]" = list("x" = 0, "y" = 14), "[WEST]" = list("x" = 0,  "y" = 14)),
		"[SLOT_ID_HEAD]" =   list("[NORTH]" = list("x" = 0, "y" = 14), "[EAST]" = list("x" = 3, "y" = 14), "[SOUTH]" = list("x" = 0, "y" = 14), "[WEST]" = list("x" = -3, "y" = 14)),
		"[SLOT_ID_LEFT_EAR]" =  list("[NORTH]" = list("x" = 0, "y" = 14), "[EAST]" = list("x" = 0, "y" = 14), "[SOUTH]" = list("x" = 0, "y" = 14), "[WEST]" = list("x" = 0,  "y" = 14)),
		"[SLOT_ID_RIGHT_EAR]" =  list("[NORTH]" = list("x" = 0, "y" = 14), "[EAST]" = list("x" = 0, "y" = 14), "[SOUTH]" = list("x" = 0, "y" = 14), "[WEST]" = list("x" = 0,  "y" = 14))
	)*/
	..()

/datum/species/proc/post_organ_rejuvenate(obj/item/organ/org, mob/living/carbon/human/H)
	return

/datum/species/adherent/can_overcome_gravity(mob/living/carbon/human/H)
	. = FALSE
	if(H && H.stat == CONSCIOUS)
		for(var/obj/item/organ/internal/powered/float/float in H.internal_organs)
			if(float.active)
				. = TRUE
				break

/datum/species/adherent/can_fall(mob/living/carbon/human/H)
	. = !can_overcome_gravity(H)
/*
/datum/species/adherent/get_slowdown(var/mob/living/carbon/human/H)
	return slowdown
*/
/datum/species/adherent/handle_environment_special(mob/living/carbon/human/H)
	for(var/i in H.overlays_standing)
		H.cut_overlay(i)
	//Todo: find a better way to adjust clothing, than to wipe all overlays

/datum/species/adherent/handle_fall_special(mob/living/carbon/human/H, turf/landing)
	var/float_is_usable = FALSE
	if(H && H.stat == CONSCIOUS)
		for(var/obj/item/organ/internal/powered/float/float in H.internal_organs)
			float_is_usable = TRUE
			break
	if(float_is_usable)
		if(istype(landing, /turf/simulated/open))
			H.visible_message("\The [H] descends from \the [landing].", "You descend regally.")
		else
			H.visible_message("\The [H] floats gracefully down from \the [landing].", "You land gently on \the [landing].")
		return TRUE
	return FALSE
/*
/datum/species/adherent/get_blood_name()
	return "coolant"
/datum/species/adherent/skills_from_age(age)
	switch(age)
		if(0 to 1000)    . = -4
		if(1000 to 2000) . =  0
		if(2000 to 8000) . =  4
		else             . =  8
*/
/datum/species/adherent/get_additional_examine_text(mob/living/carbon/human/H)
	if(can_overcome_gravity(H))
		return "They are floating on a cloud of shimmering distortion."

/datum/hud_data/adherent
	has_internals = FALSE
	gear = list(
		SLOT_ID_LEFT_EAR = list("loc" = ui_iclothing, "name" = "Aux Port", "slot" = SLOT_ID_LEFT_EAR, "state" = "ears", "toggle" = 1),
		SLOT_ID_HEAD     = list("loc" = ui_glasses,   "name" = "Hat",      "slot" = SLOT_ID_HEAD,     "state" = "hair", "toggle" = 1),
		SLOT_ID_BACK     = list("loc" = ui_back,      "name" = "Back",     "slot" = SLOT_ID_BACK,     "state" = "back"),
		SLOT_ID_WORN_ID  = list("loc" = ui_id,        "name" = "ID",       "slot" = SLOT_ID_WORN_ID,  "state" = "id"),
		SLOT_ID_BELT     = list("loc" = ui_belt,      "name" = "Belt",     "slot" = SLOT_ID_BELT,     "state" = "belt"),
	)

/datum/species/adherent/post_organ_rejuvenate(obj/item/organ/org, mob/living/carbon/human/H)
	org.robotic = ORGAN_CRYSTAL
