#define IRC_STATUS_THROTTLE 5
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

/datum/tgs_chat_command/namecheck
	name = "namecheck"
	help_text = "Returns info on the specified target"
	admin_only = TRUE

/datum/tgs_chat_command/namecheck/Run(datum/tgs_chat_user/sender, params)
	params = trim(params)
	if(!params)
		return new /datum/tgs_message_content("Insufficient parameters")
	log_admin("Chat Name Check: [sender.friendly_name] on [params]")
	message_admins("Name checking [params] from [sender.friendly_name]")
	return new /datum/tgs_message_content(keywords_lookup(params, TRUE))

/datum/tgs_chat_command/adminwho
	name = "adminwho"
	help_text = "Lists administrators currently on the server"
	admin_only = TRUE

/datum/tgs_chat_command/adminwho/Run(datum/tgs_chat_user/sender, params)
	return new /datum/tgs_message_content(tgsadminwho())

/datum/tgs_chat_command/sdql
	name = "sdql"
	help_text = "Runs an SDQL query"
	admin_only = TRUE

/datum/tgs_chat_command/sdql/Run(datum/tgs_chat_user/sender, params)
	if(GLOB.AdminProcCaller)
		return "Unable to run query, another admin proc call is in progress. Try again later."
	GLOB.AdminProcCaller = "CHAT_[sender.friendly_name]"	//_ won't show up in ckeys so it'll never match with a real admin
	var/list/results = world.SDQL2_query(params, GLOB.AdminProcCaller, GLOB.AdminProcCaller)
	GLOB.AdminProcCaller = null
	if(!results)
		return new /datum/tgs_message_content("Query produced no output")
	var/list/text_res = results.Copy(1, 3)
	var/list/refs = results.len > 3 ? results.Copy(4) : null
	return new /datum/tgs_message_content("[text_res.Join("\n")][refs ? "\nRefs: [refs.Join(" ")]" : ""]")

/datum/tgs_chat_command/tgsstatus
	name = "status"
	help_text = "Gets the admincount, playercount, gamemode, and true game mode of the server"
	admin_only = TRUE

/datum/tgs_chat_command/tgsstatus/Run(datum/tgs_chat_user/sender, params)
	var/list/adm = get_admin_counts()
	var/list/allmins = adm["total"]
	var/status = "Admins: [allmins.len] (Active: [english_list(adm["present"])] AFK: [english_list(adm["afk"])] Stealth: [english_list(adm["stealth"])] Skipped: [english_list(adm["noflags"])]). "
	status += "Players: [GLOB.clients.len] (Active: [get_active_player_count(FALSE, TRUE, FALSE)]). Round has [SSticker.HasRoundStarted() ? "" : "not "]started."
	return new /datum/tgs_message_content(status)

/datum/tgs_chat_command/ahelp
	name = "ahelp"
	help_text = "<ckey|ticket #> <message|ticket <close|resolve|icissue|reject|reopen <ticket #>|list>>"
	admin_only = TRUE

/datum/tgs_chat_command/ahelp/Run(datum/tgs_chat_user/sender, params)
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
