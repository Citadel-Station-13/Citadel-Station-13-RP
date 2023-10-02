/datum/nifsoft/crewmonitor
	name = "Crew Monitor"
	desc = "A link to the local crew monitor sensors. Useful for finding people in trouble."
	list_pos = NIF_MEDMONITOR
	access = ACCESS_MEDICAL_MAIN
	cost = 250
	p_drain = 0.025
	var/datum/tgui_module_old/crew_monitor/nif/arscreen

/datum/nifsoft/crewmonitor/New()
	..()
	arscreen = new(nif)

/datum/nifsoft/crewmonitor/Destroy()
		QDEL_NULL(arscreen)
		return ..()

/datum/nifsoft/crewmonitor/activate()
	if((. = ..()))
		arscreen.ui_interact(nif.human)
		return TRUE

/datum/nifsoft/crewmonitor/deactivate(var/force = FALSE)
	if((. = ..()))
		return TRUE

/datum/nifsoft/crewmonitor/stat_text()
	return "Show Monitor"

/datum/nifsoft/alarmmonitor
	name = "Alarm Monitor"
	desc = "A link to the local alarm monitors. Useful for detecting alarms in a pinch."
	list_pos = NIF_ENGMONITOR
	access = ACCESS_ENGINEERING_MAIN
	cost = 250
	p_drain = 0.025
	var/datum/nano_module/alarm_monitor/engineering/arscreen

/datum/nifsoft/alarmmonitor/New()
	..()
	arscreen = new(nif)

/datum/nifsoft/alarmmonitor/Destroy()
		QDEL_NULL(arscreen)
		return ..()

/datum/nifsoft/alarmmonitor/activate()
	if((. = ..()))
		arscreen.ui_interact(nif.human)
		return TRUE

/datum/nifsoft/alarmmonitor/deactivate(var/force = FALSE)
	if((. = ..()))
		return TRUE

/datum/nifsoft/alarmmonitor/stat_text()
	return "Show Monitor"
