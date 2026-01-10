/datum/tgs_chat_command/tgscheck
	name = "check"
	help_text = "Gets the playercount, gamemode, and address of the server"

/datum/tgs_chat_command/tgscheck/Run(datum/tgs_chat_user/sender, params)
	return new /datum/tgs_message_content("[GLOB.round_id ? "Round #[GLOB.round_id]: " : ""][GLOB.clients.len] players on [(LEGACY_MAP_DATUM).name]; Round [SSticker.HasRoundStarted() ? (SSticker.IsRoundInProgress() ? "Active" : "Finishing") : "Starting"] -- [world.internet_address]:[world.port]")

/datum/tgs_chat_command/gameversion
	name = "gameversion"
	help_text = "Gets the version details from the show-server-revision verb, basically"

/datum/tgs_chat_command/gameversion/Run(datum/tgs_chat_user/sender, params)
	var/list/msg = list("")
	msg += "BYOND Server Version: [world.byond_version].[world.byond_build] (Compiled with: [DM_VERSION].[DM_BUILD])\n"

	if (!GLOB.revdata)
		msg += "No revision information found."
	else
		msg += "Revision [copytext_char(GLOB.revdata.commit, 1, 9)]"
		if (GLOB.revdata.date)
			msg += " compiled on '[GLOB.revdata.date]'"

		if(GLOB.revdata.originmastercommit)
			msg += ", from origin commit: <[CONFIG_GET(string/githuburl)]/commit/[GLOB.revdata.originmastercommit]>"

		if(GLOB.revdata.testmerge.len)
			msg += "\n"
			for(var/datum/tgs_revision_information/test_merge/PR as anything in GLOB.revdata.testmerge)
				msg += "PR #[PR.number] at [copytext_char(PR.head_commit, 1, 9)] [PR.title].\n"
				if (PR.url)
					msg += "<[PR.url]>\n"
	return new /datum/tgs_message_content(msg.Join(""))

GLOBAL_LIST(round_end_notifiees)
// Notify
/datum/tgs_chat_command/notify
	name = "notify"
	help_text = "Pings the invoker when the round ends"

/datum/tgs_chat_command/notify/Run(datum/tgs_chat_user/sender, params)
	if(SSticker.current_state == GAME_STATE_FINISHED)
		return new /datum/tgs_message_content("[sender.mention], the round has already ended!")
	LAZYINITLIST(GLOB.round_end_notifiees)
	if(GLOB.round_end_notifiees[sender.mention])
		GLOB.round_end_notifiees[sender.mention] = FALSE
		return new /datum/tgs_message_content("You will no longer be notified when the server restarts")

	GLOB.round_end_notifiees[sender.mention] = TRUE
	return new /datum/tgs_message_content("You will now be notified when the server restarts")
