/client/proc/cmd_admin_say(msg as text)
	set category = "Special Verbs"
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set hidden = 1
	if(!check_rights(R_ADMIN|R_MOD))
		return

	msg = sanitize(msg)
	if(!msg)
		return
	msg = emoji_parse(msg)
	log_adminsay(msg,src)

	msg = keywords_lookup(msg) //assume the list **actualy** contain real admemes

	msg = "<span class='adminsay'><span class='prefix'>ADMIN:</span> <EM>[key_name(usr, 1)]</EM> [ADMIN_FLW(mob)]: <span class='message linkify'>[msg]</span></span>"
	for(var/client/C in admins)
		if(check_rights((R_ADMIN | R_MOD), FALSE))
			to_chat(C, msg)

	// to_chat(admin, msg)

	feedback_add_details("admin_verb","M") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/get_admin_say()
	var/msg = input(src, null, "asay \"text\"") as text
	cmd_admin_say(msg)

/client/proc/cmd_mod_say(msg as text)
	set category = "Special Verbs"
	set name = "Msay"
	set hidden = 1
	if(!check_rights(R_ADMIN|R_MOD|R_SERVER))
		return

	msg = sanitize(msg)
	if (!msg)
		return

	msg = emoji_parse(msg)
	log_modsay(msg,src)

	var/sender_name = key_name(usr, TRUE)
	if(check_rights(R_ADMIN, FALSE))
		sender_name = "<span class='admin'>[sender_name]</span>"

	msg = "<span class='mod_channel'><span class='prefix'>MOD:</span> <EM>[sender_name]</EM> [ADMIN_FLW(mob)]: <span class='message'>[msg]</span></span>"
	for(var/client/C in admins)
		if(check_rights((R_ADMIN | R_MOD | R_SERVER), FALSE))
			to_chat(C, msg)

	feedback_add_details("admin_verb","MS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_event_say(msg as text)
	set category = "Special Verbs"
	set name = "Esay"
	set hidden = 1

	if(!check_rights(R_ADMIN|R_MOD|R_EVENT|R_SERVER|R_EVENT))
		return

	msg = sanitize(msg)

	if (!msg)
		return

	msg = emoji_parse(msg)
	log_eventsay(msg,src)

	var/sender_name = key_name(usr, TRUE)
	if(check_rights(R_ADMIN, FALSE))
		sender_name = "<span class='admin'>[sender_name]</span>"
	msg = "<span class='event_channel'><span class='prefix'>EVENT:</span> <EM>[sender_name]</EM> [ADMIN_FLW(mob)]: <span class='message'>[msg]</span></span>"
	to_chat(admins, msg) //the **actual** way of sending asays

	feedback_add_details("admin_verb","GS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
