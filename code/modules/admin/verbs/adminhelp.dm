/// Client var used for returning the ahelp verb
/client/var/adminhelptimerid = 0
/// Client var used for tracking the ticket the (usually) not-admin client is dealing with
/client/var/datum/admin_help/current_ticket

GLOBAL_DATUM_INIT(ahelp_tickets, /datum/admin_help_tickets, new)

/**
 * # Adminhelp Ticket Manager
 */
/datum/admin_help_tickets
	/// The set of all active tickets
	var/list/active_tickets = list()
	/// The set of all closed tickets
	var/list/closed_tickets = list()
	/// The set of all resolved tickets
	var/list/resolved_tickets = list()

	var/obj/effect/statclick/ticket_list/astatclick = new(null, null, AHELP_ACTIVE)
	var/obj/effect/statclick/ticket_list/cstatclick = new(null, null, AHELP_CLOSED)
	var/obj/effect/statclick/ticket_list/rstatclick = new(null, null, AHELP_RESOLVED)

/datum/admin_help_tickets/Destroy()
	QDEL_LIST(active_tickets)
	QDEL_LIST(closed_tickets)
	QDEL_LIST(resolved_tickets)
	QDEL_NULL(astatclick)
	QDEL_NULL(cstatclick)
	QDEL_NULL(rstatclick)
	return ..()

/datum/admin_help_tickets/proc/TicketByID(id)
	var/list/lists = list(active_tickets, closed_tickets, resolved_tickets)
	for(var/I in lists)
		for(var/J in I)
			var/datum/admin_help/AH = J
			if(AH.id == id)
				return J

/datum/admin_help_tickets/proc/TicketsByCKey(ckey)
	. = list()
	var/list/lists = list(active_tickets, closed_tickets, resolved_tickets)
	for(var/I in lists)
		for(var/J in I)
			var/datum/admin_help/AH = J
			if(AH.initiator_ckey == ckey)
				. += AH

//private
/datum/admin_help_tickets/proc/ListInsert(datum/admin_help/new_ticket)
	var/list/ticket_list
	switch(new_ticket.state)
		if(AHELP_ACTIVE)
			ticket_list = active_tickets
		if(AHELP_CLOSED)
			ticket_list = closed_tickets
		if(AHELP_RESOLVED)
			ticket_list = resolved_tickets
		else
			CRASH("Invalid ticket state: [new_ticket.state]")
	var/num_closed = ticket_list.len
	if(num_closed)
		for(var/I in 1 to num_closed)
			var/datum/admin_help/AH = ticket_list[I]
			if(AH.id > new_ticket.id)
				ticket_list.Insert(I, new_ticket)
				return
	ticket_list += new_ticket

//opens the ticket listings for one of the 3 states
/datum/admin_help_tickets/proc/BrowseTickets(state)
	var/list/l2b
	var/title
	switch(state)
		if(AHELP_ACTIVE)
			l2b = active_tickets
			title = "Active Tickets"
		if(AHELP_CLOSED)
			l2b = closed_tickets
			title = "Closed Tickets"
		if(AHELP_RESOLVED)
			l2b = resolved_tickets
			title = "Resolved Tickets"
	if(!l2b)
		return
	var/list/dat = list("<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title>[title]</title></head>")
	dat += "<A href='byond://?_src_=holder;[HrefToken()];ahelp_tickets=[state]'>Refresh</A><br><br>"
	for(var/I in l2b)
		var/datum/admin_help/AH = I
		dat += "[SPAN_ADMINNOTICE("[SPAN_ADMINHELP("Ticket #[AH.id]")]: <A href='byond://?_src_=holder;[HrefToken()];ahelp=[REF(AH)];ahelp_action=ticket'>[AH.initiator_key_name]: [AH.name]</A>")]<br>"

	usr << browse(dat.Join(), "window=ahelp_list[state];size=600x480")

//Tickets statpanel
/datum/admin_help_tickets/proc/stat_data()
	. = list()
	var/num_disconnected = 0
	INJECT_STATPANEL_DATA_CLICK(., "Active Tickets:", "[active_tickets.len]", "\ref[astatclick]")
	for(var/I in active_tickets)
		var/datum/admin_help/AH = I
		if(AH.initiator)
			INJECT_STATPANEL_DATA_CLICK(., "#[AH.id]. [AH.initiator_key_name]:", "[AH.statclick.update()]", "\ref[AH.statclick]")
		else
			++num_disconnected
	if(num_disconnected)
		INJECT_STATPANEL_DATA_CLICK(., "Disconnected:", "[num_disconnected]", "\ref[astatclick]")
	INJECT_STATPANEL_DATA_CLICK(., "Closed Tickets:", "[closed_tickets.len]", "\ref[cstatclick]")
	INJECT_STATPANEL_DATA_CLICK(., "Resolved Tickets:", "[resolved_tickets.len]", "\ref[rstatclick]")

//Reassociate still open ticket if one exists
/datum/admin_help_tickets/proc/ClientLogin(client/C)
	C.current_ticket = CKey2ActiveTicket(C.ckey)
	if(C.current_ticket)
		C.current_ticket.initiator = C
		C.current_ticket.AddInteraction("Client reconnected.")

