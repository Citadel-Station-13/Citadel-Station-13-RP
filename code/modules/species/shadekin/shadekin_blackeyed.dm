/datum/species/crew_shadekin
	uid = SPECIES_ID_SHADEKIN_BLACK
	name = SPECIES_SHADEKIN_CREW
	name_plural = SPECIES_SHADEKIN_CREW
	uid = SPECIES_ID_SHADEKIN_BLACK
	id = SPECIES_ID_SHADEKIN

	icobase      = 'icons/mob/species/shadekin/body.dmi'
	deform       = 'icons/mob/species/shadekin/body.dmi'
	preview_icon = 'icons/mob/species/shadekin/preview_blackeyed.dmi'
	husk_icon    = 'icons/mob/species/shadekin/husk.dmi'
	tail = "tail"

	//TODO: Something more fitting for black-eyes
	//TODO: CIT ADDENDUM: since we're not really on the tether anymore we'll need a bullshit reason as to why they're around wherever we are.
	blurb = {"
	Very little is known about these creatures. They appear to be largely mammalian in appearance.
	Seemingly very rare to encounter, there have been widespread myths of these creatures the galaxy over,
	but next to no verifiable evidence to their existence. However, they have recently been more verifiably
	documented in the Virgo system, following a mining bombardment of Virgo 3. The crew of NSB Adephagia have
	taken to calling these creatures 'Shadekin', and the name has generally stuck and spread.
	"}

	wikilink = "https://citadel-station.net/wikiRP/index.php?title=Race:_Shadekin"

	name_language = LANGUAGE_ID_SHADEKIN_HIVEMIND
	intrinsic_languages = list(
		LANGUAGE_ID_SHADEKIN_HIVEMIND
	)
	max_additional_languages = 3

	rarity_value = 5 // INTERDIMENSIONAL FLUFFERS

	siemens_coefficient = 0 // Completely shockproof (this is no longer the case on virgo, feel free to change if it needs rebalancing)
	darksight = 10 // Best darksight around

	slowdown = 0 // Originally 0.5 (As slow as unathi), lowered to 0 to be at human speed.
	item_slowdown_mod = 2 // Originally 1.5. They're not as physically fits, slowed down more by heavy gear.

	total_health = 75   // Fragile
	brute_mod    = 1 // Originally 1.25, lowered to 1 because lower HP and increased damage is a bit heavy.
	burn_mod     = 1.25 // Furry

	blood_volume  = 500 // Slightly less blood than human baseline.
	hunger_factor = 0.2 // Gets hungrier faster than human baseline.

	warning_low_pressure = 50
	hazard_low_pressure = -1

	warning_high_pressure = 300
	hazard_high_pressure = INFINITY

	cold_level_1 = -1 // Immune to cold
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 850 // Resistant to heat
	heat_level_2 = 1000
	heat_level_3 = 1150

	// Shadekin biology is still unknown to the universe (unless some bullshit lore says otherwise)
	species_flags =  NO_SCAN | NO_MINOR_CUT | CONTAMINATION_IMMUNE
	species_spawn_flags = SPECIES_SPAWN_ALLOWED | SPECIES_SPAWN_WHITELISTED | SPECIES_SPAWN_WHITELIST_SELECTABLE

	reagent_tag = IS_SHADEKIN // for shadekin-unique chem interactions

	flesh_color = "#FFC896"
	blood_color = "#A10808"
	base_color  = "#f0f0f0"
	color_mult  = 1

	has_glowing_eyes = TRUE

	male_cough_sounds   = null
	female_cough_sounds = null
	male_sneeze_sound   = null
	female_sneeze_sound = null

	speech_bubble_appearance = "ghost"

	genders = list(MALE, FEMALE, PLURAL, NEUTER, HERM) //fuck it. shadekins with titties

	breath_type = null //they don't breathe
	poison_type = null

	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_SKIN_COLOR | HAS_UNDERWEAR

	has_organ = list(
		O_HEART     = /obj/item/organ/internal/heart,
		O_VOICE     = /obj/item/organ/internal/voicebox,
		O_LIVER     = /obj/item/organ/internal/liver,
		O_KIDNEYS   = /obj/item/organ/internal/kidneys,
		O_BRAIN     = /obj/item/organ/internal/brain/shadekin/crewkin,
		O_EYES      = /obj/item/organ/internal/eyes,
		O_STOMACH   = /obj/item/organ/internal/stomach,
		O_INTESTINE = /obj/item/organ/internal/intestine,
	)

	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest/crewkin),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin/crewkin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/vr/crewkin),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm/crewkin),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right/crewkin),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg/crewkin),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right/crewkin),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/crewkin),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/crewkin),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/crewkin),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/crewkin),
	)

	var/list/crew_shadekin_abilities = list(
		/datum/power/crew_shadekin/crewkin_regenerate_other,
		/datum/power/crew_shadekin/crewkin_create_shade,
	)

	var/list/crew_shadekin_ability_datums = list()
	var/kin_type
	var/energy_light = 0.25
	var/energy_dark = 0.75

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/bite/sharp,
	)

