/datum/trait/positive/speed_fast
	name = "Haste"
	desc = "Faster than average."
	cost = 2
	var_changes = list("slowdown" = -0.2)

	group = /datum/trait_group/speed
	group_short_name = "Haste"
	sort_key = "3-Haste"

/datum/trait/positive/endurance_plus
	name = "Better Endurance"
	desc = "110 hitpoints."
	cost = 3
	var_changes = list("total_health" = 110)

	group = /datum/trait_group/health
	group_short_name = "Better"
	sort_key = "4-Better"

	excluded_species = list(SPECIES_HOLOSPHERE)

/datum/trait/positive/endurance_high
	name = "High Endurance"
	desc = "125 hitpoints."
	cost = 4
	var_changes = list("total_health" = 125)

	group = /datum/trait_group/health
	group_short_name = "High"
	sort_key = "5-High"

	excluded_species = list(SPECIES_HOLOSPHERE)

/datum/trait/positive/endurance_high/apply(datum/species/S, mob/living/carbon/human/H)
	..(S,H)
	H.setMaxHealth(S.total_health)

/datum/trait/positive/nonconductive
	name = "Non-Conductive"
	desc = "25% less."
	cost = 2 //This affects tasers!
	var_changes = list("siemens_coefficient" = 0.75)

	group = /datum/trait_group/electro
	group_short_name = "Non-Conductive"
	sort_key = "5-Non-Conductive"

/datum/trait/positive/nonconductive_plus
	name = "Major Non-Conductive"
	desc = "50% less."
	cost = 3 //Let us not forget this affects tasers!
	var_changes = list("siemens_coefficient" = 0.5)

	group = /datum/trait_group/electro
	group_short_name = "Major Non-Conductive"
	sort_key = "6-Major Non-Conductive"

/datum/trait/positive/melee_attack
	name = "Sharp Melee"
	desc = "Provides sharp melee attacks that do more damage."
	cost = 1
	var_changes = list("unarmed_types" = list(/datum/melee_attack/unarmed/stomp, /datum/melee_attack/unarmed/kick, /datum/melee_attack/unarmed/claws/good, /datum/melee_attack/unarmed/bite/sharp/good))

	group = /datum/trait_group/bite_and_claw
	group_short_name = "Sharp"
	sort_key = "6-Sharp"

/datum/trait/positive/melee_attack/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	S.update_attack_types()

/datum/trait/positive/melee_attack_fangs
	name = "Sharp Melee & Venomous Fangs"
	desc = "That plus venomous fangs."
	cost = 2
	var_changes = list("unarmed_types" = list(/datum/melee_attack/unarmed/stomp, /datum/melee_attack/unarmed/kick, /datum/melee_attack/unarmed/claws/good/venom, /datum/melee_attack/unarmed/bite/sharp/good/venom))

	group = /datum/trait_group/bite_and_claw
	group_short_name = "Sharp, Venomous"
	sort_key = "7-Sharp, Venomous"

/datum/trait/positive/melee_attack_fangs/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	S.update_attack_types()

/datum/trait/positive/minor_brute_resist
	name = "Minor Brute Resist"
	desc = "15% less."
	cost = 2
	var_changes = list("brute_mod" = 0.85)

	group = /datum/trait_group/brute
	group_short_name = "Minor Resist"
	sort_key = "5-Minor Resist"

/datum/trait/positive/brute_resist
	name = "Brute Resist"
	desc = "25% less."
	cost = 3
	var_changes = list("brute_mod" = 0.75)
	excludes = list(/datum/trait/positive/minor_burn_resist,/datum/trait/positive/burn_resist)

	group = /datum/trait_group/brute
	group_short_name = "Resist"
	sort_key = "6-Resist"

/datum/trait/positive/minor_burn_resist
	name = "Minor Burn Resist"
	desc = "15% less."
	cost = 2
	var_changes = list("burn_mod" = 0.85)

	group = /datum/trait_group/burn
	group_short_name = "Minor Resist"
	sort_key = "5-Minor Resist"

/datum/trait/positive/burn_resist
	name = "Burn Resist"
	desc = "25% less."
	cost = 3
	var_changes = list("burn_mod" = 0.75)
	excludes = list(/datum/trait/positive/minor_brute_resist,/datum/trait/positive/brute_resist)

	group = /datum/trait_group/burn
	group_short_name = "Resist"
	sort_key = "6-Resist"

/datum/trait/positive/toxin_resist
	name = "Minor Toxin Resist"
	desc = "15% less."
	cost = 2
	var_changes = list("toxins_mod" = 0.85)

	group = /datum/trait_group/toxin
	group_short_name = "Minor Resist"
	sort_key = "5-Minor Resist"

/datum/trait/positive/toxin_resist_plus
	name = "Toxin Resist"
	desc = "25% less."
	cost = 3
	var_changes = list("toxins_mod" = 0.75)
	excludes = list(/datum/trait/positive/toxin_resist,/datum/trait/positive/toxin_resist_plus)

	group = /datum/trait_group/toxin
	group_short_name = "Resist"
	sort_key = "6-Resist"

