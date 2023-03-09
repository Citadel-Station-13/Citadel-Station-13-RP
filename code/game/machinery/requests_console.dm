/******************** Requests Console ********************/
/** Originally written by errorage, updated by: Carn, needs more work though. I just added some security fixes */

//Request Console Department Types
///Request Assistance
#define RC_ASSIST 1
///Request Supplies
#define RC_SUPPLY 2
///Relay Info
#define RC_INFO   4
//Request Console Screens
/// Main menu
#define RCS_MAINMENU 0
/// Request supplies
#define RCS_RQASSIST 1
/// Request assistance
#define RCS_RQSUPPLY 2
/// Relay information
#define RCS_SENDINFO 3
/// Message sent successfully
#define RCS_SENTPASS 4
/// Message sent unsuccessfully
#define RCS_SENTFAIL 5
/// View messages
#define RCS_VIEWMSGS 6
/// Authentication before sending
#define RCS_MESSAUTH 7
/// Send announcement
#define RCS_ANNOUNCE 8
var/req_console_assistance = list()
var/req_console_supplies = list()
var/req_console_information = list()
var/list/obj/machinery/requests_console/allConsoles = list()

/obj/machinery/requests_console
	name = "requests console"
	desc = "A console intended to send requests to different departments on the station."
	anchored = TRUE
	icon = 'icons/obj/terminals.dmi'
	icon_state = "req_comp0"
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	circuit = /obj/item/circuitboard/request

	/// The list of all departments on the station. (Determined from this variable on each unit)
	/// Set this to the same thing if you want several consoles in one department.
	var/department = "Unknown"
	/// List of all messages.
	var/list/message_log = list()
	/// Bitflag. Zero is reply-only. Map currently uses raw numbers instead of defines.
	var/departmentType = 0
	/// New Message Priority: 0 for no new messages, 1 for normal priority, 2 for high priority.
	var/newmessagepriority = 0

	var/screen = RCS_MAINMENU
	/// set to TRUE for it not to beep all the time.
	var/silent = FALSE
	/// Whether if's hacked or not.
//	var/hackState = FALSE
	/// Can this console be used to send department annoucements?
	var/announcementConsole = FALSE
	var/open = FALSE
	/// Will be set to 1 when you authenticate yourself for announcements.
	var/announceAuth = 0
	/// Will contain the name of the person who varified it.
	var/msgVerified = ""
	/// If a message is stamped, this will contain the stamp name.
	var/msgStamped = ""
	var/message = "";
	/// The department which will be receiving the message.
	var/recipient = "";
	/// Priority of the message being sent.
	var/priority = -1 ;
	light_range = 0
	var/datum/legacy_announcement/announcement = new

/obj/machinery/requests_console/power_change()
	..()
	update_icon()

/obj/machinery/requests_console/update_icon()
	if(machine_stat & NOPOWER)
		if(icon_state != "req_comp_off")
			icon_state = "req_comp_off"
	else
		if(icon_state == "req_comp_off")
			icon_state = "req_comp[newmessagepriority]"

/obj/machinery/requests_console/Initialize(mapload, newdir)
	. = ..()

	announcement.title = "[department] announcement"
	announcement.newscast = 1

	name = "[department] requests console"
	allConsoles += src
	if(departmentType & RC_ASSIST)
		req_console_assistance |= department
	if(departmentType & RC_SUPPLY)
		req_console_supplies |= department
	if(departmentType & RC_INFO)
		req_console_information |= department

	set_light(1)

/obj/machinery/requests_console/Destroy()
	allConsoles -= src
	var/lastDeptRC = 1
	for (var/obj/machinery/requests_console/Console in allConsoles)
		if(Console.department == department)
			lastDeptRC = 0
			break
	if(lastDeptRC)
		if(departmentType & RC_ASSIST)
			req_console_assistance -= department
		if(departmentType & RC_SUPPLY)
			req_console_supplies -= department
		if(departmentType & RC_INFO)
			req_console_information -= department
	return ..()

/obj/machinery/requests_console/attack_hand(user as mob)
	if(..(user))
		return
	nano_ui_interact(user)

