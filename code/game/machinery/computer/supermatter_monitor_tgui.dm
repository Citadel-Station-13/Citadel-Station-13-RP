/obj/item/circuitboard/sm_monitor
	name = "\improper Supermatter Monitor Computer Circuitboard"
	build_path = /obj/machinery/computer/sm_monitor

/obj/machinery/computer/sm_monitor
	name = "\improper Supermatter Monitor Computer"//cool, isnt it?
	desc = "Allows to monitor nearby Supermatter crystals."
	icon_keyboard = "generic_key"
	icon_screen = "smmon_0"
	light_color = "#00b000"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/sm_monitor
	req_access = list()
	var/datum/tgui_module/supermatter_monitor/sm_monitor

/obj/machinery/computer/sm_monitor/attack_ai(mob/user)
	ui_interact(user)

/obj/machinery/computer/sm_monitor/attack_hand(mob/user)
	if(..())
		return TRUE
	ui_interact(user)

/obj/machinery/computer/sm_monitor/ui_interact(mob/user)
	if(!sm_monitor)
		sm_monitor = new(src)
	sm_monitor.ui_interact(user)
