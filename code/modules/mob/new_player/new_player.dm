/mob/new_player
	var/ready = 0
	var/spawning = 0			// Referenced when you want to delete the new_player later on in the code.
	var/totalPlayers = 0		// Player counts for the Lobby tab
	var/totalPlayersReady = 0
	var/show_hidden_jobs = 0	// Show jobs that are set to "Never" in preferences
	var/datum/browser/panel
	var/age_gate_result
	universal_speak = 1

	invisibility = 101

	density = 0
	stat = DEAD
	canmove = 0

	anchored = 1	// Don't get pushed around

/mob/new_player/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)	// "yes i know what I'm doing"
	GLOB.mob_list += src
	flags |= INITIALIZED
	return INITIALIZE_HINT_NORMAL

/mob/new_player/verb/new_player_panel()
	set src = usr
	set waitfor = FALSE
	new_player_panel_proc()

/mob/new_player/proc/new_player_panel_proc()
	if(age_gate_result == null && client.prefs && !client.is_preference_enabled(/datum/client_preference/debug/age_verified)) // run first time verification
		verifyage()
	var/output = "<div align='center'>"
	output +="<hr>"
	output += "<p><a href='byond://?src=\ref[src];show_preferences=1'>Character Setup</A></p>"

	if(!SSticker || SSticker.current_state <= GAME_STATE_PREGAME)
		if(ready)
			output += "<p>\[ <span class='linkOn'><b>Ready</b></span> | <a href='byond://?src=\ref[src];ready=0'>Not Ready</a> \]</p>"
		else
			output += "<p>\[ <a href='byond://?src=\ref[src];ready=1'>Ready</a> | <span class='linkOn'><b>Not Ready</b></span> \]</p>"

	else
		output += "<a href='byond://?src=\ref[src];manifest=1'>View the Crew Manifest</A><br><br>"
		output += "<p><a href='byond://?src=\ref[src];late_join=1'>Join Game!</A></p>"

	output += "<p><a href='byond://?src=\ref[src];observe=1'>Observe</A></p>"

	if(!IsGuestKey(src.key))
		if(SSdbcore.Connect())
			var/isadmin = 0
			if(src.client && src.client.holder)
				isadmin = 1
			var/datum/db_query/query = SSdbcore.ExecuteQuery(
				"SELECT id FROM [format_table_name("poll_question")] WHERE [isadmin? "" : "adminonly = false AND"] Now() BETWEEN starttime AND endtime AND id NOT IN (SELECT pollid FROM [format_table_name("poll_vote")] WHERE ckey = :ckey) AND id NOT IN (SELECT pollid FROM [format_table_name("poll_textreply")] WHERE ckey = :ckey)",
				list("ckey" = ckey)
			)
			var/newpoll = 0
			while(query.NextRow())
				newpoll = 1
				break
			qdel(query)

			if(newpoll)
				output += "<p><b><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A> (NEW!)</b></p>"
			else
				output += "<p><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A></p>"

	if(client.check_for_new_server_news())
		output += "<p><b><a href='byond://?src=\ref[src];shownews=1'>Show News</A> (NEW!)</b></p>"
	else
		output += "<p><a href='byond://?src=\ref[src];shownews=1'>Show News</A></p>"

	output += "</div>"

	panel = new(src, "Welcome","Welcome", 210, 280, src)
	panel.set_window_options("can_close=0")
	panel.set_content(output)
	panel.open()
	return

