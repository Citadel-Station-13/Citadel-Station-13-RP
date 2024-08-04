/datum/pai_software/signaller
	name = "Remote Signaller"
	ram_cost = 5
	id = "signaller"
	toggle = 0

/datum/pai_software/signaller/on_nano_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
	var/data[0]

	data["frequency"] = format_frequency(user.sradio.frequency)
	data["code"] = user.sradio.code

	ui = SSnanoui.try_update_ui(user, user, id, ui, data, force_open)
	if(!ui)
		// Don't copy-paste this unless you're making a pAI software module!
		ui = new(user, user, id, "pai_signaller.tmpl", "Signaller", 320, 150)
		ui.set_initial_data(data)
		ui.open()

/datum/pai_software/signaller/Topic(href, href_list)
	var/mob/living/silicon/pai/P = usr
	if(!istype(P))
		return

	if(href_list["send"])
		P.sradio.send_signal("ACTIVATE")
		for(var/mob/O in hearers(1, P.loc))
			to_chat(O, "[icon2html(thing = src, target = O)] *beep beep*")
		return 1

	else if(href_list["freq"])
		var/new_frequency = (P.sradio.frequency + text2num(href_list["freq"]))
		if(new_frequency < PUBLIC_LOW_FREQ || new_frequency > PUBLIC_HIGH_FREQ)
			new_frequency = sanitize_frequency(new_frequency)
		P.sradio.set_frequency(new_frequency)
		return 1

	else if(href_list["code"])
		P.sradio.code += text2num(href_list["code"])
		P.sradio.code = round(P.sradio.code)
		P.sradio.code = min(100, P.sradio.code)
		P.sradio.code = max(1, P.sradio.code)
		return 1
