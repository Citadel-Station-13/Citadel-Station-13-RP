/datum/computer_file/program/card_mod
	filename = "cardmod"
	filedesc = "ID card modification program"
	tguimodule_path = /datum/tgui_module/card_mod/standard/id_computer/ntos
	program_icon_state = "id"
	program_key_state = "id_key"
	program_menu_icon = "key"
	extended_desc = "Program for programming crew ID cards."
	required_access = ACCESS_COMMAND_CARDMOD
	requires_ntnet = 0
	size = 8
	var/datum/tgui_module/card_mod/standard/id_computer/ntos/new_module

/datum/computer_file/program/card_mod/run_program(var/mob/living/user)
	if(can_run(user, 1) || !requires_access_to_run)
		computer.active_program = src
		if(tguimodule_path)
			new_module = new tguimodule_path(src)
		if(requires_ntnet && network_destination)
			generate_network_log("Connection opened to [network_destination].")
		program_state = PROGRAM_STATE_ACTIVE
		return 1
	return 0

// Use this proc to kill the program. Designed to be implemented by each program if it requires on-quit logic, such as the NTNRC client.
/datum/computer_file/program/card_mod/kill_program(var/forced = 0)
	program_state = PROGRAM_STATE_KILLED
	if(network_destination)
		generate_network_log("Connection to [network_destination] closed.")
	if(new_module)
		SStgui.close_uis(new_module)
	QDEL_NULL(new_module)
	return 1

/datum/computer_file/program/card_mod/ui_interact(mob/user, datum/tgui/ui)
	if(program_state != PROGRAM_STATE_ACTIVE)
		if(ui)
			ui.close()
		return computer.ui_interact(user)
	if(istype(new_module))
		new_module.ui_interact(user)
		return 0
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui && tgui_id)
		ui = new(user, src, tgui_id, filedesc)
		ui.open()
	return 1
