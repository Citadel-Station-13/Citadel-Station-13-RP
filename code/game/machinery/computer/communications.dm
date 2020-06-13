// The communications computer
/obj/machinery/computer/communications
	name = "command and communications console"
	desc = "Used to command and control the station. Can relay long-range communications."
	icon_keyboard = "tech_key"
	icon_screen = "comm"
	light_color = "#0099ff"
	req_access = list(access_heads)
	circuit = /obj/item/circuitboard/communications

	var/auth_id = "Unknown" //Who is currently logged in?
	var/list/messagetitle = list()
	var/list/messagetext = list()
	var/currmsg = 0
	var/aicurrmsg = 0
	var/state = STATE_DEFAULT
	var/aistate = STATE_DEFAULT
	var/message_cooldown = 0
	var/ai_message_cooldown = 0
	var/tmp_alertlevel = 0
	var/security_level_cd // used to stop mass spam.
	var/const/STATE_DEFAULT = 1
	var/const/STATE_CALLSHUTTLE = 2
	var/const/STATE_CANCELSHUTTLE = 3
	var/const/STATE_MESSAGELIST = 4
	var/const/STATE_VIEWMESSAGE = 5
	var/const/STATE_DELMESSAGE = 6
	var/const/STATE_STATUSDISPLAY = 7
	var/const/STATE_ALERT_LEVEL = 8
	var/const/STATE_CONFIRM_LEVEL = 9
	var/const/STATE_CREWTRANSFER = 10

	var/stat_msg1
	var/stat_msg2

	var/authenticated = 0
	var/prints_intercept = TRUE

	var/datum/lore/atc_controller/ATC
	var/datum/announcement/priority/crew_announcement = new

/obj/machinery/computer/communications/Initialize()
	. = ..()
	ATC = atc
	crew_announcement.newscast = 1

/obj/machinery/computer/communications/process()
	if(..())
		if(state != STATE_STATUSDISPLAY)
			updateDialog()

/obj/machinery/computer/communications/proc/checkCCcooldown()
	var/obj/item/circuitboard/communications/CM = circuit
	if(CM.lastTimeUsed + (1 MINUTES) > world.time)
		return FALSE
	return TRUE

/obj/machinery/computer/communications/proc/overrideCooldown()
	var/obj/item/circuitboard/communications/CM = circuit
	CM.lastTimeUsed = 0

