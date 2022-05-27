datum/preferences
	var/biological_gender = MALE
	var/identifying_gender = MALE

datum/preferences/proc/set_biological_gender(gender)
	biological_gender = gender
	identifying_gender = gender

/datum/category_item/player_setup_item/general/basic
	name = "Basic"
	sort_order = 1

/datum/category_item/player_setup_item/general/basic/load_character(savefile/S)
	from_file(S["real_name"], pref.real_name)
	from_file(S["nickname"], pref.nickname)
	from_file(S["name_is_always_random"], pref.be_random_name)
	from_file(S["gender"], pref.biological_gender)
	from_file(S["id_gender"], pref.identifying_gender)
	from_file(S["age"], pref.age)
	from_file(S["spawnpoint"], pref.spawnpoint)
	from_file(S["OOC_Notes"], pref.metadata)

/datum/category_item/player_setup_item/general/basic/save_character(savefile/S)
	to_file(S["real_name"], pref.real_name)
	to_file(S["nickname"], pref.nickname)
	to_file(S["name_is_always_random"], pref.be_random_name)
	to_file(S["gender"], pref.biological_gender)
	to_file(S["id_gender"], pref.identifying_gender)
	to_file(S["age"], pref.age)
	to_file(S["spawnpoint"], pref.spawnpoint)
	to_file(S["OOC_Notes"], pref.metadata)

/datum/category_item/player_setup_item/general/basic/sanitize_character()
	pref.age = sanitize_integer(pref.age, get_min_age(), get_max_age(), initial(pref.age))
	pref.biological_gender = sanitize_inlist(pref.biological_gender, get_genders(), pick(get_genders()))
	pref.identifying_gender = (pref.identifying_gender in all_genders_define_list) ? pref.identifying_gender : pref.biological_gender
	pref.real_name = sanitize_name(pref.real_name, pref.species, is_FBP())

	if(!pref.real_name)
		pref.real_name = random_name(pref.identifying_gender, pref.species)

	pref.nickname = sanitize_name(pref.nickname)
	pref.spawnpoint = sanitize_inlist(pref.spawnpoint, spawntypes, initial(pref.spawnpoint))
	pref.be_random_name = sanitize_integer(pref.be_random_name, 0, 1, initial(pref.be_random_name))

/datum/category_item/player_setup_item/general/basic/copy_to_mob(mob/living/carbon/human/character)
	if(config_legacy.humans_need_surnames)
		var/firstspace = findtext(pref.real_name, " ")
		var/name_length = length(pref.real_name)
		if(!firstspace)	//we need a surname
			pref.real_name += " [pick(last_names)]"
		else if(firstspace == name_length)
			pref.real_name += "[pick(last_names)]"

	character.real_name = pref.real_name
	character.name = character.real_name
	if(character.dna)
		character.dna.real_name = character.real_name

	character.nickname = pref.nickname

	character.gender = pref.biological_gender
	character.identifying_gender = pref.identifying_gender
	character.age = pref.age

/datum/category_item/player_setup_item/general/basic/content()
	. = list()
	. += "<b>Name:</b> "
	. += "<a href='?src=\ref[src];rename=1'><b>[pref.real_name]</b></a><br>"
	. += "<b>Nickname:</b> "
	. += "<a href='?src=\ref[src];nickname=1'><b>[pref.nickname]</b></a><br>"
	. += "<a href='?src=\ref[src];random_name=1'>Randomize Name</A><br>"
	. += "<a href='?src=\ref[src];always_random_name=1'>Always Random Name: [pref.be_random_name ? "Yes" : "No"]</a><br>"
	. += "<br>"
	. += "<b>Biological Sex:</b> <a href='?src=\ref[src];bio_gender=1'><b>[gender2text(pref.biological_gender)]</b></a><br>"
	. += "<b>Pronouns:</b> <a href='?src=\ref[src];id_gender=1'><b>[gender2text(pref.identifying_gender)]</b></a><br>"
	. += "<b>Age:</b> <a href='?src=\ref[src];age=1'>[pref.age]</a><br>"
	. += "<b>Spawn Point</b>: <a href='?src=\ref[src];spawnpoint=1'>[pref.spawnpoint]</a><br>"
	if(CONFIG_GET(flag/allow_metadata))
		. += "<b>OOC Notes:</b> <a href='?src=\ref[src];metadata=1'> Edit </a><br>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/general/basic/OnTopic(href, list/href_list, mob/user)

	if(href_list["rename"])
		var/new_name = tgui_input_text(user, "Choose your character's name:", "Character Name", pref.real_name, MAX_NAME_LEN)
		if(!isnull(new_name) && CanUseTopic(user))
			if(new_name)
				pref.real_name = sanitize_name(new_name, pref.species)
				return TOPIC_REFRESH
			else
				to_chat(user, SPAN_WARNING("Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and ."))
				return TOPIC_NOACTION

	else if(href_list["nickname"])
		var/new_nickname = tgui_input_text(user, "Choose your character's nickname:", "Character Nickname", pref.nickname, MAX_NAME_LEN)
		if(!isnull(new_nickname) && CanUseTopic(user))
			pref.nickname = sanitizeSafe(new_nickname)
			return TOPIC_REFRESH

	else if(href_list["random_name"])
		pref.real_name = random_name(pref.identifying_gender, pref.species)
		return TOPIC_REFRESH

	else if(href_list["always_random_name"])
		pref.be_random_name = !pref.be_random_name
		return TOPIC_REFRESH

	else if(href_list["bio_gender"])
		var/new_gender = tgui_input_list(user, "Choose your character's biological sex:", CHARACTER_PREFERENCE_INPUT_TITLE, get_genders(), pref.biological_gender)
		if(new_gender && CanUseTopic(user))
			pref.set_biological_gender(new_gender)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["id_gender"])
		var/new_gender = tgui_input_list(user, "Choose your character's pronouns:", CHARACTER_PREFERENCE_INPUT_TITLE, all_genders_define_list, pref.identifying_gender)
		if(new_gender && CanUseTopic(user))
			pref.identifying_gender = new_gender
		return TOPIC_REFRESH

	else if(href_list["age"])
		var/min_age = get_min_age()
		var/max_age = get_max_age()
		var/new_age = tgui_input_number(user, "Choose your character's age:\n([min_age]-[max_age])", CHARACTER_PREFERENCE_INPUT_TITLE, pref.age, max_age, min_age, round_value = TRUE)
		if(new_age && CanUseTopic(user))
			pref.age = new_age
			return TOPIC_REFRESH

	else if(href_list["spawnpoint"])
		var/list/spawnkeys = list()
		for(var/spawntype in spawntypes)
			spawnkeys += spawntype
		var/choice = tgui_input_list(user, "Where would you like to spawn when late-joining?", CHARACTER_PREFERENCE_INPUT_TITLE, spawnkeys, pref.spawnpoint)
		if(!choice || !spawntypes[choice] || !CanUseTopic(user))
			return TOPIC_NOACTION
		pref.spawnpoint = choice
		return TOPIC_REFRESH

	else if(href_list["metadata"])
		var/new_metadata = tgui_input_text(user, "Enter any information you'd like others to see, such as Roleplay-preferences:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.metadata, multiline = TRUE)
		if(new_metadata && CanUseTopic(user))
			pref.metadata = new_metadata
			return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/general/basic/proc/get_genders()
	var/datum/species/S = pref.character_static_species_meta()
	var/list/possible_genders = S.genders
	if(!pref.organ_data || pref.organ_data[BP_TORSO] != "cyborg")
		return possible_genders
	possible_genders = possible_genders.Copy()
	possible_genders |= NEUTER
	return possible_genders
