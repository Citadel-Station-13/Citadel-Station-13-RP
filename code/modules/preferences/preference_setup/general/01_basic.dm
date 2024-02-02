/datum/preferences
	var/biological_gender = MALE
	var/identifying_gender = MALE

/datum/preferences/proc/set_biological_gender(gender)
	biological_gender = gender
	identifying_gender = gender

/datum/category_item/player_setup_item/general/basic
	name = "Basic"
	sort_order = 1

/datum/category_item/player_setup_item/general/basic/load_character(var/savefile/S)
	S["real_name"]				>> pref.real_name
	S["nickname"]				>> pref.nickname
	S["name_is_always_random"]	>> pref.be_random_name
	S["gender"]					>> pref.biological_gender
	S["id_gender"]				>> pref.identifying_gender
	S["age"]					>> pref.age
	S["spawnpoint"]				>> pref.spawnpoint
	S["OOC_Notes"]				>> pref.metadata
	S["Headshot_URL"]           >> pref.headshot_url
	S["Full_Ref_URL"]			>> pref.full_ref_url
	S["Ref_Toggle"]				>> pref.full_ref_toggle

/datum/category_item/player_setup_item/general/basic/save_character(var/savefile/S)
	S["real_name"]				<< pref.real_name
	S["nickname"]				<< pref.nickname
	S["name_is_always_random"]	<< pref.be_random_name
	S["gender"]					<< pref.biological_gender
	S["id_gender"]				<< pref.identifying_gender
	S["age"]					<< pref.age
	S["spawnpoint"]				<< pref.spawnpoint
	S["OOC_Notes"]				<< pref.metadata
	S["Headshot_URL"]           << pref.headshot_url
	S["Full_Ref_URL"]			<< pref.full_ref_url
	S["Ref_Toggle"]				<< pref.full_ref_toggle

/datum/category_item/player_setup_item/general/basic/sanitize_character()
	var/species_name = pref.real_species_name()
	pref.age                = sanitize_integer(pref.age, get_min_age(), get_max_age(), initial(pref.age))
	pref.biological_gender  = sanitize_inlist(pref.biological_gender, get_genders(), pick(get_genders()))
	pref.identifying_gender = (pref.identifying_gender in all_genders_define_list) ? pref.identifying_gender : pref.biological_gender
	pref.real_name		= sanitize_species_name(pref.real_name, species_name, is_FBP())
	if(!pref.real_name)
		pref.real_name      = random_name(pref.identifying_gender, species_name)
	pref.nickname		= sanitize_species_name(pref.nickname)
	pref.spawnpoint         = sanitize_inlist(pref.spawnpoint, spawntypes, initial(pref.spawnpoint))
	pref.be_random_name     = sanitize_integer(pref.be_random_name, 0, 1, initial(pref.be_random_name))

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/basic/copy_to_mob(datum/preferences/prefs, mob/M, data, flags)
	// todo: this is just a shim
	if(!ishuman(M))
		return TRUE
	var/mob/living/carbon/human/character = M
	if(config_legacy.humans_need_surnames)
		var/firstspace = findtext(pref.real_name, " ")
		var/name_length = length(pref.real_name)
		if(!firstspace)	//we need a surname
			pref.real_name += " [pick(GLOB.last_names)]"
		else if(firstspace == name_length)
			pref.real_name += "[pick(GLOB.last_names)]"

	character.real_name = pref.real_name
	character.name = character.real_name
	if(character.dna)
		character.dna.real_name = character.real_name

	character.nickname = pref.nickname

	character.gender = pref.biological_gender
	character.identifying_gender = pref.identifying_gender
	character.age = pref.age
	character.headshot_url = pref.headshot_url
	character.fullref_url = pref.full_ref_url
	return TRUE

/datum/category_item/player_setup_item/general/basic/content(datum/preferences/prefs, mob/user, data)
	. = list()
	. += "<b>Name:</b> "
	. += "<a href='?src=\ref[src];rename=1'><b>[pref.real_name]</b></a><br>"
	. += "<a href='?src=\ref[src];random_name=1'>Randomize Name</A><br>"
	. += "<a href='?src=\ref[src];always_random_name=1'>Always Random Name: [pref.be_random_name ? "Yes" : "No"]</a><br>"
	. += "<b>Nickname:</b> "
	. += "<a href='?src=\ref[src];nickname=1'><b>[pref.nickname]</b></a>"
	. += "<br>"
	. += "<b>Biological Sex:</b> <a href='?src=\ref[src];bio_gender=1'><b>[gender2text(pref.biological_gender)]</b></a><br>"
	. += "<b>Pronouns:</b> <a href='?src=\ref[src];id_gender=1'><b>[gender2text(pref.identifying_gender)]</b></a><br>"
	. += "<b>Age:</b> <a href='?src=\ref[src];age=1'>[pref.age]</a><br>"
	. += "<b>Spawn Point</b>: <a href='?src=\ref[src];spawnpoint=1'>[pref.spawnpoint]</a><br>"
	. += "<b>OOC Notes:</b> <a href='?src=\ref[src];metadata=1'> Edit </a><br>"
	. += "<b>Profile Headshot:</b> <a href='?src=\ref[src];headshot=1'>[pref.headshot_url ? "Set" : "Not Set"]</a><br>"
	. += "<b>Profile Full Ref:</b> <a href='?src=\ref[src];fullref=1'>[pref.full_ref_url ? "Set" : "Not Set"]</a><br>"
	. += "<b>Profile Reference:</b> <a href='?src=\ref[src];fullref_toggle=1'>[pref.full_ref_toggle ? "Full Reference" : "Headshot"]</a><br>"
	. = jointext(., null)

