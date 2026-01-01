/client/proc/cmd_admin_say(msg as text)
	set category = "Special Verbs"
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set hidden = 1
	if(!check_rights(R_ADMIN|R_MOD))
		return

	msg = emoji_parse(sanitize(msg))
	if(!msg)
		return

	if(findtext(msg, "@") || findtext(msg, "#"))
		var/list/link_results = check_asay_links(msg)
		if(length(link_results))
			msg = link_results[ASAY_LINK_NEW_MESSAGE_INDEX]
			link_results[ASAY_LINK_NEW_MESSAGE_INDEX] = null
			var/list/pinged_admin_clients = link_results[ASAY_LINK_PINGED_ADMINS_INDEX]
			for(var/iter_ckey in pinged_admin_clients)
				var/client/iter_admin_client = pinged_admin_clients[iter_ckey]
				if(!iter_admin_client?.holder)
					continue
				window_flash(iter_admin_client)
				SEND_SOUND(iter_admin_client.mob, sound('sound/misc/asay_ping.ogg'))

	log_adminsay(msg,src)
	msg = keywords_lookup(msg)
	msg = "[SPAN_ADMINSAY("[SPAN_PREFIX("ADMIN:")] <EM>[key_name_admin(usr)]</EM> [admin_jump_link(mob)]: <span class='message linkify'>[msg]")]</span>"
	for(var/client/C in GLOB.admins)
		if((R_ADMIN|R_MOD) & C.holder.rights)
			to_chat(C,
				type = MESSAGE_TYPE_ADMINCHAT,
				html = msg,
				confidential = TRUE)

	feedback_add_details("admin_verb","M") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/get_admin_say()
	var/msg = input(src, null, "asay \"text\"") as text|null
	cmd_admin_say(msg)

/client/proc/cmd_mod_say(msg as text)
	set category = "Special Verbs"
	set name = "Msay"
	set hidden = 1

	if(!check_rights(R_ADMIN|R_MOD|R_SERVER))
		return

	msg = emoji_parse(sanitize(msg))
	log_modsay(msg,src)

	if (!msg)
		return

	var/sender_name = key_name(usr, 1)
	if(check_rights(R_ADMIN, 0))
		sender_name = "<span class='admin'>[sender_name]</span>"
	for(var/client/C in GLOB.admins)
		if(check_rights(R_ADMIN|R_MOD|R_SERVER))
			to_chat(C, "<span class='modsay'>" + "MOD: "+ " <span class='name'>[sender_name]</span>([admin_jump_link(mob, C.holder)]): <span class='linkify'>[msg]</span></span>")

	feedback_add_details("admin_verb","MS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_event_say(msg as text)
	set category = "Special Verbs"
	set name = "Esay"
	set hidden = 1

	if(!check_rights(R_ADMIN|R_MOD|R_EVENT|R_SERVER|R_EVENT))
		return

	msg = emoji_parse(sanitize(msg))
	log_eventsay(msg,src)

	if (!msg)
		return

	var/sender_name = key_name(usr, 1)
	if(check_rights(R_ADMIN, 0))
		sender_name = "<span class='admin'>[sender_name]</span>"
	for(var/client/C in GLOB.admins)
		to_chat(C, "<span class='event_channel'>" +  "EVENT: " + " <span class='name'>[sender_name]</span>([admin_jump_link(mob, C.holder)]): <span class='linkify'>[msg]</span></span>")

	feedback_add_details("admin_verb","GS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
