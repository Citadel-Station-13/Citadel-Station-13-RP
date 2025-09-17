/datum/trait/negative/speed_slow
	name = "Slowdown"
	desc = "Slower."
	cost = -2
	var_changes = list("movement_base_speed" = 4.5)

	group = /datum/trait_group/speed
	group_short_name = "Slowdown"
	sort_key = "2-Slowdown"

/datum/trait/negative/speed_slow_plus
	name = "Major Slowdown"
	desc = "MUCH slower."
	cost = -3
	var_changes = list("movement_base_speed" = 4)

	group = /datum/trait_group/speed
	group_short_name = "Major Slowdown"
	sort_key = "1-Major Slowdown"

/datum/trait/negative/endurance_low
	name = "Low Endurance"
	desc = "75 hitpoints."
	cost = -2
	extra_id_info = "Employee is unusually susceptible to all forms of harm."
	var_changes = list("total_health" = 75)

	group = /datum/trait_group/health
	group_short_name = "Low"
	sort_key = "2-Low"

	excluded_species = list(SPECIES_HOLOSPHERE)

/datum/trait/negative/endurance_low/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.setMaxHealth(S.total_health)

/datum/trait/negative/endurance_very_low
	name = "Extremely Low Endurance"
	desc = "50 hitpoints."
	cost = -3 //Teshari HP. This makes the person a lot more suseptable to getting stunned, killed, etc.
	extra_id_info = "Employee is extremely susceptible to all forms of harm."
	var_changes = list("total_health" = 50)

	group = /datum/trait_group/health
	group_short_name = "Extremely Low"
	sort_key = "2-Extremely Low"

	excluded_species = list(SPECIES_HOLOSPHERE)

/datum/trait/negative/endurance_very_low/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.setMaxHealth(S.total_health)

/datum/trait/negative/minor_brute_weak
	name = "Minor Brute Weakness"
	desc = "15% more."
	cost = -1
	var_changes = list("brute_mod" = 1.15)

	group = /datum/trait_group/brute
	group_short_name = "Minor Weakness"
	sort_key = "3-Minor Weakness"

/datum/trait/negative/brute_weak
	name = "Brute Weakness"
	desc = "25% more."
	cost = -2
	var_changes = list("brute_mod" = 1.25)

	group = /datum/trait_group/brute
	group_short_name = "Weakness"
	sort_key = "2-Weakness"

/datum/trait/negative/brute_weak_plus
	name = "Major Brute Weakness"
	desc = "50% more."
	cost = -3
	extra_id_info = "Employee is unusually susceptible to blunt trauma."
	var_changes = list("brute_mod" = 1.5)

	group = /datum/trait_group/brute
	group_short_name = "Major Weakness"
	sort_key = "1-Major Weakness"

/datum/trait/negative/minor_burn_weak
	name = "Minor Burn Weakness"
	desc = "15% more."
	cost = -1
	var_changes = list("burn_mod" = 1.15)

	group = /datum/trait_group/burn
	group_short_name = "Minor Weakness"
	sort_key = "3-Minor Weakness"

/datum/trait/negative/burn_weak
	name = "Burn Weakness"
	desc = "25% more."
	cost = -2
	var_changes = list("burn_mod" = 1.25)

	group = /datum/trait_group/burn
	group_short_name = "Weakness"
	sort_key = "2-Weakness"

/datum/trait/negative/burn_weak_plus
	name = "Major Burn Weakness"
	desc = "50% more."
	cost = -3
	extra_id_info = "Employee is unusually sensitive to heat."
	var_changes = list("burn_mod" = 1.5)

	group = /datum/trait_group/burn
	group_short_name = "Major Weakness"
	sort_key = "1-Major Weakness"

/datum/trait/negative/toxin_weak
	name = "Toxin Weakness"
	desc = "25% more."
	cost = -1
	var_changes = list("toxins_mod" = 1.25)

	group = /datum/trait_group/toxin
	group_short_name = "Weakness"
	sort_key = "2-Weakness"

