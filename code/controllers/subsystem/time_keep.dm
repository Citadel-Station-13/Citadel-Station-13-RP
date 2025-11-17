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
SUBSYSTEM_DEF(time_keep)
	name = "Time Keeping"
	subsystem_flags = SS_NO_FIRE | SS_NO_INIT
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

	/// approximate REALTIMEOFDAY we booted at
	/// * Set by PreInit, which is very close, but not precisely, at server boot.
	var/static/cached_server_boot_rtod

	/// world.time we started the round at
	/// * Null until round starts.
	var/static/cached_round_start_time
	/// REALTIMEOFDAY we started the round at
	/// * Null until round starts.
	var/static/cached_round_start_rtod

/datum/controller/subsystem/time_keep/PreInit(recovering)
	if(isnull(galactic_time_offset))
		galactic_time_offset = pick(possible_roundstart_offsets)
	cached_server_boot_rtod = REALTIMEOFDAY
	return ..()

/**
 * @return as YYYY-MM-DD
 */
/datum/controller/subsystem/time_keep/proc/render_galactic_date(manual_offset)
	// Note: midnight rollovers have to be subtracted because we manually track midnight rollovers
	//       in date rendering code.
	MIDNIGHT_ROLLOVER_CHECK_STANDALONE
	if(manual_offset)
		var/use_time = galactic_time_offset + manual_offset - (global.midnight_rollovers DAYS)
		return "[num2text(time2text(use_time, "YYYY")) + galactic_year_offset]-[time2text(use_time, "MM-DD", 0)]"
	else
		var/use_time = galactic_time_offset + world.time - (global.midnight_rollovers DAYS)
		var/rollovers = floor(use_time / (1 DAY))
		if(rollovers != cached_galactic_date_rollovers)
			cached_galactic_date = "[text2num(time2text(use_time, "YYYY")) + galactic_year_offset]-[time2text(use_time, "MM-DD", 0)]"
		return cached_galactic_date

/**
 * Returns time from start of current round. Default offset is current time.
 * @return as hh:mm:ss
 */
/datum/controller/subsystem/time_keep/proc/render_galactic_time(manual_offset)
	if(manual_offset)
		// TODO: slow path that doesn't cache
		return time2text(galactic_time_offset + manual_offset, "hh:mm:ss", 0)
	else
		// TODO: cache fast path
		return time2text(galactic_time_offset + world.time, "hh:mm:ss", 0)

/**
 * Returns time from start of current round. Default offset is current time.
 * @return as hh:mm
 */
/datum/controller/subsystem/time_keep/proc/render_galactic_time_short(manual_offset)
	if(manual_offset)
		// TODO: slow path that doesn't cache
		return time2text(galactic_time_offset + manual_offset, "hh:mm", 0)
	else
		// TODO: cache fast path
		return time2text(galactic_time_offset + world.time, "hh:mm", 0)

/**
 * * **warning**: this proc return should never be used to render date. BYOND is weird.
 * @return deciseconds into the current day we started the server at.
 *         Value will only make sense when time2text'd to `hh`, `mm`, `ss` format.
 *         Date formats will fail miserably due to us using `world.time` instead of `world.realtime` for floating
 *         point accuracy reasons. Make sure you remember to set timezone to `0` in `time2text` if using this
 *         for that.
 */
/datum/controller/subsystem/time_keep/proc/get_galactic_time_offset()
	return galactic_time_offset