/obj/machinery/computer/communications/Topic(href, href_list)
	if(..())
		return
	// if(!usr.canUseTopic(src))
	// 	return

	if(GLOB.using_map && !(src.z in GLOB.using_map.contact_levels))
		to_chat(usr, "<span class='boldannounce'>Unable to establish a connection</span>: You're too far away from the station!")
		return

	usr.set_machine(src)

	if(!href_list["operation"])
		return
	var/obj/item/circuitboard/communications/CM = circuit
	switch(href_list["operation"])
		// main interface
		if("main")
			state = STATE_DEFAULT
			// playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
		if("login")
			var/mob/M = usr
			var/obj/item/card/id/I = M.GetIdCard() //get_idcard(TRUE)

			if(I && istype(I))
				if(check_access(I))
					authenticated = 1
					auth_id = "[I.registered_name] ([I.assignment])"
					if(access_captain in I.access)
						authenticated = 2
					// playsound(src, 'sound/machines/terminal_on.ogg', 50, 0)
				if(emagged)
					authenticated = 2
					auth_id = "Unknown"
					to_chat(M, "<span class='warning'>[src] lets out a quiet alarm as its login is overridden.</span>")
					// playsound(src, 'sound/machines/terminal_on.ogg', 50, 0)
					// playsound(src, 'sound/machines/terminal_alert.ogg', 25, 0)
					// if(prob(25))
					// 	for(var/mob/living/silicon/ai/AI in active_ais())
					// 		SEND_SOUND(AI, sound('sound/machines/terminal_alert.ogg', volume = 10)) //Very quiet for balance reasons

		if("logout")
			authenticated = 0
			// playsound(src, 'sound/machines/terminal_off.ogg', 50, 0)

		if("swipeidseclevel")
			// var/mob/M = usr
			// var/obj/item/card/id/I = M.get_active_held_item()
			// if (istype(I, /obj/item/pda))
			// 	var/obj/item/pda/pda = I
			// 	I = pda.id
			// if (I && istype(I))
				// if(ACCESS_CAPTAIN in I.access)
			if(security_level_cd > world.time)
				to_chat(usr, "<span class='warning'>Security level protocols are currently on cooldown. Please stand by.</span>")
				return
			var/old_level = security_level
			if(!tmp_alertlevel)
				tmp_alertlevel = SEC_LEVEL_GREEN
			if(tmp_alertlevel < SEC_LEVEL_GREEN)
				tmp_alertlevel = SEC_LEVEL_GREEN
			if(tmp_alertlevel > SEC_LEVEL_BLUE)
				tmp_alertlevel = SEC_LEVEL_BLUE //Cannot engage delta with this
			set_security_level(tmp_alertlevel)
			security_level_cd = world.time + 15 SECONDS
			if(security_level != old_level)
				to_chat(usr, "<span class='notice'>Authorization confirmed. Modifying security level.</span>")
				// playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)
				//Only notify people if an actual change happened
				var/_security_level = num2seclevel(security_level)
				log_game("[key_name(usr)] has changed the security level to [_security_level] with [src] at [AREACOORD(usr)].")
				message_admins("[ADMIN_LOOKUPFLW(usr)] has changed the security level to [_security_level] with [src] at [AREACOORD(usr)].")
				say_dead_direct("<span class='deadsay'><span class='name'>[usr.real_name]</span> has changed the security level to [_security_level] with [src] at <span class='name'>[get_area_name(usr, TRUE)]</span>.</span>", usr)
				// deadchat_broadcast("<span class='deadsay'><span class='name'>[usr.real_name]</span> has changed the security level to [_security_level] with [src] at <span class='name'>[get_area_name(usr, TRUE)]</span>.</span>", usr)
				switch(security_level)
					if(SEC_LEVEL_GREEN)
						feedback_inc("alert_comms_green", 1)
					if(SEC_LEVEL_YELLOW)
						feedback_inc("alert_comms_yellow", 1)
					if(SEC_LEVEL_VIOLET)
						feedback_inc("alert_comms_violet", 1)
					if(SEC_LEVEL_ORANGE)
						feedback_inc("alert_comms_orange",1 )
					if(SEC_LEVEL_BLUE)
						feedback_inc("alert_comms_blue", 1)
			tmp_alertlevel = SEC_LEVEL_GREEN
				// else
				// 	to_chat(usr, "<span class='warning'>You are not authorized to do this!</span>")
				// 	playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
				// 	tmp_alertlevel = SEC_LEVEL_GREEN
			state = STATE_DEFAULT
			// else
			// 	to_chat(usr, "<span class='warning'>You need to swipe your ID!</span>")
			// 	playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)

		if("announce")
			if(authenticated >= 1)
				// playsound(src, 'sound/machines/terminal_prompt.ogg', 50, 0)
				make_announcement(usr)
				message_cooldown = TRUE
				spawn(1 MINUTE)//One minute cooldown
					message_cooldown = FALSE

		if("crossserver")
			if(authenticated == 2)
				if(checkCCcooldown())
					to_chat(usr, "<span class='warning'>Arrays recycling.  Please stand by.</span>")
					// playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
					return
				var/input = stripped_multiline_input(usr, "Please choose a message to transmit to allied stations.  Please be aware that this process is very expensive, and abuse will lead to... termination.", "Send a message to an allied station.", "")
				if(!input || !(usr in view(1,src)) || !checkCCcooldown())
					return
				// playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)
				send2otherserver("[station_name()]", input, "Comms_Console") //why can they only send messages?
				global_announcer.autosay("Outgoing message to allied station: [input]", ANNOUNCER_NAME) //hacky way of doing the minor announce
				// minor_announce(input, title = "Outgoing message to allied station")
				// usr.log_talk(input, LOG_SAY, tag="message to the other server")
				message_admins("[ADMIN_LOOKUPFLW(usr)] has sent a message to the other server.")
				// deadchat_broadcast("<span class='deadsay bold'>[usr.real_name] has sent an outgoing message to the other station(s).</span>", usr)
				say_dead_direct("<span class='deadsay bold'>[usr.real_name] has sent an outgoing message to the other station(s).</span>", usr)
				CM.lastTimeUsed = world.time

		if("callshuttle")
			state = STATE_DEFAULT
			if(authenticated)
				state = STATE_CALLSHUTTLE
		if("callshuttle2")
			if(authenticated)
				call_shuttle_proc(usr)
				if(SSemergencyshuttle.online())
					post_status("shuttle")
			state = STATE_DEFAULT
		if("cancelshuttle")
			state = STATE_DEFAULT
			if(authenticated)
				state = STATE_CANCELSHUTTLE
		if("cancelshuttle2")
			if(authenticated)
				cancel_call_proc(usr)
			state = STATE_DEFAULT
		if("messagelist")
			currmsg = 0
			state = STATE_MESSAGELIST
		if("toggleatc")
			ATC.squelched = !ATC.squelched
		if("viewmessage")
			state = STATE_VIEWMESSAGE
			if (!currmsg)
				if(href_list["message-num"])
					currmsg = text2num(href_list["message-num"])
				else
					state = STATE_MESSAGELIST
		if("delmessage")
			state = currmsg ? STATE_DELMESSAGE : STATE_MESSAGELIST
		if("delmessage2")
			if(authenticated)
				if(currmsg)
					var/title = messagetitle[currmsg]
					var/text  = messagetext[currmsg]
					messagetitle.Remove(title)
					messagetext.Remove(text)
					if(currmsg == aicurrmsg)
						aicurrmsg = 0
					currmsg = 0
				state = STATE_MESSAGELIST
			else
				state = STATE_VIEWMESSAGE
		if("status")
			state = STATE_STATUSDISPLAY
		if("securitylevel")
			tmp_alertlevel = text2num( href_list["newalertlevel"] )
			if(!tmp_alertlevel)
				tmp_alertlevel = 0
			state = STATE_CONFIRM_LEVEL
		if("changeseclevel")
			state = STATE_ALERT_LEVEL

		// Status display stuff
		if("setstat")
			// playsound(src, "terminal_type", 50, 0)
			switch(href_list["statdisp"])
				if("message")
					post_status("message", stat_msg1, stat_msg2)
				if("alert")
					post_status("alert", href_list["alert"])
				else
					post_status(href_list["statdisp"])

		if("setmsg1")
			stat_msg1 = reject_bad_text(sanitize(input("Line 1", "Enter Message Text", stat_msg1) as text|null, 40), 40)
			updateDialog()
		if("setmsg2")
			stat_msg2 = reject_bad_text(sanitize(input("Line 2", "Enter Message Text", stat_msg2) as text|null, 40), 40)
			updateDialog()

		// OMG CENTCOMM LETTERHEAD
		if("MessageCentCom")
			if(authenticated == 2)
				if(!checkCCcooldown())
					to_chat(usr, "<span class='warning'>Arrays recycling.  Please stand by.</span>")
					return
				var/input = stripped_input(usr, "Please choose a message to transmit to [GLOB.using_map.boss_short] via quantum entanglement.  Please be aware that this process is very expensive, and abuse will lead to... termination.  Transmission does not guarantee a response.", "Send a message to CentCom. There is a 30 second delay before you may send another message, be clear, full and concise.", "")
				if(!input || !(usr in view(1,src)) || !checkCCcooldown())
					return
				CentCom_announce(input, usr)
				to_chat(usr, "<span class='notice'>Message transmitted to [GLOB.using_map.boss_short].</span>")
				// for(var/client/X in GLOB.admins)
				// 	if(X.prefs.toggles & SOUND_ADMINHELP)
				// 		SEND_SOUND(X, sound('sound/effects/printer.ogg'))
				// 	window_flash(X, ignorepref = FALSE)
				log_game("[key_name(usr)] has made an IA [GLOB.using_map.boss_short] announcement: [input]")
				say_dead_direct("<span class='deadsay'><span class='name'>[usr.real_name]</span> has messaged [GLOB.using_map.boss_short], \"[input]\" at <span class='name'>[get_area_name(usr, TRUE)]</span>.</span>", usr)
				// deadchat_broadcast("<span class='deadsay'><span class='name'>[usr.real_name]</span> has messaged [GLOB.using_map.boss_short], \"[input]\" at <span class='name'>[get_area_name(usr, TRUE)]</span>.</span>", usr)
				CM.lastTimeUsed = world.time


		// OMG SYNDICATE ...LETTERHEAD
		if("MessageSyndicate")
			if(authenticated == 2 && emagged)
				if(!checkCCcooldown())
					to_chat(usr, "<span class='warning'>Arrays recycling.  Please stand by.</span>")
					// playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
					return
				var/input = stripped_input(usr, "Please choose a message to transmit to \[ABNORMAL ROUTING COORDINATES\] via quantum entanglement.  Please be aware that this process is very expensive, and abuse will lead to... termination. Transmission does not guarantee a response. There is a 30 second delay before you may send another message, be clear, full and concise.", "Send a message to /??????/.", "")
				if(!input || !(usr in view(1,src)) || !checkCCcooldown())
					return
				// playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)
				Syndicate_announce(input, usr)	//does the syndie exist on RP?
				to_chat(usr, "<span class='danger'>SYSERR @l(19833)of(transmit.dm): !@$ MESSAGE TRANSMITTED TO ?!?1//1? COMMAND.</span>")
				// for(var/client/X in GLOB.admins)
				// 	if(X.prefs.toggles & SOUND_ADMINHELP)
				// 		SEND_SOUND(X, sound('sound/effects/printer.ogg'))
				// 	window_flash(X, ignorepref = FALSE)
				log_game("[key_name(usr)] has made an illegal announcement: [input]")
				say_dead_direct("<span class='deadsay'><span class='name'>[usr.real_name]</span> has messaged the Syndicate, \"[input]\" at <span class='name'>[get_area_name(usr, TRUE)]</span>.</span>", usr)
				// deadchat_broadcast("<span class='deadsay'><span class='name'>[usr.real_name]</span> has messaged the Syndicate, \"[input]\" at <span class='name'>[get_area_name(usr, TRUE)]</span>.</span>", usr)
				CM.lastTimeUsed = world.time

		if("RestoreBackup")
			to_chat(usr, "<span class='notice'>Backup routing data restored!</span>")
			// playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)
			emagged = FALSE
			updateDialog()


		// AI interface
		if("ai-main")
			aicurrmsg = 0
			aistate = STATE_DEFAULT
		if("ai-callshuttle")
			aistate = STATE_CALLSHUTTLE
		if("ai-callshuttle2")
			call_shuttle_proc(usr)
			aistate = STATE_DEFAULT
		if("ai-messagelist")
			aicurrmsg = 0
			aistate = STATE_MESSAGELIST
		if("ai-viewmessage")
			aistate = STATE_VIEWMESSAGE
			if (!aicurrmsg)
				if(href_list["message-num"])
					aicurrmsg = text2num(href_list["message-num"])
				else
					aistate = STATE_MESSAGELIST
		if("ai-delmessage")
			aistate = aicurrmsg ? STATE_DELMESSAGE : STATE_MESSAGELIST
		if("ai-delmessage2")
			if(aicurrmsg)
				var/title = messagetitle[aicurrmsg]
				var/text  = messagetext[aicurrmsg]
				messagetitle.Remove(title)
				messagetext.Remove(text)
				if(currmsg == aicurrmsg)
					currmsg = 0
				aicurrmsg = 0
			aistate = STATE_MESSAGELIST
		if("ai-status")
			aistate = STATE_STATUSDISPLAY

	updateUsrDialog()

