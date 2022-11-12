/datum/category_item/player_setup_item/general/background
	name = "Background"
	sort_order = 5

/datum/category_item/player_setup_item/general/background/load_character(savefile/S)
	READ_FILE(S["med_record"],      pref.med_record)
	READ_FILE(S["sec_record"],      pref.sec_record)
	READ_FILE(S["gen_record"],      pref.gen_record)
	READ_FILE(S["economic_status"], pref.economic_status)

/datum/category_item/player_setup_item/general/background/save_character(savefile/S)
	WRITE_FILE(S["med_record"],      pref.med_record)
	WRITE_FILE(S["sec_record"],      pref.sec_record)
	WRITE_FILE(S["gen_record"],      pref.gen_record)
	WRITE_FILE(S["economic_status"], pref.economic_status)

/datum/category_item/player_setup_item/general/background/sanitize_character()
	pref.economic_status = sanitize_inlist(pref.economic_status, ECONOMIC_CLASS, initial(pref.economic_status))

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/background/copy_to_mob(datum/preferences/prefs, mob/M, data, flags)
	// todo: this is just a shim
	if(!ishuman(M))
		return TRUE
	var/mob/living/carbon/human/character = M
	character.med_record		= pref.med_record
	character.sec_record		= pref.sec_record
	character.gen_record		= pref.gen_record
	return TRUE

/datum/category_item/player_setup_item/general/background/content(datum/preferences/prefs, mob/user, data)
	. += "<b>Background Information</b><br>"
	. += "Economic Status: <a href='?src=\ref[src];econ_status=1'>[pref.economic_status]</a><br/>"

	. += "<br/><b>Records</b>:<br/>"
	if(jobban_isbanned(user, "Records"))
		. += "<span class='danger'>You are banned from using character records.</span><br>"
	else
		. += "Medical Records:<br>"
		. += "<a href='?src=\ref[src];set_medical_records=1'>[TextPreview(pref.med_record,40)]</a><br><br>"
		. += "Employment Records:<br>"
		. += "<a href='?src=\ref[src];set_general_records=1'>[TextPreview(pref.gen_record,40)]</a><br><br>"
		. += "Security Records:<br>"
		. += "<a href='?src=\ref[src];set_security_records=1'>[TextPreview(pref.sec_record,40)]</a><br>"

/datum/category_item/player_setup_item/general/background/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["econ_status"])
		var/new_class = input(user, "Choose your economic status. This will affect the amount of money you will start with.", "Character Preference", pref.economic_status)  as null|anything in ECONOMIC_CLASS
		if(new_class && CanUseTopic(user))
			pref.economic_status = new_class
			return PREFERENCES_REFRESH

	else if(href_list["set_medical_records"])
		var/new_medical = sanitize(input(user,"Enter medical information here.","Character Preference", html_decode(pref.med_record)) as message|null, MAX_RECORD_LENGTH, extra = 0)
		if(!isnull(new_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.med_record = new_medical
		return PREFERENCES_REFRESH

	else if(href_list["set_general_records"])
		var/new_general = sanitize(input(user,"Enter employment information here.","Character Preference", html_decode(pref.gen_record)) as message|null, MAX_RECORD_LENGTH, extra = 0)
		if(!isnull(new_general) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.gen_record = new_general
		return PREFERENCES_REFRESH

	else if(href_list["set_security_records"])
		var/sec_medical = sanitize(input(user,"Enter security information here.","Character Preference", html_decode(pref.sec_record)) as message|null, MAX_RECORD_LENGTH, extra = 0)
		if(!isnull(sec_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.sec_record = sec_medical
		return PREFERENCES_REFRESH

	return ..()
