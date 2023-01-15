/datum/trait/positive/speed_fast
	name = "Haste"
	desc = "Allows you to move faster on average than baseline."
	cost = 2
	var_changes = list("slowdown" = -0.2)
	excludes = list(/datum/trait/positive/hardy, /datum/trait/positive/hardy_plus)

/datum/trait/positive/hardy
	name = "Hardy"
	desc = "Allows you to carry heavy equipment with less slowdown."
	cost = 1
	var_changes = list("item_slowdown_mod" = 0.5)

/datum/trait/positive/hardy_plus
	name = "Major Hardy"
	desc = "Allows you to carry heavy equipment with almost no slowdown."
	cost = 2
	var_changes = list("item_slowdown_mod" = 0.1)

/datum/trait/positive/endurance_plus
	name = "Better Endurance"
	desc = "Increases your maximum total hitpoints to 110"
	cost = 3
	var_changes = list("total_health" = 110)

/datum/trait/positive/endurance_high
	name = "High Endurance"
	desc = "Increases your maximum total hitpoints to 125"
	cost = 4
	var_changes = list("total_health" = 125)

/datum/trait/positive/endurance_high/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.setMaxHealth(S.total_health)

/datum/trait/positive/nonconductive
	name = "Non-Conductive"
	desc = "Decreases your susceptibility to electric shocks by a 25% amount."
	cost = 2 //This effects tasers!
	var_changes = list("siemens_coefficient" = 0.75)

/datum/trait/positive/nonconductive_plus
	name = "Major Non-Conductive"
	desc = "Decreases your susceptibility to electric shocks by a 50% amount."
	cost = 3 //Let us not forget this effects tasers!
	var_changes = list("siemens_coefficient" = 0.5)

/datum/trait/positive/darksight
	name = "Darksight"
	desc = "Allows you to see a short distance in the dark, also makes you more vulnerable to flashes."
	cost = 1
	var_changes = list("darksight" = 3, "flash_mod" = 2.0)

/datum/trait/positive/darksight_plus
	name = "Major Darksight"
	desc = "Allows you to see great distances in the dark, also makes you extremely vulnerable to flashes."
	cost = 2
	var_changes = list("darksight" = 7, "flash_mod" = 3.0)

/datum/trait/positive/melee_attack
	name = "Sharp Melee"
	desc = "Provides sharp melee attacks that do slightly more damage."
	cost = 1
	var_changes = list("unarmed_types" = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp))

/datum/trait/positive/melee_attack_fangs
	name = "Sharp Melee & Numbing Fangs"
	desc = "Provides sharp melee attacks that do slightly more damage, along with fangs that makes the person bit unable to feel their body or pain."
	cost = 2
	var_changes = list("unarmed_types" = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp, /datum/unarmed_attack/bite/sharp/numbing))

/datum/trait/positive/minor_brute_resist
	name = "Minor Brute Resist"
	desc = "Adds 15% resistance to brute damage"
	cost = 2
	var_changes = list("brute_mod" = 0.85)

/datum/trait/positive/brute_resist
	name = "Brute Resist"
	desc = "Adds 25% resistance to brute damage"
	cost = 3
	var_changes = list("brute_mod" = 0.75)
	excludes = list(/datum/trait/positive/minor_burn_resist,/datum/trait/positive/burn_resist)

/datum/trait/positive/minor_burn_resist
	name = "Minor Burn Resist"
	desc = "Adds 15% resistance to burn damage sources."
	cost = 2
	var_changes = list("burn_mod" = 0.85)

/datum/trait/positive/burn_resist
	name = "Burn Resist"
	desc = "Adds 25% resistance to burn damage sources."
	cost = 3
	var_changes = list("burn_mod" = 0.75)
	excludes = list(/datum/trait/positive/minor_brute_resist,/datum/trait/positive/brute_resist)

/datum/trait/positive/toxin_resist
	name = "Minor Toxin Resist"
	desc = "Adds 15% resistance to toxin damage sources."
	cost = 2
	var_changes = list("toxins_mod" = 0.85)

