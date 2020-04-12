#define DS2TICKS(DS) ((DS)/world.tick_lag)	// Convert deciseconds to ticks
#define TICKS2DS(T) ((T) TICKS) 				// Convert ticks to deciseconds

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
#define STATION_TIME(display_only, wtime) ((((wtime - SSticker.round_start_time) * SSticker.station_time_rate_multiplier) + SSticker.gametime_offset) % 864000) - (display_only? GLOB.timezoneOffset : 0)
#define STATION_TIME_TIMESTAMP(format, wtime) time2text(STATION_TIME(TRUE, wtime), format)
