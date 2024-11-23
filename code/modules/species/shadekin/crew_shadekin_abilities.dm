/datum/power/shadekin/crewkin_create_shade
	name = "Create Shade (25)"
	desc = "Create a field of darkness that follows you."
	verbpath = /mob/living/carbon/human/proc/crewkin_create_shade
	ability_icon_state = "tech_dispelold"

/mob/living/carbon/human/proc/crewkin_create_shade()
	set name = "Create Shade (25)"
	set desc = "Create a field of darkness that follows you."
	set category = "Shadekin"

	var/ability_cost = 25

	if(species.get_exact_species_id() != SPECIES_ID_SHADEKIN_BLACK)
		to_chat(src, "<span class='warning'>Only a black-eyed shadekin can use that!</span>")
		return FALSE
	else if(stat)
		to_chat(src, "<span class='warning'>Can't use that ability in your state!</span>")
		return FALSE
	else if(shadekin_get_energy() < ability_cost)
		to_chat(src, "<span class='warning'>Not enough energy for that ability!</span>")
		return FALSE

	playsound(src, 'sound/effects/bamf.ogg', 75, 1)

	add_modifier(/datum/modifier/shadekin/create_shade/crew,20 SECONDS)
	shadekin_adjust_energy(-ability_cost)
	return TRUE

/datum/modifier/shadekin/create_shade/crew
	range = 8
