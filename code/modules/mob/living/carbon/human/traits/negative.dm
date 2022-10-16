/datum/trait/negative/speed_slow
	name = "Slowdown"
	desc = "Allows you to move slower on average than baseline."
	cost = -2
	var_changes = list("slowdown" = 0.5)

/datum/trait/negative/speed_slow_plus
	name = "Major Slowdown"
	desc = "Allows you to move MUCH slower on average than baseline."
	cost = -3
	var_changes = list("slowdown" = 1.0)

/datum/trait/negative/weakling
	name = "Weakling"
	desc = "Causes heavy equipment to slow you down more when carried."
	cost = -1
	var_changes = list("item_slowdown_mod" = 1.5)

/datum/trait/negative/weakling_plus
	name = "Major Weakling"
	desc = "Allows you to carry heavy equipment with much more slowdown."
	cost = -2
	var_changes = list("item_slowdown_mod" = 2.0)

/datum/trait/negative/endurance_low
	name = "Low Endurance"
	desc = "Reduces your maximum total hitpoints to 75."
	cost = -2
	var_changes = list("total_health" = 75)

/datum/trait/negative/endurance_low/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.setMaxHealth(S.total_health)

/datum/trait/negative/endurance_very_low
	name = "Extremely Low Endurance"
	desc = "Reduces your maximum total hitpoints to 50."
	cost = -3 //Teshari HP. This makes the person a lot more suseptable to getting stunned, killed, etc.
	var_changes = list("total_health" = 50)

/datum/trait/negative/endurance_very_low/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.setMaxHealth(S.total_health)

/datum/trait/negative/minor_brute_weak
	name = "Minor Brute Weakness"
	desc = "You take 15% more brute damage"
	cost = -1
	var_changes = list("brute_mod" = 1.15)

/datum/trait/negative/brute_weak
	name = "Brute Weakness"
	desc = "You take 25% more brute damage"
	cost = -2
	var_changes = list("brute_mod" = 1.25)

/datum/trait/negative/brute_weak_plus
	name = "Major Brute Weakness"
	desc = "You take 50% more brute damage"
	cost = -3
	var_changes = list("brute_mod" = 1.5)

/datum/trait/negative/minor_burn_weak
	name = "Minor Burn Weakness"
	desc = "You take 15% more burn damage"
	cost = -1
	var_changes = list("burn_mod" = 1.15)

/datum/trait/negative/burn_weak
	name = "Burn Weakness"
	desc = "You take 25% more burn damage"
	cost = -2
	var_changes = list("burn_mod" = 1.25)

/datum/trait/negative/burn_weak_plus
	name = "Major Burn Weakness"
	desc = "You take 50% more burn damage"
	cost = -3
	var_changes = list("burn_mod" = 1.5)

/datum/trait/negative/toxin_weak
	name = "Toxin Weakness"
	desc = "You take 25% more toxin damage"
	cost = -1
	var_changes = list("toxins_mod" = 1.25)

/datum/trait/negative/toxin_weak_plus
	name = "Major Toxin Weaness"
	desc = "You take 50% more toxin damage"
	cost = -2
	var_changes = list("toxins_mod" = 1.5)

/datum/trait/negative/oxy_weak
	name = "Breathe Weakness"
	desc = "You take 25% more breathe damage and require 25% more air (20kpa minimum). Make sure to adjust your emergency EVA tanks."
	cost = -1
	var_changes = list("minimum_breath_pressure" = 20, "oxy_mod" = 1.25)

/datum/trait/negative/rad_weak
	name = "Radiation Weakness"
	desc = "You take 25% more radition damage"
	cost = -1
	var_changes = list("radiation_mod" = 1.25)

/datum/trait/negative/rad_weak_plus
	name = "Major Radiation Weakness"
	desc = "You take 50% more radition damage"
	cost = -2
	var_changes = list("radiation_mod" = 1.50)

/datum/trait/negative/conductive
	name = "Conductive"
	desc = "Increases your susceptibility to electric shocks by 50%"
	cost = -1
	var_changes = list("siemens_coefficient" = 1.5) //This makes you a lot weaker to tasers.

/datum/trait/negative/conductive_plus
	name = "Major Conductive"
	desc = "Increases your susceptibility to electric shocks by 100%"
	cost = -2
	var_changes = list("siemens_coefficient" = 2.0) //This makes you extremely weak to tasers.

/datum/trait/negative/hollow
	name = "Weak Bones/Aluminum Alloy"
	desc = "Your bones and robot limbs are easier to break."
	cost = -2 //I feel like this should be higher, but let's see where it goes

/datum/trait/negative/hollow/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	for(var/obj/item/organ/external/O in H.organs)
		O.min_broken_damage *= 0.75
		O.min_bruised_damage *= 0.75

/datum/trait/negative/hollow_plus
	name = "Hollow Bones/Brittle Alloy"
	desc = "Your bones and robot limbs are significantly easier to break."
	cost = -4 //I feel like this should be higher, but let's see where it goes

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
	desc = "You simply can't see colors at all, period. You are 100% colorblind."
	cost = -1

/datum/trait/negative/colorblind/mono/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.add_modifier(/datum/modifier/trait/colorblind_monochrome)

/datum/trait/negative/colorblind/para_vulp
	name = "Colorblindness (Para Vulp)"
	desc = "You have a severe issue with green colors and have difficulty recognizing them from red colors."
	cost = -1

/datum/trait/negative/colorblind/para_vulp/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.add_modifier(/datum/modifier/trait/colorblind_vulp)

/datum/trait/negative/colorblind/para_taj
	name = "Colorblindness (Para Taj)"
	desc = "You have a minor issue with blue colors and have difficulty recognizing them from red colors."
	cost = -1

/datum/trait/negative/colorblind/para_taj/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.add_modifier(/datum/modifier/trait/colorblind_taj)

/datum/trait/negative/photosensitive
	name = "Photosensitive"
	desc = "You are incredibly vulnerable to bright lights. You are blinded for longer and your skin burns under extreme light."
	cost = -1
	var_changes = list("flash_mod" = 2)
	var_changes = list("flash_burn" = 5)

/datum/trait/negative/hemophilia
	name = "Hemophilia"
	desc = "You bleed twice as fast as normal."
	cost = -1
	var_changes = list("bloodloss_rate" = 2)

// todo: use it as a disability? kinda silly this applies forever
/datum/trait/negative/blind
	name = "Blind"
	desc = "You're blind. Permanently."
	cost = -3
	traits = list(
		TRAIT_BLIND
	)
	excludes = list(
		/datum/trait/negative/deaf
	)

// todo: use it as a disability to vocal ears? organs? same as above? please?
/datum/trait/negative/deaf
	name = "Deaf"
	desc = "You're deaf. Permanently."
	cost = -2
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

// todo: organ disability? better way to have mutual exclusion from having all 3
/datum/trait/negative/mute
	name = "Mute"
	desc = "You're mute. Permanently."
	cost = 0			// TTS bypasses this instantly, no powergaming mute ass explo characters
	traits = list(
		TRAIT_MUTE
	)