/mob/new_player/proc/age_gate()
	var/list/dat = list("<center>")
	dat += "Enter your date of birth here, to confirm that you are over 18.<BR>"
	dat += "<b>Your date of birth is not saved, only the fact that you are over/under 18 is.</b><BR>"
	dat += "</center>"

	dat += "<form action='?src=[REF(src)]'>"
	dat += "<input type='hidden' name='src' value='[REF(src)]'>"
	dat += "<select name = 'Month'>"
	var/monthList = list("January" = 1, "February" = 2, "March" = 3, "April" = 4, "May" = 5, "June" = 6, "July" = 7, "August" = 8, "September" = 9, "October" = 10, "November" = 11, "December" = 12)
	for(var/month in monthList)
		dat += "<option value = [monthList[month]]>[month]</option>"
	dat += "</select>"
	dat += "<select name = 'Year' style = 'float:right'>"
	var/current_year = text2num(time2text(world.realtime, "YYYY"))
	var/start_year = 1920
	for(var/year in start_year to current_year)
		var/reverse_year = 1920 + (current_year - year)
		dat += "<option value = [reverse_year]>[reverse_year]</option>"
	dat += "</select>"
	dat += "<center><input type='submit' value='Submit information'></center>"
	dat += "</form>"

	winshow(src, "age_gate", TRUE)
	var/datum/browser/popup = new(src, "age_gate", "<div align='center'>Age Gate</div>", 400, 250)
	popup.set_window_options("can_close=0")
	popup.set_content(dat.Join())
	popup.open(FALSE)
	onclose(src, "age_gate")

	while(age_gate_result == null)
		stoplag(1)

	popup.close()

	return age_gate_result

/mob/new_player/proc/verifyage()
	UNTIL(client.prefs.initialized)	// fuck this stupid ass broken piece of shit age gate
	if(client.holder)		// they're an admin
		client.set_preference(/datum/client_preference/debug/age_verified, 1)
		return TRUE
	if(!client.is_preference_enabled(/datum/client_preference/debug/age_verified)) //make sure they are verified
		if(!client.prefs)
			message_admins("Blocked [src] from new player panel because age gate could not access client preferences.")
			return FALSE
		else
			var/hasverified = client.is_preference_enabled(/datum/client_preference/debug/age_verified)
			if(!hasverified) //they have not completed age gate
				var/verify = age_gate()
				if(verify == FALSE)
					client.add_system_note("Automated-Age-Gate", "Failed automatic age gate process")
					//ban them and kick them
					to_chat(src, "You have failed the initial age verification check. \nIf you believe this was in error, you MUST submit to additional verification on the forums at citadel-station.net/forum/")
					if(client)
						AddBan(ckey, computer_id, "Failed initial age verification check. Appeal at citadel-station.net/forum/", "SYSTEM", 0, 0)
						Logout()
					return FALSE
				else
					//they claim to be of age, so allow them to continue and update their flags
					client.set_preference(/datum/client_preference/debug/age_verified, 1)
					SScharacters.queue_preferences_save(client.prefs)
					//log this
					message_admins("[ckey] has joined through the automated age gate process.")
					return TRUE
	return TRUE



/mob/new_player/Stat()
	..()

	if(SSticker.current_state == GAME_STATE_PREGAME)
		if(statpanel("Status"))
			if(SSticker.hide_mode)
				stat("Game Mode:", "Secret")
			else
				if(SSticker.hide_mode == 0)
					stat("Game Mode:", "[config_legacy.mode_names[master_mode]]")	// Old setting for showing the game mode
			var/time_remaining = SSticker.GetTimeLeft()
			if(time_remaining > 0)
				stat(null, "Time To Start: [round(time_remaining/10)]s")
			else if(time_remaining == -10)
				stat(null, "Time To Start: DELAYED")
			else
				stat(null, "Time To Start: SOON")
			stat("Players: [totalPlayers]", "Players Ready: [totalPlayersReady]")
			totalPlayers = 0
			totalPlayersReady = 0
			for(var/mob/new_player/player in GLOB.player_list)
				stat("[player.key]", (player.ready)?("(Playing)"):(null))
				totalPlayers++
				if(player.ready)totalPlayersReady++

