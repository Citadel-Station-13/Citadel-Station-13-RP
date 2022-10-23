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
	InitializeHolidays(force = TRUE)
	return ..()

/datum/controller/subsystem/events/Initialize()
	SSticker.OnRoundstart(CALLBACK(src, .proc/HolidayRoundstart))
	allEvents = typesof(/datum/event) - /datum/event
	event_containers = list(
			EVENT_LEVEL_MUNDANE 	= new/datum/event_container/mundane,
			EVENT_LEVEL_MODERATE	= new/datum/event_container/moderate,
			EVENT_LEVEL_MAJOR 		= new/datum/event_container/major
		)
	// unfortunately, character setup server startup hooks fire before /Initialize so :/
	// SScharactersetup but not shit when :)
	InitializeHolidays()
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


//////////////
// HOLIDAYS //
//////////////
//Uncommenting ALLOW_HOLIDAYS in config.txt will enable holidays

//It's easy to add stuff. Just add a holiday datum in code/modules/holiday/holidays.dm
//You can then check if it's a special day in any code in the game by doing if(SSevents.holidays["Groundhog Day"])

//You can also make holiday random events easily thanks to Pete/Gia's system.
//simply make a random event normally, then assign it a holidayID string which matches the holiday's name.
//Anything with a holidayID, which isn't in the holidays list, will never occur.

//Please, Don't spam stuff up with stupid stuff (key example being april-fools Pooh/ERP/etc),
//And don't forget: CHECK YOUR CODE!!!! We don't want any zero-day bugs which happen only on holidays and never get found/fixed!

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//ALSO, MOST IMPORTANTLY: Don't add stupid stuff! Discuss bonus content with Project-Heads first please!//
//////////////////////////////////////////////////////////////////////////////////////////////////////////


//sets up the holidays and holidays list
/datum/controller/subsystem/events/proc/InitializeHolidays(force = FALSE)
	if(holidays)
		QDEL_LIST_ASSOC_VAL(holidays)
	holidays = list()
	if(!force && !CONFIG_GET(flag/allow_holidays))
		return // Holiday stuff was not enabled in the config!

	var/YY = text2num(time2text(world.timeofday, "YY")) // get the current year
	var/MM = text2num(time2text(world.timeofday, "MM")) // get the current month
	var/DD = text2num(time2text(world.timeofday, "DD")) // get the current day
	var/DDD = time2text(world.timeofday, "DDD")	// get the current weekday
	var/W = weekdayofthemonth()	// is this the first monday? second? etc.

	for(var/H in subtypesof(/datum/holiday))
		var/datum/holiday/holiday = new H
		if(holiday.ShouldCelebrate(DD, MM, YY, W, DDD))
			holiday.OnInit()
			holidays[holiday.name] = holiday
		else
			qdel(holiday)

	tim_sort(holidays, /proc/cmp_holiday_priority)
	// // regenerate station name because holiday prefixes.
	// set_station_name(new_station_name())
	// world.update_status()

/datum/controller/subsystem/events/proc/HolidayRoundstart()
	for(var/name in holidays)
		var/datum/holiday/holiday = holidays[name]
		holiday.OnRoundstart()

/proc/IsHoliday(name)
	return SSevents.holidays[name]? TRUE : FALSE
