/datum/tgui_module/card_mod
	tgui_id = "UICardMod"

/datum/tgui_module/card_mod/admin
	ephemeral = TRUE
	autodel = TRUE
	expected_type = /obj/item/card/id

/datum/tgui_module/card_mod/admin/ui_state(mob/user, datum/tgui_module/module)
	return GLOB.admin_state

#warn impl
