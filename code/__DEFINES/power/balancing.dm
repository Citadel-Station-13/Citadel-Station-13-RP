//? master file for balancing / efficiency tuning

//* machinery power draws in watts

/// idle power usage of a lathe
#define POWER_USAGE_LATHE_IDLE 25
/// active power usage of lathe scaling to decisecond work unit (e.g. 4x speed lathe is 4 for input)
#define POWER_USAGE_LATHE_ACTIVE_SCALE(factor) (factor * 1000)
