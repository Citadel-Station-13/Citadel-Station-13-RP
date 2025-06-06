
/obj/machinery/computer/telecomms
	icon_keyboard = "tech_key"

/obj/machinery/computer/telecomms/server
	name = "Telecommunications Server Monitor"
	desc = "View communication logs and operate triangulation systems here. Translation not guaranteed."
	icon_screen = "comm_logs"

	var/list/servers = list()	// the servers located by the computer
	var/obj/machinery/telecomms/server/SelectedServer
	circuit = /obj/item/circuitboard/comm_server

	var/network = "NULL"		// the network to probe
	var/list/temp = null				// temporary feedback messages

	var/universal_translate = 0 // set to 1 if it can translate nonhuman speech

	req_access = list(ACCESS_ENGINEERING_TELECOMMS)

/obj/machinery/computer/telecomms/server/ui_data(mob/user, datum/tgui/ui)
	var/list/data = list()

	data["universal_translate"] = universal_translate
	data["network"] = network
	data["temp"] = temp

	data["servers"] = list()
	for(var/obj/machinery/telecomms/T in servers)
		data["servers"] += list(list(
			"id" = T.id,
			"name" = T.name,
		))

	data["selectedServer"] = null
	if(SelectedServer)
		data["selectedServer"] = list(
			"id" = SelectedServer.id,
			"totalTraffic" = SelectedServer.totaltraffic,
			"logs" = list(),
			"triangulating" = SelectedServer.triangulating,
			"triangulation" = SelectedServer.triangulation_data(),
		)

		var/i = 0
		for(var/c in SelectedServer.log_entries)
			i++
			var/datum/comm_log_entry/C = c

			// This is necessary to prevent leaking information to the clientside
			var/static/list/acceptable_params = list("uspeech", "intelligible", "message", "name", "race", "job", "timecode")
			var/list/parameters = list()
			for(var/log_param in acceptable_params)
				parameters["[log_param]"] = C.parameters["[log_param]"]

			data["selectedServer"]["logs"] += list(list(
				"name" = C.name,
				"input_type" = C.input_type,
				"id" = i,
				"parameters" = parameters,
			))

	return data

/obj/machinery/computer/telecomms/server/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(machine_stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

/obj/machinery/computer/telecomms/server/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TelecommsLogBrowser", name)
		ui.open()

/obj/machinery/computer/telecomms/server/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("view")
			for(var/obj/machinery/telecomms/T in servers)
				if(T.id == params["id"])
					SelectedServer = T
					break
			. = TRUE

		if("mainmenu")
			SelectedServer = null
			. = TRUE

		if("release")
			servers = list()
			SelectedServer = null
			. = TRUE

		if("scan")
			if(servers.len > 0)
				set_temp("FAILED: CANNOT PROBE WHEN BUFFER FULL", "bad")
				return TRUE

			for(var/obj/machinery/telecomms/server/T in range(25, src))
				if(T.network == network)
					servers.Add(T)

			if(!servers.len)
				set_temp("FAILED: UNABLE TO LOCATE SERVERS IN \[[network]\]", "bad")
			else
				set_temp("[servers.len] SERVERS PROBED & BUFFERED", "good")
			. = TRUE

		if("delete")
			if(!allowed(usr) && !emagged)
				to_chat(usr, "<span class='warning'>ACCESS DENIED.</span>")
				return

			if(SelectedServer)
				var/datum/comm_log_entry/D = SelectedServer.log_entries[text2num(params["id"])]
				set_temp("DELETED ENTRY: [D.name]", "bad")
				SelectedServer.log_entries.Remove(D)
				qdel(D)
			else
				set_temp("FAILED: NO SELECTED MACHINE", "bad")
			. = TRUE

		if("network")
			var/newnet = input(usr, "Which network do you want to view?", "Comm Monitor", network) as null|text

			if(newnet && (((usr in range(1, src)) || issilicon(usr))))
				if(length(newnet) > 15)
					set_temp("FAILED: NETWORK TAG STRING TOO LENGTHY", "bad")
					return TRUE
				network = newnet
				servers = list()
				set_temp("NEW NETWORK TAG SET IN ADDRESS \[[network]\]", "good")

			. = TRUE

		if("cleartemp")
			temp = null
			. = TRUE

		if("toggle_triangulation")
			SelectedServer.set_triangulating(!SelectedServer.triangulating)
			return TRUE

/obj/machinery/computer/telecomms/server/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		playsound(src, /datum/soundbyte/sparks, 75, 1)
		emagged = 1
		to_chat(user, "<span class='notice'>You you disable the security protocols</span>")
		src.updateUsrDialog()
		return 1

/obj/machinery/computer/telecomms/server/proc/set_temp(var/text, var/color = "average")
	temp = list("color" = color, "text" = text)
