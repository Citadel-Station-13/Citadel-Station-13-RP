//! excavation capability/support flags
/// supports excavation
#define MINE_CAN_EXCAVATE		(1<<0)
/// supports weakening
#define MINE_CAN_WEAKEN			(1<<1)

//! excavation levels
/// default excavation depth for a bad pickaxe
#define EXCAVATION_DEPTH_BASELINE 25		// 8 hits
/// default excavation depth for a better pickaxe
#define EXCAVATION_DEPTH_IMPROVED 35		// 6 hits
/// default excavation depth for a heavy pickaxe
#define EXCAVATION_DEPTH_ADVANCED 45		// 5 hits
/// default excavation depth for a very good, usually powered pickaxe
#define EXCAVATION_DEPTH_POWERED 55			// 4 hits

//? Archeological depths
#define EXCAVATION_DEPTH_ARCHEOLOGICAL_DRILL 30 // 30 at most

/// default excavation depth for a full turf
#define EXCAVATION_DEPTH_DEFAULT 200

#warn impl

//! excavation hardness

/// default excavation hardness for a rock wall
#define EXCAVATION_HARDNESS_DEFAULT 0

//! excavation weakening

/// default weaken strength to take it up to x below normal hardness
#define EXCAVATION_WEAKEN_DEFAULT 1

//! excavation flags - used in procs AND tools
/// breaks everything in the turf even if it doesn't hit it (artifacts)
#define EXCAVATION_OP_CONCUSSIVE (1<<0)
/// breaks everything it hits (so artifacts)
#define EXCAVATION_OP_PULVERIZING (1<<1)
/// rough tools, can over-dig if hardness is more than material hardness
#define EXCAVATION_OP_COURSE (1<<2)
/// ignore hardness
#define EXCAVATION_OP_ABSOLUTE (1<<3)

DEFINE_BITFIELD(excavation_flags, list(
	BITFIELD(EXCAVATION_OP_CONCUSSIVE),
	BITFIELD(EXCAVATION_OP_PULVERIZING),
	BITFIELD(EXCAVATION_OP_COURSE),
	BITFIELD(EXCAVATION_OP_ABSOLUTE)
))
