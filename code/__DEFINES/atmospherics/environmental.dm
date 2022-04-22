// Bitflag values for c_airblock()
#define AIR_BLOCKED 1	// Blocked
#define ZONE_BLOCKED 2	// Not blocked, but zone boundaries will not cross.
#define BLOCKED 3		// Blocked, zone boundaries will not cross even if opened.

#define ZONE_MIN_SIZE 14 // Zones with less than this many turfs will always merge, even if the connection is not direct

// /turf/var/air_status
/// blocks air, e.g. walls
#define AIR_STATUS_BLOCKED			1
/// acts as unsimulated zone
#define AIR_STATUS_IMMUTABLE		2
/// simulated, passes air
#define AIR_STATUS_SIMULATED		3
