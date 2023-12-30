
var/global/list/priority_air_alarms = list()
var/global/list/minor_air_alarms = list()


/obj/machinery/computer/atmos_alert
	name = "atmospheric alert computer"
	desc = "Used to access the station's atmospheric sensors."
	circuit = /obj/item/circuitboard/atmos_alert
	icon_keyboard = "atmos_key"
	icon_screen = "alert:0"
	light_color = "#e6ffff"

/obj/machinery/computer/atmos_alert/Initialize(mapload)
	. = ..()
	atmosphere_alarm.register_alarm(src, PROC_REF(on_alarm_update))

/obj/machinery/computer/atmos_alert/Destroy()
	atmosphere_alarm.unregister_alarm(src)
	return ..()

/obj/machinery/computer/atmos_alert/attack_hand(mob/user, list/params)
	ui_interact(user)

/obj/machinery/computer/atmos_alert/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosAlertConsole", name)
		ui.open()

/obj/machinery/computer/atmos_alert/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	var/list/major_alarms = list()
	var/list/minor_alarms = list()

	for(var/datum/alarm/alarm in atmosphere_alarm.major_alarms())
		major_alarms[++major_alarms.len] = list("name" = sanitize(alarm.alarm_name()), "ref" = "\ref[alarm]")

	for(var/datum/alarm/alarm in atmosphere_alarm.minor_alarms())
		minor_alarms[++minor_alarms.len] = list("name" = sanitize(alarm.alarm_name()), "ref" = "\ref[alarm]")

	.["priority_alarms"] = major_alarms
	.["minor_alarms"] = minor_alarms

/obj/machinery/computer/atmos_alert/update_icon()
	if(!(machine_stat & (NOPOWER|BROKEN)))
		var/list/alarms = atmosphere_alarm.major_alarms()
		if(alarms.len)
			icon_screen = "alert:2"
		else
			alarms = atmosphere_alarm.minor_alarms()
			if(alarms.len)
				icon_screen = "alert:1"
			else
				icon_screen = initial(icon_screen)
	..()

/obj/machinery/computer/atmos_alert/proc/on_alarm_update()
	update_icon()

/obj/machinery/computer/atmos_alert/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("clear")
			var/datum/alarm/alarm = locate(params["ref"]) in atmosphere_alarm.alarms
			if(alarm)
				for(var/datum/alarm_source/alarm_source in alarm.sources)
					var/obj/machinery/air_alarm/air_alarm = alarm_source.source
					if(istype(air_alarm))
						// I have to leave a note here:
						// Once upon a time, this called air_alarm.Topic() with a custom topic state
						// in order to perform three lines of code. In other words, pure insanity.
						// Whyyyyyyyyyyyyyyyyyyyyyyy.
						air_alarm.atmos_reset()
			. = TRUE
	update_icon()