//Dissasociate ticket
/datum/admin_help_tickets/proc/ClientLogout(client/C)
	if(C.current_ticket)
		var/datum/admin_help/T = C.current_ticket
		T.AddInteraction("Client disconnected.")
		//Gotta async this cause clients only logout on destroy, and sleeping in destroy is disgusting
		T.initiator = null

//Get a ticket given a ckey
/datum/admin_help_tickets/proc/CKey2ActiveTicket(ckey)
	for(var/I in active_tickets)
		var/datum/admin_help/AH = I
		if(AH.initiator_ckey == ckey)
			return AH

//
//TICKET LIST STATCLICK
//

/obj/effect/statclick/ticket_list
	var/current_state

/obj/effect/statclick/ticket_list/Initialize(mapload, name, state)
	. = ..()
	current_state = state

/obj/effect/statclick/ticket_list/Click()
	if (!usr.client?.holder)
		message_admins("[key_name_admin(usr)] non-holder clicked on a ticket list statclick! ([src])")
		return

	GLOB.ahelp_tickets.BrowseTickets(current_state)

//called by admin topic
/obj/effect/statclick/ticket_list/proc/Action()
	Click()

#define WEBHOOK_NONE 0
#define WEBHOOK_URGENT 1
#define WEBHOOK_NON_URGENT 2

/**
 * # Adminhelp Ticket
 */
/datum/admin_help
	/// Unique ID of the ticket
	var/id
	/// The current name of the ticket
	var/name
	/// The current state of the ticket
	var/state = AHELP_ACTIVE
	/// The time at which the ticket was opened
	var/opened_at
	/// The time at which the ticket was closed
	var/closed_at
	/// Semi-misnomer, it's the person who ahelped/was bwoinked
	var/client/initiator
	/// The ckey of the initiator
	var/initiator_ckey
	/// The key name of the initiator
	var/initiator_key_name
	/// If any admins were online when the ticket was initialized
	var/heard_by_no_admins = FALSE
	/// The collection of interactions with this ticket. Use AddInteraction() or, preferably, admin_ticket_log()
	var/list/ticket_interactions
	/// Statclick holder for the ticket
	var/obj/effect/statclick/ahelp/statclick
	/// Static counter used for generating each ticket ID
	var/static/ticket_counter = 0
	/// The list of clients currently responding to the opening ticket before it gets a response
	var/list/opening_responders
	/// Whether this ahelp has sent a webhook or not, and what type
	var/webhook_sent = WEBHOOK_NONE
	/// List of player interactions
	var/list/player_interactions
	/// List of admin ckeys that are involved, like through responding
	var/list/admins_involved = list()
	/// Has the player replied to this ticket yet?
	var/player_replied = FALSE

/**
 * Call this on its own to create a ticket, don't manually assign current_ticket
 *
 * Arguments:
 * * msg_raw - The first message of this admin_help: used for the initial title of the ticket
 * * is_bwoink - Boolean operator, TRUE if this ticket was started by an admin PM
 */
