/**
 * SSmapping: time module
 *
 * responsible for querying in game time
 * in game time is measured in deciseconds, as the rest of BYOND uses this unit of time.
 * however, all sectors can have different times,
 * and there's a "global" IC time.
 *
 * ? galactic time
 *
 * standard galaxy time in universe is just the server timezone plus a number of years
 * we highly recommend setting your server to UTC, as everything is meant to be UTC.
 *
 * we render galactic time as ISO unless requested not to.
 * it is highly recommended to use ISO for OOC / logging purposes.
 *
 * ? performance
 *
 * string ops kinda bad
 * cache stuff where you can, please
 * you shouldn't have to call all of this every tick, let alone multiple times a tick,
 * other than to cache values for the former case.
 */
/datum/controller/subsystem/mapping
	/// year offset from current.
	var/year_offset = 544

/**
 * standard render of galactic time
 *
 * @return "hh:mm:ss"
 */
/datum/controller/subsystem/mapping/proc/render_galactic_time(mode = TIME_FORMAT_ISO)
	return time2text(world.timeofday, "hh:mm:ss", 0)


/**
 * standard render of galactic time and date
 *
 * @return "YYYY-MM-DDThh:mm:ss"
 */
/datum/controller/subsystem/mapping/proc/render_galactic_datetime(mode = TIME_FORMAT_ISO)
	switch(mode)
		if(TIME_FORMAT_ISO)
			return time2text(world.timeofday, "[galactic_year()]-[time2text(world.timeofday, "MM-DDThh:mm:ss")]", 0)
		if(TIME_FORMAT_NORMAL)
			return time2text(world.timeofday, "[galactic_year()]-[time2text(world.timeofday, "MM-DD hh:mm:ss")]", 0)
		if(TIME_FORMAT_FLUFFY)
			return time2text(world.timeofday, "[time2text(world.timeofday, "Month DD", 0)], [galactic_year()] @ [time2text(world.timeofday, "hh:mm:ss", 0)]")

/**
 * standard render of galactic date
 *
 * @return "YYYY-MM-DD"
 */
/datum/controller/subsystem/mapping/proc/render_galactic_date(mode = TIME_FORMAT_ISO)
	switch(mode)
		if(TIME_FORMAT_FLUFFY)
			return "[time2text(world.timeofday, "Month DD", 0)], [galactic_year()]"
		else
			return "[galactic_year()]-[time2text(world.timeofday, "MM-DD", 0)]"

/**
 * returns galactic year as number
 */
/datum/controller/subsystem/mapping/proc/galactic_year()
	return text2num(time2text(timeofday, "YYYY", 0)) + year_offset
