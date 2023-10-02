//! all flags related to buckling
/// force - just do it, ignore all checks
#define BUCKLE_OP_FORCE							(1<<0)
/// ignore loc
#define BUCKLE_OP_IGNORE_LOC					(1<<1)
/// don't tell people in chat
#define BUCKLE_OP_SUPPRESS_WARNING				(1<<2)
/// don't make sounds
#define BUCKLE_OP_SUPPRESS_SOUND				(1<<3)
/// is from a default (drag drop, click, etc) interaction
#define BUCKLE_OP_DEFAULT_INTERACTION			(1<<4)
/// don't make ANY feedback
#define BUCKLE_OP_SILENT						(BUCKLE_OP_SUPPRESS_WARNING | BUCKLE_OP_SUPPRESS_SOUND)

//! semantic argument passed into buckling procs
//! these are often specific to a use case.
//! if provided, it'll be stored in buckle_mobs.

/// only used in riding handlers - we are the person/thing being ridden on
#define BUCKLE_SEMANTIC_WE_ARE_THE_VEHICLE			"_vehicle_"
/// attempt to carry piggyback someone
#define BUCKLE_SEMANTIC_HUMAN_PIGGYBACK				"piggyback"
/// attempt to carry fireman someone
#define BUCKLE_SEMANTIC_HUMAN_FIREMAN				"fireman"

//! Misc
#define HUMAN_FIREMAN_DELAY						(5 SECONDS)
#define HUMAN_PIGGYBACK_DELAY					(3 SECONDS)