/mob/new_player/Topic(href, href_list[])
	if(src != usr)
		return 0

	if(!client)
		return 0

	//don't let people get to this unless they are specifically not verified
	if(href_list["Month"] && !client.is_preference_enabled(/datum/client_preference/debug/age_verified))
		var/player_month = text2num(href_list["Month"])
		var/player_year = text2num(href_list["Year"])

		var/current_time = world.realtime
		var/current_month = text2num(time2text(current_time, "MM"))
		var/current_year = text2num(time2text(current_time, "YYYY"))

		var/player_total_months = (player_year * 12) + player_month

		var/current_total_months = (current_year * 12) + current_month

		var/months_in_eighteen_years = 18 * 12

		var/month_difference = current_total_months - player_total_months
		if(month_difference > months_in_eighteen_years)
			age_gate_result = TRUE // they're fine
		else
			if(month_difference < months_in_eighteen_years)
				age_gate_result = FALSE
			else
				//they could be 17 or 18 depending on the /day/ they were born in
				var/current_day = text2num(time2text(current_time, "DD"))
				var/days_in_months = list(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
				if((player_year % 4) == 0) // leap year so february actually has 29 days
					days_in_months[2] = 29
				var/total_days_in_player_month = days_in_months[player_month]
				var/list/days = list()
				for(var/number in 1 to total_days_in_player_month)
					days += number
				var/player_day = input(src, "What day of [player_month] were you born in.") as anything in days
				if(player_day <= current_day)
					//their birthday has passed
					age_gate_result = TRUE
				else
					//it has NOT been their 18th birthday yet
					age_gate_result = FALSE

	if(!verifyage())
		return

	if(!client)	return 0

	if(href_list["show_preferences"])
		client.prefs.ShowChoices(src)
		return 1

	if(href_list["ready"])
		if(!SSticker || SSticker.current_state <= GAME_STATE_PREGAME)	// Make sure we don't ready up after the round has started
			ready = text2num(href_list["ready"])
		else
			ready = 0

	if(href_list["refresh"])
		//src << browse(null, "window=playersetup")	// Closes the player setup window
		panel.close()
		new_player_panel_proc()

	if(href_list["observe"])
		if(!client.is_preference_enabled(/datum/client_preference/debug/age_verified)) return
		var/alert_time = SSticker?.current_state <= GAME_STATE_SETTING_UP ? 1 : round(config_legacy.respawn_time/10/60)

		if(alert(src,"Are you sure you wish to observe? You will have to wait up to [alert_time] minute\s before being able to spawn into the game!","Player Setup","Yes","No") == "Yes")
			if(!client)	return 1

			// Make a new mannequin quickly, and allow the observer to take the appearance
			var/mob/living/carbon/human/dummy/mannequin = new()
			client.prefs.dress_preview_mob(mannequin)
			var/mob/observer/dead/observer = new(mannequin)
			observer.moveToNullspace()	// Let's not stay in our doomed mannequin
			qdel(mannequin)

			spawning = 1
			if(client.media)
				client.media.stop_music() // MAD JAMS cant last forever yo

			observer.started_as_observer = 1
			close_spawn_windows()
			var/obj/landmark/L = pick_landmark_by_key(/obj/landmark/observer_spawn)
			if(L)
				to_chat(src, SPAN_NOTICE("Now teleporting."))
				observer.forceMove(L.loc)
			else
				to_chat(src, SPAN_DANGER("Could not locate an observer spawn point. Use the Teleport verb to jump to the station map."))

			announce_ghost_joinleave(src)

			if(client.prefs.be_random_name)
				client.prefs.real_name = random_name(client.prefs.identifying_gender)
			observer.real_name = client.prefs.real_name
			observer.name = observer.real_name
			if(!client.holder && !config_legacy.antag_hud_allowed)			// For new ghosts we remove the verb from even showing up if it's not allowed.
				observer.verbs -= /mob/observer/dead/verb/toggle_antagHUD	// Poor guys, don't know what they are missing!
			observer.key = key
			observer.client?.holder?.update_stealth_ghost()
			observer.set_respawn_timer(time_till_respawn())	// Will keep their existing time if any, or return 0 and pass 0 into set_respawn_timer which will use the defaults
			qdel(src)

			return 1

	if(href_list["late_join"])

		if(!SSticker || SSticker.current_state != GAME_STATE_PLAYING)
			to_chat(usr, "<font color='red'>The round is either not ready, or has already finished...</font>")
			return

		var/time_till_respawn = time_till_respawn()
		if(time_till_respawn == -1)	// Special case, never allowed to respawn
			to_chat(usr, "<span class='warning'>Respawning is not allowed!</span>")
		else if(time_till_respawn)	// Nonzero time to respawn
			to_chat(usr, "<span class='warning'>You can't respawn yet! You need to wait another [round(time_till_respawn/10/60, 0.1)] minutes.</span>")
			return
/*
		if(client.prefs.species != SPECIES_HUMAN && !check_rights(R_ADMIN, 0))
			if (config_legacy.usealienwhitelist)
				if(!is_alien_whitelisted(src, client.prefs.species))
					src << alert("You are currently not whitelisted to Play [client.prefs.species].")
					return 0
*/
		LateChoices()

	if(href_list["manifest"])
		ViewManifest()

	if(href_list["privacy_poll"])
		if(!SSdbcore.Connect())
			return
		var/voted = 0

		//First check if the person has not voted yet.
		var/datum/db_query/query = SSdbcore.NewQuery(
			"SELECT * FROM [format_table_name("privacy")] WHERE ckey = :ckey",
			list("ckey" = ckey)
		)
		query.Execute()
		while(query.NextRow())
			voted = 1
			break
		qdel(query)

		//This is a safety switch, so only valid options pass through
		var/option = "UNKNOWN"
		switch(href_list["privacy_poll"])
			if("signed")
				option = "SIGNED"
			if("anonymous")
				option = "ANONYMOUS"
			if("nostats")
				option = "NOSTATS"
			if("later")
				usr << browse(null,"window=privacypoll")
				return
			if("abstain")
				option = "ABSTAIN"

		if(option == "UNKNOWN")
			return

		if(!voted)
			SSdbcore.RunQuery(
				"INSERT INTO [format_table_name("privacy")] VALUES (null, NOW(), :ckey, :option)",
				list(
					"ckey" = ckey,
					"option" = option
				)
			)
			to_chat(usr, "<b>Thank you for your vote!</b>")
			usr << browse(null,"window=privacypoll")

	if(!ready && href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)
	else if(!href_list["late_join"])
		new_player_panel()

	if(href_list["showpoll"])

		handle_player_polling()
		return

	if(href_list["pollid"])

		var/pollid = href_list["pollid"]
		if(istext(pollid))
			pollid = text2num(pollid)
		if(isnum(pollid))
			src.poll_player(pollid)
		return

	if(href_list["votepollid"] && href_list["votetype"])
		var/pollid = text2num(href_list["votepollid"])
		var/votetype = href_list["votetype"]
		switch(votetype)
			if("OPTION")
				var/optionid = text2num(href_list["voteoptionid"])
				vote_on_poll(pollid, optionid)
			if("TEXT")
				var/replytext = href_list["replytext"]
				log_text_poll_reply(pollid, replytext)
			if("NUMVAL")
				var/id_min = text2num(href_list["minid"])
				var/id_max = text2num(href_list["maxid"])

				if( (id_max - id_min) > 100 )	//Basic exploit prevention
					to_chat(usr, "The option ID difference is too big. Please contact administration or the database admin.")
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(!isnull(href_list["o[optionid]"]))	//Test if this optionid was replied to
						var/rating
						if(href_list["o[optionid]"] == "abstain")
							rating = null
						else
							rating = text2num(href_list["o[optionid]"])
							if(!isnum(rating))
								return

						vote_on_numval_poll(pollid, optionid, rating)
			if("MULTICHOICE")
				var/id_min = text2num(href_list["minoptionid"])
				var/id_max = text2num(href_list["maxoptionid"])

				if( (id_max - id_min) > 100 )	//Basic exploit prevention
					to_chat(usr, "The option ID difference is too big. Please contact administration or the database admin.")
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(!isnull(href_list["option_[optionid]"]))	//Test if this optionid was selected
						vote_on_poll(pollid, optionid, 1)

	if(href_list["shownews"])
		handle_server_news()
		return

	if(href_list["hidden_jobs"])
		show_hidden_jobs = !show_hidden_jobs
		LateChoices()

/mob/new_player/proc/handle_server_news()
	if(!client)
		return
	var/savefile/F = get_server_news()
	if(F)
		client.prefs.lastnews = md5(F["body"])
		SScharacters.queue_preferences_save(client.prefs)

		var/dat = "<html><body><center>"
		dat += "<h1>[F["title"]]</h1>"
		dat += "<br>"
		dat += "[F["body"]]"
		dat += "<br>"
		dat += "<font size='2'><i>Last written by [F["author"]], on [F["timestamp"]].</i></font>"
		dat += "</center></body></html>"
		var/datum/browser/popup = new(src, "Server News", "Server News", 450, 300, src)
		popup.set_content(dat)
		popup.open()

/mob/new_player/proc/time_till_respawn()
	if(!ckey)
		return -1	// What?

	var/timer = GLOB.respawn_timers[ckey]
	// No timer at all
	if(!timer)
		return 0
	// Special case, infinite timer
	if(timer == -1)
		return -1
	// Timer expired
	if(timer <= world.time)
		GLOB.respawn_timers -= ckey
		return 0
	// Timer still going
	return timer - world.time

/mob/new_player/proc/AttemptLateSpawn(rank)
	if(!client.is_preference_enabled(/datum/client_preference/debug/age_verified)) return
	if (src != usr)
		return 0
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(usr, "<font color='red'>The round is either not ready, or has already finished...</font>")
		return 0
	if(!config_legacy.enter_allowed)
		to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
		return 0
	var/datum/job/J = SSjob.job_by_title(rank)
	var/reason
	if((reason = J.check_client_availability_one(client)) != ROLE_AVAILABLE)
		to_chat(src, SPAN_WARNING("[rank] is not available: [J.get_availability_reason(client, reason)]"))
		return FALSE
	if(!spawn_checks_vr())
		return FALSE
	var/list/errors = list()
	if(!client.prefs.spawn_checks(PREF_COPY_TO_FOR_LATEJOIN, errors))
		to_chat(src, SPAN_WARNING("An error has occured while trying to spawn you in:<br>[errors.Join("<br>")]"))
		return FALSE

	//Find our spawning point.
	var/list/join_props = SSjob.LateSpawn(client, rank)
	var/obj/landmark/spawnpoint/SP = pick(join_props["spawnpoint"])
	var/announce_channel = join_props["channel"] || "Common"

	if(!SP)
		return 0

	spawning = 1
	close_spawn_windows()

	if(!SSjob.AssignRole(src, rank, 1))
		to_chat(src, SPAN_WARNING("SSjob.AssignRole failed; something is seriously wrong. Attempted: [rank]."))
		. = FALSE
		CRASH("AssignRole failed; something is seriously wrong!")

	var/mob/living/character = create_character(SP.GetSpawnLoc())		// Creates the human and transfers vars and mind
	SP.OnSpawn(character)
	//Announces Cyborgs early, because that is the only way it works
	if(character.mind.assigned_role == "Cyborg")
		AnnounceCyborg(character, rank, SP.RenderAnnounceMessage(character, name = character.name, job_name = character.mind.role_alt_title || rank), announce_channel, character.z)
	character = SSjob.EquipRank(character, rank, 1)	// Equips the human
	UpdateFactionList(character)

	// AIs don't need a spawnpoint, they must spawn at an empty core
	if(character.mind.assigned_role == "AI")

		character = character.AIize(move=0)	// AIize the character, but don't move them yet

		// IsJobAvailable for AI checks that there is an empty core available in this list
		var/obj/structure/AIcore/deactivated/C = GLOB.empty_playable_ai_cores[1]
		GLOB.empty_playable_ai_cores -= C

		character.loc = C.loc

		AnnounceCyborg(character, rank, "has been transferred to the empty core in \the [character.loc.loc]")
		SSticker.mode.latespawn(character)

		qdel(C)
		qdel(src)
		return

	// Equip our custom items only AFTER deploying to spawn points eh?
	//equip_custom_items(character)

	//character.apply_traits()

	// Moving wheelchair if they have one
	if(character.buckled && istype(character.buckled, /obj/structure/bed/chair/wheelchair))
		character.buckled.loc = character.loc
		character.buckled.setDir(character.dir)

	SSticker.mode.latespawn(character)

	if(character.mind.assigned_role != "Cyborg")
		data_core.manifest_inject(character)
		SSticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn

		//Grab some data from the character prefs for use in random news procs.

		AnnounceArrival(character, rank, SP.RenderAnnounceMessage(character, name = character.mind.name, job_name = (character.mind.role_alt_title || rank)))

	qdel(src)

/mob/new_player/proc/AnnounceCyborg(var/mob/living/character, var/rank, var/join_message)
	if (SSticker.current_state == GAME_STATE_PLAYING)
		if(character.mind.role_alt_title)
			rank = character.mind.role_alt_title
		// can't use their name here, since cyborg namepicking is done post-spawn, so we'll just say "A new Cyborg has arrived"/"A new Android has arrived"/etc.
		GLOB.global_announcer.autosay("A new [rank] has arrived on the station.", "Arrivals Announcement Computer")


/mob/new_player/proc/create_character(var/turf/T)
	if(!client.is_preference_enabled(/datum/client_preference/debug/age_verified))
		return FALSE
	if(!spawn_checks_vr())
		return FALSE
	var/list/errors = list()
	if(!client.prefs.spawn_checks(PREF_COPY_TO_FOR_ROUNDSTART, errors))
		to_chat(src, SPAN_WARNING("An error has occured while trying to spawn you in:<br>[errors.Join("<br>")]"))
		return FALSE
	spawning = 1
	close_spawn_windows()

	var/mob/living/carbon/human/new_character

	var/use_species_name
	var/datum/species/chosen_species = client.prefs.real_species_datum()

	if(chosen_species && use_species_name)
		// Have to recheck admin due to no usr at roundstart. Latejoins are fine though.
		if(!(chosen_species.species_spawn_flags & SPECIES_SPAWN_WHITELISTED) || config.check_alien_whitelist(ckey(chosen_species.name), ckey))
			new_character = new(T, use_species_name)

	if(!new_character)
		new_character = new(T)

	new_character.lastarea = get_area(T)

	if(SSticker.random_players)
		new_character.gender = pick(MALE, FEMALE)
		client.prefs.real_name = random_name(new_character.gender)
		client.prefs.randomize_appearance_and_body_for(new_character)
	else
		client.prefs.copy_to(new_character)

	if(client && client.media)
		client.media.stop_music()	// MAD JAMS cant last forever yo

	if(mind)
		mind.active = 0					// We wish to transfer the key manually
		// Edited to disable the destructive forced renaming for our responsible whitelist clowns.
		//if(mind.assigned_role == "Clown")				// Give them a clownname if they are a clown
		//	new_character.real_name = pick(GLOB.clown_names)	// I hate this being here of all places but unfortunately dna is based on real_name!
		//	new_character.rename_self("clown")
		mind.original = new_character
		// todo: kick vore's persist shit into new persistence system...
		mind.loaded_from_ckey = client.ckey
		mind.loaded_from_slot = client.prefs.default_slot
		//mind.traits = client.prefs.traits.Copy()	// Conflict
		//! Preferences shim: transfer stuff over
		client.prefs.imprint_mind(mind)
		mind.transfer_to(new_character)				// Won't transfer key since the mind is not active

	new_character.name = real_name
	new_character.dna.ready_dna(new_character)
	new_character.dna.b_type = client.prefs.b_type
	new_character.sync_organ_dna()
	if(client.prefs.disabilities)
		// Set defer to 1 if you add more crap here so it only recalculates struc_enzymes once. - N3X
		new_character.dna.SetSEState(DNABLOCK_GLASSES,1,0)
		new_character.disabilities |= DISABILITY_NEARSIGHTED
	if(client.prefs.mirror == TRUE)
		if((client.prefs.organ_data[O_BRAIN] != null))
			var/obj/item/implant/mirror/positronic/F = new /obj/item/implant/mirror/positronic(new_character)
			F.handle_implant(new_character)
			F.post_implant(new_character)
		else
			var/obj/item/implant/mirror/E = new /obj/item/implant/mirror(new_character)
			E.handle_implant(new_character)
			E.post_implant(new_character)

	// And uncomment this, too.
	//new_character.dna.UpdateSE()

	// Do the initial caching of the player's body icons.
	new_character.force_update_limbs()
	new_character.update_icons_body()
	new_character.update_eyes()

	new_character.key = key		//Manually transfer the key to log them in

	return new_character

/mob/new_player/proc/ViewManifest()
	var/dat = "<div align='center'>"
	dat += data_core.get_manifest(OOC = 1)

	//src << browse(dat, "window=manifest;size=370x420;can_close=1")
	var/datum/browser/popup = new(src, "Crew Manifest", "Crew Manifest", 370, 420, src)
	popup.set_content(dat)
	popup.open()

/mob/new_player/Move()
	return 0

/mob/new_player/proc/close_spawn_windows()

	src << browse(null, "window=latechoices") //closes late choices window
	src << browse(null, "window=preferences_window") //closes the player setup window
	panel.close()

/mob/new_player/proc/has_admin_rights()
	return check_rights(R_ADMIN, 0, src)

/mob/new_player/get_species_name()
	var/datum/species/chosen_species = client?.prefs?.real_species_datum()

	if(!chosen_species)
		return SPECIES_HUMAN

	if(!(chosen_species.species_spawn_flags & SPECIES_SPAWN_WHITELISTED) || config.check_alien_whitelist(ckey(chosen_species.name), ckey))
		return chosen_species.name

	return SPECIES_HUMAN

/mob/new_player/get_gender()
	if(!client || !client.prefs) ..()
	return client.prefs.biological_gender

/mob/new_player/is_ready()
	return ready && ..()

// Prevents lobby players from seeing say, even with ghostears
/mob/new_player/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null)
	return

