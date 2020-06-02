#define SECONDS *10

#define MINUTES SECONDS*60

#define HOURS MINUTES*60

#define DAYS HOURS*24

#define TICKS *world.tick_lag

// Compatability things
// HEY! THIS MIGHT GET REMOVED SOON&trade;
#define SECOND SECONDS
#define MINUTE MINUTES
#define HOUR HOURS
#define DAY DAYS
#define TICK TICKS
//end compatability things

#define DS2TICKS(DS) ((DS)/world.tick_lag)

#define TICKS2DS(T) ((T) TICKS)

#define GAMETIMESTAMP(format, wtime) time2text(wtime, format)
#define WORLDTIME2TEXT(format) GAMETIMESTAMP(format, world.time)
#define WORLDTIMEOFDAY2TEXT(format) GAMETIMESTAMP(format, world.timeofday)
#define TIME_STAMP(format, showds) showds ? "[WORLDTIMEOFDAY2TEXT(format)]:[world.timeofday % 10]" : WORLDTIMEOFDAY2TEXT(format)
#define STATION_TIME(display_only, wtime) ((((wtime - SSSSticker.round_start_time) * SSSSticker.station_time_rate_multiplier) + SSSSticker.gametime_offset) % 864000) - (display_only? GLOB.timezoneOffset : 0)
#define STATION_TIME_TIMESTAMP(format, wtime) time2text(STATION_TIME(TRUE, wtime), format)
