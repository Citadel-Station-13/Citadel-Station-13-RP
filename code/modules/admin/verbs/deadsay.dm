GLOBAL_LIST_INIT(stealthmin_nicknames, world.file2list("[global.config.directory]/admin_nicknames.txt"))

/client/proc/dsay(msg as text)
	set category = "Special Verbs"
	set name = "Dsay" //Gave this shit a shorter name so you only have to time out "dsay" rather than "dead say" to use it --NeoFite
	set hidden = 1
	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return
	if(!src.mob)
		return
	if(prefs.muted & MUTE_DEADCHAT)
		to_chat(src, "<span class='warning'>You cannot send DSAY messages (muted).</span>")
		return

	if(!is_preference_enabled(/datum/client_preference/show_dsay))
		to_chat(src, "<span class='warning'>You have deadchat muted.</span>")
		return

	var/stafftype = holder.rank

	msg = sanitize(msg)
	log_admin("DSAY: [key_name(src)] : [msg]")

	if (!msg)
		return

	var/key
	if(holder.fakekey)
		if(is_preference_enabled(/datum/client_preference/holder/obfuscate_stealth_dsay))
			key = pick(GLOB.stealthmin_nicknames)
		else
			key = holder.fakekey
	else
		key = src.key

	say_dead_direct("<span class='name'>[stafftype]([key])</span> says, <span class='message'>\"[msg]\"</span>")

	feedback_add_details("admin_verb","D") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/get_dead_say()
	var/msg = input(src, null, "dsay \"text\"") as text|null
	dsay(msg)
