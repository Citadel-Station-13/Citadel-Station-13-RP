/// Convert deciseconds to ticks
#define DS2TICKS(DS) ((DS)/world.tick_lag)
/// Convert ticks to deciseconds
#define TICKS2DS(T) ((T) TICKS)

//? converts normal time to deciseconds - beware of floating point inaccuracy.

#define SECOND *10
#define SECONDS *10

#define MINUTE *600
#define MINUTES *600

#define HOUR *36000
#define HOURS *36000

#define DAY *864000
#define DAYS *864000

#define TICK *world.tick_lag
#define TICKS *world.tick_lag

//? converts units of time to other units explicitly

#define HOURS_TO_SECONDS(_h) (_h * 60 * 60)
#define HOURS_TO_MINUTES(_h) (_h * 60)
#define MINUTES_TO_HOURS(_m) (_m / 60)
#define MINUTES_TO_SECONDS(_m) (_m * 60)
#define SECONDS_TO_MINUTES(_s) (_s / 60)
#define SECONDS_TO_HOURS(_s) (_s / (60 * 60))

//? misc timestamp/whatnot helpers

#define GAMETIMESTAMP(format, wtime) time2text(wtime, format)
#define WORLDTIME2TEXT(format) GAMETIMESTAMP(format, world.time)
#define WORLDTIMEOFDAY2TEXT(format) GAMETIMESTAMP(format, world.timeofday)
// todo: unify with time_stamp().
#define TIME_STAMP(format, showds) showds ? "[WORLDTIMEOFDAY2TEXT(format)]:[world.timeofday % 10]" : WORLDTIMEOFDAY2TEXT(format)
#define STATION_TIME(display_only, wtime) ((((wtime - SSticker.SSticker.round_start_time) * SSticker.station_time_rate_multiplier) + SSticker.gametime_offset) % 864000) - (display_only? GLOB.timezoneOffset : 0)
#define STATION_TIME_TIMESTAMP(format, wtime) time2text(STATION_TIME(TRUE, wtime), format)

//? month enums

#define JANUARY		1
#define FEBRUARY	2
#define MARCH		3
#define APRIL		4
#define MAY			5
#define JUNE		6
#define JULY		7
#define AUGUST		8
#define SEPTEMBER	9
#define OCTOBER		10
#define NOVEMBER	11
#define DECEMBER	12

//? for some procs that render time, here's the format possibilities
/// ISO 8601 timestamps
#define TIME_FORMAT_ISO 0
/// write everything out, no abbreviations
#define TIME_FORMAT_FLUFFY 1
/// ISO but no T
#define TIME_FORMAT_NORMAL 2

//? unsorted / misc

/// use for rapid actions that make messages to throttle messages
#define CHATSPAM_THROTTLE_DEFAULT		(!(world.time % 5))
/// ditto
#define CHATSPAM_THROTTLE(every)			(!(world.time % every))
