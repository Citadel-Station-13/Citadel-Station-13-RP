/client/proc/dsay(message as text)
	set category = "Special Verbs"
	set name = "Dsay" //Gave this shit a shorter name so you only have to time out "dsay" rather than "dead say" to use it --NeoFite
	set hidden = 1

	if(!holder)
		to_chat(usr, "Only administrators may use this command.", confidential = TRUE)
		return

	if(prefs.muted & MUTE_DEADCHAT)
		to_chat(usr, SPAN_DANGER("You cannot send DSAY messages (muted)."), confidential = TRUE)
		return

	if(!get_preference_toggle(/datum/game_preference_toggle/chat/dsay))
		to_chat(usr, "<span class='warning'>You have deadchat muted.</span>")
		return

	message = copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN)
	log_admin("DSAY: [key_name(src)] : [message]")

	if (!message)
		return

	var/rank_name = holder.rank
	var/admin_name = key
	if(holder.fakekey)
		rank_name = pick(strings("admin_nicknames.json", "ranks", "config"))
		admin_name = pick(strings("admin_nicknames.json", "names", "config"))
	var/name_and_rank = "[SPAN_TOOLTIP(rank_name, "STAFF")] ([admin_name])"

	say_dead_direct("[name_and_rank] says, <span class='message'>\"[emoji_parse(message)]\"</span>")

	feedback_add_details("admin_verb","D") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/get_dead_say()
	var/msg = input(src, null, "dsay \"text\"") as text|null
	if (isnull(msg))
		return
	dsay(msg)
