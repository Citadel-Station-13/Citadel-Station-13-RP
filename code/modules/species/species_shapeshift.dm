// This is something of an intermediary species used for species that
// need to emulate the appearance of another race. Currently it is only
// used for slimes but it may be useful for changelings later.
var/list/wrapped_species_by_ref = list()

/datum/species/shapeshifter
	abstract_type = /datum/species/shapeshifter

	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
	)

	var/list/valid_transform_species = list()
	var/monochromatic = FALSE
	var/default_form = SPECIES_HUMAN
	var/heal_rate = 0

/datum/species/shapeshifter/get_valid_shapeshifter_forms(mob/living/carbon/human/H)
	return valid_transform_species

/datum/species/shapeshifter/get_icobase(mob/living/carbon/human/H, get_deform)
	if(!H) return ..(null, get_deform)
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_icobase(H, get_deform)

/datum/species/shapeshifter/real_race_key(mob/living/carbon/human/H)
	return "[..()]-[wrapped_species_by_ref["\ref[H]"]]"

/datum/species/shapeshifter/get_effective_bodytype(mob/living/carbon/human/H, obj/item/I, slot_id)
	if(!H) return ..(H, I, slot_id)
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_effective_bodytype(H, I, slot_id)

/datum/species/shapeshifter/get_bodytype_legacy(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_bodytype_legacy(H)

/datum/species/shapeshifter/get_worn_legacy_bodytype(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_worn_legacy_bodytype(H)

/datum/species/shapeshifter/get_blood_mask(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_blood_mask(H)

/datum/species/shapeshifter/get_damage_mask(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_damage_mask(H)

/datum/species/shapeshifter/get_damage_overlays(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_damage_overlays(H)

/datum/species/shapeshifter/get_tail(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_tail(H)

/datum/species/shapeshifter/get_tail_animation(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_tail_animation(H)

/datum/species/shapeshifter/get_tail_hair(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_tail_hair(H)

/datum/species/shapeshifter/get_husk_icon(mob/living/carbon/human/H)
	if(H)
		var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
		if(S)
			return S.get_husk_icon(H)
	 return ..()

/datum/species/shapeshifter/handle_post_spawn(mob/living/carbon/human/H)
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
	var/list/valid_gradstyles = GLOB.hair_gradients
	for(var/hairstyle in hair_styles_list)
		var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if(S.apply_restrictions && !(species.get_bodytype_legacy(src) in S.species_allowed))
			continue
		valid_hairstyles += hairstyle
	for(var/facialhairstyle in facial_hair_styles_list)
		var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if(S.apply_restrictions && !(species.get_bodytype_legacy(src) in S.species_allowed))
			continue
		valid_facialhairstyles += facialhairstyle


	visible_message("<span class='notice'>\The [src]'s form contorts subtly.</span>")
	if(valid_hairstyles.len)
		var/new_hair = input("Select a hairstyle.", "Shapeshifter Hair") as null|anything in valid_hairstyles
		if(!new_hair)
			return
		change_hair(new_hair)
	if(valid_gradstyles.len)
		var/new_hair = input("Select a hair gradient style.", "Shapeshifter Hair") as null|anything in valid_gradstyles
		change_hair_gradient(new_hair ? new_hair : "None")
		if(!new_hair)
			return
	if(valid_facialhairstyles.len)
		var/new_hair = input("Select a facial hair style.", "Shapeshifter Hair") as null|anything in valid_facialhairstyles
		if(!new_hair)
			return
		change_facial_hair(new_hair)

/mob/living/carbon/human/proc/shapeshifter_select_gender()

	set name = "Select Gender"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_gender = input("Please select a gender.", "Shapeshifter Gender") as null|anything in list(FEMALE, MALE, NEUTER, PLURAL)
	if(!new_gender)
		return

	var/new_gender_identity = input("Please select a gender Identity.", "Shapeshifter Gender Identity") as null|anything in list(FEMALE, MALE, NEUTER, PLURAL, HERM)
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

	if(!new_species || !SScharacters.resolve_species_name(new_species) || wrapped_species_by_ref["\ref[src]"] == new_species)
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

	var/new_skin = input(usr, "Please select a new body color.", "Shapeshifter Colour", rgb(r_skin, g_skin, b_skin)) as color|null
	if(!new_skin)
		return
	shapeshifter_set_colour(new_skin)

/mob/living/carbon/human/proc/shapeshifter_set_colour(new_skin)

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

	var/new_hair = input(usr, "Please select a new hair color.", "Hair Colour", rgb(r_hair, g_hair, b_hair)) as color|null
	if(!new_hair)
		return
	shapeshifter_set_hair_color(new_hair)
	var/new_grad = input(usr, "Please select a new hair gradient color.", "Hair Gradient Colour", rgb(r_grad, g_grad, b_grad)) as color|null
	if(!new_grad)
		return
	shapeshifter_set_grad_color(new_grad)
	var/new_fhair = input(usr, "Please select a new facial hair color.", "Facial Hair Color", rgb(r_facial, g_facial, b_facial)) as color|null
	if(!new_fhair)
		return
	shapeshifter_set_facial_color(new_fhair)

/mob/living/carbon/human/proc/shapeshifter_set_hair_color(new_hair)
	change_hair_color(hex2num(copytext(new_hair, 2, 4)), hex2num(copytext(new_hair, 4, 6)), hex2num(copytext(new_hair, 6, 8)))

/mob/living/carbon/human/proc/shapeshifter_set_grad_color(new_grad)
	change_grad_color(hex2num(copytext(new_grad, 2, 4)), hex2num(copytext(new_grad, 4, 6)), hex2num(copytext(new_grad, 6, 8)))

/mob/living/carbon/human/proc/shapeshifter_set_facial_color(new_fhair)
	change_facial_hair_color(hex2num(copytext(new_fhair, 2, 4)), hex2num(copytext(new_fhair, 4, 6)), hex2num(copytext(new_fhair, 6, 8)))

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

/mob/living/carbon/human/proc/shapeshifter_set_eye_color(new_eyes)

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
	var/new_ear_style = tgui_input_list(src, "Pick some ears!", "Character Preference", pretty_ear_styles)
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

		var/current_ter_color = rgb(r_ears3,g_ears3,b_ears3)

		var/new_ter_color = input("Pick tertiary ear color (only applies to some ears):","Ear Color (sec)", current_ter_color) as null|color
		if(new_ter_color)
			new_color_rgb_list = hex2rgb(new_sec_color)
			r_ears3 = new_color_rgb_list[1]
			g_ears3 = new_color_rgb_list[2]
			b_ears3 = new_color_rgb_list[3]

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
	var/new_tail_style = tgui_input_list(src, "Pick a tail!", "Character Preference", pretty_tail_styles)
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

		var/current_ter_color = rgb(r_tail3,g_tail3,b_tail3)

		var/new_ter_color = input("Pick tertiary tail color (only applies to some tails):","Tail Color (sec)", current_ter_color) as null|color
		if(new_ter_color)
			new_color_rgb_list = hex2rgb(new_ter_color)
			r_tail3 = new_color_rgb_list[1]
			g_tail3 = new_color_rgb_list[2]
			b_tail3 = new_color_rgb_list[3]

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
	var/new_wing_style = tgui_input_list(src, "Pick some wings!", "Character Preference", pretty_wing_styles)
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

		var/current_ter_color = rgb(r_wing3,g_wing3,b_wing3)

		var/new_ter_color = input("Pick tertiary wing color (only applies to some wings):","Wing Color (sec)", current_ter_color) as null|color
		if(new_ter_color)
			new_color_rgb_list = hex2rgb(new_ter_color)
			r_wing3 = new_color_rgb_list[1]
			g_wing3 = new_color_rgb_list[2]
			b_wing3 = new_color_rgb_list[3]

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
	visible_message(SPAN_NOTICE("\The [src]'s interal composition seems to change."))
	update_icons_body()

/datum/species/shapeshifter/handle_environment_special(mob/living/carbon/human/H)
	// Heal remaining damage.
	if(H.fire_stacks >= 0 && heal_rate > 0)
		if(H.getBruteLoss() || H.getFireLoss() || H.getOxyLoss() || H.getToxLoss())
			var/nutrition_cost = 0
			var/nutrition_debt = H.getBruteLoss()
			var/starve_mod = 1
			if(H.nutrition <= 25)
				starve_mod = 0.75
			H.adjustBruteLoss(-heal_rate * starve_mod)
			nutrition_cost += nutrition_debt - H.getBruteLoss()

			nutrition_debt = H.getFireLoss()
			H.adjustFireLoss(-heal_rate * starve_mod)
			nutrition_cost += nutrition_debt - H.getFireLoss()

			nutrition_debt = H.getOxyLoss()
			H.adjustOxyLoss(-heal_rate * starve_mod)
			nutrition_cost += nutrition_debt - H.getOxyLoss()

			nutrition_debt = H.getToxLoss()
			H.adjustToxLoss(-heal_rate * starve_mod)
			nutrition_cost += nutrition_debt - H.getToxLoss()
			H.nutrition -= (2 * nutrition_cost) //Costs Nutrition when damage is being repaired, corresponding to the amount of damage being repaired.
			H.nutrition = max(0, H.nutrition) //Ensure it's not below 0.
	..()