/obj/machinery/computer/communications/emag_act(remaining_charges, mob/user)
	. = ..()
	if(emagged)
		return FALSE
	emagged = TRUE
	to_chat(user, "You scramble the communication routing circuits!")
	// playsound(src, 'sound/machines/terminal_alert.ogg', 50, 0)
	return TRUE

/obj/machinery/computer/communications/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/computer/communications/attack_hand(mob/user)
	. = ..()
	if(!.)
		return
	// user.set_machine(src)
	if (GLOB.using_map && !(src.z in GLOB.using_map.contact_levels))
		to_chat(user, "<span class='boldannounce'>Unable to establish a connection</span>: You're too far away from the station!")
		return

	var/dat = ""
	if(SSemergencyshuttle.has_eta())
		var/timeleft = SSemergencyshuttle.estimate_arrival_time()
		dat += "<B>Emergency shuttle</B>\n<BR>\nETA: [timeleft / 60 % 60]:[add_zero(num2text(timeleft % 60), 2)]"

	var/datum/browser/popup = new(user, "communications", "Communications Console", 400, 500)
	// popup.set_title_image(user.browse_rsc_icon(icon, icon_state)) //no nice things!

	if(issilicon(user)) // || (hasSiliconAccessInArea(user) && !in_range(user,src))
		var/dat2 = interact_ai(user) // give the AI a different interact proc to limit its access
		if(dat2)
			dat +=  dat2
			popup.set_content(dat)
			popup.open()
		return

	switch(state)
		if(STATE_DEFAULT)
			if (authenticated)
				// if(SSshuttle.emergencyCallAmount)
				// 	if(SSshuttle.emergencyLastCallLoc)
				// 		dat += "Most recent shuttle call/recall traced to: <b>[format_text(SSshuttle.emergencyLastCallLoc.name)]</b><BR>"
				// 	else
				// 		dat += "Unable to trace most recent shuttle call/recall signal.<BR>"
				dat += "Logged in as: [auth_id]"
				dat += "<BR>"
				dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=logout'>Log Out</A> \]<BR>"
				dat += "<BR><B>General Functions</B>"
				dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=messagelist'>Message List</A> \]"
				dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=toggleatc'>[ATC.squelched ? "Enable" : "Disable"] ATC Relay</A> \]"
				if(SSemergencyshuttle.location())
					if (SSemergencyshuttle.online())
						dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=callshuttle'>Call Emergency Shuttle</A> \]"
					else
						dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=cancelshuttle'>Cancel Shuttle Call</A> \]"
				if(authenticated >= 1)
					dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=announce'>Make a Captain's Announcement</A> \]"

				dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=status'>Set Status Display</A> \]"
				if (authenticated == 2)
					dat += "<BR><BR><B>Captain Functions</B>"
					var/cross_servers_count = length(CONFIG_GET(keyed_list/cross_server))
					if(cross_servers_count)
						dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=crossserver'>Send a message to [cross_servers_count == 1 ? "an " : ""]allied station[cross_servers_count > 1 ? "s" : ""]</A> \]"
					// if(SSmapping.config.allow_custom_shuttles)
					// 	dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=purchase_menu'>Purchase Shuttle</A> \]"
					dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=changeseclevel'>Change Alert Level</A> \]"
					// dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=emergencyaccess'>Emergency Maintenance Access</A> \]"
					// dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=nukerequest'>Request Nuclear Authentication Codes</A> \]"
					if(!emagged)
						dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=MessageCentCom'>Send Message to [GLOB.using_map.boss_short]</A> \]"
					else
						dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=MessageSyndicate'>Send Message to \[UNKNOWN\]</A> \]"
						dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=RestoreBackup'>Restore Backup Routing Data</A> \]"
			else
				dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=login'>Log In</A> \]"
		if(STATE_CALLSHUTTLE)
			dat += "Are you sure you want to call the shuttle? "
			dat += "\[ <A HREF='?src=[REF(src)];operation=callshuttle2'>OK</A> | <A HREF='?src=[REF(src)];operation=main'>Cancel</A> \]" //get_call_shuttle_form()
			// playsound(src, 'sound/machines/terminal_prompt.ogg', 50, 0)
		if(STATE_CANCELSHUTTLE)
			dat += "Are you sure you want to cancel the shuttle? "
			dat += "\[ <A HREF='?src=[REF(src)];operation=cancelshuttle2'>OK</A> | <A HREF='?src=[REF(src)];operation=main'>Cancel</A> \]" //get_cancel_shuttle_form()
			// playsound(src, 'sound/machines/terminal_prompt.ogg', 50, 0)
		if(STATE_MESSAGELIST)
			dat += "Messages:"
			for(var/i in 1 to messagetitle.len)
				dat += "<BR><A HREF='?src=[REF(src)];operation=viewmessage;message-num=[i]'>[messagetitle[i]]</A>"
			// playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)
		if(STATE_VIEWMESSAGE)
			if (currmsg)
				dat += "<B>[messagetitle[currmsg]]</B><BR><BR>[messagetext[currmsg]]"
				// if(!currmsg.answered && currmsg.possible_answers.len) //this is for pirate ransoms over tg.
				// 	for(var/i in 1 to currmsg.possible_answers.len)
				// 		var/answer = currmsg.possible_answers[i]
				// 		dat += "<br>\[ <A HREF='?src=[REF(src)];operation=respond;answer=[i]'>Answer : [answer]</A> \]"
				// else if(currmsg.answered)
				// 	var/answered = currmsg.possible_answers[currmsg.answered]
				// 	dat += "<br> Archived Answer : [answered]"
				dat += "<BR><BR>\[ <A HREF='?src=[REF(src)];operation=delmessage'>Delete</A> \]"
			else
				aistate = STATE_MESSAGELIST
				attack_hand(user)
				return
		if(STATE_DELMESSAGE)
			if (currmsg)
				dat += "Are you sure you want to delete this message? \[ <A HREF='?src=[REF(src)];operation=delmessage2'>OK</A> | <A HREF='?src=[REF(src)];operation=viewmessage'>Cancel</A> \]"
			else
				state = STATE_MESSAGELIST
				attack_hand(user)
				return
		if(STATE_STATUSDISPLAY)
			dat += "Set Status Displays<BR>"
			dat += "\[ <A HREF='?src=[REF(src)];operation=setstat;statdisp=blank'>Clear</A> \]<BR>"
			dat += "\[ <A HREF='?src=[REF(src)];operation=setstat;statdisp=time'>Station Time</A> \]<BR>"
			dat += "\[ <A HREF='?src=[REF(src)];operation=setstat;statdisp=shuttle'>Shuttle ETA</A> \]<BR>"
			dat += "\[ <A HREF='?src=[REF(src)];operation=setstat;statdisp=message'>Message</A> \]"
			dat += "<ul><li> Line 1: <A HREF='?src=[REF(src)];operation=setmsg1'>[ stat_msg1 ? stat_msg1 : "(none)"]</A>"
			dat += "<li> Line 2: <A HREF='?src=[REF(src)];operation=setmsg2'>[ stat_msg2 ? stat_msg2 : "(none)"]</A></ul><br>"
			dat += "\[ Alert: <A HREF='?src=[REF(src)];operation=setstat;statdisp=alert;alert=default'>None</A> |"
			dat += " <A HREF='?src=[REF(src)];operation=setstat;statdisp=alert;alert=redalert'>Red Alert</A> |"
			dat += " <A HREF='?src=[REF(src)];operation=setstat;statdisp=alert;alert=lockdown'>Lockdown</A> |"
			dat += " <A HREF='?src=[REF(src)];operation=setstat;statdisp=alert;alert=biohazard'>Biohazard</A> \]<BR><HR>"
			// playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)
		if(STATE_ALERT_LEVEL)
			dat += "Current alert level: [get_security_level()]<BR>"
			if(security_level == SEC_LEVEL_DELTA)
				dat += "<span class='warning'><b>The self-destruct mechanism is active. Find a way to deactivate the mechanism to lower the alert level or evacuate.</b></span>"
			else
				dat += "<A HREF='?src=[REF(src)];operation=securitylevel;newalertlevel=[SEC_LEVEL_BLUE]'>Blue</A><BR>"
				dat += "<A HREF='?src=[REF(src)];operation=securitylevel;newalertlevel=[SEC_LEVEL_ORANGE]'>Orange</A><BR>"
				dat += "<A HREF='?src=[REF(src)];operation=securitylevel;newalertlevel=[SEC_LEVEL_VIOLET]'>Violet</A><BR>"
				dat += "<A HREF='?src=[REF(src)];operation=securitylevel;newalertlevel=[SEC_LEVEL_YELLOW]'>Yellow</A><BR>"
				dat += "<A HREF='?src=[REF(src)];operation=securitylevel;newalertlevel=[SEC_LEVEL_GREEN]'>Green</A>"
		if(STATE_CONFIRM_LEVEL)
			dat += "Current alert level: [get_security_level()]<BR>"
			dat += "Confirm the change to: [num2seclevel(tmp_alertlevel)]<BR>"
			dat += "<A HREF='?src=[REF(src)];operation=swipeidseclevel'>OK</A> to confirm change.<BR>" //Swipe ID

	dat += "<BR><BR>\[ [(state != STATE_DEFAULT) ? "<A HREF='?src=[REF(src)];operation=main'>Main Menu</A> | " : ""]<A HREF='?src=[REF(user)];mach_close=communications'>Close</A> \]"

	popup.set_content(dat)
	popup.open()

