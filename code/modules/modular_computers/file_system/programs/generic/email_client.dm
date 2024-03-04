/datum/computer_file/program/email_client
	filename = "emailc"
	filedesc = "Email Client"
	extended_desc = "This program may be used to log in into your email account."
	program_icon_state = "generic"
	size = 7
	requires_ntnet = TRUE
	requires_ntnet_feature = NTNET_COMMUNICATION // duh
	available_on_ntnet = 1
	tgui_id = "NtosEmailClient"

	var/stored_login = ""
	var/stored_password = ""

	var/msg_title = ""
	var/msg_body = ""
	var/msg_recipient = ""
	var/datum/computer_file/msg_attachment = null
	var/folder = "Inbox"
	var/addressbook = FALSE
	var/new_message = FALSE

	var/last_message_count = 0	// How many messages were there during last check.
	var/read_message_count = 0	// How many messages were there when user has last accessed the UI.

	var/datum/computer_file/downloading = null
	var/download_progress = 0
	var/download_speed = 0

	var/datum/computer_file/data/email_account/current_account = null
	var/datum/computer_file/data/email_message/current_message = null

	// tguimodule_path = /datum/tgui_module_old/email_client

// Persistency. Unless you log out, or unless your password changes, this will pre-fill the login data when restarting the program
/datum/computer_file/program/email_client/kill_program()
	if(TM)
		var/datum/tgui_module_old/email_client/TME = TM
		if(TME.current_account)
			stored_login = TME.stored_login
			stored_password = TME.stored_password
		else
			stored_login = ""
			stored_password = ""
	. = ..()

/datum/computer_file/program/email_client/run_program()
	. = ..()
	if(TM)
		var/datum/tgui_module_old/email_client/TME = TM
		TME.stored_login = stored_login
		TME.stored_password = stored_password
		TME.log_in()
		TME.error = ""
		TME.check_for_new_messages(TRUE)

/datum/computer_file/program/email_client/proc/new_mail_notify()
	var/turf/T = get_turf(computer) // Because visible_message is being a butt
	if(T)
		T.visible_message("<span class='notice'>[computer] beeps softly, indicating a new email has been received.</span>")
	playsound(computer, 'sound/misc/server-ready.ogg', 100, 0)

/datum/computer_file/program/email_client/process_tick()
	..()
	var/datum/tgui_module_old/email_client/TME = TM
	if(!istype(TME))
		return
	TME.relayed_process(ntnet_speed)

	var/check_count = TME.check_for_new_messages()
	if(check_count)
		if(check_count == NTOS_EMAIL_NEWMESSAGE)
			new_mail_notify()
		ui_header = "ntnrc_new.gif"
	else
		ui_header = "ntnrc_idle.gif"
