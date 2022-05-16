// Bitflag values for c_airblock()
/// Blocked
#define AIR_BLOCKED 1
/// Not blocked, but zone boundaries will not cross.
#define ZONE_BLOCKED 2
/// Blocked, zone boundaries will not cross even if opened.
#define BLOCKED 3
/// Zones with less than this many turfs will always merge, even if the connection is not direct
#define ZONE_MIN_SIZE 14
