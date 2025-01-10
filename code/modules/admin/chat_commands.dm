/// Reload admins tgs chat command. Intentionally not validated.
/datum/tgs_chat_command/reload_admins
	name = "reload_admins"
	help_text = "Forces the server to reload admins."
	admin_only = TRUE

/datum/tgs_chat_command/reload_admins/Run(datum/tgs_chat_user/sender, params)
	ReloadAsync()
	log_admin("[sender.friendly_name] reloaded admins via chat command.")
	message_admins("[sender.friendly_name] reloaded admins via chat command.")
	return new /datum/tgs_message_content("Admins reloaded.")

/datum/tgs_chat_command/reload_admins/proc/ReloadAsync()
	set waitfor = FALSE
	load_admins()

/// subtype tgs chat command with validated admin ranks. Only supports discord.
/datum/tgs_chat_command/validated
	ignore_type = /datum/tgs_chat_command/validated
	admin_only = TRUE
	var/required_rights = NONE //! validate discord userid is linked to a game admin with these flags.

/// called by tgs
/datum/tgs_chat_command/validated/Run(datum/tgs_chat_user/sender, params)
	// TODO: discord <-> ss13 admin linkage
	return Validated_Run(sender, params)

/// Called if the sender passes validation checks or if those checks are disabled.
/datum/tgs_chat_command/validated/proc/Validated_Run(datum/tgs_chat_user/sender, params)
	RETURN_TYPE(/datum/tgs_message_content)
	CRASH("[type] has no implementation for Validated_Run()")

/datum/tgs_chat_command/validated/ahelp
	name = "ahelp"
	help_text = "<ckey|ticket #> <message|ticket <close|resolve|icissue|reject|reopen <ticket #>|list>>"
	admin_only = TRUE
	required_rights = R_ADMIN

/datum/tgs_chat_command/validated/ahelp/Validated_Run(datum/tgs_chat_user/sender, params)
	var/list/all_params = splittext(params, " ")
	if(all_params.len < 2)
		return new /datum/tgs_message_content("Insufficient parameters")
	var/target = all_params[1]
	all_params.Cut(1, 2)
	var/id = text2num(target)
	if(id != null)
		var/datum/admin_help/AH = GLOB.ahelp_tickets.TicketByID(id)
		if(AH)
			target = AH.initiator_ckey
		else
			return new /datum/tgs_message_content("Ticket #[id] not found!")
	return new /datum/tgs_message_content(TgsPm(target, all_params.Join(" "), sender.friendly_name))

/datum/tgs_chat_command/validated/namecheck
	name = "namecheck"
	help_text = "Returns info on the specified target"
	admin_only = TRUE
	required_rights = R_ADMIN

/datum/tgs_chat_command/validated/namecheck/Validated_Run(datum/tgs_chat_user/sender, params)
	params = trim(params)
	if(!params)
		return new /datum/tgs_message_content("Insufficient parameters")
	log_admin("Chat Name Check: [sender.friendly_name] on [params]")
	message_admins("Name checking [params] from [sender.friendly_name]")
	return new /datum/tgs_message_content(keywords_lookup(params, 1))

/datum/tgs_chat_command/validated/adminwho
	name = "adminwho"
	help_text = "Lists administrators currently on the server"
	admin_only = TRUE
	required_rights = 0

/datum/tgs_chat_command/validated/adminwho/Validated_Run(datum/tgs_chat_user/sender, params)
	return new /datum/tgs_message_content(tgsadminwho())

/datum/tgs_chat_command/validated/sdql
	name = "sdql"
	help_text = "Runs an SDQL query"
	admin_only = TRUE
	required_rights = R_DEBUG

/datum/tgs_chat_command/validated/sdql/Validated_Run(datum/tgs_chat_user/sender, params)
	var/list/results = HandleUserlessSDQL(sender.friendly_name, params)
	if(!results)
		return new /datum/tgs_message_content("Query produced no output")
	var/list/text_res = results.Copy(1, 3)
	var/list/refs = results.len > 3 ? results.Copy(4) : null
	return new /datum/tgs_message_content("[text_res.Join("\n")][refs ? "\nRefs: [refs.Join(" ")]" : ""]")

