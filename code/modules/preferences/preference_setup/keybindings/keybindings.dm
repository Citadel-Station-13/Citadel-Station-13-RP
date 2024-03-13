/datum/category_item/player_setup_item/keybinding/hotkey_mode/content(datum/preferences/prefs, mob/user, data)
	. += "<b>Hotkey mode:</b> <a href='?src=[REF(src)];option=hotkeys'>[(pref.hotkeys) ? "Hotkeys" : "Default"]</a><br>"
	. += "Keybindings mode controls how the game behaves with tab and map/input focus.<br>If it is on <b>Hotkeys</b>, the game will always attempt to force you to map focus, meaning keypresses are sent \
	directly to the map instead of the input. You will still be able to use the command bar, but you need to tab to do it every time you click on the game map.<br>\
	If it is on <b>Input</b>, the game will not force focus away from the input bar, and you can switch focus using TAB between these two modes: If the input bar is pink, that means that you are in non-hotkey mode, sending all keypresses of the normal \
	alphanumeric characters, punctuation, spacebar, backspace, enter, etc, typing keys into the input bar. If the input bar is white, you are in hotkey mode, meaning all keypresses go into the game's keybind handling system unless you \
	manually click on the input bar to shift focus there.<br>\
	Input mode is the closest thing to the old input system.<br>\
	<b>IMPORTANT:</b> While in input mode's non hotkey setting (tab toggled), Ctrl + KEY will send KEY to the keybind system as the key itself, not as Ctrl + KEY. This means Ctrl + T/W/A/S/D/all your familiar stuff still works, but you \
	won't be able to access any regular Ctrl binds.<br>"

/datum/category_item/player_setup_item/keybinding/bindings/OnTopic(href, list/href_list, mob/user)
	if(href_list["option"])
		switch(href_list["option"])
			if("keybindings_set")
				var/kb_name = href_list["keybinding"]
				if(!kb_name)
					user << browse(null, "window=capturekeypress")
					return PREFERENCES_REFRESH

				var/clear_key = text2num(href_list["clear_key"])
				var/old_key = href_list["old_key"]
				if(clear_key)
					if(pref.key_bindings[old_key])
						pref.key_bindings[old_key] -= kb_name
						if(!length(pref.key_bindings[old_key]))
							pref.key_bindings -= old_key
					user << browse(null, "window=capturekeypress")
					SScharacters.queue_preferences_save(pref)
					return PREFERENCES_REFRESH

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
				if(pref.key_bindings[old_key])
					pref.key_bindings[old_key] -= kb_name
					if(!length(pref.key_bindings[old_key]))
						pref.key_bindings -= old_key
				pref.key_bindings[full_key] += list(kb_name)
				pref.key_bindings[full_key] = sortList(pref.key_bindings[full_key])

				user << browse(null, "window=capturekeypress")
				user.client.update_movement_keys()
				SScharacters.queue_preferences_save(pref)

/datum/preferences/proc/CaptureKeybinding(mob/user, datum/keybinding/kb, old_key, datum/category_item/player_setup_item/keybinding/bindings/host)
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
		var url = 'byond://?src=[REF(host)];option=keybindings_set;keybinding=[kb.name];old_key=[old_key];clear_key='+escPressed+';key='+e.key+';alt='+alt+';ctrl='+ctrl+';shift='+shift+';numpad='+numpad+';key_code='+e.keyCode;
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
