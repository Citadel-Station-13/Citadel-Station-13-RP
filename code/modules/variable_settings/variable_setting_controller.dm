/**
  * Variable settings controller. Sorta like config but not as much as meant to be customized by config as much as adminbus purposes.
  */
/datum/variable_settings_controller
	/// Our user friendly name
	var/name = "Controller"
	/// List of entries by type.
	var/list/entries_by_type = list()
	/// List of entries by category
	var/list/entries_by_category = list()
	/// List of entries followed by default values.
	var/list/initial_entries = list()
	/// List of presets followed by a list of entries to set to specific values. Entries not included are not impacted
	var/list/presets = list()
	/// Default entry set name
	var/initial_preset_name = "RESET TO DEFAULT"

/datum/variable_settings_controller/New()
	for(var/path in initial_entries)
		var/datum/variable_setting_entry/E = new path(initial_entries[path])
		entries_by_type[path] = E
		LAZYINITLIST(entries_by_category[E.category])
		entries_by_category[E.category] += E

/datum/variable_settings_controller/Topic(href, href_list)
	if(..())
		return
	if(!check_rights())
		to_chat(usr, "<span class='boldwarning'>You must be an admin to modify this.</span>")
		var/logline = "[key_name(usr)] attempted to modify [src] without permissions."
		message_admins(logline)
		log_admin(logline)
		return TRUE
	var/category = href_list["category"]
	var/refresh = FALSE
	if(href_list["target"])
		var/path = text2path(href_list["target"])
		var/datum/variable_setting_entry/E = entries_by_type[path]
		refresh = E.OnTopic(href, href_list)
	else if(href_list["preset"])
		request_and_set_preset(usr)
		refresh = TRUE
	else if(href_list["reset"])
		var/logline = "[key_name(usr)] reset [src]([type]) to defaults."
		message_admins(logline)
		log_admin(logline)
		reset_to_default()
		refresh = TRUE
	else if(href_list["refresh"])
		refresh = TRUE

	if(refresh)
		ui_interact(usr, category)

/datum/variable_settings_controller/ui_interact(mob/user, category)
	if(!(category in entries_by_category))
		category = entries_by_category[1]
	var/datum/browser/B = new(user, "vsc_[name]", name, 500, 1000, src)
	B.set_content(html_render(category))
	B.open(FALSE)

/datum/variable_settings_controller/proc/html_render(category = entries_by_category[1])
	. = list()
	. += "<a href='?src=[REF(src)];category=[category];preset=1'>Set Preset</a> <a href='?src=[REF(src)];category=[category];reset=1'>Reset Default</a><br>"
	for(var/cat in entries_by_category)
		. += "<span class='[(cat == category)? "linkOn" : ""]'><a href='?src=[REF(src)];category=[cat];refresh=1'>[cat]</a></span> "
	. += "<hr>"
	for(var/datum/variable_setting_entry/E in entries_by_category[category])
		. += "<div class='statusDisplay'>[E.ui_html(src, category)]</div>"
	return jointext(., "")

/datum/variable_settings_controller/proc/get_entries()
	. = list()
	for(var/path in entries_by_type)
		. += entries_by_type[path]

/datum/variable_settings_controller/proc/reset_to_default()
	for(var/datum/variable_setting_entry/E in get_entries())
		E.reset_to_default()

/datum/variable_settings_controller/proc/get_value(path)
	var/datum/variable_setting_entry/E = entries_by_type[path]
	return E.value

/datum/variable_settings_controller/proc/get_datum(path)
	return entries_by_type[path]

/datum/variable_settings_controller/proc/request_and_set_preset(mob/user)
	var/input = input(user, "Select Preset", "Presets") as null|anything in (presets | initial_preset_name)
	if(!input)
		return
	var/announce = alert(user, "Announce to all players?", "Announce?", "No", "Yes", "Cancel")
	var/logstr = "[key_name(user)] changed [src]'s preset to [input]"
	if(announce == "Cancel")
		return
	else if(announce == "Yes")
		to_chat(world, "<span class='boldnotice'>[user?.client?.holder?.fakekey? "Administrator" : user.key] applied preset [input] to [src].</span>")
	message_admins(logstr)
	log_admin(logstr)
	if(input == initial_preset_name)
		reset_to_default()
	else
		apply_preset_list(presets[input])

/datum/variable_settings_controller/proc/apply_preset_list(list/preset_list)
	for(var/path in preset_list)
		var/datum/variable_setting_entry/E = get_datum(path)
		if(!E)
			continue
		E.value = preset_list[path]
