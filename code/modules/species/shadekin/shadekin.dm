/datum/species/shadekin
	uid = SPECIES_ID_SHADEKIN
	name = SPECIES_SHADEKIN
	name_plural = SPECIES_SHADEKIN
	category = SPECIES_CATEGORY_RESTRICTED

	icobase      = 'icons/mob/species/shadekin/body.dmi'
	deform       = 'icons/mob/species/shadekin/body.dmi'
	preview_icon = 'icons/mob/species/shadekin/preview.dmi'
	husk_icon    = 'icons/mob/species/shadekin/husk.dmi'

	sprite_accessory_defaults = list(
		SPRITE_ACCESSORY_SLOT_TAIL = /datum/sprite_accessory/tail/bodyset/shadekin,
	)

	blurb = {"
	Shadekin are rather unusual creatures, coming from the Azuel system. Their appearance is largely
	mammalian, even though they aren't mammals. The official, formal name for the species is Lumelea,
	but thanks to a period of difficulties when the Lumelea first met other species, the nickname
	Shadekin was made popular by the galaxy's various species, and it stuck to this day as an
	informal name. After a few hundred years of living side by side, it's by now widely known that
	Shadekin culture revolves around tribes with various levels of technology, with some tribes
	integrating into other cultures and cities, as well as some Shadekin leaving their tribe to
	travel alone. Nanotrasen is one of the biggest employers of Shadekin.
	"}
	wikilink = "https://citadel-station.net/wikiRP/index.php?title=Race:_Shadekin"
	catalogue_data = list(/datum/category_item/catalogue/fauna/shadekin)

	max_additional_languages = 3
	intrinsic_languages = LANGUAGE_ID_SHADEKIN_HIVEMIND
	name_language = LANGUAGE_ID_SHADEKIN_HIVEMIND

	unarmed_types = list(
		/datum/melee_attack/unarmed/stomp,
		/datum/melee_attack/unarmed/kick,
		/datum/melee_attack/unarmed/claws/shadekin,
		/datum/melee_attack/unarmed/bite/sharp/shadekin,
	)

	siemens_coefficient = 0
	vision_innate = /datum/vision/baseline/species_tier_3/for_snowflake_ocs
	vision_organ = O_EYES

	movement_base_speed = 6
	item_slowdown_mod = 0.5

	brute_mod = 0.7 // Naturally sturdy.
	burn_mod = 1.2 // Furry
	radiation_mod = 0

	warning_low_pressure = 50
	hazard_low_pressure = -1

	warning_high_pressure = 300
	hazard_high_pressure = INFINITY

	cold_level_1 = -1 //Immune to cold
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 850 //Resistant to heat
	heat_level_2 = 1000
	heat_level_3 = 1150

	species_flags = NO_SCAN | NO_MINOR_CUT | NO_INFECT | CONTAMINATION_IMMUNE
	species_spawn_flags = SPECIES_SPAWN_RESTRICTED | SPECIES_SPAWN_CHARACTER

	reagent_tag = IS_SHADEKIN // for shadekin-unique chem interactions

	color_mult  = 1
	flesh_color = "#FFC896"
	blood_color = "#A10808"
	base_color  = "#f0f0f0"

	has_glowing_eyes = TRUE

	male_cough_sounds   = null
	female_cough_sounds = null
	male_sneeze_sound   = null
	female_sneeze_sound = null

	speech_bubble_appearance = "ghost"

	genders = list(MALE, FEMALE, PLURAL, NEUTER, HERM)	//fuck it. shadekins with titties

	virus_immune = TRUE

	breath_type = null
	poison_type = null

	vision_flags = SEE_SELF|SEE_MOBS
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_UNDERWEAR

	move_trail = /obj/effect/debris/cleanable/blood/tracks/paw

	has_organ = list(
		O_HEART     = /obj/item/organ/internal/heart,
		O_VOICE     = /obj/item/organ/internal/voicebox,
		O_LIVER     = /obj/item/organ/internal/liver,
		O_KIDNEYS   = /obj/item/organ/internal/kidneys,
		O_BRAIN     = /obj/item/organ/internal/brain/shadekin,
		O_EYES      = /obj/item/organ/internal/eyes,
		O_STOMACH   = /obj/item/organ/internal/stomach,
		O_INTESTINE = /obj/item/organ/internal/intestine,
	)

	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/vr/shadekin),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right),
	)

	var/list/shadekin_abilities = list(
		/datum/power/shadekin/phase_shift,
		/datum/power/shadekin/regenerate_other,
		/datum/power/shadekin/create_shade,
	)

	var/list/shadekin_ability_datums = list()
	var/kin_type
	var/energy_light = 0.25
	var/energy_dark = 0.75

/datum/species/shadekin/New()
	..()
	for(var/power in shadekin_abilities)
		var/datum/power/shadekin/SKP = new power(src)
		shadekin_ability_datums.Add(SKP)

/datum/species/shadekin/get_bodytype_legacy()
	return SPECIES_SHADEKIN