/obj/machinery/computer/communications/proc/interact_ai(mob/living/silicon/ai/user)
	var/dat = ""
	switch(aistate)
		if(STATE_DEFAULT)
			// if(SSshuttle.emergencyCallAmount)
			// 	if(SSshuttle.emergencyLastCallLoc)
			// 		dat += "Latest emergency signal trace attempt successful.<BR>Last signal origin: <b>[format_text(SSshuttle.emergencyLastCallLoc.name)]</b>.<BR>"
			// 	else
			// 		dat += "Latest emergency signal trace attempt failed.<BR>"
			if(authenticated)
				dat += "Current login: [auth_id]"
			else
				dat += "Current login: None"
			dat += "<BR><BR><B>General Functions</B>"
			dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=ai-messagelist'>Message List</A> \]"
			if(SSemergencyshuttle.location() && !SSemergencyshuttle.online())
				dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=ai-callshuttle'>Call Emergency Shuttle</A> \]"
			dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=ai-status'>Set Status Display</A> \]"
			dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=toggleatc'>[ATC.squelched ? "Enable" : "Disable"] ATC Relay</A> \]"
			// dat += "<BR><BR><B>Special Functions</B>"
			// dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=ai-announce'>Make an Announcement</A> \]"
			// dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=ai-changeseclevel'>Change Alert Level</A> \]"
			// dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=ai-emergencyaccess'>Emergency Maintenance Access</A> \]"
		if(STATE_CALLSHUTTLE)
			dat += "Are you sure you want to call the shuttle?" //get_call_shuttle_form(TRUE)
			dat += " \[ <A HREF='?src=[REF(src)];operation=ai-callshuttle2'>OK</A> | <A HREF='?src=[REF(src)];operation=ai-main'>Cancel</A> \]"
		if(STATE_MESSAGELIST)
			dat += "Messages:"
			for(var/i in 1 to messagetitle.len)
				dat += "<BR><A HREF='?src=[REF(src)];operation=ai-viewmessage;message-num=[i]'>[messagetitle[i]]</A>"
		if(STATE_VIEWMESSAGE)
			if (aicurrmsg)
				dat += "<B>[messagetitle[aicurrmsg]]</B><BR><BR>[messagetext[aicurrmsg]]"
				// if(!aicurrmsg.answered && aicurrmsg.possible_answers.len)
				// 	for(var/i in 1 to aicurrmsg.possible_answers.len)
				// 		var/answer = aicurrmsg.possible_answers[i]
				// 		dat += "<br>\[ <A HREF='?src=[REF(src)];operation=ai-respond;answer=[i]'>Answer : [answer]</A> \]"
				// else if(aicurrmsg.answered)
				// 	var/answered = aicurrmsg.possible_answers[aicurrmsg.answered]
				// 	dat += "<br> Archived Answer : [answered]"
				// dat += "<BR><BR>\[ <A HREF='?src=[REF(src)];operation=ai-delmessage'>Delete</A> \]"
			else
				aistate = STATE_MESSAGELIST
				attack_hand(user)
				return null
		if(STATE_DELMESSAGE)
			if(aicurrmsg)
				dat += "Are you sure you want to delete this message? \[ <A HREF='?src=[REF(src)];operation=ai-delmessage2'>OK</A> | <A HREF='?src=[REF(src)];operation=ai-viewmessage'>Cancel</A> \]"
			else
				aistate = STATE_MESSAGELIST
				attack_hand(user)
				return

		if(STATE_STATUSDISPLAY)
			dat += "Set Status Displays<BR>"
			dat += "\[ <A HREF='?src=[REF(src)];operation=setstat;statdisp=blank'>Clear</A> \]<BR>"
			dat += "\[ <A HREF='?src=[REF(src)];operation=setstat;statdisp=time'>Station Time</A> \]<BR>"
			dat += "\[ <A HREF='?src=[REF(src)];operation=setstat;statdisp=shuttle'>Shuttle ETA</A> \]<BR>"
			dat += "\[ <A HREF='?src=[REF(src)];operation=setstat;statdisp=message'>Message</A> \]"
			dat += "<ul><li> Line 1: <A HREF='?src=[REF(src)];operation=setmsg1'>[ stat_msg1 ? stat_msg1 : "(none)"]</A>"
			dat += "<li> Line 2: <A HREF='?src=[REF(src)];operation=setmsg2'>[ stat_msg2 ? stat_msg2 : "(none)"]</A></ul><br>"
			dat += "\[ Alert: <A HREF='?src=[REF(src)];operation=setstat;statdisp=alert;alert=default'>None</A> |"
			dat += " <A HREF='?src=[REF(src)];operation=setstat;statdisp=alert;alert=redalert'>Red Alert</A> |"
			dat += " <A HREF='?src=[REF(src)];operation=setstat;statdisp=alert;alert=lockdown'>Lockdown</A> |"
			dat += " <A HREF='?src=[REF(src)];operation=setstat;statdisp=alert;alert=biohazard'>Biohazard</A> \]<BR><HR>"


	dat += "<BR><BR>\[ [(aistate != STATE_DEFAULT) ? "<A HREF='?src=[REF(src)];operation=ai-main'>Main Menu</A> | " : ""]<A HREF='?src=[REF(user)];mach_close=communications'>Close</A> \]"
	return dat

