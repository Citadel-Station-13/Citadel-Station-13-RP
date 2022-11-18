/// Convert deciseconds to ticks
#define DS2TICKS(DS) ((DS)/world.tick_lag)
/// Convert ticks to deciseconds
#define TICKS2DS(T) ((T) TICKS)
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

#define GAMETIMESTAMP(format, wtime) time2text(wtime, format)
#define WORLDTIME2TEXT(format) GAMETIMESTAMP(format, world.time)
#define WORLDTIMEOFDAY2TEXT(format) GAMETIMESTAMP(format, world.timeofday)
#define TIME_STAMP(format, showds) showds ? "[WORLDTIMEOFDAY2TEXT(format)]:[world.timeofday % 10]" : WORLDTIMEOFDAY2TEXT(format)
#define STATION_TIME(display_only, wtime) ((((wtime - SSticker.SSticker.round_start_time) * SSticker.station_time_rate_multiplier) + SSticker.gametime_offset) % 864000) - (display_only? GLOB.timezoneOffset : 0)
#define STATION_TIME_TIMESTAMP(format, wtime) time2text(STATION_TIME(TRUE, wtime), format)

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

/// use for rapid actions that make messages to throttle messages
#define CHATSPAM_THROTTLE_DEFAULT (!(world.time % 5))
/// ditto
#define CHATSPAM_THROTTLE(every) (!(world.time % every))

/**
 *! Timezones
 */

/// Line Islands Time
#define TIMEZONE_LINT 14

// Chatham Daylight Time
#define TIMEZONE_CHADT 13.75

/// Tokelau Time
#define TIMEZONE_TKT 13

/// Tonga Time
#define TIMEZONE_TOT 13

/// New Zealand Daylight Time
#define TIMEZONE_NZDT 13

/// New Zealand Standard Time
#define TIMEZONE_NZST 12

/// Norfolk Time
#define TIMEZONE_NFT 11

/// Lord Howe Standard Time
#define TIMEZONE_LHST 10.5

/// Australian Eastern Standard Time
#define TIMEZONE_AEST 10

/// Australian Central Standard Time
#define TIMEZONE_ACST 9.5

/// Australian Central Western Standard Time
#define TIMEZONE_ACWST 8.75

/// Australian Western Standard Time
#define TIMEZONE_AWST 8

/// Christmas Island Time
#define TIMEZONE_CXT 7

/// Cocos Islands Time
#define TIMEZONE_CCT 6.5

/// Central European Summer Time
#define TIMEZONE_CEST 2

/// Coordinated Universal Time
#define TIMEZONE_UTC 0

/// Eastern Daylight Time
#define TIMEZONE_EDT -4

/// Central Daylight Time
#define TIMEZONE_CDT -5

/// Mountain Daylight Time
#define TIMEZONE_MDT -6

/// Mountain Standard Time
#define TIMEZONE_MST -7

/// Pacific Daylight Time
#define TIMEZONE_PDT -7

/// Alaska Daylight Time
#define TIMEZONE_AKDT -8

/// Hawaii-Aleutian Daylight Time
#define TIMEZONE_HDT -9

/// Hawaii Standard Time
#define TIMEZONE_HST -10

/// Cook Island Time
#define TIMEZONE_CKT -10

/// Niue Time
#define TIMEZONE_NUT -11

/// Anywhere on Earth
#define TIMEZONE_ANYWHERE_ON_EARTH -12
