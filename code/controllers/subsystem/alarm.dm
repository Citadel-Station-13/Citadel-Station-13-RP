// We manually initialize the alarm handlers instead of looping over all existing types
// to make it possible to write: camera_alarm.triggerAlarm() rather than SSalarms.managers[datum/alarm_handler/camera].triggerAlarm() or a variant thereof.
GLOBAL_DATUM_INIT(atmosphere_alarm, /datum/alarm_handler/atmosphere, new)
GLOBAL_DATUM_INIT(camera_alarm, /datum/alarm_handler/camera, new)
GLOBAL_DATUM_INIT(fire_alarm, /datum/alarm_handler/fire, new)
GLOBAL_DATUM_INIT(motion_alarm, /datum/alarm_handler/motion, new)
GLOBAL_DATUM_INIT(power_alram, /datum/alarm_handler/power, new)

SUBSYSTEM_DEF(alarms)
	name = "Alarms"
	wait = 2 SECONDS
	priority = FIRE_PRIORITY_ALARMS
	init_order = INIT_ORDER_ALARMS
	var/static/list/datum/alarm/all_handlers
	var/tmp/list/currentrun = null
	var/static/list/active_alarm_cache = list()

/datum/controller/subsystem/alarms/Initialize()
	SSalarms.all_handlers = list(atmosphere_alarm, camera_alarm, fire_alarm, motion_alarm, power_alarm)
	. = ..()

/datum/controller/subsystem/alarms/fire(resumed = FALSE)
	if(!resumed)
		src.currentrun = SSalarms.all_handlers.Copy()
		active_alarm_cache.Cut()

	var/list/currentrun = src.currentrun // Cache for sanic speed
	while (currentrun.len)
		var/datum/alarm_handler/AH = currentrun[currentrun.len]
		currentrun.len--
		AH.process()
		active_alarm_cache += AH.alarms

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/alarms/proc/active_alarms()
	return active_alarm_cache.Copy()

/datum/controller/subsystem/alarms/proc/number_of_active_alarms()
	return active_alarm_cache.len

/datum/controller/subsystem/alarms/stat_entry()
	return ..() + " [number_of_active_alarms()] alarm\s"
