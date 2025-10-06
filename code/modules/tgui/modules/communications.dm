#define COMM_SCREEN_MAIN		1
#define COMM_SCREEN_STAT		2
#define COMM_SCREEN_MESSAGES	3

#define COMM_AUTHENTICATION_NONE	0
#define COMM_AUTHENTICATION_MIN		1
#define COMM_AUTHENTICATION_MAX		2

#define COMM_MSGLEN_MINIMUM 6
#define COMM_CCMSGLEN_MINIMUM 20

/datum/tgui_module_old/communications
	name = "Command & Communications"
	tgui_id = "CommunicationsConsole"

	var/emagged = FALSE

	var/current_viewing_message_id = 0
	var/current_viewing_message = null

	var/authenticated = COMM_AUTHENTICATION_NONE
	var/menu_state = COMM_SCREEN_MAIN
	var/ai_menu_state = COMM_SCREEN_MAIN
	var/aicurrmsg

	var/message_cooldown
	var/centcom_message_cooldown
	var/tmp_alertlevel = 0

	var/stat_msg1
	var/stat_msg2
	var/display_type = "blank"

	var/datum/legacy_announcement/priority/crew_announcement

	var/list/req_access = list()

/datum/tgui_module_old/communications/New(host)
	. = ..()
	crew_announcement = new()
	crew_announcement.newscast = TRUE

/datum/tgui_module_old/communications/ui_interact(mob/user, datum/tgui/ui)
	if((LEGACY_MAP_DATUM) && !(get_z(user) in (LEGACY_MAP_DATUM).contact_levels))
		to_chat(user, SPAN_DANGER("Unable to establish a connection: You're too far away from the station!"))
		return FALSE
	. = ..()

/datum/tgui_module_old/communications/proc/is_authenticated(mob/user, message = TRUE)
	if(authenticated == COMM_AUTHENTICATION_MAX)
		return COMM_AUTHENTICATION_MAX
	else if(isobserver(user))
		var/mob/observer/dead/D = user
		if(D.can_admin_interact())
			return COMM_AUTHENTICATION_MAX
	else if(authenticated)
		return COMM_AUTHENTICATION_MIN
	else
		if(message)
			to_chat(user, SPAN_WARNING("Access denied."))
		return COMM_AUTHENTICATION_NONE

/datum/tgui_module_old/communications/proc/change_security_level(new_level)
	tmp_alertlevel = new_level
	var/old_level = GLOB.security_level
	if(!tmp_alertlevel) tmp_alertlevel = SEC_LEVEL_GREEN
	if(tmp_alertlevel < SEC_LEVEL_GREEN) tmp_alertlevel = SEC_LEVEL_GREEN
	if(tmp_alertlevel > SEC_LEVEL_ORANGE) tmp_alertlevel = SEC_LEVEL_ORANGE //cannot engage red/delta. this code was never updated with the fact that blue is lower than orange/violet/etc
	set_security_level(tmp_alertlevel)
	if(GLOB.security_level != old_level)
		//Only notify the admins if an actual change happened
		log_game("[key_name(usr)] has changed the security level to [get_security_level()].")
		message_admins("[key_name_admin(usr)] has changed the security level to [get_security_level()].")
		switch(GLOB.security_level)
			if(SEC_LEVEL_GREEN)
				feedback_inc("alert_comms_green",1)
			if(SEC_LEVEL_YELLOW)
				feedback_inc("alert_comms_yellow",1)
			if(SEC_LEVEL_VIOLET)
				feedback_inc("alert_comms_violet",1)
			if(SEC_LEVEL_ORANGE)
				feedback_inc("alert_comms_orange",1)
			if(SEC_LEVEL_BLUE)
				feedback_inc("alert_comms_blue",1)
	tmp_alertlevel = 0

