/datum/pai_software/radio_config
	name = "Radio Configuration"
	ram_cost = 0
	id = "radio"
	toggle = 0
	default = 1

/datum/pai_software/radio_config/on_nano_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui = null, force_open = 1)
	var/data[0]

	data["listening"] = user.radio.broadcasting
	data["frequency"] = format_frequency(user.radio.frequency)

	var/channels[0]
	for(var/ch_name in user.radio.channels)
		var/ch_stat = user.radio.channels[ch_name]
		var/ch_dat[0]
		ch_dat["name"] = ch_name
		// FREQ_LISTENING is const in /obj/item/radio
		ch_dat["listening"] = !!(ch_stat & user.radio.FREQ_LISTENING)
		channels[++channels.len] = ch_dat

	data["channels"] = channels

	ui = SSnanoui.try_update_ui(user, user, id, ui, data, force_open)
	if(!ui)
		ui = new(user, user, id, "pai_radio.tmpl", "Radio Configuration", 300, 150)
		ui.set_initial_data(data)
		ui.open()

/datum/pai_software/radio_config/Topic(href, href_list)
	var/mob/living/silicon/pai/P = usr
	if(!istype(P))
		return

	P.radio.Topic(href, href_list)
	return 1
