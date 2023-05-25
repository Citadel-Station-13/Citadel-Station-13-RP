/client/proc/set_headshot_for_user()
	set category = "Admin"
	set name = "Set Headshot For User"

	if(!check_rights(R_ADMIN))
		return

	var/list/mob_list = GLOB.clients
	var/client/selection = input(usr, "Select a player to set a headshot for.", "Headshot Selection") as anything in mob_list
	var input_link = input(usr, "Enter the URL for the headshot image.", "Headshot Selection") as text
	if(!selection || !input_link || !selection.prefs)
		to_chat(usr, SPAN_BOLDWARNING("Your selection was either invalid, or the link was blank."))
		return
	selection.prefs.headshot_url = input_link
	to_chat(usr, SPAN_NOTICE("[selection]'s headshot URL for [selection.prefs.real_name] has been set."))
	to_chat(selection, SPAN_BOLDNOTICE("Your headshot URL for your currently selected character, [selection.prefs.real_name], has been set by an admin."))
	SScharacters.queue_preferences_save(selection.prefs)