// Prevents lobby players from seeing emotes, even with ghosteyes
/mob/new_player/show_message(msg, type, alt, alt_type)
	return

/mob/new_player/hear_radio()
	return

/mob/new_player/MayRespawn()
	return 1

/mob/new_player/proc/spawn_checks_vr() //Custom spawn checks.
	var/pass = TRUE

	//No Flavor Text
	if (config_legacy.require_flavor && client && client.prefs && client.prefs.flavor_texts && !client.prefs.flavor_texts["general"])
		to_chat(src,"<span class='warning'>Please set your general flavor text to give a basic description of your character. Set it using the 'Set Flavor text' button on the 'General' tab in character setup, and choosing 'General' category.</span>")
		pass = FALSE

	//No OOC notes
	if (config_legacy.allow_Metadata && client && client.prefs && (isnull(client.prefs.metadata) || length(client.prefs.metadata) < 15))
		to_chat(src,"<span class='warning'>Please set informative OOC notes related to ERP preferences. Set them using the 'OOC Notes' button on the 'General' tab in character setup.</span>")
		pass = FALSE

	//Are they on the VERBOTEN LIST?
	if (prevent_respawns.Find(client.prefs.real_name))
		to_chat(src,"<span class='warning'>You've already quit the round as this character. You can't go back now that you've free'd your job slot. Play another character, or wait for the next round.</span>")
		pass = FALSE

	//Do they have their scale properly setup?
	if(!client.prefs.size_multiplier)
		pass = FALSE
		to_chat(src, SPAN_WARNING("You have not set your scale yet.  Do this on the Species Customization tab in character setup."))

	//Custom species checks
	if (client && client.prefs && client.prefs.real_species_name() == SPECIES_CUSTOM)

		//Didn't name it
		if(!client.prefs.custom_species)
			pass = FALSE
			to_chat(src, SPAN_WARNING("You have to name your custom species.  Do this on the Species Customization tab in character setup."))

		//Check traits/costs
		var/list/megalist = client.prefs.pos_traits + client.prefs.neu_traits + client.prefs.neg_traits
		var/points_left = client.prefs.starting_trait_points
		var/traits_left = client.prefs.max_traits
		for(var/T in megalist)
			var/cost = traits_costs[T]

			if(cost)
				traits_left--

			//A trait was removed from the game
			if(isnull(cost))
				pass = FALSE
				to_chat(src,"<span class='warning'>Your custom species is not playable. One or more traits appear to have been removed from the game or renamed. Enter character setup to correct this.</span>")
				break
			else
				points_left -= traits_costs[T]

		//Went into negatives
		if(points_left < 0 || traits_left < 0)
			pass = FALSE
			to_chat(src, SPAN_WARNING("Your custom species is not playable.  Reconfigure your traits on the Species Customization tab."))

	//Final popup notice
	if (!pass)
		spawn()
			alert(src,"There were problems with spawning your character. Check your message log for details.","Error","OK")
	return pass

/mob/new_player/make_perspective()
	. = ..()
	self_perspective.AddScreen(GLOB.lobby_image)