/obj/machinery/computer/communications/proc/make_announcement(mob/living/user, is_silicon)
	if(message_cooldown) //!SScommunications.can_announce(user, is_silicon)
		to_chat(user, "Intercomms recharging. Please stand by.")
		return
	var/input = stripped_input(user, "Please write a message to announce to the station crew.", "What?")
	if(!input || !(usr in view(1,src))) //!user.canUseTopic(src))
		return
	// SScommunications.make_announcement(user, is_silicon, input)
	crew_announcement.announcer = auth_id
	crew_announcement.Announce(input)
	say_dead_direct("<span class='deadsay'><span class='name'>[user.real_name]</span> made an priority announcement from <span class='name'>[get_area_name(usr, TRUE)]</span>.</span>", user)
	// deadchat_broadcast("<span class='deadsay'><span class='name'>[user.real_name]</span> made an priority announcement from <span class='name'>[get_area_name(usr, TRUE)]</span>.</span>", user)

/obj/machinery/computer/communications/proc/post_status(command, data1, data2)
	var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435) //SSradio.return_frequency(FREQ_STATUS_DISPLAYS)

	if(!frequency)
		return

	var/datum/signal/status_signal = new //(list("command" = command))
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command
	switch(command)
		if("message")
			status_signal.data["msg1"] = data1
			status_signal.data["msg2"] = data2
			log_admin("STATUS: [src.fingerprintslast] set status screen message with [src]: [data1] [data2]")
		if("alert")
			status_signal.data["picture_state"] = data1

	frequency.post_signal(src, status_signal)

