// Bitflag values for c_airblock().

#define AIR_BLOCKED		(1<<0)	// Blocked
#define ZONE_BLOCKED	(1<<1)	// Not blocked, but zone boundaries will not cross.
// assuming it's airblock and zoneblock because (1<<0) == 0x01 == 1 and (1<<1) == 0x10 == 2, adding them up returning a 3 == 0x11
#define BLOCKED (AIR_BLOCKED | ZONE_BLOCKED)	// Blocked, zone boundaries will not cross even if opened.

#define ZONE_MIN_SIZE 14 // Zones with less than this many turfs will always merge, even if the connection is not direct
