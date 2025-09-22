/obj/machinery/computer/mecha
	name = "Exosuit Control"
	desc = "Used to track exosuits, as well as view their logs and activate EMP beacons."
	icon_keyboard = "rd_key"
	icon_screen = "mecha"
	light_color = "#a97faa"
	req_access = list(ACCESS_SCIENCE_ROBOTICS)
	circuit = /obj/item/circuitboard/mecha_control
	var/list/located = list()
	var/screen = 0
	var/list/stored_data

/obj/machinery/computer/mecha/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/computer/mecha/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(..())
		return
	ui_interact(user)

/obj/machinery/computer/mecha/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MechaControlConsole", name)
		ui.open()

/obj/machinery/computer/mecha/ui_data(mob/user, datum/tgui/ui)
	var/list/data = ..()

	data["beacons"] = list()
	for(var/obj/item/vehicle_tracking_beacon/TR as anything in GLOB.vehicle_tracking_beacons)
		var/list/tr_data = TR.ui_data(user)
		if(tr_data)
			data["beacons"] += list(tr_data)

	LAZYINITLIST(stored_data)
	data["stored_data"] = stored_data

	return data

/obj/machinery/computer/mecha/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("send_message")
			var/obj/item/vehicle_tracking_beacon/MT = locate(params["mt"])
			if(istype(MT))
				var/message = sanitize(input(usr, "Input message", "Transmit message") as text)
				var/obj/vehicle/sealed/mecha/M = MT.in_mecha()
				if(message && M)
					M.occupant_message(message)
			return TRUE

		if("shock")
			var/obj/item/vehicle_tracking_beacon/MT = locate(params["mt"])
			if(istype(MT))
				MT.shock()
			return TRUE

		if("get_log")
			var/obj/item/vehicle_tracking_beacon/MT = locate(params["mt"])
			if(istype(MT))
				stored_data = MT.get_mecha_log()
			return TRUE

		if("clear_log")
			stored_data = null
			return TRUE
