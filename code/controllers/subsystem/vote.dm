SUBSYSTEM_DEF(vote)
	name = "Vote"
	wait = 10
	priority = FIRE_PRIORITY_VOTE
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	subsystem_flags = SS_KEEP_TIMING | SS_NO_INIT

	//Current vote
	var/initiator
	var/started_time
	var/time_remaining
	var/duration
	var/mode
	var/question
	/// Options to choose from
	var/list/choices = list()
	/// Votes by option
	var/list/votes_by_choice = list()
	/// Stores each ckeys vote
	var/list/current_votes = list()
	/// Who has voted
	var/list/voting = list()
	/// Anonymous votes
	var/secret = FALSE
	/// Ghost_weight on votes in %
	var/ghost_weight_percent = 25


/datum/config_entry/number/ghost_weight
	default = 25

/datum/config_entry/flag/transfer_vote_obfuscation
	default = FALSE

/datum/config_entry/string/default_on_transfer_tie
	default = "Extend the Shift"

/datum/controller/subsystem/vote/Initialize()
	ghost_weight_percent = CONFIG_GET(number/ghost_weight)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/vote/fire(resumed)
	if(mode)
		time_remaining = round((started_time + duration - world.time)/10)
		if(mode == VOTE_GAMEMODE && SSticker.current_state >= GAME_STATE_SETTING_UP)
			to_chat(world, "<b>Gamemode vote aborted: Game has already started.</b>")
			reset()
			return
		if(time_remaining <= 0)
			result()
			reset()

/datum/controller/subsystem/vote/proc/autotransfer()
	// Before doing the vote, see if anyone is playing.
	// If not, just do the transfer.
	var/players_are_in_round = FALSE
	for(var/a in GLOB.player_list) // Mobs with clients attached.
		var/mob/living/L = a
		if(!istype(L)) // Exclude ghosts and other weird things.
			continue
		if(L.stat == DEAD) // Dead mobs aren't playing.
			continue
		// Everything else is, however.
		players_are_in_round = TRUE
		break

	if(!players_are_in_round)
		log_debug(SPAN_DEBUG("The crew transfer shuttle was automatically called at vote time due to no players being present."))
		init_shift_change(null, 1)
		return

	initiate_vote(VOTE_CREW_TRANSFER, "the server", 1)
	subsystem_log("The server has called a crew transfer vote.")

/datum/controller/subsystem/vote/proc/reset()
	initiator = null
	started_time = null
	duration = null
	time_remaining = null
	mode = null
	question = null
	choices.Cut()
	votes_by_choice.Cut()
	current_votes.Cut()
	secret = FALSE
	ghost_weight_percent = CONFIG_GET(number/ghost_weight)

/datum/controller/subsystem/vote/proc/get_result() // Get the highest number of votes
	var/greatest_votes = 0
	var/total_votes = 0
	var/list/winning = list()

	for(var/option in choices)
		var/votes = votes_by_choice[option]
		total_votes += votes
		if(votes <= 0)
			continue
		if(votes > greatest_votes)
			winning = list()
			LAZYDISTINCTADD(winning, option)
			greatest_votes = votes
		else if(votes == greatest_votes)
			LAZYDISTINCTADD(winning, option)
	return winning
	//there used to be code here for giving default votes from non voters, but if you dont vote you dont get to default either

/datum/controller/subsystem/vote/proc/announce_result()
	var/list/winners = get_result()
	var/text
	if(mode == VOTE_CREW_TRANSFER)
		switch(LAZYLEN(winners))
			if(0)
				. = "Initiate Crew Transfer"
			if(2)
				. = CONFIG_GET(string/default_on_transfer_tie)
	if(LAZYLEN(winners) > 0)
		if(!.)
			if(LAZYLEN(winners) > 1)
				text += "More than one winner, result chosen at random."
			. = pick(winners)
		text += "<b>Vote Result: [.]</b>"
	else
		text += "<b>Vote Result: Inconclusive - No Votes!</b>"

	for(var/option in choices)
		text += SPAN_NOTICE("\n[option] - [votes_by_choice[option] || 0]")
	log_vote(text)
	to_chat(world, "<font color='purple'>[text]</font>")

/datum/controller/subsystem/vote/proc/result()
	. = announce_result()
	var/restart = 0
	if(.)
		switch(mode)
			if(VOTE_RESTART)
				if(. == "Restart Round")
					restart = 1
			if(VOTE_CREW_TRANSFER)
				if(. == "Initiate Crew Transfer")
					init_shift_change(null, 1)

	if(restart)
		to_chat(world, "World restarting due to vote...")
		feedback_set_details("end_error", "restart vote")
		if(blackbox)
			blackbox.save_all_data_to_sql()
		sleep(50)
		log_game("Rebooting due to restart vote")
		world.Reboot()

/datum/controller/subsystem/vote/proc/submit_vote(user, ckey, newVote)
	//if they are a observer or a newplayer(in lobby) use ghost weight, otherwise use 1
	var/weight = (isobserver(user) || isnewplayer(user)) ? ghost_weight_percent / 100 : 1
	if(mode)
		if(weight == 0)
			return
		if(newVote)
			if(current_votes[ckey])
				votes_by_choice[current_votes[ckey][2]] -= current_votes[ckey][1]
			current_votes[ckey] = list(weight, choices[newVote])
			votes_by_choice[current_votes[ckey][2]] += current_votes[ckey][1]
		else
			votes_by_choice[current_votes[ckey][2]] -= current_votes[ckey][1]
			current_votes[ckey] = null



