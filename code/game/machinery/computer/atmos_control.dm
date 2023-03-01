/obj/item/circuitboard/atmoscontrol
	name = "\improper Central Atmospherics Computer Circuitboard"
	build_path = /obj/machinery/computer/atmoscontrol

/obj/machinery/computer/atmoscontrol
	name = "\improper Central Atmospherics Computer"
	desc = "Control the station's atmospheric systems from afar! Certified atmospherics technicians only."
	icon_keyboard = "generic_key"
	icon_screen = "comm_logs"
	light_color = "#00b000"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/atmoscontrol
	req_access = list(ACCESS_ENGINEERING_ATMOS)
	var/list/monitored_alarm_ids = null
	var/datum/tgui_module_old/atmos_control/atmos_control

/obj/machinery/computer/atmoscontrol/Initialize(mapload)
	. = ..()

/obj/machinery/computer/atmoscontrol/laptop //TODO: Change name to PCU and update mapdata to include replacement computers
	name = "\improper Atmospherics PCU"
	desc = "A personal computer unit. It seems to have only the Atmosphereics Control program installed."
	icon_screen = "pcu_atmo"
	icon_state = "pcu_engi"
	icon_keyboard = "pcu_key"
	density = FALSE
	light_color = "#00cc00"

/obj/machinery/computer/atmoscontrol/attack_ai(mob/user)
	ui_interact(user)

/obj/machinery/computer/atmoscontrol/attack_hand(mob/user)
	if(..())
		return TRUE
	ui_interact(user)

/obj/machinery/computer/atmoscontrol/emag_act(remaining_carges, mob/user)
	if(!emagged)
		user.visible_message(
			SPAN_WARNING("\The [user] does something \the [src], causing the screen to flash!"),\
			SPAN_WARNING("You cause the screen to flash as you gain full control."),\
			SPAN_NOTICE("You hear an electronic warble.")
			)
		atmos_control.emagged = TRUE
		return TRUE

/obj/machinery/computer/atmoscontrol/ui_interact(mob/user)
	if(!atmos_control)
		atmos_control = new(src, req_access, req_one_access, monitored_alarm_ids)
	atmos_control.ui_interact(user)
