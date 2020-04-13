SUBSYSTEM_DEF(alarms)
	name = "Alarms"
	wait = 20
	flags = SS_NO_TICK_CHECK
	var/static/list/datum/alarm/all_handlers
	// We manually initialize the alarm handlers instead of looping over all existing types
	// to make it possible to write: camera.triggerAlarm() rather than alarm_manager.managers[datum/alarm_handler/camera].triggerAlarm() or a variant thereof.
	var/static/datum/alarm_handler/atmosphere/atmosphere_alarm
	var/static/datum/alarm_handler/camera/camera_alarm
	var/static/datum/alarm_handler/fire/fire_alarm
	var/static/datum/alarm_handler/motion/motion_alarm
	var/static/datum/alarm_handler/power/power_alarm

/datum/controller/subsystem/alarm/Initialize()
	atmosphere_alarm = new
	camera_alarm = new
	fire_alarm = new
	motion_alarm = new
	power_alarm = new
	all_handlers = list(atmosphere_alarm, camera_alarm, fire_alarm, motion_alarm, power_alarm)
	return ..()

/datum/controller/subsystem/alarm/fire()
	for(var/datum/alarm_handler/A in all_handlers)
		A.process()

/datum/controller/subsystem/alarm/proc/active_alarms()
	. = list()
	for(var/datum/alarm_handler/AH in all_handlers)
		. += AH.alarms

/datum/controller/subsystem/alarm/proc/number_of_active_alarms()
	return length(active_alarms())

/datum/controller/subsystem/alarm/stat_entry()
	..("[number_of_active_alarms()] alarms")
