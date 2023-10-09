/datum/preferences
	//The mob should have a gender you want before running this proc. Will run fine without H
/datum/preferences/proc/randomize_appearance_and_body_for(var/mob/living/carbon/human/H)
	var/datum/species/current_species = real_species_datum()
	set_biological_gender(pick(current_species.genders))

	h_style_id = random_hair_style(biological_gender, current_species.name)
	f_style_id = random_facial_hair_style(biological_gender, current_species.name)
	if(current_species)
		if(current_species.species_appearance_flags & HAS_SKIN_TONE)
			s_tone = random_skin_tone()
		if(current_species.species_appearance_flags & HAS_SKIN_COLOR)
			r_skin = rand (0,255)
			g_skin = rand (0,255)
			b_skin = rand (0,255)
		if(current_species.species_appearance_flags & HAS_EYE_COLOR)
			randomize_eyes_color()
		if(current_species.species_appearance_flags & HAS_HAIR_COLOR)
			randomize_hair_color("hair")
			randomize_hair_color("facial")
		if(current_species.species_appearance_flags & HAS_SKIN_COLOR)
			r_skin = rand (0,255)
			g_skin = rand (0,255)
			b_skin = rand (0,255)
	if(current_species.species_appearance_flags & HAS_UNDERWEAR)
		all_underwear.Cut()
		for(var/datum/category_group/underwear/WRC in GLOB.global_underwear.categories)
			var/datum/category_item/underwear/WRI = pick(WRC.items)
			all_underwear[WRC.name] = WRI.name

	backbag = rand(1, 7)
	pdachoice = rand(1, 7)
	age = rand(current_species.min_age, current_species.max_age)
	b_type = RANDOM_BLOOD_TYPE
	if(H)
		copy_to(H)

/datum/preferences/proc/randomize_hair_color(var/target = "hair")
	if(prob (75) && target == "facial") // Chance to inherit hair color
		r_facial = r_hair
		g_facial = g_hair
		b_facial = b_hair
		return

	var/red
	var/green
	var/blue

	var/col = pick ("blonde", "black", "chestnut", "copper", "brown", "wheat", "old", "punk")
	switch(col)
		if("blonde")
			red = 255
			green = 255
			blue = 0
		if("black")
			red = 0
			green = 0
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 51
		if("copper")
			red = 255
			green = 153
			blue = 0
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("wheat")
			red = 255
			green = 255
			blue = 153
		if("old")
			red = rand (100, 255)
			green = red
			blue = red
		if("punk")
			red = rand (0, 255)
			green = rand (0, 255)
			blue = rand (0, 255)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	switch(target)
		if("hair")
			r_hair = red
			g_hair = green
			b_hair = blue
		if("facial")
			r_facial = red
			g_facial = green
			b_facial = blue

/datum/preferences/proc/randomize_eyes_color()
	var/red
	var/green
	var/blue

	var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
	switch(col)
		if("black")
			red = 0
			green = 0
			blue = 0
		if("grey")
			red = rand (100, 200)
			green = red
			blue = red
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 0
		if("blue")
			red = 51
			green = 102
			blue = 204
		if("lightblue")
			red = 102
			green = 204
			blue = 255
		if("green")
			red = 0
			green = 102
			blue = 0
		if("albino")
			red = rand (200, 255)
			green = rand (0, 150)
			blue = rand (0, 150)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	r_eyes = red
	g_eyes = green
	b_eyes = blue

/datum/preferences/proc/randomize_skin_color()
	var/red
	var/green
	var/blue

	var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
	switch(col)
		if("black")
			red = 0
			green = 0
			blue = 0
		if("grey")
			red = rand (100, 200)
			green = red
			blue = red
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 0
		if("blue")
			red = 51
			green = 102
			blue = 204
		if("lightblue")
			red = 102
			green = 204
			blue = 255
		if("green")
			red = 0
			green = 102
			blue = 0
		if("albino")
			red = rand (200, 255)
			green = rand (0, 150)
			blue = rand (0, 150)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	r_skin = red
	g_skin = green
	b_skin = blue

//TFF 5/8/19 - add randomised sensor setting for random button clicking
/datum/preferences/randomize_appearance_and_body_for(var/mob/living/carbon/human/H)
	sensorpref = rand(1,5)

/datum/preferences/proc/get_valid_hairstyles()
	var/list/valid_hairstyles = list()
	var/species_name = real_species_name()
	for(var/hairstyle in GLOB.legacy_hair_lookup)
		var/datum/sprite_accessory/S = GLOB.legacy_hair_lookup[hairstyle]
		if(S.apply_restrictions && !(species_name in S.species_allowed) && (!custom_base || !(custom_base in S.species_allowed))) //Custom species base species allowance
			continue

		valid_hairstyles[hairstyle] = GLOB.legacy_hair_lookup[hairstyle]

	return valid_hairstyles

/datum/preferences/proc/get_valid_facialhairstyles()
	var/list/valid_facialhairstyles = list()
	var/datum/species/RS = real_species_datum()
	for(var/facialhairstyle in GLOB.legacy_facial_hair_lookup)
		var/datum/sprite_accessory/S = GLOB.legacy_facial_hair_lookup[facialhairstyle]
		if(biological_gender == MALE && S.gender == FEMALE)
			continue
		if(biological_gender == FEMALE && S.gender == MALE)
			continue
		if(S.apply_restrictions && !(RS.name in S.species_allowed) && (!custom_base || !(custom_base in S.species_allowed))) //Custom species base species allowance
			continue

		valid_facialhairstyles[facialhairstyle] = GLOB.legacy_facial_hair_lookup[facialhairstyle]

	return valid_facialhairstyles
