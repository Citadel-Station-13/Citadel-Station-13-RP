//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * # SStime_keep
 *
 * Centralized time-keeping subsystem for world & in-game time.
 *
 * * Linux broke our clock, instead of figuring out why
 *   I'm going to fix this by doing what I do best:
 *   needlessly refactoring code.
 * * Galactic date is the IRL date plus a given number of years.
 * * Galactic time is a random hour, usually, plus time from server boot.
 * * Galactic time is affected by time dilation, unlike timeofday/realtimeofday.
 */
/datum/controller/subsystem/time_keep
	var/galactic_year_offset = 544
	var/static/galactic_time_offset = null

	var/list/possible_roundstart_offsets = list(
		2 HOURS,
		7 HOURS,
		12 HOURS,
		17 HOURS,
	)

	var/tmp/cached_galactic_date
	var/tmp/cached_galactic_date_rollovers

/datum/controller/subsystem/time_keep/PreInit(recovering)
	if(isnull(galactic_time_offset))
		galactic_time_offset = pick(possible_roundstart_offsets)
	return ..()

/**
 * @return as YYYY-MM-DD
 */
/datum/controller/subsystem/time_keep/proc/get_galactic_date()
	var/use_time = world.time + galactic_time_offset
	var/rollovers = floor(use_time / DAYS)
	if(rollovers != cached_galactic_date_rollovers)
		cached_galactic_date = "[num2text(time2text(use_time, "YYYY")) + galactic_year_offset]-[time2text(use_time, "MM-DD", 0)]"
	return cached_galactic_date

/**
 * @return as YYYY-MM-DD
 */
/datum/controller/subsystem/time_keep/proc/get_galactic_date_offset(offset)
	var/use_time = world.time + galactic_time_offset + offset
	return "[num2text(time2text(use_time, "YYYY")) + galactic_year_offset]-[time2text(use_time, "MM-DD", 0)]"

/**
 * @return as hh:mm:ss
 */
/datum/controller/subsystem/time_keep/proc/get_galactic_time()
	var/static/last_get
	var/static/last_str

	if(world.time != last_get)
		last_str = time2text(world.time + galactic_time_offset, "hh:mm:ss", 0)
	return last_str

/**
 * @return as hh:mm:ss
 */
/datum/controller/subsystem/time_keep/proc/get_galactic_time_offset(offset)
	return time2text(world.time + galactic_time_offset + offset, "hh:mm:ss", 0)

/**
 * @return as hh:mm
 */
/datum/controller/subsystem/time_keep/proc/get_galactic_time_short()
	return get_galactic_time_short_offset(0)

/**
 * @return as hh:mm
 */
/datum/controller/subsystem/time_keep/proc/get_galactic_time_short_offset(offset)
	return time2text(world.time + galactic_time_offset + offset, "hh:mm", 0)