/proc/enable_prison_shuttle(mob/user)
	for(var/obj/machinery/computer/prison_shuttle/PS in machines)
		PS.allowedtocall = !PS.allowedtocall

/proc/call_shuttle_proc(mob/user)
	if(!SSticker || !SSemergencyshuttle || !SSemergencyshuttle.location())
		return

	if(!universe.OnShuttleCall(usr))
		to_chat(user, "<span class='notice'>Cannot establish a bluespace connection.</span>")
		return

	if(deathsquad.deployed)
		to_chat(user, "[GLOB.using_map.boss_short] will not allow the shuttle to be called. Consider all contracts terminated.")
		return

	if(SSemergencyshuttle.deny_shuttle)
		to_chat(user, "The emergency shuttle may not be sent at this time. Please try again later.")
		return

	if(world.time < (10 MINUTES)) // Ten minute grace period to let the game get going without people speedruning central any%
		to_chat(user, "The emergency shuttle is refueling. Please wait another [DisplayTimeText((10 MINUTES) - (world.time - SSticker.round_start_time))] before trying again.")
		return

	if(SSemergencyshuttle.going_to_centcom())
		to_chat(user, "The emergency shuttle may not be called while returning to [GLOB.using_map.boss_short].")
		return

	if(SSemergencyshuttle.online())
		to_chat(user, "The emergency shuttle is already on its way.")
		return

	if(SSticker.mode.name == "blob")
		to_chat(user, "Under directive 7-10, [station_name()] is quarantined until further notice.")
		return

	SSemergencyshuttle.call_evac()
	log_game("[key_name(user)] has called the shuttle.")
	message_admins("[ADMIN_LOOKUPFLW(user)] has called the shuttle.") // (<A HREF='?_src_=holder;[HrefToken()];trigger_centcom_recall=1'>TRIGGER [uppertext(GLOB.using_map.boss_short)] RECALL</A>)
	admin_chat_message(message = "Emergency evac beginning! Called by [key_name(user)]!", color = "#CC2222") //VOREStation Add
	return

