/// check to make sure external gas pressure doesn't drop below (pump in)
/// or rise above (pump out) a certain pressure
#define ATMOS_VENT_CHECK_EXTERNAL (1<<0)
/// check to make sure internal gas pressure doesn't drop below (pump out)
/// or rise above (pump in) a certain pressure
#define ATMOS_VENT_CHECK_INTERNAL (1<<1)
/// all bits in check bitfield
#define ATMOS_VENT_CHECKS (ATMOS_VENT_CHECK_EXTERNAL | ATMOS_VENT_CHECK_INTERNAL)

#define ATMOS_VENT_DIRECTION_SIPHON 0
#define ATMOS_VENT_DIRECTION_RELEASE 1

#define ATMOS_VENT_MAX_PRESSURE_LIMIT (ONE_ATMOSPHERE * 500)
