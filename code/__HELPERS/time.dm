GLOBAL_VAR_INIT(startup_year, text2num(time2text(world.time, "YYYY")))
GLOBAL_VAR_INIT(startup_month, text2num(time2text(world.time, "MM")))
GLOBAL_VAR_INIT(startup_day, text2num(time2text(world.time, "DD")))

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

#define worldtime2stationtime(time) SStime_keep.render_galactic_time_short(time)
#define round_duration_in_ds (SSticker.round_start_time ? world.time - SSticker.round_start_time : 0)
#define station_time_in_ds (world.time + SStime_keep.get_galactic_time_offset())

// TODO: remove
/proc/stationtime2text()
	return SStime_keep.render_galactic_time()

// TODO: remove
/proc/stationdate2text()
	return SStime_keep.render_galactic_date()

/// ISO 8601
/proc/time_stamp()
	var/date_portion = time2text(world.timeofday, "YYYY-MM-DD")
	var/time_portion = time2text(world.timeofday, "hh:mm:ss")
	return "[date_portion]T[time_portion]"

/proc/gameTimestamp(format = "hh:mm:ss", wtime=null)
	if(!wtime)
		wtime = world.time
	return time2text(wtime, format, 0)

/**
 * Returns 1 if it is the selected month and day.
 */
/proc/isDay(var/month, var/day)
	if(isnum(month) && isnum(day))
		/// Get the current month.
		var/MM = text2num(time2text(world.timeofday, "MM"))
		/// Get the current day.
		var/DD = text2num(time2text(world.timeofday, "DD"))
		if(month == MM && day == DD)
			return TRUE

		// Uncomment this out when debugging!
		// else
		// 	return TRUE

/var/next_duration_update = 0
/var/last_round_duration = 0

// TODO: this is buggy, should use RTOD / walltime
/proc/roundduration2text()
	if(!SSticker.round_start_time)
		return "00:00"
	if(last_round_duration && world.time < next_duration_update)
		return last_round_duration

	/// 1/10 of a second, not real milliseconds but whatever.
	var/mills = round_duration_in_ds
	/// Not really needed, but I'll leave it here for refrence.. or something.
	//var/secs = ((mills % 36000) % 600) / 10
	var/mins = round((mills % 36000) / 600)
	var/hours = round(mills / 36000)

	mins = mins < 10 ? add_zero(mins, 1) : mins
	hours = hours < 10 ? add_zero(hours, 1) : hours

	last_round_duration = "[hours]:[mins]"
	next_duration_update = world.time + 1 MINUTES
	return last_round_duration

/proc/weekdayofthemonth()
	/// Get the current day.
	var/DD = text2num(time2text(world.timeofday, "DD"))
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
	var/second = FLOOR(time_value * 0.1, round_seconds_to)
	if(!second)
		return "right now"
	if(second < 60)
		return "[second] second[(second != 1)? "s":""]"
	var/minute = FLOOR(second / 60, 1)
	second = MODULUS_F(second, 60)
	var/secondT
	if(second)
		secondT = " and [second] second[(second != 1)? "s":""]"
	if(minute < 60)
		return "[minute] minute[(minute != 1)? "s":""][secondT]"
	var/hour = FLOOR(minute / 60, 1)
	minute = MODULUS_F(minute, 60)
	var/minuteT
	if(minute)
		minuteT = " and [minute] minute[(minute != 1)? "s":""]"
	if(hour < 24)
		return "[hour] hour[(hour != 1)? "s":""][minuteT][secondT]"
	var/day = FLOOR(hour / 24, 1)
	hour = MODULUS_F(hour, 24)
	var/hourT
	if(hour)
		hourT = " and [hour] hour[(hour != 1)? "s":""]"
	return "[day] day[(day != 1)? "s":""][hourT][minuteT][secondT]"

/proc/daysSince(realtimev)
	return round((world.realtime - realtimev) / (24 HOURS))