/obj/machinery/requests_console/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data["department"] = department
	data["screen"] = screen
	data["message_log"] = message_log
	data["newmessagepriority"] = newmessagepriority
	data["silent"] = silent
	data["announcementConsole"] = announcementConsole

	data["assist_dept"] = req_console_assistance
	data["supply_dept"] = req_console_supplies
	data["info_dept"]   = req_console_information

	data["message"] = message
	data["recipient"] = recipient
	data["priortiy"] = priority
	data["msgStamped"] = msgStamped
	data["msgVerified"] = msgVerified
	data["announceAuth"] = announceAuth

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "request_console.tmpl", "[department] Request Console", 520, 410)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/requests_console/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)

	if(reject_bad_text(href_list["write"]))
		recipient = href_list["write"] //write contains the string of the receiving department's name

		var/new_message = sanitize(input("Write your message:", "Awaiting Input", ""))
		if(new_message)
			message = new_message
			screen = RCS_MESSAUTH
			switch(href_list["priority"])
				if("1") priority = 1
				if("2")	priority = 2
				else	priority = 0
		else
			reset_message(1)

	if(href_list["writeAnnouncement"])
		var/new_message = sanitize(input("Write your message:", "Awaiting Input", ""))
		if(new_message)
			message = new_message
		else
			reset_message(1)

	if(href_list["sendAnnouncement"])
		if(!announcementConsole)	return
		announcement.Announce(message, msg_sanitized = 1)
		reset_message(1)

	if(href_list["department"] && message)
		var/log_msg = message
		var/pass = 0
		screen = RCS_SENTFAIL
		for (var/obj/machinery/message_server/MS in GLOB.machines)
			if(!MS.active) continue
			MS.send_rc_message(ckey(href_list["department"]),department,log_msg,msgStamped,msgVerified,priority)
			pass = 1
		if(pass)
			screen = RCS_SENTPASS
			message_log += "<B>Message sent to [recipient]</B><BR>[message]"
		else
			audible_message(text("[icon2html(thing = src, target = world)] *The Requests Console beeps: 'NOTICE: No server detected!'"),,4)

	//Handle printing
	if (href_list["print"])
		var/msg = message_log[text2num(href_list["print"])];
		if(msg)
			msg = replacetext(msg, "<BR>", "\n")
			msg = strip_html_properly(msg)
			var/obj/item/paper/R = new(src.loc)
			R.name = "[department] Message"
			R.info = "<H3>[department] Requests Console</H3><div>[msg]</div>"

	//Handle screen switching
	if(href_list["setScreen"])
		var/tempScreen = text2num(href_list["setScreen"])
		if(tempScreen == RCS_ANNOUNCE && !announcementConsole)
			return
		if(tempScreen == RCS_VIEWMSGS)
			for (var/obj/machinery/requests_console/Console in allConsoles)
				if(Console.department == department)
					Console.newmessagepriority = 0
					Console.icon_state = "req_comp0"
					Console.set_light(1)
		if(tempScreen == RCS_MAINMENU)
			reset_message()
		screen = tempScreen

	//Handle silencing the console
	if(href_list["toggleSilent"])
		silent = !silent

	updateUsrDialog()
	return

					//err... hacking code, which has no reason for existing... but anyway... it was once supposed to unlock priority 3 messaging on that console (EXTREME priority...), but the code for that was removed.
