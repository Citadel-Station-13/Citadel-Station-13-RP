
#define TimeOfGame (get_game_time())
#define TimeOfTick (TICK_USAGE*0.01*world.tick_lag)

/proc/get_game_time()
	var/global/time_offset = 0
	var/global/last_time = 0
	var/global/last_usage = 0

	var/wtime = world.time
	var/wusage = TICK_USAGE * 0.01

	if(last_time < wtime && last_usage > 1)
		time_offset += last_usage - 1

	last_time = wtime
	last_usage = wusage

	return wtime + (time_offset + wusage) * world.tick_lag

GLOBAL_VAR_INIT(roundstart_hour, pick(2,7,12,17))
/var/station_date = ""
/var/next_station_date_change = 1 DAY

#define duration2stationtime(time) time2text(station_time_in_ds + time, "hh:mm")
#define worldtime2stationtime(time) time2text(GLOB.roundstart_hour HOURS + time, "hh:mm")
#define round_duration_in_ds (SSticker.round_start_time ? world.time - SSticker.round_start_time : 0)
#define station_time_in_ds (GLOB.roundstart_hour HOURS + round_duration_in_ds)

/proc/stationtime2text()
	return time2text(station_time_in_ds + GLOB.timezoneOffset, "hh:mm")

/proc/stationdate2text()
	var/update_time = FALSE
	if(station_time_in_ds > next_station_date_change)
		next_station_date_change += 1 DAY
		update_time = TRUE
	if(!station_date || update_time)
		var/extra_days = round(station_time_in_ds / (1 DAY)) DAYS
		var/timeofday = world.timeofday + extra_days
		station_date = num2text((text2num(time2text(timeofday, "YYYY"))+544)) + "-" + time2text(timeofday, "MM-DD")
	return station_date

/// ISO 8601
/proc/time_stamp()
	var/date_portion = time2text(world.timeofday, "YYYY-MM-DD")
	var/time_portion = time2text(world.timeofday, "hh:mm:ss")
	return "[date_portion]T[time_portion]"

/proc/get_timezone_offset()
	var/midnight_gmt_here = text2num(time2text(0,"hh")) * 36000
	if(midnight_gmt_here > 12 HOURS)
		return 24 HOURS - midnight_gmt_here
	else
		return midnight_gmt_here

/proc/gameTimestamp(format = "hh:mm:ss", wtime=null)
	if(!wtime)
		wtime = world.time
	return time2text(wtime - GLOB.timezoneOffset, format)

/**
 * This is used for displaying the "station time" equivelent of a world.time value
 * Calling it with no args will give you the current time, but you can specify a world.time-based value as an argument.
 * - You can use this, for example, to do "This will expire at [station_time_at(world.time + 500)]" to display a "station time" expiration date
 *   which is much more useful for a player).
 */
/proc/station_time(time=world.time, display_only=FALSE)
	return ((((time - SSticker.round_start_time)) + GLOB.gametime_offset) % 864000) - (display_only ? GLOB.timezoneOffset : 0)

/proc/station_time_timestamp(format = "hh:mm:ss", time=world.time)
	return time2text(station_time(time, TRUE), format)

/// Returns 1 if it is the selected month and day.
/proc/isDay(var/month, var/day)
	if(isnum(month) && isnum(day))
		var/MM = text2num(time2text(world.timeofday, "MM")) // Get the current month.
		var/DD = text2num(time2text(world.timeofday, "DD")) // Get the current day.
		if(month == MM && day == DD)
			return TRUE

		// Uncomment this out when debugging!
		// else
		// 	return TRUE

/var/next_duration_update = 0
/var/last_round_duration = 0

/proc/roundduration2text()
	if(!SSticker.round_start_time)
		return "00:00"
	if(last_round_duration && world.time < next_duration_update)
		return last_round_duration

	var/mills = round_duration_in_ds // 1/10 of a second, not real milliseconds but whatever
	//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence.. or something
	var/mins = round((mills % 36000) / 600)
	var/hours = round(mills / 36000)

	mins = mins < 10 ? add_zero(mins, 1) : mins
	hours = hours < 10 ? add_zero(hours, 1) : hours

	last_round_duration = "[hours]:[mins]"
	next_duration_update = world.time + 1 MINUTES
	return last_round_duration

/var/midnight_rollovers = 0
/var/rollovercheck_last_timeofday = 0

/proc/update_midnight_rollover()
	if (world.timeofday < rollovercheck_last_timeofday) //TIME IS GOING BACKWARDS!
		return midnight_rollovers++
	return midnight_rollovers

/proc/weekdayofthemonth()
	var/DD = text2num(time2text(world.timeofday, "DD")) // get the current day
	switch(DD)
		if(8 to 13)
			return 2
		if(14 to 20)
			return 3
		if(21 to 27)
			return 4
		if(28 to INFINITY)
			return 5
		else
			return 1

/**
 * Takes a value of time in deciseconds.
 * Returns a text value of that number in hours, minutes, or seconds.
 */
/proc/DisplayTimeText(time_value, round_seconds_to = 0.1)
	var/second = round(time_value * 0.1, round_seconds_to)
	if(!second)
		return "right now"
	if(second < 60)
		return "[second] second[(second != 1)? "s":""]"
	var/minute = FLOOR(second / 60, 1)
	second = MODULUS(second, 60)
	var/secondT
	if(second)
		secondT = " and [second] second[(second != 1)? "s":""]"
	if(minute < 60)
		return "[minute] minute[(minute != 1)? "s":""][secondT]"
	var/hour = FLOOR(minute / 60, 1)
	minute = MODULUS(minute, 60)
	var/minuteT
	if(minute)
		minuteT = " and [minute] minute[(minute != 1)? "s":""]"
	if(hour < 24)
		return "[hour] hour[(hour != 1)? "s":""][minuteT][secondT]"
	var/day = FLOOR(hour / 24, 1)
	hour = MODULUS(hour, 24)
	var/hourT
	if(hour)
		hourT = " and [hour] hour[(hour != 1)? "s":""]"
	return "[day] day[(day != 1)? "s":""][hourT][minuteT][secondT]"

/proc/daysSince(realtimev)
	return round((world.realtime - realtimev) / (24 HOURS))
