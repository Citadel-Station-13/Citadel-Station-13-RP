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
	var/datum/species/S = SScharacters.resolve_species_name(H.species.base_species)
	if(istype(S, src)) return ..(null, get_deform)
	return S.get_icobase(H, get_deform)

/datum/species/shapeshifter/real_race_key(mob/living/carbon/human/H)
	return "[..()]-[H.species.base_species]"

/datum/species/shapeshifter/get_effective_bodytype(mob/living/carbon/human/H, obj/item/I, slot_id)
	if(!H) return ..(H, I, slot_id)
	var/datum/species/S = SScharacters.resolve_species_name(H.species.base_species)
	if(istype(S, src)) return ..(H, I, slot_id)
	return S.get_effective_bodytype(H, I, slot_id)

/datum/species/shapeshifter/get_bodytype_legacy(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(H.species.base_species)
	if(istype(S, src)) return ..()
	return S.get_bodytype_legacy(H)

/datum/species/shapeshifter/get_worn_legacy_bodytype(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(H.species.base_species)
	if(istype(S, src)) return ..()
	return S.get_worn_legacy_bodytype(H)

/datum/species/shapeshifter/get_blood_mask(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(H.species.base_species)
	if(istype(S, src)) return ..()
	return S.get_blood_mask(H)

/datum/species/shapeshifter/get_damage_mask(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(H.species.base_species)
	if(istype(S, src)) return ..()
	return S.get_damage_mask(H)

/datum/species/shapeshifter/get_damage_overlays(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(H.species.base_species)
	if(istype(S, src)) return ..()
	return S.get_damage_overlays(H)

/datum/species/shapeshifter/get_default_sprite_accessory(mob/living/carbon/human/character, slot)
	if(!character)
		return ..()
	var/datum/species/S = SScharacters.resolve_species_name(character.species.base_species)
	if(istype(S, src)) return ..()
	return S.get_default_sprite_accessory(arglist(args))

/datum/species/shapeshifter/get_husk_icon(mob/living/carbon/human/H)
	if(H)
		var/datum/species/S = SScharacters.resolve_species_name(H.species.base_species)
		if(istype(S, src)) return ..()
		if(S)
			return S.get_husk_icon(H)
	 return ..()

/datum/species/shapeshifter/handle_post_spawn(mob/living/carbon/human/H)
	..()
	H.species.base_species = default_form
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
	for(var/hairstyle in GLOB.legacy_hair_lookup)
		var/datum/sprite_accessory/S = GLOB.legacy_hair_lookup[hairstyle]
		if(gender == MALE && S.random_generation_gender == FEMALE)
			continue
		if(gender == FEMALE && S.random_generation_gender == MALE)
			continue
		if(S.apply_restrictions && !(species.get_bodytype_legacy(src) in S.species_allowed))
			continue
		valid_hairstyles += hairstyle
	for(var/facialhairstyle in GLOB.legacy_facial_hair_lookup)
		var/datum/sprite_accessory/S = GLOB.legacy_facial_hair_lookup[facialhairstyle]
		if(!isnull(S.random_generation_gender) && gender != S.random_generation_gender)
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

	if(!new_species || !SScharacters.resolve_species_name(new_species) || species.base_species == new_species)
		return
	shapeshifter_change_shape(new_species)

/mob/living/carbon/human/proc/shapeshifter_change_shape(var/new_species = null)
	if(!new_species)
		return

	species.base_species = SScharacters.resolve_species_name(new_species).name

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
	if(istype(S) && S.monochromatic)
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
	for(var/path in GLOB.legacy_ears_lookup)
		var/datum/sprite_accessory/ears/instance = GLOB.legacy_ears_lookup[path]
		pretty_ear_styles[instance.name] = path

	// Present choice to user
	var/new_ear_style = tgui_input_list(src, "Pick some ears!", "Character Preference", pretty_ear_styles)
	if(!new_ear_style)
		return

	//Set new style
	ear_style = GLOB.legacy_ears_lookup[pretty_ear_styles[new_ear_style]]

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

	render_spriteacc_ears() //Includes Virgo ears

/mob/living/carbon/human/proc/shapeshifter_select_horns()
	set name = "Select Secondary Ears"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 10
	// Construct the list of names allowed for this user.
	var/list/pretty_horn_styles = list("Normal" = null)
	for(var/path in GLOB.legacy_ears_lookup)
		var/datum/sprite_accessory/ears/instance = GLOB.legacy_ears_lookup[path]
		pretty_horn_styles[instance.name] = path

	// Present choice to user
	var/new_horn_style = tgui_input_list(src, "Pick some secondary ears!", "Character Preference", pretty_horn_styles)
	if(!new_horn_style)
		return

	//Set new style
	horn_style = GLOB.legacy_ears_lookup[pretty_horn_styles[new_horn_style]]

	//Allow color picks
	var/current_pri_color = rgb(r_horn,g_horn,b_horn)

	var/new_pri_color = input("Pick primary ear color:","Ear Color (Pri)", current_pri_color) as null|color
	if(new_pri_color)
		var/list/new_color_rgb_list = hex2rgb(new_pri_color)
		r_horn = new_color_rgb_list[1]
		g_horn = new_color_rgb_list[2]
		b_horn = new_color_rgb_list[3]

		//Indented inside positive primary color choice, don't bother if they clicked cancel
		var/current_sec_color = rgb(r_horn2,g_horn2,b_horn2)

		var/new_sec_color = input("Pick secondary ear color (only applies to some ears):","Ear Color (sec)", current_sec_color) as null|color
		if(new_sec_color)
			new_color_rgb_list = hex2rgb(new_sec_color)
			r_horn2 = new_color_rgb_list[1]
			g_horn2 = new_color_rgb_list[2]
			b_horn2 = new_color_rgb_list[3]

		var/current_ter_color = rgb(r_horn3,g_horn3,b_horn3)

		var/new_ter_color = input("Pick tertiary ear color (only applies to some ears):","Ear Color (sec)", current_ter_color) as null|color
		if(new_ter_color)
			new_color_rgb_list = hex2rgb(new_sec_color)
			r_horn3 = new_color_rgb_list[1]
			g_horn3 = new_color_rgb_list[2]
			b_horn3 = new_color_rgb_list[3]

	render_spriteacc_horns()

/mob/living/carbon/human/proc/shapeshifter_select_tail()
	set name = "Select Tail"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 10
	// Construct the list of names allowed for this user.
	var/list/pretty_tail_styles = list("Normal" = null)
	for(var/path in GLOB.legacy_tail_lookup)
		var/datum/sprite_accessory/tail/instance = GLOB.legacy_tail_lookup[path]
		pretty_tail_styles[instance.name] = path

	// Present choice to user
	var/new_tail_style = tgui_input_list(src, "Pick a tail!", "Character Preference", pretty_tail_styles)
	if(!new_tail_style)
		return

	//Set new style
	tail_style = GLOB.legacy_tail_lookup[pretty_tail_styles[new_tail_style]]

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

	render_spriteacc_tail()

/mob/living/carbon/human/proc/shapeshifter_select_wings()
	set name = "Select Wings"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 10
	// Construct the list of names allowed for this user.
	var/list/pretty_wing_styles = list("None" = null)
	for(var/path in GLOB.legacy_wing_lookup)
		var/datum/sprite_accessory/wing/instance = GLOB.legacy_wing_lookup[path]
		pretty_wing_styles[instance.name] = path

	// Present choice to user
	var/new_wing_style = tgui_input_list(src, "Pick some wings!", "Character Preference", pretty_wing_styles)
	if(!new_wing_style)
		return

	//Set new style
	wing_style = GLOB.legacy_wing_lookup[pretty_wing_styles[new_wing_style]]

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

	render_spriteacc_wings()

/mob/living/carbon/human/proc/promethean_toggle_body_transparency()

	set name = "Toggle Body Opacity" //Opacity is a shorter word than Transparency - the latter word cuts off on the verb button.
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	for(var/limb in src.organs)
		var/obj/item/organ/external/L = limb
		L.transparent = !L.transparent
	visible_message(SPAN_NOTICE("\The [src]'s internal composition seems to change."))
	update_icons_body()

/mob/living/carbon/human/proc/promethean_set_hair_transparency()

	set name = "Set Hair Opacity"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_transparency = input("Pick a number between 100 and 255, 255 being no transparency.", "Change Transparency") as num|null
	if(new_transparency)
		new_transparency = clamp(new_transparency,100,255)
		var/obj/item/organ/external/head/H = src.get_organ(BP_HEAD)
		H.hair_opacity = new_transparency
		visible_message(SPAN_NOTICE("\The [src]'s \"hair\" composition seems to change."))
		update_hair()

/datum/species/shapeshifter/handle_environment_special(mob/living/carbon/human/H, datum/gas_mixture/environment, dt)
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



/mob/living/carbon/human/proc/shapeshifter_copy_core_features(var/mob/living/carbon/human/target)
	change_gender(target.gender)
	change_gender_identity(target.identifying_gender)
	change_hair(target.h_style)
	change_hair_gradient(target.grad_style)
	change_facial_hair(target.f_style)
	change_hair_color(target.r_hair, target.g_hair, target.b_hair)
	change_grad_color(target.r_grad, target.g_grad, target.b_grad)
	change_facial_hair_color(target.r_facial, target.g_facial, target.b_facial)
	change_eye_color(target.r_eyes, target.g_eyes, target.b_eyes)

	if(target.species.species_appearance_flags & HAS_SKIN_COLOR)
		change_skin_color(target.r_skin, target.g_skin, target.b_skin)
	if(target.species.species_appearance_flags & HAS_SKIN_TONE)
		change_skin_tone(target.s_tone)

	//why are these eploded instead of using the individual colour/style change calls?
	//so we only have to do the render call once (per accessory). they're way more expensive than hair
	ear_style = target.ear_style
	r_ears = target.r_ears
	g_ears = target.g_ears
	b_ears = target.b_ears
	r_ears2 = target.r_ears2
	g_ears2 = target.g_ears2
	b_ears2 = target.b_ears2
	r_ears3 = target.r_ears3
	g_ears3 = target.g_ears3
	b_ears3 = target.b_ears3
	render_spriteacc_ears()

	horn_style = target.horn_style
	r_horn = target.r_horn
	g_horn = target.g_horn
	b_horn = target.b_horn
	r_horn2 = target.r_horn2
	g_horn2 = target.g_horn2
	b_horn2 = target.b_horn2
	r_horn3 = target.r_horn3
	g_horn3 = target.g_horn3
	b_horn3 = target.b_horn3
	render_spriteacc_horns()

	tail_style = target.tail_style
	r_tail = target.r_tail
	g_tail = target.g_tail
	b_tail = target.b_tail
	r_tail2 = target.r_tail2
	g_tail2 = target.g_tail2
	b_tail2 = target.b_tail2
	r_tail3 = target.r_tail3
	g_tail3 = target.g_tail3
	b_tail3 = target.b_tail3
	render_spriteacc_tail()

	wing_style = target.wing_style
	grad_wingstyle = target.grad_wingstyle

	r_gradwing = target.r_gradwing
	g_gradwing = target.g_gradwing
	b_gradwing = target.b_gradwing
	r_wing = target.r_wing
	g_wing = target.g_wing
	b_wing = target.b_wing
	r_wing2 = target.r_wing2
	g_wing2 = target.g_wing2
	b_wing2 = target.b_wing2
	r_wing3 = target.r_wing3
	g_wing3 = target.g_wing3
	b_wing3 = target.b_wing3
	render_spriteacc_wings()

/mob/living/carbon/human/proc/shapeshifter_reset_to_slot()
	set name = "Reset Appearance to Slot"
	set category = "Abilities"
	set desc = "Resets your character's appearance to the CURRENTLY-SELECTED slot."

	shapeshifter_reset_to_slot_generic(1 MINUTE, "<span class='warning'>[src] deforms and contorts strangely...</span>", 5 SECONDS)

/mob/living/carbon/human/proc/hologram_reset_to_slot()
	set name = "Reset Appearance to Slot"
	set category = "Abilities"
	set desc = "Resets your character's appearance to the CURRENTLY-SELECTED slot."

	shapeshifter_reset_to_slot_generic(1 MINUTE, "<span class='warning'>[src]'s hologram flickers briefly...</span>", 5 SECONDS)

/mob/living/carbon/human/proc/shapeshifter_reset_to_slot_generic(transform_cooldown, transform_text, transform_duration)
	if(stat || world.time < last_special)
		return

	last_special = world.time + transform_cooldown

	visible_message(transform_text)

	if(!do_after(src, transform_duration))
		return FALSE

	shapeshifter_reset_to_slot_core(src)

	//sigh
	if(istype(src.species, /datum/species/shapeshifter))
		var/datum/species/shapeshifter/SS = src.species
		SS.base_species = SS.default_form

	regenerate_icons()

//i cant wait for characters v2
/mob/living/carbon/human/proc/shapeshifter_reset_to_slot_core(var/mob/living/carbon/human/character)

	var/datum/preferences/pref = character.client.prefs

	character.gender = pref.biological_gender
	character.identifying_gender = pref.identifying_gender

	character.r_eyes			= pref.r_eyes
	character.g_eyes			= pref.g_eyes
	character.b_eyes			= pref.b_eyes
	character.r_hair			= pref.r_hair
	character.g_hair			= pref.g_hair
	character.b_hair			= pref.b_hair
	character.r_grad			= pref.r_grad
	character.g_grad			= pref.g_grad
	character.b_grad			= pref.b_grad
	character.r_facial			= pref.r_facial
	character.g_facial			= pref.g_facial
	character.b_facial			= pref.b_facial
	character.r_skin			= pref.r_skin
	character.g_skin			= pref.g_skin
	character.b_skin			= pref.b_skin
	character.s_tone			= pref.s_tone
	var/datum/sprite_accessory/S = GLOB.sprite_accessory_hair[pref.h_style_id]
	character.h_style = S.name
	S = GLOB.sprite_accessory_facial_hair[pref.f_style_id]
	character.f_style = S.name
	character.grad_style		= pref.grad_style
	character.b_type			= pref.b_type
	character.synth_color 		= pref.synth_color
	character.r_synth			= pref.r_synth
	character.g_synth			= pref.g_synth
	character.b_synth			= pref.b_synth
	character.synth_markings 	= pref.synth_markings
	character.s_base			= pref.s_base
	character.body_alpha        = pref.body_alpha
	character.hair_alpha        = pref.hair_alpha

	character.ear_style = GLOB.sprite_accessory_ears[pref.ear_style_id]
	character.tail_style = GLOB.sprite_accessory_tails[pref.tail_style_id]
	character.wing_style = GLOB.sprite_accessory_wings[pref.wing_style_id]
	character.horn_style = GLOB.sprite_accessory_ears[pref.horn_style_id]

	character.r_ears			= pref.r_ears
	character.b_ears			= pref.b_ears
	character.g_ears			= pref.g_ears
	character.r_ears2			= pref.r_ears2
	character.b_ears2			= pref.b_ears2
	character.g_ears2			= pref.g_ears2
	character.r_ears3			= pref.r_ears3
	character.b_ears3			= pref.b_ears3
	character.g_ears3			= pref.g_ears3

	character.r_horn			= pref.r_horn
	character.b_horn			= pref.b_horn
	character.g_horn			= pref.g_horn
	character.r_horn2			= pref.r_horn2
	character.b_horn2			= pref.b_horn2
	character.g_horn2			= pref.g_horn2
	character.r_horn3			= pref.r_horn3
	character.b_horn3			= pref.b_horn3
	character.g_horn3			= pref.g_horn3

	character.r_tail			= pref.r_tail
	character.b_tail			= pref.b_tail
	character.g_tail			= pref.g_tail
	character.r_tail2			= pref.r_tail2
	character.b_tail2			= pref.b_tail2
	character.g_tail2			= pref.g_tail2
	character.r_tail3			= pref.r_tail3
	character.b_tail3			= pref.b_tail3
	character.g_tail3			= pref.g_tail3

	character.r_wing			= pref.r_wing
	character.b_wing			= pref.b_wing
	character.g_wing			= pref.g_wing
	character.r_wing2			= pref.r_wing2
	character.b_wing2			= pref.b_wing2
	character.g_wing2			= pref.g_wing2
	character.r_wing3			= pref.r_wing3
	character.b_wing3			= pref.b_wing3
	character.g_wing3			= pref.g_wing3
	character.r_gradwing		= pref.r_gradwing
	character.g_gradwing		= pref.g_gradwing
	character.b_gradwing		= pref.b_gradwing


	for(var/N in character.organs_by_name)
		var/obj/item/organ/external/O = character.organs_by_name[N]
		if(!istype(O))
			continue
		O.markings.Cut()
		O.sync_colour_to_human(character)

	for(var/id in pref.body_marking_ids)
		var/datum/sprite_accessory/marking/mark_datum = GLOB.sprite_accessory_markings[id]
		var/mark_color = "[pref.body_marking_ids[id]]"

		for(var/BP in mark_datum.body_parts)
			var/obj/item/organ/external/O = character.organs_by_name[BP]
			if(O)
				O.markings[id] = list("color" = mark_color, "datum" = mark_datum)