/datum/trait/positive/toxin_resist_plus
	name = "Toxin Resist"
	desc = "Adds 25% resistance to toxin damage sources."
	cost = 3
	var_changes = list("toxins_mod" = 0.75)
	excludes = list(/datum/trait/positive/toxin_resist,/datum/trait/positive/toxin_resist_plus)

/datum/trait/positive/oxy_resist
	name = "Minor Breathe Resist"
	desc = "You take 15% less oxygen damge and require 12.5% less air (14kpa minimum)."
	cost = 2
	var_changes = list("minimum_breath_pressure" = 14, "oxy_mod" = 0.85)

/datum/trait/positive/oxy_resist_plus
	name = "Breathe Resist"
	desc = "You take 25% less oxygen damge and require 25% less air (12kpa minimum)."
	cost = 3
	var_changes = list("minimum_breath_pressure" = 12, "oxy_mod" = 0.75)
	excludes = list(/datum/trait/positive/oxy_resist,/datum/trait/positive/oxy_resist_plus)

/datum/trait/positive/rad_resist
	name = "Minor Radiation Resist"
	desc = "You take 15% less radition damage"
	cost = 1
	var_changes = list("radiation_mod" = 0.85)

/datum/trait/positive/rad_resist_plus
	name = "Radiation Resist"
	desc = "You take 25% less radition damage"
	cost = 2
	var_changes = list("radiation_mod" = 0.75)
	excludes = list(/datum/trait/positive/rad_resist,/datum/trait/positive/rad_resist_plus)

/datum/trait/positive/photoresistant
	name = "Photoresistant"
	desc = "Decreases stun duration from flashes and other light-based stuns and disabilities by 50%"
	cost = 1
	var_changes = list("flash_mod" = 0.5)

/datum/trait/positive/reinforced
	name = "Reinforced Skeleton"
	desc = "Your body either by science or nature has been reinforced and is harder to break."
	cost = 4 //Strong Trait, high cost.

/datum/trait/positive/reinforced/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	for(var/obj/item/organ/external/O in H.organs)
		O.min_broken_damage *= 1.25
		O.min_bruised_damage *= 1.25

/datum/trait/positive/winged_flight
	name = "Flight"
	desc = "Allows you to fly. Whether by wings, technology, or other means."
	cost = 1

/datum/trait/positive/winged_flight/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	add_verb(H, /mob/living/proc/flying_toggle)
	add_verb(H, /mob/living/proc/start_wings_hovering)

/datum/trait/positive/hardfeet
	name = "Hard Feet"
	desc = "Makes your nice clawed, scaled, hooved, armored, or otherwise just awfully calloused feet immune to glass shards."
	cost = 1

/datum/trait/positive/hardfeet/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	S.species_flags |= NO_MINOR_CUT

/datum/trait/positive/antiseptic_saliva
	name = "Antiseptic Saliva"
	desc = "Your saliva has especially strong antiseptic properties that can be used to heal small wounds."
	cost = 1

/datum/trait/positive/antiseptic_saliva/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/carbon/human/proc/lick_wounds)

/datum/trait/positive/thick_blood
	name = "Thick Blood"
	desc = "You bleed 25% slower."
	cost = 1
	var_changes = list("bloodloss_rate" = 0.75)

/datum/trait/positive/positive/weaver
	name = "Weaver"
	desc = "You can produce silk and create various articles of clothing and objects."
	cost = 2
	var_changes = list("is_weaver" = 1)

/datum/trait/positive/positive/weaver/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/carbon/human/proc/check_silk_amount)
	add_verb(H, /mob/living/carbon/human/proc/toggle_silk_production)
	add_verb(H, /mob/living/carbon/human/proc/weave_structure)
	add_verb(H, /mob/living/carbon/human/proc/weave_item)
	add_verb(H, /mob/living/carbon/human/proc/set_silk_color)