/datum/trait/positive/oxy_resist
	name = "Minor Breathe Resist"
	desc = "15% less damage, 12.5% less air. (14kpa min)"
	cost = 2
	var_changes = list("minimum_breath_pressure" = 14, "oxy_mod" = 0.85)
	extra_id_info = "Employee only requires an atmospheric pressure of <b>14kPa</b> to breathe."

	group = /datum/trait_group/oxy
	group_short_name = "Minor Resist"
	sort_key = "5-Minor Resist"

/datum/trait/positive/oxy_resist_plus
	name = "Breathe Resist"
	desc = "25% less damage, 25% less air. (12kpa min)"
	cost = 3
	var_changes = list("minimum_breath_pressure" = 12, "oxy_mod" = 0.75)
	excludes = list(/datum/trait/positive/oxy_resist,/datum/trait/positive/oxy_resist_plus)
	extra_id_info = "Employee only requires an atmospheric pressure of <b>12kPa</b> to breathe."

	group = /datum/trait_group/oxy
	group_short_name = "Resist"
	sort_key = "6-Resist"

/datum/trait/positive/rad_resist
	name = "Minor Radiation Resist"
	desc = "15% less."
	cost = 1
	var_changes = list("radiation_mod" = 0.85)

	group = /datum/trait_group/rad
	group_short_name = "Minor Resist"
	sort_key = "5-Minor Resist"

/datum/trait/positive/rad_resist_plus
	name = "Radiation Resist"
	desc = "25% less."
	cost = 2
	var_changes = list("radiation_mod" = 0.75)
	excludes = list(/datum/trait/positive/rad_resist,/datum/trait/positive/rad_resist_plus)

	group = /datum/trait_group/rad
	group_short_name = "Resist"
	sort_key = "6-Resist"

/datum/trait/positive/photoresistant
	name = "Photoresistant"
	desc = "Decreases stun duration from flashes and other light-based stuns and disabilities by 50%"
	cost = 1
	var_changes = list("flash_mod" = 0.5)

	group = /datum/trait_group/photosensitivity
	group_short_name = "Photoresistant"
	sort_key = "6-Photoresistant"

/datum/trait/positive/reinforced
	name = "Reinforced Skeleton"
	desc = "Harder to break."
	cost = 4 //Strong Trait, high cost.

	group = /datum/trait_group/bones
	group_short_name = "Reinforced"
	sort_key = "6-Reinforced"

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

/datum/trait/positive/hardfeet
	name = "Hard Feet"
	desc = "Makes your nice clawed, scaled, hooved, armored, or otherwise just awfully calloused feet immune to glass shards."
	cost = 1

/datum/trait/positive/hardfeet/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	S.species_flags |= NO_MINOR_CUT

/datum/trait/positive/antiseptic_saliva
	name = "Antiseptic Saliva"
	desc = "Does the same thing, costs more. Weird."
	cost = 1
	extra_id_info = "Employee's saliva carries antiseptic properties."

	group = /datum/trait_group/vampirism
	group_short_name = "Saliva"
	sort_key = "9-Saliva"


/datum/trait/positive/antiseptic_saliva/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/carbon/human/proc/lick_wounds)

/datum/trait/positive/thick_blood
	name = "Thick Blood"
	desc = "You bleed 25% slower."
	cost = 1
	var_changes = list("bloodloss_rate" = 0.75)

	group = /datum/trait_group/blood
	group_short_name = "Thick Blood"
	sort_key = "6-Thick Blood"

/datum/trait/positive/positive/weaver
	name = "Weaver"
	desc = "You can produce silk and create various articles of clothing and objects."
	cost = 2
	//var_changes = list("is_weaver" = 1)

/datum/trait/positive/positive/weaver/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/carbon/human/proc/check_silk_amount)
	add_verb(H, /mob/living/carbon/human/proc/toggle_silk_production)
	add_verb(H, /mob/living/carbon/human/proc/weave_structure)
	add_verb(H, /mob/living/carbon/human/proc/weave_item)
	add_verb(H, /mob/living/carbon/human/proc/set_silk_color)
	var/obj/item/organ/internal/weaver/weak/silk = new(H)
	H.internal_organs += silk
	H.internal_organs_by_name[O_WEAVER] = silk

/datum/trait/positive/aquatic
	name = "Aquatic"
	desc = "You can breathe under water and can traverse water more efficiently. Additionally, you can eat others in the water."
	cost = 1
	sort_key = "10-Aquatic"

/datum/trait/positive/aquatic/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	ADD_TRAIT(H, TRAIT_MOB_WATER_BREATHER, LOADOUT_TRAIT)
	add_verb(H, /mob/living/carbon/human/proc/underwater_devour)
	add_verb(H, /mob/living/carbon/human/proc/water_stealth)
	S.water_movement = min(-4, S.water_movement)
	..()