/datum/admin_help/New(msg_raw, client/C, is_bwoink, urgent = FALSE)
	//clean the input msg
	var/msg = sanitize(copytext_char(msg_raw, 1, MAX_MESSAGE_LEN))
	if(!msg || !C || !C.mob)
		qdel(src)
		return

	id = ++ticket_counter
	opened_at = world.time

	name = copytext_char(msg, 1, 100)

	initiator = C
	initiator_ckey = initiator.ckey
	initiator_key_name = key_name(initiator, FALSE, TRUE)
	if(initiator.current_ticket) //This is a bug
		stack_trace("Multiple ahelp current_tickets")
		initiator.current_ticket.AddInteraction("Ticket erroneously left open by code")
		initiator.current_ticket.Close()
	initiator.current_ticket = src

	TimeoutVerb()

	statclick = new(null, src)
	ticket_interactions = list()
	player_interactions = list()

	if(is_bwoink)
		AddInteraction("<font color='blue'>[key_name_admin(usr)] PM'd [LinkedReplyName()]</font>", player_message = "<font color='blue'>[key_name_admin(usr, include_name = FALSE)] PM'd [LinkedReplyName()]</font>")
		message_admins("<font color='blue'>Ticket [TicketHref("#[id]")] created</font>")
	else
		MessageNoRecipient(msg_raw, urgent)
		send_message_to_tgs(msg, urgent)
	GLOB.ahelp_tickets.active_tickets += src

/datum/admin_help/proc/format_embed_discord(message)
	var/datum/discord_embed/embed = new()
	embed.title = "Ticket #[id]"
	embed.description = "<byond://[world.internet_address]:[world.port]>"
	embed.author = key_name(initiator_ckey)
	var/round_state
	switch(SSticker.current_state)
		if(GAME_STATE_INIT, GAME_STATE_PREGAME, GAME_STATE_SETTING_UP)
			round_state = "Round has not started"
		if(GAME_STATE_PLAYING)
			round_state = "Round is ongoing."
			// if(SSshuttle.emergency.getModeStr())
			// 	round_state += "\n[SSshuttle.emergency.getModeStr()]: [SSshuttle.emergency.getTimerStr()]"
			// 	if(SSticker.emergency_reason)
			// 		round_state += ", Shuttle call reason: [SSticker.emergency_reason]"
		if(GAME_STATE_FINISHED)
			round_state = "Round has ended"
	var/list/admin_counts = get_admin_counts(R_BAN)
	var/stealth_admins = jointext(admin_counts["stealth"], ", ")
	var/afk_admins = jointext(admin_counts["afk"], ", ")
	var/other_admins = jointext(admin_counts["noflags"], ", ")
	var/admin_text = ""
	var/player_count = "**Total**: [length(GLOB.clients)], **Living**: [length(GLOB.alive_player_list)], **Dead**: [length(GLOB.dead_player_list)], **Observers**: [length(GLOB.current_observers_list)]"
	if(stealth_admins)
		admin_text += "**Stealthed**: [stealth_admins]\n"
	if(afk_admins)
		admin_text += "**AFK**: [afk_admins]\n"
	if(other_admins)
		admin_text += "**Lacks +BAN**: [other_admins]\n"
	embed.fields = list(
		"CKEY" = initiator_ckey,
		"PLAYERS" = player_count,
		"ROUND STATE" = round_state,
		"ROUND ID" = GLOB.round_id,
		"ROUND TIME" = roundduration2text(),
		"MESSAGE" = message,
		"ADMINS" = admin_text,
	)
	return embed

/datum/admin_help/proc/send_message_to_tgs(message, urgent = FALSE)
	var/message_to_send = message

	if(urgent)
		to_chat(initiator, SPAN_BOLDWARNING("Notified admins to prioritize your ticket"))
		var/datum/discord_embed/embed = format_embed_discord(message)
		embed.footer = "This player requested an admin"
		send2adminchat_webhook(embed, urgent = TRUE)
		webhook_sent = WEBHOOK_URGENT
	//send it to TGS if nobody is on and tell us how many were on
	var/admin_number_present = send2tgs_adminless_only(initiator_ckey, "Ticket #[id]: [message_to_send]")
	log_admin_private("Ticket #[id]: [key_name(initiator)]: [name] - heard by [admin_number_present] non-AFK admins who have +BAN.")
	if(admin_number_present <= 0)
		to_chat(initiator, SPAN_NOTICE("No active admins are online, your adminhelp was sent to admins who are available through IRC or Discord."), confidential = TRUE)
		heard_by_no_admins = TRUE
		var/regular_webhook_url = config_legacy.chat_webhook_url
		if(regular_webhook_url && !urgent)
			var/datum/discord_embed/embed = format_embed_discord(message)
			embed.footer = "This player sent an ahelp when no admins are available [urgent? "and also requested an admin": ""]"
			send2adminchat_webhook(embed, urgent = FALSE)
			webhook_sent = WEBHOOK_NON_URGENT

/proc/send2adminchat_webhook(message_or_embed, urgent)
	var/webhook = config_legacy.chat_webhook_url

	if(!webhook)
		return
	var/list/webhook_info = list()
	if(istext(message_or_embed))
		var/message_content = replacetext(replacetext(message_or_embed, "\proper", ""), "\improper", "")
		message_content = GLOB.has_discord_embeddable_links.Replace(replacetext(message_content, "`", ""), " ```$1``` ")
		webhook_info["content"] = message_content
	else
		var/datum/discord_embed/embed = message_or_embed
		webhook_info["embeds"] = list(embed.convert_to_list())
		if(embed.content)
			webhook_info["content"] = embed.content
	// Uncomment when servers are moved to TGS4
	// send2chat(new /datum/tgs_message_content("[initiator_ckey] | [message_content]"), "ahelp", TRUE)
	var/list/headers = list()
	headers["Content-Type"] = "application/json"
	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_POST, webhook, json_encode(webhook_info), headers, "tmp/response.json")
	request.begin_async()

/datum/admin_help/proc/AddInteraction(formatted_message, player_message)
	if (!isnull(usr) && usr.ckey != initiator_ckey)
		admins_involved |= usr.ckey
		if(heard_by_no_admins)
			heard_by_no_admins = FALSE
			send2adminchat(initiator_ckey, "Ticket #[id]: Answered by [key_name(usr)]")

	ticket_interactions += "[time_stamp()]: [formatted_message]"
	if (!isnull(player_message))
		player_interactions += "[time_stamp()]: [player_message]"

//Removes the ahelp verb and returns it after 2 minutes
/datum/admin_help/proc/TimeoutVerb()
	remove_verb(initiator, /client/verb/adminhelp)
	initiator.adminhelptimerid = addtimer(CALLBACK(initiator, TYPE_PROC_REF(/client, giveadminhelpverb)), 1200, TIMER_STOPPABLE) //2 minute cooldown of admin helps

