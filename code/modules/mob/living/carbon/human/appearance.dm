/mob/living/carbon/human/proc/change_appearance(var/flags = APPEARANCE_ALL_HAIR, var/location = src, var/mob/user = src, var/check_species_whitelist = 1, var/list/species_whitelist = list(), var/list/species_blacklist = list(), var/datum/topic_state/state = default_state)
	var/datum/nano_module/appearance_changer/AC = new(location, src, check_species_whitelist, species_whitelist, species_blacklist)
	AC.flags = flags
	AC.nano_ui_interact(user, state = state)

/mob/living/carbon/human/proc/change_species(var/new_species)
	if(!new_species)
		return

	if(species == new_species)
		return

	if(!(new_species in SScharacters.all_species_names()))
		return

	set_species(new_species)
	reset_hair()
	return 1

/mob/living/carbon/human/proc/change_gender(var/gender)
	if(src.gender == gender)
		return

	src.gender = gender
	update_icons_body()
	update_dna()
	return 1

/mob/living/carbon/human/proc/change_gender_identity(var/identifying_gender)
	if(src.identifying_gender == identifying_gender)
		return

	src.identifying_gender = identifying_gender
	return 1

/mob/living/carbon/human/proc/change_hair(var/hair_style)
	if(!hair_style)
		return

	if(h_style == hair_style)
		return

	if(!(hair_style in GLOB.legacy_hair_lookup))
		return

	h_style = hair_style

	update_hair()
	return 1

/mob/living/carbon/human/proc/change_hair_gradient(var/hair_gradient)
	if(!hair_gradient)
		return

	if(grad_style == hair_gradient)
		return

	if(!(hair_gradient in GLOB.hair_gradients))
		return

	grad_style = hair_gradient

	update_hair()
	return 1

/mob/living/carbon/human/proc/change_wing_gradient(var/wing_gradient)
	if(!wing_gradient)
		return

	if(grad_wingstyle == wing_gradient)
		return

	if(!(wing_gradient in GLOB.hair_gradients))
		return

	grad_wingstyle = wing_gradient

	update_wing_showing()
	return 1

/mob/living/carbon/human/proc/change_facial_hair(var/facial_hair_style)
	if(!facial_hair_style)
		return

	if(f_style == facial_hair_style)
		return

	if(!(facial_hair_style in GLOB.legacy_facial_hair_lookup))
		return

	f_style = facial_hair_style

	update_hair()
	return 1

/mob/living/carbon/human/proc/reset_hair()
	var/list/valid_hairstyles = generate_valid_hairstyles()
	var/list/valid_facial_hairstyles = generate_valid_facial_hairstyles()

	if(valid_hairstyles.len)
		h_style = pick(valid_hairstyles)
	else
		//this shouldn't happen
		h_style = "Bald"

	if(valid_facial_hairstyles.len)
		f_style = pick(valid_facial_hairstyles)
	else
		//this shouldn't happen
		f_style = "Shaved"

	update_hair()

/mob/living/carbon/human/proc/change_eye_color(var/red, var/green, var/blue)
	if(red == r_eyes && green == g_eyes && blue == b_eyes)
		return

	r_eyes = red
	g_eyes = green
	b_eyes = blue

	update_eyes()
	update_icons_body()
	return 1

/mob/living/carbon/human/proc/change_hair_color(var/red, var/green, var/blue)
	if(red == r_hair && green == g_hair && blue == b_hair)
		return

	r_hair = red
	g_hair = green
	b_hair = blue

	update_hair()
	return 1

/mob/living/carbon/human/proc/change_grad_color(var/red, var/green, var/blue)
	if(red == r_grad && green == g_grad && blue == b_grad)
		return

	r_grad = red
	g_grad = green
	b_grad = blue

	update_hair()
	return 1

/mob/living/carbon/human/proc/change_facial_hair_color(var/red, var/green, var/blue)
	if(red == r_facial && green == g_facial && blue == b_facial)
		return

	r_facial = red
	g_facial = green
	b_facial = blue

	update_hair()
	return 1

/mob/living/carbon/human/proc/change_skin_color(var/red, var/green, var/blue)
	if(red == r_skin && green == g_skin && blue == b_skin || !(species.species_appearance_flags & HAS_SKIN_COLOR))
		return

	r_skin = red
	g_skin = green
	b_skin = blue

	force_update_limbs()
	update_icons_body()
	return 1

/mob/living/carbon/human/proc/change_skin_tone(var/tone)
	if(s_tone == tone || !(species.species_appearance_flags & HAS_SKIN_TONE))
		return

	s_tone = tone

	force_update_limbs()
	update_icons_body()
	return 1

/mob/living/carbon/human/proc/update_dna()
	check_dna()
	dna.ready_dna(src)

/mob/living/carbon/human/proc/generate_valid_species(var/check_whitelist = 1, var/list/whitelist = list(), var/list/blacklist = list())
	var/list/valid_species = new()
	for(var/datum/species/S in SScharacters.all_static_species_meta())
		var/current_species_name = S.name

		if(check_whitelist && config_legacy.usealienwhitelist && !check_rights(R_ADMIN, 0, src)) //If we're using the whitelist, make sure to check it!
			if(!(S.species_spawn_flags & SPECIES_SPAWN_CHARACTER))
				continue
			if(whitelist.len && !(current_species_name in whitelist))
				continue
			if(blacklist.len && (current_species_name in blacklist))
				continue
			if((S.species_spawn_flags & SPECIES_SPAWN_WHITELISTED) && !config.check_alien_whitelist(ckey(S.name), ckey))
				continue

		valid_species += current_species_name

	return valid_species

/mob/living/carbon/human/proc/generate_valid_hairstyles(var/check_gender = 1)

	var/use_species = species.get_bodytype_legacy(src)
	var/obj/item/organ/external/head/H = get_organ(BP_HEAD)
	if(H) use_species = H.species.get_bodytype_legacy(src)

	var/list/valid_hairstyles = new()
	for(var/hairstyle in GLOB.legacy_hair_lookup)
		var/datum/sprite_accessory/S = GLOB.legacy_hair_lookup[hairstyle]

		if(check_gender && gender != NEUTER)
			if(gender == MALE && S.gender == FEMALE)
				continue
			else if(gender == FEMALE && S.gender == MALE)
				continue

		if(S.apply_restrictions && !(use_species in S.species_allowed))
			continue
		valid_hairstyles += hairstyle

	return valid_hairstyles

/mob/living/carbon/human/proc/generate_valid_facial_hairstyles()

	var/use_species = species.get_bodytype_legacy(src)
	var/obj/item/organ/external/head/H = get_organ(BP_HEAD)
	if(H) use_species = H.species.get_bodytype_legacy(src)

	var/list/valid_facial_hairstyles = new()
	for(var/facialhairstyle in GLOB.legacy_facial_hair_lookup)
		var/datum/sprite_accessory/S = GLOB.legacy_facial_hair_lookup[facialhairstyle]

		if(gender != NEUTER)
			if(gender == MALE && S.gender == FEMALE)
				continue
			else if(gender == FEMALE && S.gender == MALE)
				continue

		if(S.apply_restrictions && !(use_species in S.species_allowed))
			continue

		valid_facial_hairstyles += facialhairstyle

	return valid_facial_hairstyles

/mob/living/carbon/human/proc/force_update_limbs()
	for(var/obj/item/organ/external/O in organs)
		O.sync_colour_to_human(src)
	update_icons_body(FALSE)
