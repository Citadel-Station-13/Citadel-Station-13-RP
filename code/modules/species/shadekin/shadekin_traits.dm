/datum/trait/kintype
	allowed_species = list(SPECIES_SHADEKIN)
	var/color = BLUE_EYES
	name = "Shadekin Blue Adaptation"
	desc = "Good energy regeneration in darkness, decreased regeneration in the light and unchanged health!"
	cost = 0
	custom_only = FALSE
	var_changes = list(
		"total_health" = 100,
		"energy_light" = 0.5,
		"energy_dark" = 1,
		"unarmed_types" = list(
			/datum/melee_attack/unarmed/stomp,
			/datum/melee_attack/unarmed/kick,
			/datum/melee_attack/unarmed/claws/shadekin,
			/datum/melee_attack/unarmed/bite/sharp/shadekin,
			/datum/melee_attack/unarmed/shadekinharmbap,
		)
	)

	group = /datum/trait_group/shadekin
	group_short_name = "Blue-Eyed"
	show_when_forbidden = FALSE

/datum/trait/kintype/red
	name = "Shadekin Red Adaptation"
	color =	RED_EYES
	desc = "Minimal energy regeneration in darkness, good regeneration in the light and increased health!"
	var_changes = list(
		"total_health" = 200,
		"energy_light" = 1,
		"energy_dark" = 0.25,
		"unarmed_types" = list(
			/datum/melee_attack/unarmed/stomp,
			/datum/melee_attack/unarmed/kick,
			/datum/melee_attack/unarmed/claws/shadekin,
			/datum/melee_attack/unarmed/bite/sharp/shadekin,
			/datum/melee_attack/unarmed/shadekinharmbap
		)
	)

	group = /datum/trait_group/shadekin
	group_short_name = "Red-Eyed"
	show_when_forbidden = FALSE

/datum/trait/kintype/purple
	name = "Shadekin Purple Adaptation"
	color = PURPLE_EYES
	desc = "Very good energy regeneration in darkness, minor regeneration in the light and increased health!"
	var_changes = list(
		"total_health" = 150,
		"energy_light" = 0.25,
		"energy_dark" = 1.5,
		"unarmed_types" = list(
			/datum/melee_attack/unarmed/stomp,
			/datum/melee_attack/unarmed/kick,
			/datum/melee_attack/unarmed/claws/shadekin,
			/datum/melee_attack/unarmed/bite/sharp/shadekin,
			/datum/melee_attack/unarmed/shadekinharmbap
		)
	)

	group = /datum/trait_group/shadekin
	group_short_name = "Purple-Eyed"
	show_when_forbidden = FALSE

/datum/trait/kintype/yellow
	name = "Shadekin Yellow Adaptation"
	color = YELLOW_EYES
	desc = "Highest energy regeneration in darkness, minor regeneration in the light and unchanged health!"
	var_changes = list(
		"total_health" = 100,
		"energy_light" = 0.25,
		"energy_dark" = 3,
		"unarmed_types" = list(
			/datum/melee_attack/unarmed/stomp,
			/datum/melee_attack/unarmed/kick,
			/datum/melee_attack/unarmed/claws/shadekin,
			/datum/melee_attack/unarmed/bite/sharp/shadekin,
			/datum/melee_attack/unarmed/shadekinharmbap
		)
	)

	group = /datum/trait_group/shadekin
	group_short_name = "Yellow-Eyed"
	show_when_forbidden = FALSE

/datum/trait/kintype/green
	name = "Shadekin Green Adaptation"
	color = GREEN_EYES
	desc = "High energy regeneration in darkness, minor regeneration in the light and unchanged health!"
	var_changes = list(
		"total_health" = 100,
		"energy_light" = 0.25,
		"energy_dark" = 2,
		"unarmed_types" = list(
			/datum/melee_attack/unarmed/stomp,
			/datum/melee_attack/unarmed/kick,
			/datum/melee_attack/unarmed/claws/shadekin,
			/datum/melee_attack/unarmed/bite/sharp/shadekin,
			/datum/melee_attack/unarmed/shadekinharmbap
		)
	)

	group = /datum/trait_group/shadekin
	group_short_name = "Green-Eyed"
	show_when_forbidden = FALSE

/datum/trait/kintype/orange
	name = "Shadekin Orange Adaptation"
	color = ORANGE_EYES
	desc = "Good energy regeneration in darkness, minor regeneration in the light and increased health!"
	var_changes = list(
		"total_health" = 175,
		"energy_light" = 0.25,
		"energy_dark" = 1,
		"unarmed_types" = list(
			/datum/melee_attack/unarmed/stomp,
			/datum/melee_attack/unarmed/kick,
			/datum/melee_attack/unarmed/claws/shadekin,
			/datum/melee_attack/unarmed/bite/sharp/shadekin,
			/datum/melee_attack/unarmed/shadekinharmbap
		)
	)

	group = /datum/trait_group/shadekin
	group_short_name = "Orange-Eyed"
	show_when_forbidden = FALSE

/datum/trait/kintype/apply(datum/species/shadekin/S, mob/living/carbon/human/H)
	if (istype(S))
		..(S,H)
		if(color) //Sanity check to see if they're actually a shadekin, otherwise just don't do anything. They shouldn't be able to spawn with the trait.
			S.kin_type = color
			switch(color)
				if(BLUE_EYES)
					H.shapeshifter_set_eye_color("0000FF")
				if(RED_EYES)
					H.shapeshifter_set_eye_color("FF0000")
				if(GREEN_EYES)
					H.shapeshifter_set_eye_color("00FF00")
				if(PURPLE_EYES)
					H.shapeshifter_set_eye_color("FF00FF")
				if(YELLOW_EYES)
					H.shapeshifter_set_eye_color("FFFF00")
				if(ORANGE_EYES)
					H.shapeshifter_set_eye_color("FFA500")


/datum/melee_attack/unarmed/shadekinharmbap
	verb_past_participle = list("slashed", "clawed", "scratched")
	attack_name = "syphon strike"
	attack_verb_legacy = list("hit", "clawed", "slashed", "scratched")
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'

/datum/melee_attack/unarmed/shadekinharmbap/apply_effects(mob/living/carbon/human/shadekin/user, mob/living/carbon/human/target, armour, attack_damage, zone)
	..()
	if(user == target) //Prevent self attack to gain energy
		return
	var/obj/item/organ/internal/brain/shadekin/shade_organ = user.internal_organs_by_name[O_BRAIN]
	if(!istype(shade_organ))
		return
	shade_organ.dark_energy = clamp(shade_organ.dark_energy + attack_damage,0,shade_organ.max_dark_energy) //Convert Damage done to Energy Gained