//private
/datum/admin_help/proc/FullMonty(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	. = ADMIN_FULLMONTY_NONAME(initiator.mob)
	. += " (<A href='byond://?_src_=holder;[HrefToken()];showmessageckey=[initiator.ckey]'>NOTES</A>)"
	if(state == AHELP_ACTIVE)
		. += ClosureLinks(ref_src)

//private
/datum/admin_help/proc/ClosureLinks(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	. = ADMIN_AHELP_FULLMONTY(ref_src)

//private
/datum/admin_help/proc/LinkedReplyName(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	return "<A href='byond://?_src_=holder;[HrefToken(forceGlobal = TRUE)];ahelp=[ref_src];ahelp_action=reply'>[initiator_key_name]</A>"

//private
/datum/admin_help/proc/TicketHref(msg, ref_src, action = "ticket")
	if(!ref_src)
		ref_src = "[REF(src)]"
	return "<A href='byond://?_src_=holder;[HrefToken(forceGlobal = TRUE)];ahelp=[ref_src];ahelp_action=[action]'>[msg]</A>"

//message from the initiator without a target, all admins will see this
//won't bug irc/discord
/datum/admin_help/proc/MessageNoRecipient(msg, urgent = FALSE)
	msg = sanitize(copytext_char(msg, 1, MAX_MESSAGE_LEN))
	var/ref_src = "[REF(src)]"
	//Message to be sent to all admins
	var/admin_msg = fieldset_block(
		SPAN_ADMINHELP("Ticket [TicketHref(SPAN_TOOLTIP("Open the ticket in a new window.","#[id]"), ref_src)]"),
		"<b>[SPAN_TOOLTIP("Open a prompt to reply to this ticket.",SPAN_TOOLTIP("Open a prompt to reply to this ticket.","[LinkedReplyName(ref_src)]"))]</b>\n\n\
		[SPAN_LINKIFY(keywords_lookup(msg))]\n\n\
		<b class='smaller'>[FullMonty(ref_src)]</b>",
		"boxed_message red_box")

	AddInteraction("<font color='red'>[SPAN_TOOLTIP("Open a prompt to reply to this ticket.","[LinkedReplyName(ref_src)]")]: [msg]</font>", player_message = "<font color='red'>[LinkedReplyName(ref_src)]: [msg]</font>")
	log_admin_private("Ticket #[id]: [key_name(initiator)]: [msg]")

	//send this msg to all admins
	for(var/client/X in GLOB.admins)
		// if(X.get_preference_toggle(/datum/client_preference/holder/play_adminhelp_ping))
			// SEND_SOUND(X, sound('sound/effects/adminhelp.ogg'))
		SEND_SOUND(X, sound('sound/effects/adminhelp.ogg'))
		window_flash(X)
		to_chat(X,
			type = MESSAGE_TYPE_ADMINPM,
			html = admin_msg,
			confidential = TRUE)

	//show it to the person adminhelping too
	reply_to_admins_notification(msg)

/// Sends a message to the player that they are replying to admins.
/datum/admin_help/proc/reply_to_admins_notification(message)
	to_chat(
		initiator,
		type = MESSAGE_TYPE_ADMINPM,
		html = SPAN_NOTICE("PM to-<b>Admins</b>: [SPAN_LINKIFY(message)]"),
		confidential = TRUE,
	)

	player_replied = TRUE

//Reopen a closed ticket
/datum/admin_help/proc/Reopen()
	if(state == AHELP_ACTIVE)
		to_chat(usr, SPAN_WARNING("This ticket is already open."), confidential = TRUE)
		return

	if(GLOB.ahelp_tickets.CKey2ActiveTicket(initiator_ckey))
		to_chat(usr, SPAN_WARNING("This user already has an active ticket, cannot reopen this one."), confidential = TRUE)
		return

	statclick = new(null, src)
	GLOB.ahelp_tickets.active_tickets += src
	GLOB.ahelp_tickets.closed_tickets -= src
	GLOB.ahelp_tickets.resolved_tickets -= src
	switch(state)
		if(AHELP_CLOSED)
			feedback_dec("ahelp_close")
		if(AHELP_RESOLVED)
			feedback_dec("ahelp_resolve")
	state = AHELP_ACTIVE
	closed_at = null
	if(initiator)
		initiator.current_ticket = src

	AddInteraction("<font color='purple'>Reopened by [key_name_admin(usr)]</font>", player_message = "Ticket reopened!")
	var/msg = SPAN_ADMINHELP("Ticket [TicketHref("#[id]")] reopened by [key_name_admin(usr)].")
	message_admins(msg)
	log_admin_private(msg)
	feedback_inc("ahelp_reopen")
	TicketPanel() //can only be done from here, so refresh it

//private
/datum/admin_help/proc/RemoveActive()
	if(state != AHELP_ACTIVE)
		return
	closed_at = world.time
	QDEL_NULL(statclick)
	GLOB.ahelp_tickets.active_tickets -= src
	if(initiator && initiator.current_ticket == src)
		initiator.current_ticket = null

//Mark open ticket as closed/meme
/datum/admin_help/proc/Close(key_name = key_name_admin(usr), silent = FALSE)
	if(state != AHELP_ACTIVE)
		return
	RemoveActive()
	state = AHELP_CLOSED
	GLOB.ahelp_tickets.ListInsert(src)
	AddInteraction("<font color='red'>Closed by [key_name].</font>", player_message = "<font color='red'>Ticket closed!</font>")
	if(!silent)
		feedback_inc("ahelp_close")
		var/msg = "Ticket [TicketHref("#[id]")] closed by [key_name]."
		message_admins(msg)
		log_admin_private(msg)

//Mark open ticket as resolved/legitimate, returns ahelp verb
/datum/admin_help/proc/Resolve(key_name = key_name_admin(usr), silent = FALSE)
	if(state != AHELP_ACTIVE)
		return
	RemoveActive()
	state = AHELP_RESOLVED
	GLOB.ahelp_tickets.ListInsert(src)

	addtimer(CALLBACK(initiator, TYPE_PROC_REF(/client, giveadminhelpverb)), 5 SECONDS)

	AddInteraction("<font color='green'>Resolved by [key_name].</font>", player_message = "<font color='green'>Ticket resolved!</font>")
	to_chat(initiator, SPAN_ADMINHELP("Your ticket has been resolved by an admin. The Adminhelp verb will be returned to you shortly."), confidential = TRUE)
	if(!silent)
		feedback_inc("ahelp_resolve")
		var/msg = "Ticket [TicketHref("#[id]")] resolved by [key_name]"
		message_admins(msg)
		log_admin_private(msg)

//Close and return ahelp verb, use if ticket is incoherent
/datum/admin_help/proc/Reject(key_name = key_name_admin(usr))
	if(state != AHELP_ACTIVE)
		return

	if(initiator)
		initiator.giveadminhelpverb()

		SEND_SOUND(initiator, sound('sound/effects/adminhelp.ogg'))

		to_chat(initiator, "<font color='red' size='4'><b>- AdminHelp Rejected! -</b></font>", confidential = TRUE)
		to_chat(initiator, "<font color='red'><b>Your admin help was rejected.</b> The adminhelp verb has been returned to you so that you may try again.</font>", confidential = TRUE)
		to_chat(initiator, "Please try to be calm, clear, and descriptive in admin helps, do not assume the admin has seen any related events, and clearly state the names of anybody you are reporting.", confidential = TRUE)

	feedback_inc("ahelp_reject")
	var/msg = "Ticket [TicketHref("#[id]")] rejected by [key_name]"
	message_admins(msg)
	log_admin_private(msg)
	AddInteraction("Rejected by [key_name].", player_message = "Ticket rejected!")
	Close(silent = TRUE)

//Resolve ticket with IC Issue message
/datum/admin_help/proc/ICIssue(key_name = key_name_admin(usr))
	if(state != AHELP_ACTIVE)
		return

	var/msg = "<font color='red' size='4'><b>- AdminHelp marked as IC issue! -</b></font><br>"
	msg += "<font color='red'>Your issue has been determined by an administrator to be an in character issue and does NOT require administrator intervention at this time. For further resolution you should pursue options that are in character.</font>"

	if(initiator)
		to_chat(initiator, msg, confidential = TRUE)

	feedback_inc("ahelp_icissue")
	msg = "Ticket [TicketHref("#[id]")] marked as IC by [key_name]"
	message_admins(msg)
	log_admin_private(msg)
	AddInteraction("Marked as IC issue by [key_name]", player_message = "Marked as IC issue!")
	Resolve(silent = TRUE)

//Resolve ticket with IC Issue message
/datum/admin_help/proc/HandleIssue()
	if(state != AHELP_ACTIVE)
		return

	var/msg = "<font color='red'>Your AdminHelp is being handled by [key_name(usr,FALSE,FALSE)] please be patient.</font>"

	if(initiator)
		to_chat(initiator, msg, confidential = TRUE)

	feedback_inc("ahelp_icissue")
	msg = "Ticket [TicketHref("#[id]")] being handled by [key_name(usr,FALSE,FALSE)]"
	message_admins(msg)
	log_admin_private(msg)
	AddInteraction("[key_name_admin(usr)] is now handling this ticket.")

//Show the ticket panel
/datum/admin_help/proc/TicketPanel()
	var/list/dat = list("<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title>Ticket #[id]</title></head>")
	var/ref_src = "[REF(src)]"
	dat += "<h4>Admin Help Ticket #[id]: [LinkedReplyName(ref_src)]</h4>"
	dat += "<b>State: [ticket_status()]</b>"
	dat += "[FOURSPACES][TicketHref("Refresh", ref_src)][FOURSPACES][TicketHref("Re-Title", ref_src, "retitle")]"
	if(state != AHELP_ACTIVE)
		dat += "[FOURSPACES][TicketHref("Reopen", ref_src, "reopen")]"
	dat += "<br><br>Opened at: [gameTimestamp(wtime = opened_at)] (Approx [DisplayTimeText(world.time - opened_at)] ago)"
	if(closed_at)
		dat += "<br>Closed at: [gameTimestamp(wtime = closed_at)] (Approx [DisplayTimeText(world.time - closed_at)] ago)"
	dat += "<br><br>"
	if(initiator)
		dat += "<b>Actions:</b> [FullMonty(ref_src)]<br>"
	else
		dat += "<b>DISCONNECTED</b>[FOURSPACES][ClosureLinks(ref_src)]<br>"
	dat += "<br><b>Log:</b><br><br>"
	for(var/I in ticket_interactions)
		dat += "[I]<br>"

	// Helper for opening directly to player ticket history
	dat += "<br><br><b>Player Ticket History:</b>"
	dat += "[FOURSPACES]<A href='byond://?_src_=holder;[HrefToken()];player_ticket_history=[initiator_ckey]'>Open</A>"

	// Append any tickets also opened by this user if relevant
	var/list/related_tickets = GLOB.ahelp_tickets.TicketsByCKey(initiator_ckey)
	if (related_tickets.len > 1)
		dat += "<br/><b>Other Tickets by User</b><br/>"
		for (var/datum/admin_help/related_ticket in related_tickets)
			if (related_ticket.id == id)
				continue
			dat += "[related_ticket.TicketHref("#[related_ticket.id]")] ([related_ticket.ticket_status()]): [related_ticket.name]<br/>"
	dat += "</html>"

	usr << browse(dat.Join(), "window=ahelp[id];size=750x480")

/**
 * Renders the current status of the ticket into a displayable string
 */
/datum/admin_help/proc/ticket_status()
	switch(state)
		if(AHELP_ACTIVE)
			return "<font color='red'>OPEN</font>"
		if(AHELP_RESOLVED)
			return "<font color='green'>RESOLVED</font>"
		if(AHELP_CLOSED)
			return "CLOSED"
		else
			stack_trace("Invalid ticket state: [state]")
			return "INVALID, CALL A CODER"

/datum/admin_help/proc/Retitle()
	var/new_title = input(usr, "Enter a title for the ticket", "Rename Ticket", name) as text|null
	if(new_title)
		name = new_title
		//not saying the original name cause it could be a long ass message
		var/msg = "Ticket [TicketHref("#[id]")] titled [name] by [key_name_admin(usr)]"
		message_admins(msg)
		log_admin_private(msg)
	TicketPanel() //we have to be here to do this

//Forwarded action from admin/Topic
/datum/admin_help/proc/Action(action)
	testing("Ahelp action: [action]")
	if(webhook_sent != WEBHOOK_NONE)
		var/datum/discord_embed/embed = new()
		embed.title = "Ticket #[id]"
		embed.description = "[key_name(usr)] has sent an action to this ticket. Action ID: [action]"
		if(webhook_sent == WEBHOOK_URGENT)
			send2adminchat_webhook(embed, urgent = TRUE)
		if(webhook_sent == WEBHOOK_NON_URGENT)
			send2adminchat_webhook(embed, urgent = FALSE)
		webhook_sent = WEBHOOK_NONE
	switch(action)
		if("ticket")
			TicketPanel()
		if("retitle")
			Retitle()
		if("reject")
			Reject()
		if("reply")
			usr.client.cmd_ahelp_reply(initiator)
		if("icissue")
			ICIssue()
		if("close")
			Close()
		if("resolve")
			Resolve()
		if("handleissue")
			HandleIssue()
		if("reopen")
			Reopen()

/datum/admin_help/proc/player_ticket_panel()
	var/list/dat = list("<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title>Player Ticket</title></head>")
	dat += "<b>State: "
	switch(state)
		if(AHELP_ACTIVE)
			dat += "<font color='red'>OPEN</font></b>"
		if(AHELP_RESOLVED)
			dat += "<font color='green'>RESOLVED</font></b>"
		if(AHELP_CLOSED)
			dat += "CLOSED</b>"
		else
			dat += "UNKNOWN</b>"
	dat += "\n[FOURSPACES]<A href='byond://?_src_=holder;[HrefToken(forceGlobal = TRUE)];player_ticket_panel=1'>Refresh</A>"
	dat += "<br><br>Opened at: [gameTimestamp("hh:mm:ss", opened_at)] (Approx [DisplayTimeText(world.time - opened_at)] ago)"
	if(closed_at)
		dat += "<br>Closed at: [gameTimestamp("hh:mm:ss", closed_at)] (Approx [DisplayTimeText(world.time - closed_at)] ago)"
	dat += "<br><br>"
	dat += "<br><b>Log:</b><br><br>"
	for (var/interaction in player_interactions)
		dat += "[interaction]<br>"

	var/datum/browser/player_panel = new(usr, "ahelp[id]", 0, 620, 480)
	player_panel.set_content(dat.Join())
	player_panel.open()

//
// TICKET STATCLICK
//

/obj/effect/statclick/ahelp
	var/datum/admin_help/ahelp_datum

INITIALIZE_IMMEDIATE(/obj/effect/statclick/ahelp)
/obj/effect/statclick/ahelp/Initialize(mapload, datum/admin_help/AH)
	ahelp_datum = AH
	return ..(mapload)

/obj/effect/statclick/ahelp/update()
	return ..(ahelp_datum.name)

/obj/effect/statclick/ahelp/Click()
	if (!usr.client?.holder)
		message_admins("[key_name_admin(usr)] non-holder clicked on an ahelp statclick! ([src])")
		return

	ahelp_datum.TicketPanel()

/obj/effect/statclick/ahelp/Destroy()
	ahelp_datum = null
	return ..()

//
// CLIENT PROCS
//

/client/proc/giveadminhelpverb()
	add_verb(src, /client/verb/adminhelp)
	deltimer(adminhelptimerid)
	adminhelptimerid = 0

// Used for methods where input via arg doesn't work
/client/proc/get_adminhelp()
	var/msg = input(src, "Please describe your problem concisely and an admin will help as soon as they're able.", "Adminhelp contents") as message|null
	adminhelp(msg)

/client/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<span class='danger'>Error: Admin-PM: You cannot send adminhelps (Muted).</span>")
		return
	if(handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	if(!msg)
		return

	msg = sanitize(msg)

	if(persistent.ligma)
		//remove out adminhelp verb temporarily to prevent spamming of admins.
		remove_verb(src, /client/verb/adminhelp)
		adminhelptimerid = addtimer(CALLBACK(src, PROC_REF(giveadminhelpverb)), 2 MINUTES, flags = TIMER_STOPPABLE)

		to_chat(usr, "<span class='adminnotice'>PM to-<b>Admins</b>: [msg]</span>")
		log_shadowban("[key_name(src)] AHELP: [msg]")
		return

	feedback_add_details("admin_verb","Adminhelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	if(current_ticket)
		current_ticket.TimeoutVerb()
		current_ticket.MessageNoRecipient(msg, FALSE)
		return
	new /datum/admin_help(msg, src, FALSE, FALSE)

//admin proc
/client/proc/cmd_admin_ticket_panel()
	set name = "Show Ticket List"
	set category = "Admin"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG, TRUE))
		return

	var/browse_to

	switch(input("Display which ticket list?") as null|anything in list("Active Tickets", "Closed Tickets", "Resolved Tickets"))
		if("Active Tickets")
			browse_to = AHELP_ACTIVE
		if("Closed Tickets")
			browse_to = AHELP_CLOSED
		if("Resolved Tickets")
			browse_to = AHELP_RESOLVED
		else
			return

	GLOB.ahelp_tickets.BrowseTickets(browse_to)

/client/verb/view_latest_ticket()
	set category = "Admin"
	set name = "View Latest Ticket"

	if(!current_ticket)
		// Check if the client had previous tickets, and show the latest one
		var/list/prev_tickets = list()
		var/datum/admin_help/last_ticket
		// Check all resolved tickets for this player
		for(var/datum/admin_help/resolved_ticket in GLOB.ahelp_tickets.resolved_tickets)
			if(resolved_ticket.initiator_ckey == ckey) // Initiator is a misnomer, it's always the non-admin player even if an admin bwoinks first
				prev_tickets += resolved_ticket
		// Check all closed tickets for this player
		for(var/datum/admin_help/closed_ticket in GLOB.ahelp_tickets.closed_tickets)
			if(closed_ticket.initiator_ckey == ckey)
				prev_tickets += closed_ticket
		// Take the most recent entry of prev_tickets and open the panel on it
		if(LAZYLEN(prev_tickets))
			last_ticket = pop(prev_tickets)
			last_ticket.player_ticket_panel()
			return

		// client had no tickets this round
		to_chat(src, SPAN_WARNING("You have not had an ahelp ticket this round."))
		return

	current_ticket.player_ticket_panel()

//
// LOGGING
//

/// Use this proc when an admin takes action that may be related to an open ticket on what
/// what can be a client, ckey, or mob
/// player_message: If the message should be shown in the player ticket panel, fill this out
/// log_in_blackbox: Whether or not this message with the blackbox system.
/// If disabled, this message should be logged with a different proc call
/proc/admin_ticket_log(what, message, player_message, log_in_blackbox = TRUE)
	var/client/mob_client
	var/mob/Mob = what
	if(istype(Mob))
		mob_client = Mob.client
	else
		mob_client = what
	if(istype(mob_client) && mob_client.current_ticket)
		if (isnull(player_message))
			mob_client.current_ticket.AddInteraction(message)
		else
			mob_client.current_ticket.AddInteraction(message, player_message)
		return mob_client.current_ticket
	if(istext(what)) //ckey
		var/datum/admin_help/active_admin_help = GLOB.ahelp_tickets.CKey2ActiveTicket(what)
		if(active_admin_help)
			if (isnull(player_message))
				active_admin_help.AddInteraction(message)
			else
				active_admin_help.AddInteraction(message, player_message)
			return active_admin_help

//
// HELPER PROCS
//

/proc/get_admin_counts(requiredflags = R_BAN)
	. = list("total" = list(), "noflags" = list(), "afk" = list(), "stealth" = list(), "present" = list())
	for(var/client/X in GLOB.admins)
		.["total"] += X
		if(requiredflags != NONE && !check_rights_for(X, requiredflags))
			.["noflags"] += X
		else if(X.is_afk())
			.["afk"] += X
		else if(X.holder.fakekey)
			.["stealth"] += X
		else
			.["present"] += X

/proc/send2tgs_adminless_only(source, msg, requiredflags = R_BAN)
	var/list/adm = get_admin_counts(requiredflags)
	var/list/activemins = adm["present"]
	. = activemins.len
	if(. <= 0)
		var/final = ""
		var/list/afkmins = adm["afk"]
		var/list/stealthmins = adm["stealth"]
		var/list/powerlessmins = adm["noflags"]
		var/list/allmins = adm["total"]
		if(!afkmins.len && !stealthmins.len && !powerlessmins.len)
			final = "[msg] - No admins online"
		else
			final = "[msg] - All admins stealthed\[[english_list(stealthmins)]\], AFK\[[english_list(afkmins)]\], or lacks +BAN\[[english_list(powerlessmins)]\]! Total: [allmins.len] "
		send2adminchat(source,final)

// **do not use**
/proc/send2irc(msg,msg2)
	send2adminchat(msg, msg2)

/proc/tgsadminwho()
	var/list/message = list("Admins: ")
	var/list/admin_keys = list()
	for(var/adm in GLOB.admins)
		var/client/C = adm
		admin_keys += "[C][C.holder.fakekey ? "(Stealth)" : ""][C.is_afk() ? "(AFK)" : ""]"

	for(var/admin in admin_keys)
		if(LAZYLEN(message) > 1)
			message += ", [admin]"
		else
			message += "[admin]"

	return jointext(message, "")

/proc/keywords_lookup(msg,external)

	//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
	var/list/adminhelp_ignored_words = list("unknown","the","a","an","of","monkey","alien","as", "i")

	//explode the input msg into a list
	var/list/msglist = splittext(msg, " ")

	//generate keywords lookup
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()
	var/founds = ""
	for(var/mob/M in GLOB.mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)
			indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = splittext(string, " ")
			var/surname_found = 0
			//surnames
			for(var/i=L.len, i >= 1, i--)
				var/word = ckey(L[i])
				if(word)
					surnames[word] = M
					surname_found = i
					break
			//forenames
			for(var/i in 1 to surname_found-1)
				var/word = ckey(L[i])
				if(word)
					forenames[word] = M
			//ckeys
			ckeys[M.ckey] = M

	var/ai_found = 0
	msg = ""
	var/list/mobs_found = list()
	for(var/original_word in msglist)
		var/word = ckey(original_word)
		if(word)
			if(!(word in adminhelp_ignored_words))
				if(word == "ai")
					ai_found = 1
				else
					var/mob/found = ckeys[word]
					if(!found)
						found = surnames[word]
						if(!found)
							found = forenames[word]
					if(found)
						if(!(found in mobs_found))
							mobs_found += found
							if(!ai_found && isAI(found))
								ai_found = 1
							var/is_antag = FALSE
							if(found.mind && found.mind.special_role)
								is_antag = TRUE
							founds += "Name: [found.name]([found.real_name]) Key: [found.key] Ckey: [found.ckey] [is_antag ? "(Antag)" : null] "
							msg += "[original_word]<font size='1' color='[is_antag ? "red" : "black"]'>(<A href='byond://?_src_=holder;[HrefToken(forceGlobal = TRUE)];adminmoreinfo=[REF(found)]'>?</A>|<A href='byond://?_src_=holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservefollow=[REF(found)]'>F</A>)</font> "
							continue
		msg += "[original_word] "
	if(external)
		if(founds == "")
			return "Search Failed"
		else
			return founds

	return msg

/**
 * Checks a given message to see if any of the words are something we want to treat specially, as detailed below.
 *
 * There are 3 cases where a word is something we want to act on
 * 1. Admin pings, like @adminckey. Pings the admin in question, text is not clickable
 * 2. Datum refs, like @0x2001169 or @mob_23. Clicking on the link opens up the VV for that datum
 * 3. Ticket refs, like #3. Displays the status and ahelper in the link, clicking on it brings up the ticket panel for it.
 * Returns a list being used as a tuple. Index ASAY_LINK_NEW_MESSAGE_INDEX contains the new message text (with clickable links and such)
 * while index ASAY_LINK_PINGED_ADMINS_INDEX contains a list of pinged admin clients, if there are any.
 *
 * Arguments:
 * * msg - the message being scanned
 */
/proc/check_asay_links(msg)
	var/list/msglist = splittext(msg, " ") //explode the input msg into a list
	var/list/pinged_admins = list() // if we ping any admins, store them here so we can ping them after
	var/modified = FALSE // did we find anything?

	var/i = 0
	for(var/word in msglist)
		i++
		if(!length(word))
			continue

		switch(word[1])
			if("@")
				var/stripped_word = ckey(copytext(word, 2))

				// first we check if it's a ckey of an admin
				var/client/client_check = GLOB.directory[stripped_word]
				if(client_check?.holder)
					msglist[i] = "<u>[word]</u>"
					pinged_admins[stripped_word] = client_check
					modified = TRUE
					continue

				// then if not, we check if it's a datum ref

				var/word_with_brackets = "\[[stripped_word]\]" // the actual memory address lookups need the bracket wraps
				var/datum/datum_check = locate(word_with_brackets)
				if(!istype(datum_check))
					continue
				msglist[i] = "<u><a href='byond://?_src_=vars;[HrefToken(forceGlobal = TRUE)];Vars=[word_with_brackets]'>[word]</A></u>"
				modified = TRUE

			if("#") // check if we're linking a ticket
				var/possible_ticket_id = text2num(copytext(word, 2))
				if(!possible_ticket_id)
					continue

				var/datum/admin_help/ahelp_check = GLOB.ahelp_tickets?.TicketByID(possible_ticket_id)
				if(!ahelp_check)
					continue

				var/state_word
				switch(ahelp_check.state)
					if(AHELP_ACTIVE)
						state_word = "Active"
					if(AHELP_CLOSED)
						state_word = "Closed"
					if(AHELP_RESOLVED)
						state_word = "Resolved"

				msglist[i]= "<u><A href='byond://?_src_=holder;[HrefToken(forceGlobal = TRUE)];ahelp=[REF(ahelp_check)];ahelp_action=ticket'>[word] ([state_word] | [ahelp_check.initiator_key_name])</A></u>"
				modified = TRUE

	if(modified)
		var/list/return_list = list()
		return_list[ASAY_LINK_NEW_MESSAGE_INDEX] = jointext(msglist, " ") // without tuples, we must make do!
		return_list[ASAY_LINK_PINGED_ADMINS_INDEX] = pinged_admins
		return return_list


#undef WEBHOOK_URGENT
#undef WEBHOOK_NONE
#undef WEBHOOK_NON_URGENT