/proc/init_shift_change(mob/user, force = FALSE)
	if(!SSticker || !SSemergencyshuttle || !SSemergencyshuttle.location())
		return

	if(SSemergencyshuttle.going_to_centcom())
		to_chat(user, "The shuttle may not be called while returning to [GLOB.using_map.boss_short].")
		return

	if(SSemergencyshuttle.online())
		to_chat(user, "The shuttle is already on its way.")
		return

	// if force is 0, some things may stop the shuttle call
	if(!force)
		if(SSemergencyshuttle.deny_shuttle)
			to_chat(user, "[GLOB.using_map.boss_short] does not currently have a shuttle available in your sector. Please try again later.")
			return

		if(deathsquad.deployed == 1)
			to_chat(user, "[GLOB.using_map.boss_short] will not allow the shuttle to be called. Consider all contracts terminated.")
			return
				//this is 90 minutes (1.5 HOURS)
		if(world.time < (1.5 HOURS))
			to_chat(user, "The shuttle is refueling. Please wait another [DisplayTimeText((1.5 HOURS) - (world.time - SSticker.round_start_time))] before trying again.")
			return

		if(SSticker.mode.auto_recall_shuttle)
			//New version pretends to call the shuttle but cause the shuttle to return after a random duration.
			SSemergencyshuttle.auto_recall = TRUE

		if(SSticker.mode.name == "blob" || SSticker.mode.name == "epidemic")
			to_chat(user, "Under directive 7-10, [station_name()] is quarantined until further notice.")
			return

	SSemergencyshuttle.call_transfer()

	//delay events in case of an autotransfer
	if (isnull(user))
		SSevents.delay_events(EVENT_LEVEL_MODERATE, 15 MINUTES)
		SSevents.delay_events(EVENT_LEVEL_MAJOR, 15 MINUTES)

	log_game("[user? key_name(user) : "Autotransfer"] has called the shuttle.")
	message_admins("[user? ADMIN_LOOKUPFLW(user) : "Autotransfer"] has called the shuttle.")
	admin_chat_message("Autotransfer shuttle dispatched, shift ending soon.", "#2277BB") //TGS Magic?
	return

/proc/cancel_call_proc(mob/user)
	if(!SSticker || !SSemergencyshuttle || !SSemergencyshuttle.can_recall())
		return
	if(SSticker.mode.name == "blob" || SSticker.mode.name == "Meteor")
		return

	if(!SSemergencyshuttle.going_to_centcom()) //check that shuttle isn't already heading to CentCom
		SSemergencyshuttle.recall()
		log_game("[key_name(user)] has recalled the shuttle.")
		message_admins("[ADMIN_LOOKUPFLW(user)] has recalled the shuttle.")
	return

/proc/is_relay_online()
    for(var/obj/machinery/telecomms/relay/M in telecomms_list)
        if(M.stat == CONSCIOUS) //yes, the machine is alive(0)
            return TRUE
    return FALSE