/datum/species/crew_shadekin/New()
	..()
	for(var/power in crew_shadekin_abilities)
		var/datum/power/crew_shadekin/BESKP = new power(src)
		crew_shadekin_ability_datums.Add(BESKP)

/datum/species/crew_shadekin/can_breathe_water()
	return TRUE	//they dont quite breathe

/datum/species/crew_shadekin/handle_environment_special(mob/living/carbon/human/H)
	handle_shade(H)

/datum/species/crew_shadekin/add_inherent_verbs(mob/living/carbon/human/H)
	..()
	add_crew_shadekin_abilities(H)

/datum/species/crew_shadekin/proc/add_crew_shadekin_abilities(mob/living/carbon/human/H)
	if(!H.ability_master || !istype(H.ability_master, /atom/movable/screen/movable/ability_master/crew_shadekin))
		H.ability_master = null
		H.ability_master = new /atom/movable/screen/movable/ability_master/crew_shadekin(H)
	for(var/datum/power/crew_shadekin/P in crew_shadekin_ability_datums)
		if(!(P.verbpath in H.verbs))
			H.verbs += P.verbpath
			H.ability_master.add_crew_shadekin_ability(
				object_given = H,
				verb_given = P.verbpath,
				name_given = P.name,
				ability_icon_given = P.ability_icon_state,
				arguments = list()
			)

/datum/species/crew_shadekin/proc/handle_shade(mob/living/carbon/human/H)
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
	update_crew_shadekin_hud(H)

/datum/species/crew_shadekin/proc/get_energy(mob/living/carbon/human/H)
	var/obj/item/organ/internal/brain/shadekin/crewkin/shade_organ = H.internal_organs_by_name[O_BRAIN]
	if(!istype(shade_organ))
		return FALSE

	return shade_organ.dark_energy

/datum/species/crew_shadekin/proc/get_max_energy(mob/living/carbon/human/H)
	var/obj/item/organ/internal/brain/shadekin/crewkin/shade_organ = H.internal_organs_by_name[O_BRAIN]
	if(!istype(shade_organ))
		return FALSE

	return shade_organ.max_dark_energy

/datum/species/crew_shadekin/proc/set_energy(mob/living/carbon/human/H, new_energy)
	var/obj/item/organ/internal/brain/shadekin/crewkin/shade_organ = H.internal_organs_by_name[O_BRAIN]
	if(!istype(shade_organ))
		return

	shade_organ.dark_energy = clamp(new_energy, 0, get_max_energy(H))

/datum/species/crew_shadekin/proc/set_max_energy(mob/living/carbon/human/H, new_max_energy)
	var/obj/item/organ/internal/brain/shadekin/crewkin/shade_organ = H.internal_organs_by_name[O_BRAIN]
	if(!istype(shade_organ))
		return FALSE

	shade_organ.max_dark_energy = new_max_energy

/datum/species/crew_shadekin/proc/check_infinite_energy(mob/living/carbon/human/H)
	var/obj/item/organ/internal/brain/shadekin/crewkin/shade_organ = H.internal_organs_by_name[O_BRAIN]
	if(!istype(shade_organ))
		return FALSE

	return shade_organ.dark_energy_infinite

/datum/species/crew_shadekin/proc/update_crew_shadekin_hud(mob/living/carbon/human/H)
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
			if(0 to 12)
				e_icon = 0
			if(13 to 24)
				e_icon = 1
			if(25 to 37)
				e_icon = 2
			if(38 to 49)
				e_icon = 3
			if(50 to INFINITY)
				e_icon = 4

		H.shadekin_display.icon_state = "shadekin-[l_icon]-[e_icon]"
	return