/datum/tgs_chat_command/validated/tgsstatus
	name = "status"
	help_text = "Gets the admincount, playercount, gamemode, and true game mode of the server"
	admin_only = TRUE
	required_rights = R_ADMIN

/datum/tgs_chat_command/validated/tgsstatus/Validated_Run(datum/tgs_chat_user/sender, params)
	var/list/adm = get_admin_counts()
	var/list/allmins = adm["total"]
	var/status = "Admins: [allmins.len] (Active: [english_list(adm["present"])] AFK: [english_list(adm["afk"])] Stealth: [english_list(adm["stealth"])] Skipped: [english_list(adm["noflags"])]). "
	status += "Players: [GLOB.clients.len]. Round has [SSticker.HasRoundStarted() ? "" : "not "]started."
	return new /datum/tgs_message_content(status)

#define IRC_STATUS_THROTTLE 5

/datum/tgs_chat_command/irccheck
	name = "check"
	help_text = "Gets the playercount, gamemode, and address of the server"
	var/last_irc_check = 0

/datum/tgs_chat_command/irccheck/Run(datum/tgs_chat_user/sender, params)
	var/rtod = REALTIMEOFDAY
	if(rtod - last_irc_check < IRC_STATUS_THROTTLE)
		return
	last_irc_check = rtod
	var/server = null		//CONFIG_GET(string/server)
	//return "[round_id ? "Round #[round_id]: " : ""][clients.len] players on [SSmapping.config_legacy.map_name], Mode: [master_mode]; Round [SSticker.HasRoundStarted() ? (SSticker.IsRoundInProgress() ? "Active" : "Finishing") : "Starting"] -- [server ? server : "[world.internet_address]:[world.port]"]"
	var/current_state
	switch(SSticker.current_state)
		if(GAME_STATE_PREGAME)
			current_state = "pregame"
		if(GAME_STATE_SETTING_UP)
			current_state = "starting"
		if(GAME_STATE_PLAYING)
			current_state = "active"
		if(GAME_STATE_FINISHED)
			current_state = "finishing"
	return "[GLOB.clients.len] players on [(LEGACY_MAP_DATUM).name], Mode: [master_mode]; round [current_state] -- Duration [roundduration2text()] -- [server ? server : "[world.internet_address]:[world.port]"]"

GLOBAL_LIST(round_end_notifiees)

/datum/tgs_chat_command/endnotify
	name = "notify"
	help_text = "Pings the invoker when the round ends"
	admin_only = FALSE

/datum/tgs_chat_command/endnotify/Run(datum/tgs_chat_user/sender, params)
	//if(!SSticker.IsRoundInProgress() && SSticker.HasRoundStarted())
	if(SSticker.current_state == GAME_STATE_FINISHED)
		return "[sender.mention], the round has already ended!"
	LAZYINITLIST(GLOB.round_end_notifiees)
	GLOB.round_end_notifiees[sender.mention] = TRUE
	return "I will notify [sender.mention] when the round ends."


/datum/tgs_chat_command/whitelist
	name = "whitelist"
	help_text = "Whitelists a ckey for the panic bunker"
	admin_only = TRUE

/datum/tgs_chat_command/whitelist/Run(datum/tgs_chat_user/sender, params)
	GLOB.bunker_passthrough |= ckey(params)
	GLOB.bunker_passthrough[ckey(params)] = world.realtime
	return "Added [ckey(params)] to the bypass list."

/datum/tgs_chat_command/dewhitelist
	name = "dewhitelist"
	help_text = "Cancel a bunker bypass for a ckey."
	admin_only = TRUE

/datum/tgs_chat_command/dewhitelist/Run(datum/tgs_chat_user/sender, params)
	GLOB.bunker_passthrough -= ckey(params)
	return "Removed [ckey(params)] from the bypass list if they were on it."