/datum/tgui_module_old/communications/ui_data(mob/user, datum/tgui/ui)
	var/list/data = ..()
	data["is_ai"]         = isAI(user) || isrobot(user)
	data["menu_state"]    = data["is_ai"] ? ai_menu_state : menu_state
	data["emagged"]       = emagged
	data["authenticated"] = is_authenticated(user, 0)
	data["authmax"] = data["authenticated"] == COMM_AUTHENTICATION_MAX ? TRUE : FALSE
	data["atcsquelch"] = SSlegacy_atc.squelched
	data["boss_short"] = (LEGACY_MAP_DATUM).boss_short

	data["stat_display"] =  list(
		"type"   = display_type,
		// "icon"   = display_icon,
		"line_1" = (stat_msg1 ? stat_msg1 : "-----"),
		"line_2" = (stat_msg2 ? stat_msg2 : "-----"),

		"presets" = list(
			list("name" = "blank",    "label" = "Clear",        "desc" = "Blank slate."),
			list("name" = "time",     "label" = "Station Time", "desc" = "The current time according to the station's clock."),
			list("name" = "shuttle",  "label" = "Tram ETA",     "desc" = "Display how much time is left."),  // Shuttle ETA -> Tram ETA because we use trams
			list("name" = "message",  "label" = "Message",      "desc" = "A custom message.")
		),
	)

	data["GLOB.security_level"] = GLOB.security_level
	switch(GLOB.security_level)
		if(SEC_LEVEL_BLUE)
			data["security_level_color"] = "blue";
		if(SEC_LEVEL_ORANGE)
			data["security_level_color"] = "orange";
		if(SEC_LEVEL_VIOLET)
			data["security_level_color"] = "violet";
		if(SEC_LEVEL_YELLOW)
			data["security_level_color"] = "yellow";
		if(SEC_LEVEL_GREEN)
			data["security_level_color"] = "green";
		if(SEC_LEVEL_RED)
			data["security_level_color"] = "red";
		else
			data["security_level_color"] = "purple";
	data["str_security_level"] = capitalize(get_security_level())
	data["levels"] = list(
		list("id" = SEC_LEVEL_GREEN,  "name" = "Green",  "icon" = "dove"),
		list("id" = SEC_LEVEL_YELLOW, "name" = "Yellow", "icon" = "exclamation-triangle"),
		list("id" = SEC_LEVEL_BLUE,   "name" = "Blue",   "icon" = "eye"),
		list("id" = SEC_LEVEL_ORANGE, "name" = "Orange", "icon" = "wrench"),
		list("id" = SEC_LEVEL_VIOLET, "name" = "Violet", "icon" = "biohazard"),
	)

	var/datum/comm_message_listener/l = obtain_message_listener()
	data["messages"] = l.messages
	data["message_deletion_allowed"] = l != global_message_listener
	data["message_current_id"] = current_viewing_message_id
	data["message_current"] = current_viewing_message

	// data["lastCallLoc"]     = SSshuttle.emergencyLastCallLoc ? format_text(SSshuttle.emergencyLastCallLoc.name) : null
	data["msg_cooldown"] = message_cooldown ? (round((message_cooldown - world.time) / 10)) : 0
	data["cc_cooldown"] = centcom_message_cooldown ? (round((centcom_message_cooldown - world.time) / 10)) : 0

	data["esc_callable"] = SSemergencyshuttle.location() && !SSemergencyshuttle.online() ? TRUE : FALSE
	data["esc_recallable"] = SSemergencyshuttle.location() && SSemergencyshuttle.online() ? TRUE : FALSE
	data["esc_status"] = FALSE
	if(SSemergencyshuttle.has_eta())
		var/timeleft = SSemergencyshuttle.estimate_arrival_time()
		data["esc_status"] = SSemergencyshuttle.online() ? "ETA:" : "RECALLING:"
		data["esc_status"] += " [timeleft / 60 % 60]:[add_zero(num2text(timeleft % 60), 2)]"
	return data

/datum/tgui_module_old/communications/proc/setCurrentMessage(mob/user, value)
	current_viewing_message_id = value

	var/datum/comm_message_listener/l = obtain_message_listener()
	for(var/list/m in l.messages)
		if(m["id"] == current_viewing_message_id)
			current_viewing_message = m

/datum/tgui_module_old/communications/proc/setMenuState(mob/user, value)
	if(isAI(user) || isrobot(user))
		ai_menu_state = value
	else
		menu_state = value

/datum/tgui_module_old/communications/proc/obtain_message_listener()
	if(istype(host, /datum/computer_file/program/comm))
		var/datum/computer_file/program/comm/P = host
		return P.message_core
	return global_message_listener

