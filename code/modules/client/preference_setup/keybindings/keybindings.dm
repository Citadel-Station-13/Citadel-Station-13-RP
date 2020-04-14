/datum/preferences
	/// Custom Keybindings
	var/list/key_bindings = list()
	/// Hotkeys mode
	var/hotkeys = TRUE

//Used in savefile update from 11, can be removed once that is no longer relevant.
/datum/preferences/proc/force_reset_keybindings()
	var/choice = tgalert(parent.mob, "Your basic keybindings need to be reset, emotes will remain as before. Would you prefer 'hotkey' or 'classic' mode?", "Reset keybindings", "Hotkey", "Classic")
	hotkeys = (choice != "Classic")
	var/list/oldkeys = key_bindings
	key_bindings = (hotkeys) ? deepCopyList(GLOB.hotkey_keybinding_list_by_key) : deepCopyList(GLOB.classic_keybinding_list_by_key)

	for(var/key in oldkeys)
		if(!key_bindings[key])
			key_bindings[key] = oldkeys[key]
	parent.update_movement_keys()

/dtaum/category_item/player_setup_item/keybinding/hotkey_mode
	name = "Hotkey Mode"
	sort_order = 1

/datum/category_item/player_setup_item/keybinding/hotkey_mode/load_preferences(savefile/S)
	S["hotkeys"] >> pref.hotkeys

/datum/category_item/player_setup_item/keybinding/hotkey_mode/save_preferences(savefile/S)
	WRITE_FILE(S["hotkeys"], pref.hotkeys)

/datum/category_item/player_setup_item/keybinding/hotkey_mode/sanitize_preferences()
	pref.hotkeys = sanitize_integer(pref.hotkeys, 0, 1, initial(pref.hotkeys))

/datum/category_item/player_setup_item/keybinding/hotkey_mode/content(mob/user)
	. += "<b>Hotkey mode:</b> <a href='?src=[REF(src)];option=hotkeys'>[(pref.hotkeys) ? "Hotkeys" : "Default"]</a><br>"

/datum/category_item/player_setup_item/keybinding/hotkey_mode/OnTopic(href, list/href_list, mob/user)
	if(href_list["option"])
		switch(href_list["option"])
			if("hotkeys")
				pref.hotkeys = !pref.hotkeys
				if(pref.hotkeys)
					winset(user, null, "input.focus=true input.background-color=[COLOR_INPUT_ENABLED]")
				else
					winset(user, null, "input.focus=true input.background-color=[COLOR_INPUT_DISABLED]")
		return TOPIC_REFRESH
	return ..()

/datum/category_item/player_setup_item/keybinding/bindings
	name = "Bindings"
	sort_order = 2

/datum/category_item/player_setup_item/keybinding/bindings/load_preferences(savefile/S)
	S["key_bindings"] >> pref.key_bindings

/datum/category_item/player_setup_item/keybinding/bindings/save_preferences(savefile/S)
	WRITE_FILE(S["key_bindings"], pref.key_bindings)

/datum/category_item/player_setup_item/keybinding/bindings/sanitize_preferences()
	pref.key_bindings = sanitize_islist(pref.key_bindings, list())

/datum/category_item/player_setup_item/keybinding/bindings/content(mob/user)
	. = list()
	var/list/key_bindings = pref.key_bindings		//cache for speed or atleast my finger's sake..
	// Create an inverted list of keybindings -> key
	var/list/user_binds = list()
	for (var/key in key_bindings)
		for(var/kb_name in key_bindings[key])
			user_binds[kb_name] += list(key)

	var/list/kb_categories = list()
	// Group keybinds by category
	for (var/name in GLOB.keybindings_by_name)
		var/datum/keybinding/kb = GLOB.keybindings_by_name[name]
		kb_categories[kb.category] += list(kb)

	. += "<style>label { display: inline-block; width: 200px; }</style><body>"

	for (var/category in kb_categories)
		. += "<h3>[category]</h3>"
		for (var/i in kb_categories[category])
			var/datum/keybinding/kb = i
			if(!length(user_binds[kb.name]))
				. += "<label>[kb.full_name]</label> <a href ='?src=[REF(src)];option=keybindings_capture;keybinding=[kb.name];old_key=["Unbound"]'>Unbound</a>"
				var/list/default_keys = hotkeys ? kb.hotkey_keys : kb.classic_keys
				if(LAZYLEN(default_keys))
					. += "| Default: [default_keys.Join(", ")]"
				. += "<br>"
			else
				var/bound_key = user_binds[kb.name][1]
				. += "<label>[kb.full_name]</label> <a href ='?src=[REF(src)];option=keybindings_capture;keybinding=[kb.name];old_key=[bound_key]'>[bound_key]</a>"
				for(var/bound_key_index in 2 to length(user_binds[kb.name]))
					bound_key = user_binds[kb.name][bound_key_index]
					. += " | <a href ='?src=[REF(src)];option=keybindings_capture;keybinding=[kb.name];old_key=[bound_key]'>[bound_key]</a>"
				if(length(user_binds[kb.name]) < MAX_KEYS_PER_KEYBIND)
					. += "| <a href ='?src=[REF(src)];option=keybindings_capture;keybinding=[kb.name]'>Add Secondary</a>"
				var/list/default_keys = hotkeys ? kb.classic_keys : kb.hotkey_keys
				if(LAZYLEN(default_keys))
					. += "| Default: [default_keys.Join(", ")]"
				. += "<br>"

	. += "<br><br>"
	. += "<a href ='?src=[REF(src)];option=keybindings_reset'>\[Reset to default\]</a>"
	. += "</body>"