/datum/category_item/player_setup_item/general/basic/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["rename"])
		var/raw_name = input(user, "Choose your character's name:", "Character Name")  as text|null
		if (!isnull(raw_name) && CanUseTopic(user))
			var/new_name = sanitize_species_name(raw_name, pref.real_species_name(), is_FBP())
			if(new_name)
				pref.real_name = new_name
				return PREFERENCES_REFRESH
			else
				to_chat(user, "<span class='warning'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</span>")
				return PREFERENCES_NOACTION

	else if(href_list["random_name"])
		pref.real_name = random_name(pref.identifying_gender, pref.real_species_name())
		return PREFERENCES_REFRESH

	else if(href_list["always_random_name"])
		pref.be_random_name = !pref.be_random_name
		return PREFERENCES_REFRESH

	else if(href_list["nickname"])
		var/raw_nickname = input(user, "Choose your character's nickname:", "Character Nickname")  as text|null
		if (!isnull(raw_nickname) && CanUseTopic(user))
			var/new_nickname = sanitize_species_name(raw_nickname, pref.real_species_name(), is_FBP())
			if(new_nickname)
				pref.nickname = new_nickname
				return PREFERENCES_REFRESH
			else
				to_chat(user, "<span class='warning'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</span>")
				return PREFERENCES_NOACTION

	else if(href_list["bio_gender"])
		var/new_gender = tgui_input_list(user, "Choose your character's biological sex:", "Character Preference", get_genders(), pref.biological_gender)
		if(new_gender && CanUseTopic(user))
			pref.set_biological_gender(new_gender)
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["id_gender"])
		var/new_gender = tgui_input_list(user, "Choose your character's pronouns:", "Character Preference", GLOB.gender_select_list, pref.identifying_gender)
		if(new_gender && CanUseTopic(user))
			pref.identifying_gender = GLOB.gender_select_list[new_gender]
		return PREFERENCES_REFRESH

	else if(href_list["age"])
		var/min_age = get_min_age()
		var/max_age = get_max_age()
		var/new_age = input(user, "Choose your character's age:\n([min_age]-[max_age])", "Character Preference", pref.age) as num|null
		if(new_age && CanUseTopic(user))
			pref.age = max(min(round(text2num(new_age)), max_age), min_age)
			return PREFERENCES_REFRESH

	else if(href_list["spawnpoint"])
		var/list/spawnkeys = list()
		for(var/spawntype in spawntypes)
			spawnkeys += spawntype
		var/choice = tgui_input_list(user, "Where would you like to spawn when late-joining?", "Spawnlocation", spawnkeys)
		if(!choice || !spawntypes[choice] || !CanUseTopic(user))	return PREFERENCES_NOACTION
		pref.spawnpoint = choice
		return PREFERENCES_REFRESH

	else if(href_list["metadata"])
		var/new_metadata = sanitize(input(user, "Enter any information you'd like others to see in terms of roleplay preferences (including any ERP consent / preference information). This information is considered OOC, unlike 'Flavor Text'.", "OOC Notes" , html_decode(pref.metadata)) as message, extra = 0)
		if(!isnull(new_metadata) && CanUseTopic(user))
			pref.metadata = new_metadata
			return PREFERENCES_REFRESH

	else if(href_list["headshot"])
		if(pref.headshot_url)
			if(alert(user, "Do you want to unset your headshot URL? An admin must set it again.", "Unset Headshot", "No", "Yes") == "Yes")
				pref.headshot_url = null
		else
			to_chat(user, SPAN_BOLDWARNING("You must join the Discord and open a ticket in order to have your headshot URL set!"))
		return PREFERENCES_REFRESH

	else if(href_list["fullref"])
		if(pref.full_ref_url)
			if(alert(user, "Do you want to unset your headshot URL? An admin must set it again.", "Unset Headshot", "No", "Yes") == "Yes")
				pref.full_ref_url = null
		else
			to_chat(user, SPAN_BOLDWARNING("You must join the Discord and open a ticket in order to have your full reference URL set!"))
		return PREFERENCES_REFRESH

	else if(href_list["fullref_toggle"])
		pref.full_ref_toggle = !pref.full_ref_toggle
		to_chat(user, SPAN_NOTICE("Now showing your [pref.full_ref_toggle ? "full reference": "headshot"] in your character profile."))
		return PREFERENCES_REFRESH

	return ..()

/datum/category_item/player_setup_item/general/basic/spawn_checks(datum/preferences/prefs, data, flags, list/errors, list/warnings)
	. = TRUE
	if(length(prefs.metadata) < 10)
		var/enforcing = CONFIG_GET(flag/enforce_ooc_notes)
		var/error = "Missing or insufficient OOC Notes - See Character Setup for information."
		if(enforcing)
			errors += error
			. = FALSE
		else
			warnings += error

/datum/category_item/player_setup_item/general/basic/proc/get_genders()
	var/datum/species/S = pref.real_species_datum()
	var/list/possible_genders = S.genders
	if(!pref.organ_data || pref.organ_data[BP_TORSO] != "cyborg")
		return possible_genders
	possible_genders = possible_genders.Copy()
	possible_genders |= NEUTER
	return possible_genders
