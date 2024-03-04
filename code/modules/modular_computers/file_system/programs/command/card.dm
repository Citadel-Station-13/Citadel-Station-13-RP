/datum/computer_file/program/card_mod
	filename = "plexagonidwriter"
	filedesc = "Plexagon Access Management"
	category = PROGRAM_CATEGORY_CREW
	program_icon_state = "id"
	extended_desc = "Program for programming employee ID cards to access parts of the station."
	transfer_access = ACCESS_COMMAND_CARDMOD
	requires_ntnet = 0
	size = 8
	tgui_id = "NtosCard"
	program_icon = "id-card"

	var/is_centcom = FALSE

	#warn depricate this
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
			return tgui_cardmod.ui_act(action, params, ui)

#warn FIXME
// /datum/computer_file/program/card_mod/ui_pre_open(datum/tgui/ui)
// 	ui.register_module(tgui_cardmod, "modify")

