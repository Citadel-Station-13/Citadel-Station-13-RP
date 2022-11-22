//* singular strings/primitives
/mob/living/carbon/human/proc/get_eye_color(get_dna)
	return get_dna? dna.get_eye_color() : eye_color

/mob/living/carbon/human/proc/set_eye_color(str, set_dna, update = TRUE)
	if(set_dna)
		dna.set_eye_color(str)
	eye_color = str
	if(update)
		update_eyes()

/mob/living/carbon/human/proc/get_body_color(get_dna)
	return get_dna? dna.get_body_color() : body_color

/mob/living/carbon/human/proc/set_body_color(str, set_dna, update = TRUE)
	if(set_dna)
		dna.set_body_color(str)
	body_color = str
	if(update)
		update_icons_body()

//* abstracted read methods
/**
 * gets primary hair color
 * returns null if for some reason we don't have hair accessory set.
 */
/mob/living/carbon/human/proc/get_hair_color(get_dna)
	var/datum/sprite_accessory_data/D = peek_sprite_accessory_hair(get_dna)
	return D.get_color_index(1)
