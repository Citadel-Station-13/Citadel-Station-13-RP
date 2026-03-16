GLOBAL_VAR_INIT(year, time2text(world.realtime, "YYYY", NO_TIMEZONE))
GLOBAL_VAR_INIT(year_integer, text2num(year)) // = 2013???

/// 12:00 in seconds
GLOBAL_VAR_INIT(gametime_offset, 432000)

// I guess this counds as a time var?
GLOBAL_VAR_INIT(internal_tick_usage, 0.2 * world.tick_lag)
