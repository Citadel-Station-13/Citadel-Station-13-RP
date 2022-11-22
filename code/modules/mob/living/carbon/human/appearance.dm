/mob/living/carbon/human/proc/change_appearance(var/flags = APPEARANCE_ALL_HAIR, var/location = src, var/mob/user = src, var/check_species_whitelist = 1, var/list/species_whitelist = list(), var/list/species_blacklist = list(), var/datum/topic_state/state = default_state)
	#warn refactor to use shapeshift panel

#warn param for updating DNA too?
//* singular strings/primitives
#warn update icons for these
/mob/living/carbon/human/proc/get_eye_color()
	return dna.get_eye_color()

/mob/living/carbon/human/proc/set_eye_color(str, update = TRUE)
	return dna.set_eye_color(str)

/mob/living/carbon/human/proc/get_body_color()
	return dna.get_body_color()

/mob/living/carbon/human/proc/set_body_color(str, update = TRUE)
	return dna.set_body_color(str)


//* abstracted read methods
/**
 * gets primary hair color
 * returns null if for some reason we don't have hair accessory set.
 */
/mob/living/carbon/human/proc/get_hair_color()
	var/datum/sprite_accessory_data/D = peek_sprite_accessory_hair()
	return D.get_color_index(1)