/datum/category_item/player_setup_item/keybinding/hotkey_mode/OnTopic(href, list/href_list, mob/user)
	var/list/key_bindings = pref.key_bindings
	if(href_list["option"])
		switch(href_list["option"])
			if("keybindings_capture")
				var/datum/keybinding/kb = GLOB.keybindings_by_name[href_list["keybinding"]]
				var/old_key = href_list["old_key"]
				CaptureKeybinding(user, kb, old_key)
				return

			if("keybindings_set")
				var/kb_name = href_list["keybinding"]
				if(!kb_name)
					user << browse(null, "window=capturekeypress")
					ShowChoices(user)
					return

				var/clear_key = text2num(href_list["clear_key"])
				var/old_key = href_list["old_key"]
				if(clear_key)
					if(key_bindings[old_key])
						key_bindings[old_key] -= kb_name
						if(!length(key_bindings[old_key]))
							key_bindings -= old_key
					user << browse(null, "window=capturekeypress")
					save_preferences()
					ShowChoices(user)
					return

				var/new_key = uppertext(href_list["key"])
				var/AltMod = text2num(href_list["alt"]) ? "Alt" : ""
				var/CtrlMod = text2num(href_list["ctrl"]) ? "Ctrl" : ""
				var/ShiftMod = text2num(href_list["shift"]) ? "Shift" : ""
				var/numpad = text2num(href_list["numpad"]) ? "Numpad" : ""
				// var/key_code = text2num(href_list["key_code"])

				if(GLOB._kbMap[new_key])
					new_key = GLOB._kbMap[new_key]

				var/full_key
				switch(new_key)
					if("Alt")
						full_key = "[new_key][CtrlMod][ShiftMod]"
					if("Ctrl")
						full_key = "[AltMod][new_key][ShiftMod]"
					if("Shift")
						full_key = "[AltMod][CtrlMod][new_key]"
					else
						full_key = "[AltMod][CtrlMod][ShiftMod][numpad][new_key]"
				if(key_bindings[old_key])
					key_bindings[old_key] -= kb_name
					if(!length(key_bindings[old_key]))
						key_bindings -= old_key
				key_bindings[full_key] += list(kb_name)
				key_bindings[full_key] = sortList(key_bindings[full_key])

				user << browse(null, "window=capturekeypress")
				user.client.update_movement_keys()
				save_preferences()

			if("keybindings_reset")
				var/choice = tgalert(user, "Would you prefer 'hotkey' or 'classic' defaults?", "Setup keybindings", "Hotkey", "Classic", "Cancel")
				if(choice == "Cancel")
					ShowChoices(user)
					return
				hotkeys = (choice == "Hotkey")
				key_bindings = (hotkeys) ? deepCopyList(GLOB.hotkey_keybinding_list_by_key) : deepCopyList(GLOB.classic_keybinding_list_by_key)
				user.client.update_movement_keys()
		return TOPIC_REFRESH
	return ..()

/datum/preferences/proc/CaptureKeybinding(mob/user, datum/keybinding/kb, var/old_key)
	var/HTML = {"
	<div id='focus' style="outline: 0;" tabindex=0>Keybinding: [kb.full_name]<br>[kb.description]<br><br><b>Press any key to change<br>Press ESC to clear</b></div>
	<script>
	var deedDone = false;
	document.onkeyup = function(e) {
		if(deedDone){ return; }
		var alt = e.altKey ? 1 : 0;
		var ctrl = e.ctrlKey ? 1 : 0;
		var shift = e.shiftKey ? 1 : 0;
		var numpad = (95 < e.keyCode && e.keyCode < 112) ? 1 : 0;
		var escPressed = e.keyCode == 27 ? 1 : 0;
		var url = 'byond://?src=[REF(src)];preference=keybindings_set;keybinding=[kb.name];old_key=[old_key];clear_key='+escPressed+';key='+e.key+';alt='+alt+';ctrl='+ctrl+';shift='+shift+';numpad='+numpad+';key_code='+e.keyCode;
		window.location=url;
		deedDone = true;
	}
	document.getElementById('focus').focus();
	</script>
	"}
	winshow(user, "capturekeypress", TRUE)
	var/datum/browser/popup = new(user, "capturekeypress", "<div align='center'>Keybindings</div>", 350, 300)
	popup.set_content(HTML)
	popup.open(FALSE)
	onclose(user, "capturekeypress", src)
