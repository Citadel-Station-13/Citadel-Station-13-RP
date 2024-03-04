/datum/computer_file/program/ntnet_dos
	filename = "ntn_dos"
	filedesc = "DoS Traffic Generator"
	category = PROGRAM_CATEGORY_MISC
	program_icon_state = "hostile"
	extended_desc = "This advanced script can perform denial of service attacks against NTNet quantum relays. The system administrator will probably notice this. Multiple devices can run this program together against same relay for increased effect"
	size = 20
	requires_ntnet = TRUE
	available_on_ntnet = FALSE
	available_on_syndinet = TRUE
	tgui_id = "NtosNetDos"
	program_icon = "satellite-dish"

	var/obj/machinery/ntnet_relay/target = null
	var/dos_speed = 0
	var/error = ""
	var/executed = 0

/datum/computer_file/program/ntnet_dos/process_tick()
	dos_speed = 0
	switch(ntnet_status)
		if(1)
			dos_speed = NTNETSPEED_LOWSIGNAL * 10
		if(2)
			dos_speed = NTNETSPEED_HIGHSIGNAL * 10
		if(3)
			dos_speed = NTNETSPEED_ETHERNET * 10
	if(target && executed)
		target.dos_overload += dos_speed
		if(!target.operable())
			target.dos_sources.Remove(src)
			target = null
			error = "Connection to destination relay lost."

/datum/computer_file/program/ntnet_dos/kill_program(forced = FALSE)
	if(target)
		target.dos_sources.Remove(src)
	target = null
	executed = FALSE

	..()

/datum/computer_file/program/ntnet_dos/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("PRG_target_relay")
			for(var/obj/machinery/ntnet_relay/R in ntnet_global.relays)
				if("[R.uid]" == params["targid"])
					target = R
					break
			return TRUE
		if("PRG_reset")
			if(target)
				target.dos_sources.Remove(src)
				target = null
			executed = FALSE
			error = ""
			return TRUE
		if("PRG_execute")
			if(target)
				executed = TRUE
				target.dos_sources.Add(src)
				if(ntnet_global.intrusion_detection_enabled)
					var/obj/item/computer_hardware/network_card/network_card = computer.all_components[MC_NET]
					ntnet_global.add_log("IDS WARNING - Excess traffic flood targeting relay [target.uid] detected from device: [network_card.get_network_tag()]")
					ntnet_global.intrusion_detection_alarm = TRUE
			return TRUE

/datum/computer_file/program/ntnet_dos/ui_data(mob/user)
	if(!ntnet_global)
		return

	var/list/data = get_header_data()

	data["error"] = error
	if(target && executed)
		data["target"] = TRUE
		data["speed"] = dos_speed

		data["overload"] = target.dos_overload
		data["capacity"] = target.dos_capacity
	else
		data["target"] = FALSE
		data["relays"] = list()
		for(var/obj/machinery/ntnet_relay/R in ntnet_global.relays)
			data["relays"] += list(list("id" = R.uid))
		data["focus"] = target ? target.uid : null

	return data