/datum/controller/subsystem/vote/proc/initiate_vote(vote_type, initiator_key, automatic = FALSE, time = config_legacy.vote_period)
	if(!mode)
		if(started_time != null && !(check_rights(R_ADMIN) || automatic))
			var/next_allowed_time = (started_time + config_legacy.vote_delay)
			if(next_allowed_time > world.time)
				return 0

		//reset()

		switch(vote_type)
			if(VOTE_RESTART)
				choices.Add("Restart Round", "Continue Playing")
				votes_by_choice["Restart Round"] = 0
				votes_by_choice["Continue Playing"] = 0
			if(VOTE_CREW_TRANSFER)
				question = "Your PDA beeps with a message from Central. Would you like an additional hour to finish ongoing projects?"
				choices.Add("Initiate Crew Transfer", "Extend the Shift")
				votes_by_choice["Initiate Crew Transfer"] = 0
				votes_by_choice["Extend the Shift"] = 0
				secret = CONFIG_GET(flag/transfer_vote_obfuscation)
			if(VOTE_CUSTOM)
				question = sanitizeSafe(input(usr, "What is the vote for?") as text|null)
				if(!question)
					return 0
				var/list/temp = list()
				for(var/i = 1 to 10)
					var/option = capitalize(sanitize(input(usr, "Please enter an option or hit cancel to finish") as text|null))
					if(!option || mode || !usr.client)
						break
					temp.Add(option)
					votes_by_choice[temp] = 0
				choices = temp
			else
				return 0

		mode = vote_type
		initiator = initiator_key
		started_time = world.time
		duration = time
		var/text = SPAN_VOTENOTIFICATION("[capitalize(mode)] vote started by [initiator].")
		if(mode == VOTE_CUSTOM)
			text += SPAN_VOTENOTIFICATION("\n[question]")
		if(ghost_weight_percent <= 0)
			text += SPAN_NOTICE("\nGhosts are excluded from the vote.")
		log_vote(text)

		to_chat(world, SPAN_INFOPLAIN("<font color='purple'><b>[text]</b>\nType <b>vote</b> or click <a href='?src=\ref[src]'>here</a> to place your votes.\nYou have [config_legacy.vote_period / 10] seconds to vote.</font>"))
		if(vote_type == VOTE_CREW_TRANSFER || vote_type == VOTE_GAMEMODE)
			SEND_SOUND(world, sound('sound/ambience/alarm4.ogg', repeat = 0, wait = 0, volume = 50, channel = 3))

		if(vote_type == VOTE_CUSTOM)
			SEND_SOUND(world, sound('sound/custom_vote.ogg', repeat = 0, wait = 0, volume = 30, channel = 3))

		time_remaining = round(config_legacy.vote_period / 10)
		return 1
	return 0

/datum/controller/subsystem/vote/Topic(href, href_list[])
	usr.client.vote()

/client/verb/vote()
	set category = VERB_CATEGORY_OOC
	set name = "Vote"

	if(SSvote)
		SSvote.ui_interact(usr)


/datum/controller/subsystem/vote/ui_state()
	return GLOB.always_state

/datum/controller/subsystem/vote/ui_interact(mob/user, datum/tgui/ui)
	// Tracks who is voting
	if(!(user.client?.ckey in voting))
		voting += user.client?.ckey
		//current_votes[user.client?.ckey] = null
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Vote")
		ui.open()

/datum/controller/subsystem/vote/ui_data(mob/user, datum/tgui/ui)
	var/list/data = list(
		"choices" = list(),
		"question" = question,
		"selected_choice" = LAZYACCESS(current_votes,user.key) ? LAZYACCESS(current_votes,user.key)[2] : "",
		"time_remaining" = time_remaining,
		"admin" = check_rights_for(user.client, R_ADMIN),

		"vote_happening" = !!choices.len,
		"secret" = secret,
		"ghost_weight" = ghost_weight_percent,
		"ghost" = isobserver(user) || isnewplayer(user),
	)

	for(var/key in choices)
		data["choices"] += list(list(
			"name" = key,
			"votes" = votes_by_choice[key] || 0
		))

	return data

/datum/controller/subsystem/vote/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	var/admin = FALSE
	var/client/C = usr.client
	if(C.holder)
		if(C.holder.rights & R_ADMIN)
			admin = TRUE

	switch(action)
		if("cancel")
			if(admin)
				log_and_message_admins("[key_name_admin(usr)] has cancelled the current vote.")
				reset()
		if("restart")
			if(admin || config_legacy.allow_vote_restart)
				initiate_vote(VOTE_RESTART, usr.key)
		if("transfer")
			if(config_legacy.allow_vote_restart || usr.client.holder)
				initiate_vote(VOTE_CREW_TRANSFER, usr.key)
		if("custom")
			if(admin)
				initiate_vote(VOTE_CUSTOM, usr.key)
		if("vote")
			//current_votes[usr.client.ckey] = round(text2num(params["index"]))
			submit_vote(usr, usr.key,params["index"])
		if("unvote")
			submit_vote(usr, usr.key, null)
		if("hide")
			if(admin)
				secret = !secret
				log_and_message_admins("[usr] made the individual vote numbers [(secret ? "invisibile" : "visible")].")
		if("ghost_weight")
			if(admin)
				ghost_weight_percent = params["ghost_weight"] ? max(0, text2num(params["ghost_weight"])) : ghost_weight_percent
				log_and_message_admins("[usr] changed the ghost vote weight to [ghost_weight_percent].")

	return TRUE