/datum/trait/negative/toxin_weak_plus
	name = "Major Toxin Weakness"
	desc = "50% more."
	cost = -2
	extra_id_info = "Employee's organs are ineffective at filtering toxins."
	var_changes = list("toxins_mod" = 1.5)

	group = /datum/trait_group/toxin
	group_short_name = "Major Weakness"
	sort_key = "1-Major Weakness"

/datum/trait/negative/oxy_weak
	name = "Breathe Weakness"
	desc = "25% more damage, 25% more air. (20kpa min)"
	cost = -1
	extra_id_info = "Employee requires a minimum atmospheric pressure of 20kPa to breathe."
	var_changes = list("minimum_breath_pressure" = 20, "oxy_mod" = 1.25)

	group = /datum/trait_group/oxy
	group_short_name = "Weakness"
	sort_key = "2-Weakness"

/datum/trait/negative/rad_weak
	name = "Radiation Weakness"
	desc = "25% more."
	cost = -1
	var_changes = list("radiation_mod" = 1.25)

	group = /datum/trait_group/rad
	group_short_name = "Weakness"
	sort_key = "2-Weakness"

/datum/trait/negative/rad_weak_plus
	name = "Major Radiation Weakness"
	desc = "50% more."
	cost = -2
	extra_id_info = "Employee is extremely susceptible to radiation."
	var_changes = list("radiation_mod" = 1.50)

	group = /datum/trait_group/rad
	group_short_name = "Major Weakness"
	sort_key = "1-Major Weakness"

/datum/trait/negative/conductive
	name = "Conductive"
	desc = "50% more susceptible."
	cost = -1
	var_changes = list("siemens_coefficient" = 1.5) //This makes you a lot weaker to tasers.

	group = /datum/trait_group/electro
	group_short_name = "Conductive"
	sort_key = "2-Conductive"

/datum/trait/negative/conductive_plus
	name = "Major Conductive"
	desc = "100% more susceptible."
	cost = -2
	extra_id_info = "Employee is exceptionally conductive."
	var_changes = list("siemens_coefficient" = 2.0) //This makes you extremely weak to tasers.

	group = /datum/trait_group/electro
	group_short_name = "Major Conductive"
	sort_key = "1-Major Conductive"

/datum/trait/negative/hollow
	name = "Weak Bones/Aluminum Alloy"
	desc = "Easier to break."
	cost = -2 //I feel like this should be higher, but let's see where it goes

	group = /datum/trait_group/bones
	group_short_name = "Weak/Aluminum"
	sort_key = "2-Weak/Aluminum"

/datum/trait/negative/hollow/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	for(var/obj/item/organ/external/O in H.organs)
		O.min_broken_damage *= 0.75
		O.min_bruised_damage *= 0.75

/datum/trait/negative/hollow_plus
	name = "Hollow Bones/Brittle Alloy"
	desc = "Significantly easier to break."
	cost = -4 //I feel like this should be higher, but let's see where it goes
	extra_id_info = "Employee's bones are unusually fragile."

	group = /datum/trait_group/bones
	group_short_name = "Hollow/Brittle"
	sort_key = "1-Hollow/Brittle"

/datum/trait/negative/hollow_plus/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	for(var/obj/item/organ/external/O in H.organs)
		O.min_broken_damage *= 0.5
		O.min_bruised_damage *= 0.5

/datum/trait/negative/lightweight
	name = "Lightweight"
	desc = "Your light weight and poor balance make you very susceptible to unhelpful bumping. Think of it like a bowling ball versus a pin."
	cost = -2
	var_changes = list("lightweight" = 1)