/datum/species/shadekin/get_random_name()
	return "shadekin"

/datum/species/shadekin/handle_environment_special(mob/living/carbon/human/H, datum/gas_mixture/environment, dt)
	handle_shade(H)

/datum/species/shadekin/can_breathe_water()
	return TRUE	//they dont quite breathe

/datum/species/shadekin/add_inherent_verbs(mob/living/carbon/human/H)
	..()
	add_shadekin_abilities(H)

/datum/species/shadekin/proc/add_shadekin_abilities(mob/living/carbon/human/H)
	if(!H.ability_master || !istype(H.ability_master, /atom/movable/screen/movable/ability_master/shadekin))
		H.ability_master = null
		H.ability_master = new /atom/movable/screen/movable/ability_master/shadekin(H)
	for(var/datum/power/shadekin/P in shadekin_ability_datums)
		if(!(P.verbpath in H.verbs))
			add_verb(H, P.verbpath)
			H.ability_master.add_shadekin_ability(
				object_given = H,
				verb_given = P.verbpath,
				name_given = P.name,
				ability_icon_given = P.ability_icon_state,
				arguments = list()
			)

/datum/species/shadekin/proc/handle_shade(mob/living/carbon/human/H)
	//Shifted kin don't gain/lose energy (and save time if we're at the cap)
	var/darkness = 1
	var/dark_gains = 0

	var/turf/T = get_turf(H)
	if(!T)
		dark_gains = 0
		return

	var/brightness = T.get_lumcount() //Brightness in 0.0 to 1.0
	darkness = 1-brightness //Invert
	var/is_dark = (darkness >= 0.5)
	if(isspaceturf(T))
		is_dark = 1

	if(H.ability_flags & AB_PHASE_SHIFTED)
		dark_gains = 0
	else
		//Heal (very) slowly in good darkness
		if(is_dark)
			H.adjustFireLoss((-0.10)*darkness)
			H.adjustBruteLoss((-0.10)*darkness)
			H.adjustToxLoss((-0.10)*darkness)
			//energy_dark and energy_light are set by the shadekin eye traits.
			//These are balanced around their playstyles and 2 planned new aggressive abilities
			dark_gains = energy_dark
		else
			dark_gains = energy_light

	set_energy(H, get_energy(H) + dark_gains)

	//Update huds
	update_shadekin_hud(H)

/datum/species/shadekin/proc/get_energy(mob/living/carbon/human/H)
	var/obj/item/organ/internal/brain/shadekin/shade_organ = H.internal_organs_by_name[O_BRAIN]
	if(!istype(shade_organ))
		return FALSE

	return shade_organ.dark_energy

/datum/species/shadekin/proc/get_max_energy(mob/living/carbon/human/H)
	var/obj/item/organ/internal/brain/shadekin/shade_organ = H.internal_organs_by_name[O_BRAIN]
	if(!istype(shade_organ))
		return FALSE

	return shade_organ.max_dark_energy

/datum/species/shadekin/proc/set_energy(mob/living/carbon/human/H, new_energy)
	var/obj/item/organ/internal/brain/shadekin/shade_organ = H.internal_organs_by_name[O_BRAIN]
	if(!istype(shade_organ))
		return

	shade_organ.dark_energy = clamp(new_energy, 0, get_max_energy(H))

/datum/species/shadekin/proc/set_max_energy(mob/living/carbon/human/H, new_max_energy)
	var/obj/item/organ/internal/brain/shadekin/shade_organ = H.internal_organs_by_name[O_BRAIN]
	if(!istype(shade_organ))
		return FALSE

	shade_organ.max_dark_energy = new_max_energy

/datum/species/shadekin/proc/check_infinite_energy(mob/living/carbon/human/H)
	var/obj/item/organ/internal/brain/shadekin/shade_organ = H.internal_organs_by_name[O_BRAIN]
	if(!istype(shade_organ))
		return FALSE

	return shade_organ.dark_energy_infinite

/datum/species/shadekin/proc/update_shadekin_hud(mob/living/carbon/human/H)
	var/turf/T = get_turf(H)
	if(H.shadekin_display)
		var/l_icon = 0
		var/e_icon = 0

		H.shadekin_display.invisibility = 0
		if(T)
			var/brightness = T.get_lumcount() //Brightness in 0.0 to 1.0
			var/darkness = 1-brightness //Invert
			switch(darkness)
				if(0.80 to 1.00)
					l_icon = 0
				if(0.60 to 0.80)
					l_icon = 1
				if(0.40 to 0.60)
					l_icon = 2
				if(0.20 to 0.40)
					l_icon = 3
				if(0.00 to 0.20)
					l_icon = 4

		switch(get_energy(H))
			if(0 to 24.99)
				e_icon = 0
			if(25 to 49.99)
				e_icon = 1
			if(50 to 74.99)
				e_icon = 2
			if(75 to 99.99)
				e_icon = 3
			if(100 to INFINITY)
				e_icon = 4

		H.shadekin_display.icon_state = "shadekin-[l_icon]-[e_icon]"
	return
