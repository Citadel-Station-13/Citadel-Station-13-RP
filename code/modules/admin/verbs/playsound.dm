//world/proc/shelleo
#define SHELLEO_ERRORLEVEL 1
#define SHELLEO_STDOUT 2
#define SHELLEO_STDERR 3

/client/proc/play_sound()
	set category = "Fun"
	set name = "Play Global Sound"
	set desc = "Play a sound to all connected players."

	if(!check_rights(R_SOUNDS))
		return

	var/sound = prompt_for_sound_or_null("Pick a sound", "Play Global Sound", 2 * 1024 * 1024)
	if(!sound)
		return

	var/vol = tgui_input_number(usr, "What volume would you like the sound to play at?", max_value = 100)
	if(!vol)
		return
	var/freq = tgui_input_number(usr, "What frequency would you like the sound to play at?", max_value = 100)
	if(!freq)
		return
	vol = clamp(vol, 1, 100)

	var/sound/admin_sound = new()
	admin_sound.file = sound
	admin_sound.priority = 250
	admin_sound.channel = CHANNEL_ADMIN
	admin_sound.frequency = freq
	admin_sound.wait = 1
	admin_sound.repeat = FALSE
	admin_sound.status = SOUND_STREAM
	admin_sound.volume = vol

	var/res = tgui_alert(usr, "Show the title of this song to the players?", "Play Sound", list("Yes", "No", "Cancel"))
	switch(res)
		if("Yes")
			to_chat(world, SPAN_BOLDANNOUNCE("An admin played: [sound]"), confidential = TRUE)
		if("Cancel")
			return

	log_admin("[key_name(usr)] played sound [sound]")
	message_admins("[key_name_admin(usr)] played sound [sound]")

	for(var/mob/M in GLOB.player_list)
		if(M.get_preference_toggle(/datum/game_preference_toggle/music/admin)) //if(M.client.prefs.toggles & SOUND_MIDI)
			admin_sound.volume = vol * M.client.admin_music_volume
			SEND_SOUND(M, admin_sound)
			admin_sound.volume = vol

	feedback_add_details("admin_verb","PGS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/play_local_sound()
	set category = "Fun"
	set name = "Play Local Sound"
	set desc = "Plays a sound only you can hear."

	if(!check_rights(R_SOUNDS))
		return

	var/sound = prompt_for_sound_or_null("Pick a sound", "Play Local Sound", 2 * 1024 * 1024)
	if(!sound)
		return

	log_admin("[key_name(usr)] played a local sound [sound]")
	message_admins("[key_name_admin(usr)] played a local sound [sound]")
	var/volume = tgui_input_number(usr, "What volume would you like the sound to play at?", max_value = 100)
	playsound(get_turf(mob), sound, volume || 50, FALSE)
	feedback_add_details("admin_verb","PLS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/play_web_sound()
	set category = "Fun"
	set name = "Play Internet Sound"
	set desc = "Play a given internet sound to all players."

	if(!check_rights(R_SOUNDS))
		return

	if(S_TIMER_COOLDOWN_TIMELEFT(SStimer, CD_INTERNET_SOUND))
		if(tgui_alert(usr, "Someone else is already playing an Internet sound! It has [DisplayTimeText(S_TIMER_COOLDOWN_TIMELEFT(SStimer, CD_INTERNET_SOUND), 1)] remaining. \
		Would you like to override?", "Musicalis Interruptus", list("No","Yes")) != "Yes")
			return

	var/web_sound_input = tgui_input_text(usr, "Enter content URL (supported sites only, leave blank to stop playing)", "Play Internet Sound", null)

	if(length(web_sound_input))
		web_sound_input = trim(web_sound_input)
		if(findtext(web_sound_input, ":") && !findtext(web_sound_input, GLOB.is_http_protocol))
			to_chat(usr, SPAN_BOLDWARNING("Non-http(s) URIs are not allowed."), confidential = TRUE)
			to_chat(usr, SPAN_WARNING("For youtube-dl shortcuts like ytsearch: please use the appropriate full URL from the website."), confidential = TRUE)
			return
		web_sound(mob, web_sound_input)
	else
		web_sound(mob, null)

///Takes an input from either proc/play_web_sound or the request manager and runs it through yt-dlp and prompts the user before playing it to the server.
/proc/web_sound(mob/user, input, credit)
	if(!check_rights(R_SOUNDS))
		return
	var/ytdl = CONFIG_GET(string/invoke_youtubedl)
	if(!ytdl)
		to_chat(user, SPAN_BOLDWARNING("yt-dlp was not configured, action unavailable"), confidential = TRUE) //Check config.txt for the INVOKE_YOUTUBEDL value
		return
	var/web_sound_url = ""
	var/stop_web_sounds = FALSE
	var/list/music_extra_data = list()
	var/duration = 0
	if(istext(input))
		var/shell_scrubbed_input = shell_url_scrub(input)
		var/list/output = world.shelleo("[ytdl] --geo-bypass --format \"bestaudio\[ext=mp3]/best\[ext=mp4]\[height <= 360]/bestaudio\[ext=m4a]/bestaudio\[ext=aac]\" --dump-single-json --no-playlist -- \"[shell_scrubbed_input]\"")
		var/errorlevel = output[SHELLEO_ERRORLEVEL]
		var/stdout = output[SHELLEO_STDOUT]
		var/stderr = output[SHELLEO_STDERR]
		if(errorlevel)
			to_chat(user, SPAN_BOLDWARNING("yt-dlp URL retrieval FAILED:"), confidential = TRUE)
			to_chat(user, SPAN_WARNING("[stderr]"), confidential = TRUE)
			return
		var/list/data
		try
			data = json_decode(stdout)
		catch(var/exception/e)
			to_chat(user, SPAN_BOLDWARNING("yt-dlp JSON parsing FAILED:"), confidential = TRUE)
			to_chat(user, SPAN_WARNING("[e]: [stdout]"), confidential = TRUE)
			return
		if (data["url"])
			web_sound_url = data["url"]
		var/title = "[data["title"]]"
		var/webpage_url = title
		if (data["webpage_url"])
			webpage_url = "<a href=\"[data["webpage_url"]]\">[title]</a>"
		music_extra_data["duration"] = DisplayTimeText(data["duration"] * 1 SECONDS)
		music_extra_data["link"] = data["webpage_url"]
		music_extra_data["artist"] = data["artist"]
		music_extra_data["upload_date"] = data["upload_date"]
		music_extra_data["album"] = data["album"]
		duration = data["duration"] * 1 SECONDS
		if (duration > 10 MINUTES)
			if((tgui_alert(user, "This song is over 10 minutes long. Are you sure you want to play it?", "Length Warning", list("No", "Yes", "Cancel")) != "Yes"))
				return
		var/include_song_data = tgui_alert(user, "Show the title of and link to this song to the players?\n[title]", "Song Info", list("Yes", "No", "Cancel"))
		switch(include_song_data)
			if("Yes")
				music_extra_data["title"] = data["title"]
				music_extra_data["artist"] = data["artist"]
			if("No")
				music_extra_data["link"] = "\[\[HYPERLINK BLOCKED\]\]"
				music_extra_data["title"] = "Untitled"
				music_extra_data["artist"] = "Unknown"
				music_extra_data["upload_date"] = "XX.YY.ZZZZ"
				music_extra_data["album"] = "Default"
			if("Cancel", null)
				return
		var/credit_yourself = tgui_alert(user, "Display who played the song?", "Credit Yourself", list("Yes", "No", "Cancel"))

		var/list/to_chat_message = list()

		switch(credit_yourself)
			if("Yes")
				if(include_song_data == "Yes")
					to_chat_message += SPAN_NOTICE("[user.ckey] played: [SPAN_LINKIFY(webpage_url)]")
				else
					to_chat_message += SPAN_NOTICE("[user.ckey] played a sound.")
			if("No")
				if(include_song_data == "Yes")
					to_chat_message += SPAN_NOTICE("An admin played: [SPAN_LINKIFY(webpage_url)]")
				else
					to_chat_message += SPAN_NOTICE("An admin played a sound.")
			if("Cancel", null)
				return

		if(credit)
			to_chat_message += SPAN_NOTICE("<br>[credit]")

		to_chat(world, fieldset_block("Now Playing: [SPAN_BOLD(music_extra_data["title"])] by [SPAN_BOLD(music_extra_data["artist"])]", jointext(to_chat_message, ""), "boxed_message"))

		log_admin("[key_name(user)] played web sound: [input]")
		message_admins("[key_name(user)] played web sound: [input]")
	else
		//pressed ok with blank
		log_admin("[key_name(user)] stopped web sounds.")

		message_admins("[key_name(user)] stopped web sounds.")
		web_sound_url = null
		stop_web_sounds = TRUE
	if(web_sound_url && !findtext(web_sound_url, GLOB.is_http_protocol))
		tgui_alert(user, "The media provider returned a content URL that isn't using the HTTP or HTTPS protocol. This is a security risk and the sound will not be played.", "Security Risk", list("OK"))
		to_chat(user, SPAN_BOLDWARNING("BLOCKED: Content URL not using HTTP(S) Protocol!"), confidential = TRUE)

		return
	if(web_sound_url || stop_web_sounds)
		for(var/m in GLOB.player_list)
			var/mob/M = m
			var/client/C = M.client
			if(M.get_preference_toggle(/datum/game_preference_toggle/music/admin))
				if(!stop_web_sounds)
					C.tgui_panel?.play_music(web_sound_url, music_extra_data)
				else
					C.tgui_panel?.stop_music()

	S_TIMER_COOLDOWN_START(SStimer, CD_INTERNET_SOUND, duration)

	feedback_add_details("admin_verb","PIS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//? HEY! yt-dlp is smart enough to handle direct file links (this verb might not be needed)
/client/proc/manual_play_web_sound()
	set category = "Fun"
	set name = "Manual Play Internet Sound"
	if(!check_rights(R_SOUNDS))
		return

	var/web_sound_input = input("Enter content stream URL (must be a direct link)", "Play Internet Sound via direct URL") as text|null
	if(istext(web_sound_input))
		if(!length(web_sound_input))
			log_admin("[key_name(src)] stopped web sound")
			message_admins("[key_name(src)] stopped web sound")
			var/mob/M
			for(var/i in GLOB.player_list)
				M = i
				M?.client?.tgui_panel?.stop_music()
			return

		var/list/music_extra_data = list()
		web_sound_input = trim(web_sound_input)
		if(web_sound_input && (findtext(web_sound_input, ":") && !findtext(web_sound_input, GLOB.is_http_protocol)))
			to_chat(src, "<span class='boldwarning'>Non-http(s) URIs are not allowed.</span>", confidential = TRUE)
			return

		var/list/explode = splittext(web_sound_input, "/") //if url=="https://fixthisshit.com/pogchamp.ogg"then title="pogchamp.ogg"
		var/title = "[explode[explode.len]]"

		if(!findtext(title, ".mp3") && !findtext(title, ".mp4")) // IE sucks.
			to_chat(src, "<span class='warning'>The format is not .mp3/.mp4, IE 8 and above can only support the .mp3/.mp4 format, the music might not play.</span>", confidential = TRUE)

		if(length(title) > 50) //kev no.
			title = "Unknown.mp3"

		music_extra_data["title"] = title

		//SSblackbox.record_feedback("nested tally", "played_url", 1, list("[ckey]", "[web_sound_input]"))
		log_admin("[key_name(src)] played web sound: [web_sound_input]")
		message_admins("[key_name(src)] played web sound: [web_sound_input]")

		for(var/m in GLOB.player_list)
			var/mob/M = m
			var/client/C = M.client
			if(M.get_preference_toggle(/datum/game_preference_toggle/music/admin)) //if(C.prefs.toggles & SOUND_MIDI)
				C.tgui_panel?.play_music(web_sound_input, music_extra_data)

	//SSblackbox.record_feedback("tally", "admin_verb", 1, "Manual Play Internet Sound")
	feedback_add_details("admin_verb","MPIS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/stop_sounds()
	set category = "Debug"
	set name = "Stop All Playing Sounds"
	set desc = "Stops all playing sounds for EVERYONE."

	if(!holder)
		return

	log_admin("[key_name(usr)] stopped all currently playing sounds.")
	message_admins("[key_name_admin(usr)] stopped all currently playing sounds.")
	for(var/mob/player as anything in GLOB.player_list)
		SEND_SOUND(player, sound(null))
		var/client/player_client = player.client
		player_client?.tgui_panel?.stop_music()

	S_TIMER_COOLDOWN_RESET(SStimer, CD_INTERNET_SOUND)
	feedback_add_details("admin_verb","SAPS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//world/proc/shelleo
#undef SHELLEO_ERRORLEVEL
#undef SHELLEO_STDOUT
#undef SHELLEO_STDERR
