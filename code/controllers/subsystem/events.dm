SUBSYSTEM_DEF(events)
	name = "Events"
	wait = 2 SECONDS
	init_order = INIT_ORDER_EVENTS

	/// Current holidays
	var/list/holidays = list()

	var/tmp/list/currentrun = null

	var/list/datum/event/active_events = list()
	var/list/datum/event/finished_events = list()

	var/list/datum/event/allEvents
	var/list/datum/event_container/event_containers

	var/datum/event_meta/new_event = new

/datum/controller/subsystem/events/PreInit()
	// unfortunately, character setup server startup hooks fire before /Initialize so :/
	// SScharactersetup but not shit when :)
	// Instantiate our holidays list if it hasn't been already
	if(isnull(GLOB.holidays))
		fill_holidays()
	return ..()

/datum/controller/subsystem/events/Initialize()
	SSticker.OnRoundstart(CALLBACK(src, .proc/HolidayRoundstart))
	allEvents = typesof(/datum/event) - /datum/event
	event_containers = list(
			EVENT_LEVEL_MUNDANE 	= new/datum/event_container/mundane,
			EVENT_LEVEL_MODERATE	= new/datum/event_container/moderate,
			EVENT_LEVEL_MAJOR 		= new/datum/event_container/major
		)
	return ..()

/datum/controller/subsystem/events/fire(resumed)
	if (!resumed)
		src.currentrun = active_events.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	var/dt = (subsystem_flags & SS_TICKER)? (wait * world.tick_lag * 0.1) : (wait * 0.1)
	while (currentrun.len)
		var/datum/event/E = currentrun[currentrun.len]
		currentrun.len--
		if(E.processing_active)
			E.process(dt)
		if (MC_TICK_CHECK)
			return

	for(var/i = EVENT_LEVEL_MUNDANE to EVENT_LEVEL_MAJOR)
		var/datum/event_container/EC = event_containers[i]
		EC.process(dt)

/datum/controller/subsystem/events/stat_entry()
	..("E:[active_events.len]")

/datum/controller/subsystem/events/Recover()
	if(SSevents.active_events)
		active_events |= SSevents.active_events
	if(SSevents.finished_events)
		finished_events |= SSevents.finished_events

/datum/controller/subsystem/events/proc/event_complete(var/datum/event/E)
	active_events -= E

	if(!E.event_meta || !E.severity)	// datum/event is used here and there for random reasons, maintaining "backwards compatibility"
		log_debug("Event of '[E.type]' with missing meta-data has completed.")
		return

	finished_events += E

	// Add the event back to the list of available events
	var/datum/event_container/EC = event_containers[E.severity]
	var/datum/event_meta/EM = E.event_meta
	if(EM.add_to_queue)
		EC.available_events += EM

	log_debug("Event '[EM.name]' has completed at [worldtime2stationtime(world.time)].")

/datum/controller/subsystem/events/proc/delay_events(var/severity, var/delay)
	var/datum/event_container/EC = event_containers[severity]
	EC.next_event_time += delay

/datum/controller/subsystem/events/proc/RoundEnd()
	if(!report_at_round_end)
		return

	to_chat(world, "<br><br><br><font size=3><b>Random Events This Round:</b></font>")
	for(var/datum/event/E in active_events|finished_events)
		var/datum/event_meta/EM = E.event_meta
		if(EM.name == "Nothing")
			continue
		var/message = "'[EM.name]' began at [worldtime2stationtime(E.startedAt)] "
		if(E.isRunning)
			message += "and is still running."
		else
			if(E.endedAt - E.startedAt > MinutesToTicks(5)) // Only mention end time if the entire duration was more than 5 minutes
				message += "and ended at [worldtime2stationtime(E.endedAt)]."
			else
				message += "and ran to completion."
		to_chat(world, message)


/**
 * HOLIDAYS
 *
 * Uncommenting ALLOW_HOLIDAYS in config.txt will enable holidays
 *
 * It's easy to add stuff. Just add a holiday datum in code/modules/holiday/holidays.dm
 * You can then check if it's a special day in any code in the game by calling check_holidays("Groundhog Day")
 *
 * You can also make holiday random events easily thanks to Pete/Gia's system.
 * simply make a random event normally, then assign it a holidayID string which matches the holiday's name.
 * Anything with a holidayID, which isn't in the holidays list, will never occur.
 *
 * Please, Don't spam stuff up with stupid stuff (key example being april-fools Pooh/ERP/etc),
 * and don't forget: CHECK YOUR CODE!!!! We don't want any zero-day bugs which happen only on holidays and never get found/fixed!
 */
GLOBAL_LIST(holidays)

/**
 * Checks that the passed holiday is located in the global holidays list.
 *
 * Returns a holiday datum, or null if it's not that holiday.
 */
/proc/check_holidays(holiday_to_find)
	if(!CONFIG_GET(flag/allow_holidays))
		return // Holiday stuff was not enabled in the config!

	if(isnull(GLOB.holidays) && !fill_holidays())
		return // Failed to generate holidays, for some reason

	return GLOB.holidays[holiday_to_find]

/**
 * Fills the holidays list if applicable, or leaves it an empty list.
 */
/proc/fill_holidays()
	if(!CONFIG_GET(flag/allow_holidays))
		return FALSE // Holiday stuff was not enabled in the config!

	GLOB.holidays = list()
	for(var/holiday_type in subtypesof(/datum/holiday))
		var/datum/holiday/holiday = new holiday_type()
		var/delete_holiday = TRUE
		for(var/timezone in holiday.timezones)
			var/time_in_timezone = world.realtime + timezone HOURS

			var/YYYY = text2num(time2text(time_in_timezone, "YYYY")) // get the current year
			var/MM = text2num(time2text(time_in_timezone, "MM")) // get the current month
			var/DD = text2num(time2text(time_in_timezone, "DD")) // get the current day
			var/DDD = time2text(time_in_timezone, "DDD") // get the current weekday

			if(holiday.should_celebrate(DD, MM, YYYY, DDD))
				holiday.celebrate()
				GLOB.holidays[holiday.name] = holiday
				delete_holiday = FALSE
				break
		if(delete_holiday)
			qdel(holiday)

	if(GLOB.holidays.len)
		shuffle_inplace(GLOB.holidays)
		// regenerate station name because holiday prefixes.
		// set_station_name(new_station_name())
		// world.update_status()

	return TRUE

/datum/controller/subsystem/events/proc/HolidayRoundstart()
	for(var/name in holidays)
		var/datum/holiday/holiday = holidays[name]
		holiday.OnRoundstart()
