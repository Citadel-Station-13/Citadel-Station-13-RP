/datum/tgui_module/supply_system
	tgui_id = "TGUISupplySystem"

/datum/tgui_module/supply_system/New(datum/host, datum/supply_system/system)
	. = ..()


/datum/tgui_module/supply_system/data(mob/user, ...)
	. = ..()

/datum/tgui_module/supply_system/static_data(mob/user, ...)
	. = ..()


/datum/tgui_module/supply_system/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/datum/tgui_module/supply_system/console
	expected_type = /obj/machinery/computer/supplycomp