/datum/trait/negative/colorblind/mono
	name = "Colorblindness (Monochromancy)"
	desc = "No colors. 100% colorblind."
	cost = -1
	custom_only = FALSE
	extra_id_info = "Employee is only capable of perceiving luminance, and cannot perceive hues or saturation."

	group = /datum/trait_group/colorblindness
	group_short_name = "Monochromancy"
	sort_key = "1-Monochromancy"

/datum/trait/negative/colorblind/mono/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.add_modifier(/datum/modifier/trait/colorblind_monochrome)

/datum/trait/negative/colorblind/para_vulp
	name = "Colorblindness (Para Vulp)"
	desc = "Severe red/green difficulty."
	cost = -1
	extra_id_info = "Employee has a form of red/green colorblindness."

	group = /datum/trait_group/colorblindness
	group_short_name = "Para Vulp"
	sort_key = "2-Para Vulp"

/datum/trait/negative/colorblind/para_vulp/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.add_modifier(/datum/modifier/trait/colorblind_vulp)

/datum/trait/negative/colorblind/para_taj
	name = "Colorblindness (Para Taj)"
	desc = "Minor red/blue difficulty."
	cost = -1
	extra_id_info = "Employee has a form of blue/red colorblindness."

	group = /datum/trait_group/colorblindness
	group_short_name = "Para Taj"
	sort_key = "2-Para Taj"

/datum/trait/negative/colorblind/para_taj/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.add_modifier(/datum/modifier/trait/colorblind_taj)

/datum/trait/negative/photosensitive
	name = "Photosensitive"
	desc = "You are incredibly vulnerable to bright lights. You are blinded for longer and your skin burns under extreme light."
	cost = -1
	var_changes = list("flash_mod" = 2, "flash_burn" = 5)

	group = /datum/trait_group/photosensitivity
	group_short_name = "Photosensitive"
	sort_key = "4-Photosensitive"

	extra_id_info = "Employee is exceptionally sensitive to bright lights."

/datum/trait/negative/hemophilia
	name = "Hemophilia"
	desc = "You bleed twice as fast as normal."
	cost = -1
	extra_id_info = "Employee is exceptionally prone to bleeding."
	var_changes = list("bloodloss_rate" = 2)

	group = /datum/trait_group/blood
	group_short_name = "Hemophilia"
	sort_key = "4-Hemophilia"

// todo: use it as a disability? kinda silly this applies forever
/datum/trait/negative/blind
	name = "Blind"
	desc = "You're blind. Permanently."
	cost = -3
	extra_id_info = "Employee has <b>extremely limited vision</b>."
	custom_only = FALSE
	excludes = list(
		/datum/trait/negative/deaf
	)

	group = /datum/trait_group/disability
	group_short_name = "Blind"

/datum/trait/negative/blind/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	.=..()
	H.add_blindness_source(TRAIT_BLINDNESS_NEGATIV)

// todo: use it as a disability to vocal ears? organs? same as above? please?
/datum/trait/negative/deaf
	name = "Deaf"
	desc = "You're deaf. Permanently."
	cost = -2
	extra_id_info = "Employee <b>cannot perceive sound</b>."
	custom_only = FALSE
	traits = list(
		TRAIT_DEAF
	)
	// this should disallow taking both blind and deaf but it'll use blind
	// since the backend for that isn't here yet
	// reason: i don't want to deal with meme characters that are blind, mute, and deaf
	// if you want to have hardmode go roleplay it out
	excludes = list(
		/datum/trait/negative/blind
	)

	group = /datum/trait_group/disability
	group_short_name = "Deaf"

// todo: organ disability? better way to have mutual exclusion from having all 3
/datum/trait/negative/mute
	name = "Mute"
	desc = "You're mute. Permanently."
	cost = 0			// TTS bypasses this instantly, no powergaming mute ass explo characters
	extra_id_info = "Employee is <b>incapable of vocalizing</b>."
	custom_only = FALSE
	traits = list(
		TRAIT_MUTE
	)

	group = /datum/trait_group/disability
	group_short_name = "Mute"