/proc/post_status(atom/source, command, data1, data2, mob/user = null)
	var/datum/radio_frequency/frequency = radio_controller.return_frequency(FREQ_STATUS_DISPLAYS)

	if(!frequency)
		return

	var/datum/signal/status_signal = new
	status_signal.source = source
	status_signal.transmission_method = TRANSMISSION_RADIO
	status_signal.data["command"] = command

	switch(command)
		if("message")
			status_signal.data["msg1"] = data1
			status_signal.data["msg2"] = data2
			log_admin("STATUS: [user] set status screen message: [data1] [data2]")
			//message_admins("STATUS: [user] set status screen with [PDA]. Message: [data1] [data2]")
		if("alert")
			status_signal.data["picture_state"] = data1

	frequency.post_signal(null, status_signal)

/datum/tgui_module_old/communications/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	if(..())
		return TRUE
	if((LEGACY_MAP_DATUM) && !(get_z(usr) in (LEGACY_MAP_DATUM).contact_levels))
		to_chat(usr, SPAN_DANGER("Unable to establish a connection: You're too far away from the station!"))
		return FALSE

	. = TRUE
	if(action == "auth")
		if(!ishuman(usr))
			to_chat(usr, SPAN_WARNING("Access denied."))
			return FALSE
		// Logout function.
		if(authenticated != COMM_AUTHENTICATION_NONE)
			authenticated = COMM_AUTHENTICATION_NONE
			crew_announcement.announcer = null
			setMenuState(usr, COMM_SCREEN_MAIN)
			return
		// Login function.
		if(check_access(usr, ACCESS_COMMAND_BRIDGE))
			authenticated = COMM_AUTHENTICATION_MIN
		if(check_access(usr, ACCESS_COMMAND_CAPTAIN))
			authenticated = COMM_AUTHENTICATION_MAX
			var/mob/M = usr
			var/obj/item/card/id = M.GetIdCard()
			if(istype(id))
				crew_announcement.announcer = GetNameAndAssignmentFromId(id)
		if(authenticated == COMM_AUTHENTICATION_NONE)
			to_chat(usr, SPAN_WARNING("You need to wear your ID."))

	// All functions below this point require authentication.
	if(!is_authenticated(usr))
		return FALSE

	switch(action)
		// main interface
		if("main")
			setMenuState(usr, COMM_SCREEN_MAIN)

		if("newalertlevel")
			if(isAI(usr) || isrobot(usr))
				to_chat(usr, SPAN_WARNING("Firewalls prevent you from changing the alert level."))
				return
			else if(isobserver(usr))
				var/mob/observer/dead/D = usr
				if(D.can_admin_interact())
					change_security_level(text2num(params["level"]))
					return TRUE
			else if(!ishuman(usr))
				to_chat(usr, SPAN_WARNING("Security measures prevent you from changing the alert level."))
				return

			if(is_authenticated(usr))
				change_security_level(text2num(params["level"]))
			else
				to_chat(usr, SPAN_WARNING("You are not authorized to do this."))
			setMenuState(usr, COMM_SCREEN_MAIN)

		if("announce")
			if(is_authenticated(usr) == COMM_AUTHENTICATION_MAX)
				if(message_cooldown > world.time)
					to_chat(usr, SPAN_WARNING("Please allow at least one minute to pass between announcements."))
					return
				var/input = input(usr, "Please write a message to announce to the station crew.", "Priority Announcement") as null|message
				if(!input || message_cooldown > world.time || ..() || !(is_authenticated(usr) == COMM_AUTHENTICATION_MAX))
					return
				if(length(input) < COMM_MSGLEN_MINIMUM)
					to_chat(usr, SPAN_WARNING("Message '[input]' is too short. [COMM_MSGLEN_MINIMUM] character minimum."))
					return
				crew_announcement.Announce(input)
				message_cooldown = world.time + 600 //One minute

		if("callshuttle")
			if(!is_authenticated(usr))
				return

			call_shuttle_proc(usr)
			if(SSemergencyshuttle.online())
				post_status(src, "shuttle", user = usr)
			setMenuState(usr, COMM_SCREEN_MAIN)

		if("cancelshuttle")
			if(isAI(usr) || isrobot(usr))
				to_chat(usr, SPAN_WARNING("Firewalls prevent you from recalling the shuttle."))
				return
			var/response = tgui_alert(usr, "Are you sure you wish to recall the shuttle?", "Confirm", list("Yes", "No"))
			if(response == "Yes")
				cancel_call_proc(usr)
			setMenuState(usr, COMM_SCREEN_MAIN)

		if("messagelist")
			current_viewing_message = null
			current_viewing_message_id = null
			if(params["msgid"])
				setCurrentMessage(usr, text2num(params["msgid"]))
			setMenuState(usr, COMM_SCREEN_MESSAGES)

		if("toggleatc")
			SSlegacy_atc.squelched = !SSlegacy_atc.squelched

		if("delmessage")
			var/datum/comm_message_listener/l = obtain_message_listener()
			if(params["msgid"])
				setCurrentMessage(usr, text2num(params["msgid"]))
			var/response = tgui_alert(usr, "Are you sure you wish to delete this message?", "Confirm", list("Yes", "No"))
			if(response == "Yes")
				if(current_viewing_message)
					if(l != global_message_listener)
						l.Remove(current_viewing_message)
					current_viewing_message = null
				setMenuState(usr, COMM_SCREEN_MESSAGES)

		if("status")
			setMenuState(usr, COMM_SCREEN_STAT)

		// Status display stuff
		if("setstat")
			display_type = params["statdisp"]
			switch(display_type)
				if("message")
					post_status(src, "message", stat_msg1, stat_msg2, user = usr)
				if("alert")
					post_status(src, "alert", params["alert"], user = usr)
				else
					post_status(src, params["statdisp"], user = usr)

		if("setmsg1")
			stat_msg1 = reject_bad_text(sanitize(input(usr, "Line 1", "Enter Message Text", stat_msg1) as text|null, 40), 40)
			setMenuState(usr, COMM_SCREEN_STAT)

		if("setmsg2")
			stat_msg2 = reject_bad_text(sanitize(input(usr, "Line 2", "Enter Message Text", stat_msg2) as text|null, 40), 40)
			setMenuState(usr, COMM_SCREEN_STAT)

		// OMG CENTCOM LETTERHEAD
		if("MessageCentCom")
			if(is_authenticated(usr) == COMM_AUTHENTICATION_MAX)
				if(centcom_message_cooldown > world.time)
					to_chat(usr, SPAN_WARNING("Arrays recycling. Please stand by."))
					return
				var/input = sanitize(input(usr, "Please choose a message to transmit to [(LEGACY_MAP_DATUM).boss_short] via quantum entanglement. \
				Please be aware that this process is very expensive, and abuse will lead to... termination.  \
				Transmission does not guarantee a response. \
				There is a 30 second delay before you may send another message, be clear, full and concise.", "Central Command Quantum Messaging") as null|message)
				if(!input || ..() || !(is_authenticated(usr) == COMM_AUTHENTICATION_MAX))
					return
				if(length(input) < COMM_CCMSGLEN_MINIMUM)
					to_chat(usr, SPAN_WARNING("Message '[input]' is too short. [COMM_CCMSGLEN_MINIMUM] character minimum."))
					return
				message_centcom(input, usr)
				to_chat(usr, SPAN_NOTICE("Message transmitted."))
				log_game("[key_name(usr)] has made an IA [(LEGACY_MAP_DATUM).boss_short] announcement: [input]")
				centcom_message_cooldown = world.time + 300 // 30 seconds
			setMenuState(usr, COMM_SCREEN_MAIN)

		// OMG SYNDICATE ...LETTERHEAD
		if("MessageSyndicate")
			if((is_authenticated(usr) == COMM_AUTHENTICATION_MAX) && (emagged))
				if(centcom_message_cooldown > world.time)
					to_chat(usr, "Arrays recycling.  Please stand by.")
					return
				var/input = sanitize(input(usr, "Please choose a message to transmit to \[ABNORMAL ROUTING CORDINATES\] via quantum entanglement.  Please be aware that this process is very expensive, and abuse will lead to... termination. Transmission does not guarantee a response. There is a 30 second delay before you may send another message, be clear, full and concise.", "To abort, send an empty message.", ""))
				if(!input || ..() || !(is_authenticated(usr) == COMM_AUTHENTICATION_MAX))
					return
				if(length(input) < COMM_CCMSGLEN_MINIMUM)
					to_chat(usr, SPAN_WARNING("Message '[input]' is too short. [COMM_CCMSGLEN_MINIMUM] character minimum."))
					return
				message_syndicate(input, usr)
				to_chat(usr, SPAN_NOTICE("Message transmitted."))
				log_game("[key_name(usr)] has made an illegal announcement: [input]")
				centcom_message_cooldown = world.time + 300 // 30 seconds

		if("RestoreBackup")
			to_chat(usr, "Backup routing data restored!")
			emagged = FALSE
			setMenuState(usr, COMM_SCREEN_MAIN)

/datum/tgui_module_old/communications/ntos
	ntos = TRUE
