// This is something of an intermediary species used for species that
// need to emulate the appearance of another race. Currently it is only
// used for slimes but it may be useful for changelings later.
var/list/wrapped_species_by_ref = list()

/datum/species/shapeshifter

	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_gender
		)

	var/list/valid_transform_species = list()
	var/monochromatic
	var/default_form = SPECIES_HUMAN

/datum/species/shapeshifter/get_valid_shapeshifter_forms(var/mob/living/carbon/human/H)
	return valid_transform_species

/datum/species/shapeshifter/get_icobase(var/mob/living/carbon/human/H, var/get_deform)
	if(!H) return ..(null, get_deform)
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_icobase(H, get_deform)

/datum/species/shapeshifter/get_race_key(var/mob/living/carbon/human/H)
	return "[..()]-[wrapped_species_by_ref["\ref[H]"]]"

/datum/species/shapeshifter/get_bodytype(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_bodytype(H)

/datum/species/shapeshifter/get_blood_mask(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_blood_mask(H)

/datum/species/shapeshifter/get_damage_mask(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_damage_mask(H)

/datum/species/shapeshifter/get_damage_overlays(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_damage_overlays(H)

/datum/species/shapeshifter/get_tail(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_tail(H)

/datum/species/shapeshifter/get_tail_animation(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_tail_animation(H)

/datum/species/shapeshifter/get_tail_hair(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_tail_hair(H)

/datum/species/shapeshifter/handle_post_spawn(var/mob/living/carbon/human/H)
	..()
	wrapped_species_by_ref["\ref[H]"] = default_form
	if(monochromatic)
		H.r_hair =   H.r_skin
		H.g_hair =   H.g_skin
		H.b_hair =   H.b_skin
		H.r_facial = H.r_skin
		H.g_facial = H.g_skin
		H.b_facial = H.b_skin

	for(var/obj/item/organ/external/E in H.organs)
		E.sync_colour_to_human(H)

// Verbs follow.
/mob/living/carbon/human/proc/shapeshifter_select_hair()

	set name = "Select Hair"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 10

	var/list/valid_hairstyles = list()
	var/list/valid_facialhairstyles = list()
	for(var/hairstyle in hair_styles_list)
		var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if(!(species.get_bodytype(src) in S.species_allowed))
			continue
		valid_hairstyles += hairstyle
	for(var/facialhairstyle in facial_hair_styles_list)
		var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if(!(species.get_bodytype(src) in S.species_allowed))
			continue
		valid_facialhairstyles += facialhairstyle


	visible_message("<span class='notice'>\The [src]'s form contorts subtly.</span>")
	if(valid_hairstyles.len)
		var/new_hair = input("Select a hairstyle.", "Shapeshifter Hair") as null|anything in valid_hairstyles
		change_hair(new_hair ? new_hair : "Bald")
	if(valid_facialhairstyles.len)
		var/new_hair = input("Select a facial hair style.", "Shapeshifter Hair") as null|anything in valid_facialhairstyles
		change_facial_hair(new_hair ? new_hair : "Shaved")

/mob/living/carbon/human/proc/shapeshifter_select_gender()

	set name = "Select Gender"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_gender = input("Please select a gender.", "Shapeshifter Gender") as null|anything in list(FEMALE, MALE, NEUTER, PLURAL)
	if(!new_gender)
		return

	var/new_gender_identity = input("Please select a gender Identity.", "Shapeshifter Gender Identity") as null|anything in list(FEMALE, MALE, NEUTER, PLURAL, HERM) //VOREStation Edit
	if(!new_gender_identity)
		return

	visible_message("<span class='notice'>\The [src]'s form contorts subtly.</span>")
	change_gender(new_gender)
	change_gender_identity(new_gender_identity)

/mob/living/carbon/human/proc/shapeshifter_select_shape()

	set name = "Select Body Shape"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_species = null
	new_species = input("Please select a species to emulate.", "Shapeshifter Body") as null|anything in species.get_valid_shapeshifter_forms(src)

	if(!new_species || !GLOB.all_species[new_species] || wrapped_species_by_ref["\ref[src]"] == new_species)
		return
	shapeshifter_change_shape(new_species)

/mob/living/carbon/human/proc/shapeshifter_change_shape(var/new_species = null)
	if(!new_species)
		return

	wrapped_species_by_ref["\ref[src]"] = new_species
	visible_message("<span class='notice'>\The [src] shifts and contorts, taking the form of \a [new_species]!</span>")
	regenerate_icons()

/mob/living/carbon/human/proc/shapeshifter_select_colour()

	set name = "Select Body Colour"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_skin = input("Please select a new body color.", "Shapeshifter Colour") as color
	if(!new_skin)
		return
	shapeshifter_set_colour(new_skin)

/mob/living/carbon/human/proc/shapeshifter_set_colour(var/new_skin)

	r_skin =   hex2num(copytext(new_skin, 2, 4))
	g_skin =   hex2num(copytext(new_skin, 4, 6))
	b_skin =   hex2num(copytext(new_skin, 6, 8))
	r_synth = r_skin
	g_synth = g_skin
	b_synth = b_skin

	var/datum/species/shapeshifter/S = species
	if(S.monochromatic)
		r_hair =   r_skin
		g_hair =   g_skin
		b_hair =   b_skin
		r_facial = r_skin
		g_facial = g_skin
		b_facial = b_skin

	for(var/obj/item/organ/external/E in organs)
		E.sync_colour_to_human(src)

	regenerate_icons()

/mob/living/carbon/human/proc/shapeshifter_select_hair_colors()

	set name = "Select Hair Colors"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_hair = input("Please select a new hair color.", "Hair Colour") as color
	if(!new_hair)
		return
	shapeshifter_set_hair_color(new_hair)
	var/new_fhair = input("Please select a new facial hair color.", "Facial Hair Color") as color
	if(!new_fhair)
		return
	shapeshifter_set_facial_color(new_fhair)

/mob/living/carbon/human/proc/shapeshifter_set_hair_color(var/new_hair)

	change_hair_color(hex2num(copytext(new_hair, 2, 4)), hex2num(copytext(new_hair, 4, 6)), hex2num(copytext(new_hair, 6, 8)))

/mob/living/carbon/human/proc/shapeshifter_set_facial_color(var/new_fhair)

	change_facial_hair_color(hex2num(copytext(new_fhair, 2, 4)), hex2num(copytext(new_fhair, 4, 6)), hex2num(copytext(new_fhair, 6, 8)))

// Replaces limbs and copies wounds
/mob/living/carbon/human/proc/shapeshifter_change_species(var/new_species)
	if(!species)
		return

	dna.species = new_species

	var/list/limb_exists = list(
		BP_TORSO =  0,
		BP_GROIN =  0,
		BP_HEAD =   0,
		BP_L_ARM =  0,
		BP_R_ARM =  0,
		BP_L_LEG =  0,
		BP_R_LEG =  0,
		BP_L_HAND = 0,
		BP_R_HAND = 0,
		BP_L_FOOT = 0,
		BP_R_FOOT = 0
		)
	var/list/wounds_by_limb = list(
		BP_TORSO =  new/list(),
		BP_GROIN =  new/list(),
		BP_HEAD =   new/list(),
		BP_L_ARM =  new/list(),
		BP_R_ARM =  new/list(),
		BP_L_LEG =  new/list(),
		BP_R_LEG =  new/list(),
		BP_L_HAND = new/list(),
		BP_R_HAND = new/list(),
		BP_L_FOOT = new/list(),
		BP_R_FOOT = new/list()
		)

	// Copy damage values
	for(var/limb in organs_by_name)
		var/obj/item/organ/external/O = organs_by_name[limb]
		limb_exists[O.organ_tag] = 1
		wounds_by_limb[O.organ_tag] = O.wounds

	species = GLOB.all_species[new_species]
	species.create_organs(src)
//	species.handle_post_spawn(src)

	for(var/limb in organs_by_name)
		var/obj/item/organ/external/O = organs_by_name[limb]
		if(limb_exists[O.organ_tag])
			O.species = GLOB.all_species[new_species]
			O.wounds = wounds_by_limb[O.organ_tag]
			// sync the organ's damage with its wounds
			O.update_damages()
			O.owner.updatehealth() //droplimb will call updatehealth() again if it does end up being called
		else
			organs.Remove(O)
			organs_by_name.Remove(O)

	spawn(0)
		regenerate_icons()
/* VOREStation Edit - Our own trait system, sorry.
	if(species && mind)
		apply_traits()
*/
	return

/mob/living/carbon/human/proc/shapeshifter_select_eye_colour()

	set name = "Select Eye Color"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/current_color = rgb(r_eyes,g_eyes,b_eyes)
	var/new_eyes = input("Pick a new color for your eyes.","Eye Color", current_color) as null|color
	if(!new_eyes)
		return

	shapeshifter_set_eye_color(new_eyes)

/mob/living/carbon/human/proc/shapeshifter_set_eye_color(var/new_eyes)

	var/list/new_color_rgb_list = hex2rgb(new_eyes)
	// First, update mob vars.
	r_eyes = new_color_rgb_list[1]
	g_eyes = new_color_rgb_list[2]
	b_eyes = new_color_rgb_list[3]
	// Now sync the organ's eye_colour list, if possible
	var/obj/item/organ/internal/eyes/eyes = internal_organs_by_name[O_EYES]
	if(istype(eyes))
		eyes.update_colour()

	update_icons_body()
	update_eyes()

/mob/living/carbon/human/proc/shapeshifter_select_ears()
	set name = "Select Ears"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 10
	// Construct the list of names allowed for this user.
	var/list/pretty_ear_styles = list("Normal" = null)
	for(var/path in ear_styles_list)
		var/datum/sprite_accessory/ears/instance = ear_styles_list[path]
		if((!instance.ckeys_allowed) || (ckey in instance.ckeys_allowed))
			pretty_ear_styles[instance.name] = path

	// Present choice to user
	var/new_ear_style = input(src, "Pick some ears!", "Character Preference", ear_style ? ear_style.name : null) as null|anything in pretty_ear_styles
	if(!new_ear_style)
		return

	//Set new style
	ear_style = ear_styles_list[pretty_ear_styles[new_ear_style]]

	//Allow color picks
	var/current_pri_color = rgb(r_ears,g_ears,b_ears)

	var/new_pri_color = input("Pick primary ear color:","Ear Color (Pri)", current_pri_color) as null|color
	if(new_pri_color)
		var/list/new_color_rgb_list = hex2rgb(new_pri_color)
		r_ears = new_color_rgb_list[1]
		g_ears = new_color_rgb_list[2]
		b_ears = new_color_rgb_list[3]

		//Indented inside positive primary color choice, don't bother if they clicked cancel
		var/current_sec_color = rgb(r_ears2,g_ears2,b_ears2)

		var/new_sec_color = input("Pick secondary ear color (only applies to some ears):","Ear Color (sec)", current_sec_color) as null|color
		if(new_sec_color)
			new_color_rgb_list = hex2rgb(new_sec_color)
			r_ears2 = new_color_rgb_list[1]
			g_ears2 = new_color_rgb_list[2]
			b_ears2 = new_color_rgb_list[3]

	update_hair() //Includes Virgo ears

/mob/living/carbon/human/proc/shapeshifter_select_tail()
	set name = "Select Tail"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 10
	// Construct the list of names allowed for this user.
	var/list/pretty_tail_styles = list("Normal" = null)
	for(var/path in tail_styles_list)
		var/datum/sprite_accessory/tail/instance = tail_styles_list[path]
		if((!instance.ckeys_allowed) || (ckey in instance.ckeys_allowed))
			pretty_tail_styles[instance.name] = path

	// Present choice to user
	var/new_tail_style = input(src, "Pick a tail!", "Character Preference", tail_style ? tail_style.name : null) as null|anything in pretty_tail_styles
	if(!new_tail_style)
		return

	//Set new style
	tail_style = tail_styles_list[pretty_tail_styles[new_tail_style]]

	//Allow color picks
	var/current_pri_color = rgb(r_tail,g_tail,b_tail)

	var/new_pri_color = input("Pick primary tail color:","Tail Color (Pri)", current_pri_color) as null|color
	if(new_pri_color)
		var/list/new_color_rgb_list = hex2rgb(new_pri_color)
		r_tail = new_color_rgb_list[1]
		g_tail = new_color_rgb_list[2]
		b_tail = new_color_rgb_list[3]

		//Indented inside positive primary color choice, don't bother if they clicked cancel
		var/current_sec_color = rgb(r_tail2,g_tail2,b_tail2)

		var/new_sec_color = input("Pick secondary tail color (only applies to some tails):","Tail Color (sec)", current_sec_color) as null|color
		if(new_sec_color)
			new_color_rgb_list = hex2rgb(new_sec_color)
			r_tail2 = new_color_rgb_list[1]
			g_tail2 = new_color_rgb_list[2]
			b_tail2 = new_color_rgb_list[3]

	update_tail_showing()

/mob/living/carbon/human/proc/shapeshifter_select_wings()
	set name = "Select Wings"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 10
	// Construct the list of names allowed for this user.
	var/list/pretty_wing_styles = list("None" = null)
	for(var/path in wing_styles_list)
		var/datum/sprite_accessory/wing/instance = wing_styles_list[path]
		if((!instance.ckeys_allowed) || (ckey in instance.ckeys_allowed))
			pretty_wing_styles[instance.name] = path

	// Present choice to user
	var/new_wing_style = input(src, "Pick some wings!", "Character Preference", wing_style ? wing_style.name : null) as null|anything in pretty_wing_styles
	if(!new_wing_style)
		return

	//Set new style
	wing_style = wing_styles_list[pretty_wing_styles[new_wing_style]]

	//Allow color picks
	var/current_color = rgb(r_wing,g_wing,b_wing)

	var/new_color = input("Pick wing color:","Wing Color", current_color) as null|color
	if(new_color)
		var/list/new_color_rgb_list = hex2rgb(new_color)
		r_wing = new_color_rgb_list[1]
		g_wing = new_color_rgb_list[2]
		b_wing = new_color_rgb_list[3]

		//Indented inside positive primary color choice, don't bother if they clicked cancel
		var/current_sec_color = rgb(r_wing2,g_wing2,b_wing2)

		var/new_sec_color = input("Pick secondary wing color (only applies to some wings):","Wing Color (sec)", current_sec_color) as null|color
		if(new_sec_color)
			new_color_rgb_list = hex2rgb(new_sec_color)
			r_wing2 = new_color_rgb_list[1]
			g_wing2 = new_color_rgb_list[2]
			b_wing2 = new_color_rgb_list[3]

	update_wing_showing()

/mob/living/carbon/human/proc/promethean_select_opaqueness()

	set name = "Toggle Transparency"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	for(var/limb in src.organs)
		var/obj/item/organ/external/L = limb
		L.transparent = !L.transparent
	visible_message("<span class='notice'>\The [src]'s interal composition seems to change.</span>")
	update_icons_body()

