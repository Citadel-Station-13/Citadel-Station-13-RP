/client/proc/set_headshot_for_user()
	set category = "Admin"
	set name = "Set Headshot / Full Reference For User"

	if(!check_rights(R_ADMIN))
		return

	var/their_ckey = input(src, "Enter the player's ckey", "Reference Selection") as text|null
	if(isnull(their_ckey))
		return
	var/datum/preferences/their_prefs = SScharacters.fetch_preferences_datum(their_ckey, TRUE)
	if(isnull(their_prefs))
		to_chat(src, SPAN_WARNING("[their_ckey] does not exist."))
		return
	//! WARNING WARNING FUCKING WARNING DIRECT SAVEFILE MANIPULATIONS DO NOT TOUCH THIS UNLESS YOU KNOW WHAT YOU ARE DOING
	//  todo: /datum/character so we don't do this atrocious shit WHEN
	if(isnull(their_prefs.path))
		to_chat(src, SPAN_DANGER("[their_ckey] doesn't have a valid path?? how??"))
		return
	var/savefile/their_savefile = new(their_prefs.path)
	var/list/loaded_characters = list()
	for(var/i in 1 to config_legacy.character_slots)
		their_savefile.cd = "/character[i]"
		var/iter_name
		their_savefile["real_name"] >> iter_name
		if(isnull(iter_name))
			continue
		var/orig = iter_name
		if(!isnull(loaded_characters[iter_name]))
			var/what_the_heck = 1
			do
				iter_name = "[orig] (#[what_the_heck++])"
			while(!isnull(loaded_characters[iter_name]))
		loaded_characters[iter_name] = list(i, orig)
	loaded_characters = tim_sort(loaded_characters, /proc/cmp_text_asc)
	var/chosen_character = input(src, "Choose the character to edit", "Reference Selection") as null|anything in loaded_characters
	if(isnull(chosen_character))
		return
	var/chosen_slot = loaded_characters[chosen_character][1]
	var/chosen_original_name = loaded_characters[chosen_character][2]
	var/input_headshot = input(src, "Enter the URL for the headshot image. (Cancel to skip, empty string to remove)", "Reference Selection") as text|null
	if(!isnull(input_headshot))
		their_savefile["Headshot_URL"] << input_headshot
		if(their_prefs.default_slot == chosen_slot)
			their_prefs.headshot_url = input_headshot
	var/input_fullref = input(src, "Enter the URL for the full reference image. (Cancel to skip, empty string to remove)", "Reference Selection") as text|null
	if(!isnull(input_headshot))
		their_savefile["Full_Ref_URL"] << input_fullref
		if(their_prefs.default_slot == chosen_slot)
			their_prefs.full_ref_url = input_fullref
	to_chat(src, SPAN_NOTICE("References set."))
	var/client/theyre_here = GLOB.directory[their_ckey]
	if(!isnull(theyre_here))
		to_chat(theyre_here, SPAN_BOLDNOTICE("[chosen_character]'s image references have been edited by an admin."))
		return
	var/mob/their_mob = theyre_here?.mob
	if(!isnull(their_mob) && (their_mob.real_name == chosen_original_name) && isliving(their_mob))
		var/mob/living/casted = their_mob
		if(!isnull(input_headshot))
			casted.headshot_url = input_headshot
		if(!isnull(input_fullref))
			casted.fullref_url = input_fullref
		casted.profile?.update_static_data()
