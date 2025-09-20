/datum/computer_file/program/card_mod
	filename = "cardmod"
	filedesc = "ID card modification program"
	tgui_id = "NtosIdentificationComputer"
	program_icon_state = "id"
	program_key_state = "id_key"
	program_menu_icon = "key"
	extended_desc = "Program for programming crew ID cards."
	required_access = ACCESS_COMMAND_CARDMOD
	requires_ntnet = 0
	size = 8
	var/datum/tgui_module/card_mod/standard/id_computer/ntos/tgui_cardmod

/datum/computer_file/program/card_mod/New()
	tgui_cardmod = new(src)

/datum/computer_file/program/card_mod/Destroy()
	. = ..()
	QDEL_NULL(tgui_cardmod)

/datum/computer_file/program/card_mod/ui_static_data(mob/user, datum/tgui/ui)
	. = get_header_data()

/datum/computer_file/program/card_mod/ui_route(action, list/params, datum/tgui/ui, id)
	. = ..()
	if(.)
		return
	switch(id)
		if("modify")
			return tgui_cardmod.ui_act(action, params, ui, ui.state, new /datum/event_args/actor(usr))

/datum/computer_file/program/card_mod/ui_pre_open(datum/tgui/ui)
	ui.register_module(tgui_cardmod, "modify")
	return ..()
