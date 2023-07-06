/datum/pai_software/messenger
	name = "Digital Messenger"
	ram_cost = 5
	id = "messenger"
	toggle = 0

/datum/pai_software/messenger/on_nano_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
	var/data[0]

	data["receiver_off"] = user.pda.toff
	data["ringer_off"] = user.pda.message_silent
	data["current_ref"] = null
	data["current_name"] = user.current_pda_messaging

	var/pdas[0]
	if(!user.pda.toff)
		for(var/obj/item/pda/P in GLOB.PDAs)
			if(!P.owner || P.toff || P == user.pda || P.hidden) continue
			var/pda[0]
			pda["name"] = "[P]"
			pda["owner"] = "[P.owner]"
			pda["ref"] = "\ref[P]"
			if(P.owner == user.current_pda_messaging)
				data["current_ref"] = "\ref[P]"
			pdas[++pdas.len] = pda

	data["pdas"] = pdas

	var/messages[0]
	if(user.current_pda_messaging)
		for(var/index in user.pda.tnote)
			if(index["owner"] != user.current_pda_messaging)
				continue
			var/msg[0]
			var/sent = index["sent"]
			msg["sent"] = sent ? 1 : 0
			msg["target"] = index["owner"]
			msg["message"] = index["message"]
			messages[++messages.len] = msg

	data["messages"] = messages

	ui = SSnanoui.try_update_ui(user, user, id, ui, data, force_open)
	if(!ui)
		// Don't copy-paste this unless you're making a pAI software module!
		ui = new(user, user, id, "pai_messenger.tmpl", "Digital Messenger", 450, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/pai_software/messenger/Topic(href, href_list)
	var/mob/living/silicon/pai/P = usr
	if(!istype(P)) return

	if(!isnull(P.pda))
		if(href_list["toggler"])
			P.pda.toff = href_list["toggler"] != "1"
			return 1
		else if(href_list["ringer"])
			P.pda.message_silent = href_list["ringer"] != "1"
			return 1
		else if(href_list["select"])
			var/s = href_list["select"]
			if(s == "*NONE*")
				P.current_pda_messaging = null
			else
				P.current_pda_messaging = s
			return 1
		else if(href_list["target"])
			if(P.silence_time)
				return alert("Communications circuits remain uninitialized.")

			var/target = locate(href_list["target"])
			P.pda.create_message(P, target, 1)
			return 1