/obj/machinery/requests_console/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(computer_deconstruction_screwdriver(user, O))
		return
	if(istype(O, /obj/item/multitool))
		var/input = sanitize(input(usr, "What Department ID would you like to give this request console?", "Multitool-Request Console Interface", department))
		if(!input)
			to_chat(usr, "No input found. Please hang up and try your call again.")
			return
		department = input
		announcement.title = "[department] announcement"
		announcement.newscast = 1

		name = "[department] Requests Console"
		allConsoles += src
		if(departmentType & RC_ASSIST)
			req_console_assistance |= department
		if(departmentType & RC_SUPPLY)
			req_console_supplies |= department
		if(departmentType & RC_INFO)
			req_console_information |= department
		return

	if(istype(O, /obj/item/card/id))
		if(inoperable(MAINT)) return
		if(screen == RCS_MESSAUTH)
			var/obj/item/card/id/T = O
			msgVerified = text("<font color='green'><b>Verified by [T.registered_name] ([T.assignment])</b></font>")
			updateUsrDialog()
		if(screen == RCS_ANNOUNCE)
			var/obj/item/card/id/ID = O
			if(ACCESS_COMMAND_ANNOUNCE in ID.GetAccess())
				announceAuth = 1
				announcement.announcer = ID.assignment ? "[ID.assignment] [ID.registered_name]" : ID.registered_name
			else
				reset_message()
				to_chat(user, "<span class='warning'>You are not authorized to send announcements.</span>")
			updateUsrDialog()
	if(istype(O, /obj/item/stamp))
		if(inoperable(MAINT)) return
		if(screen == RCS_MESSAUTH)
			var/obj/item/stamp/T = O
			msgStamped = text("<font color=#4F49AF><b>Stamped with the [T.name]</b></font>")
			updateUsrDialog()
	return

/obj/machinery/requests_console/proc/reset_message(var/mainmenu = 0)
	message = ""
	recipient = ""
	priority = 0
	msgVerified = ""
	msgStamped = ""
	announceAuth = 0
	announcement.announcer = ""
	if(mainmenu)
		screen = RCS_MAINMENU


//! ## VR FILE MERGE ## !//

// Request Console Presets!  Make mapping 400% easier!
// By using these presets we can rename the departments easily.

//!Request Console Department Types
///Request Assistance
// #define RC_ASSIST 1
///Request Supplies
// #define RC_SUPPLY 2
///Relay Info
// #define RC_INFO   4

/obj/machinery/requests_console/preset
	name = ""
	department = ""
	departmentType = ""
	announcementConsole = 0

// Departments
/obj/machinery/requests_console/preset/cargo
	name = "Cargo RC"
	department = "Cargo Bay"
	departmentType = RC_SUPPLY

/obj/machinery/requests_console/preset/security
	name = "Security RC"
	department = "Security"
	departmentType = RC_ASSIST

/obj/machinery/requests_console/preset/engineering
	name = "Engineering RC"
	department = "Engineering"
	departmentType = RC_ASSIST|RC_SUPPLY

/obj/machinery/requests_console/preset/atmos
	name = "Atmospherics RC"
	department = "Atmospherics"
	departmentType = RC_ASSIST|RC_SUPPLY

/obj/machinery/requests_console/preset/medical
	name = "Medical RC"
	department = "Medical Department"
	departmentType = RC_ASSIST|RC_SUPPLY

/obj/machinery/requests_console/preset/research
	name = "Research RC"
	department = "Research Department"
	departmentType = RC_ASSIST|RC_SUPPLY

/obj/machinery/requests_console/preset/janitor
	name = "Janitor RC"
	department = "Janitorial"
	departmentType = RC_ASSIST

/obj/machinery/requests_console/preset/bridge
	name = "Bridge RC"
	department = "Bridge"
	departmentType = RC_ASSIST|RC_INFO
	announcementConsole = 1

// Heads

/obj/machinery/requests_console/preset/ce
	name = "Chief Engineer RC"
	department = "Chief Engineer's Desk"
	departmentType = RC_ASSIST|RC_INFO
	announcementConsole = 1

/obj/machinery/requests_console/preset/cmo
	name = "Chief Medical Officer RC"
	department = "Chief Medical Officer's Desk"
	departmentType = RC_ASSIST|RC_INFO
	announcementConsole = 1

/obj/machinery/requests_console/preset/hos
	name = "Head of Security RC"
	department = "Head of Security's Desk"
	departmentType = RC_ASSIST|RC_INFO
	announcementConsole = 1

/obj/machinery/requests_console/preset/rd
	name = "Research Director RC"
	department = "Research Director's Desk"
	departmentType = RC_ASSIST|RC_INFO
	announcementConsole = 1

/obj/machinery/requests_console/preset/captain
	name = "Captain RC"
	department = "Captain's Desk"
	departmentType = RC_ASSIST|RC_INFO
	announcementConsole = 1

/obj/machinery/requests_console/preset/ai
	name = "AI RC"
	department = "AI"
	departmentType = RC_ASSIST|RC_INFO
