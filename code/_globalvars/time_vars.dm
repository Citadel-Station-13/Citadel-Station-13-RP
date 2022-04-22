/// The difference betwen midnight (of the host computer) and 0 world.ticks.
GLOBAL_VAR_INIT(timezoneOffset, 0)
/// 12:00 in seconds
GLOBAL_VAR_INIT(gametime_offset, 432000)

// I guess this counds as a time var?
GLOBAL_VAR_INIT(internal_tick_usage, 0.2 * world.tick_lag)
