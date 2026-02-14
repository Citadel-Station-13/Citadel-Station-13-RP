//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* airlock sides *//

#define AIRLOCK_SIDE_INTERIOR "interior"
#define AIRLOCK_SIDE_EXTERIOR "exterior"
#define AIRLOCK_SIDE_NEUTRAL "neutral"
#define AIRLOCK_SIDE_BOTH "both"

// TODO: DECLARE_ENUM for sensor / controller

//* airlock cycler operation return codes *//

/// worked
#define AIRLOCK_CYCLER_OP_SUCCESS 0
/// fatal error
#define AIRLOCK_CYCLER_OP_FATAL (1<<0)
/// unpowered
#define AIRLOCK_CYCLER_OP_NO_POWER (1<<1)
/// insufficient air
#define AIRLOCK_CYCLER_OP_NO_GAS (1<<2)
/// pumping against too much of a gradient
#define AIRLOCK_CYCLER_OP_HIGH_RESISTANCE (1<<3)
/// literally a machine is missing
#define AIRLOCK_CYCLER_OP_MISSING_COMPONENT (1<<4)

#define AIRLOCK_CYCLER_OP_MAX_BIT 4

GLOBAL_REAL_LIST(airlock_cycler_op_desc_lookup) = list(
	"fatal error",
	"no power",
	"no gas",
	"high resistance",
	"missing machine",
)

//* airlock cycle finish status *//

#define AIRLOCK_CYCLE_FIN_SUCCESS 0
#define AIRLOCK_CYCLE_FIN_FAILED 1
#define AIRLOCK_CYCLE_FIN_ABORTED 2

//* airlock phase setup status *//

#define AIRLOCK_PHASE_SETUP_FAIL 0
#define AIRLOCK_PHASE_SETUP_SUCCESS 1
#define AIRLOCK_PHASE_SETUP_SKIP 2

// * airlock phase tick status *//

#define AIRLOCK_PHASE_TICK_ERROR 0
#define AIRLOCK_PHASE_TICK_CONTINUE 1
#define AIRLOCK_PHASE_TICK_FINISH 2

//* airlock system blackboard keys *//

/**
 * Blackboard for currently cycled-to side, so that programs
 * know to seal / drain from / to the correct side on cycle.
 * * Valid options are 'null', or an AIRLOCK_SIDE_* define.
 */
#define AIRLOCK_SYSTEM_BLACKBOARD_CURRENT_SIDE "current_side"
/**
 * Blackboard for if a given side's doors should be locked open / closed
 * * TRUE = open, FALSE = closed, null = not locked
 */
#define AIRLOCK_SYSTEM_BLACKBOARD_INTERIOR_DOOR_LOCKED_STATE "interior_locked_val"
/**
 * Blackboard for if a given side's doors should be locked open / closed
 * * TRUE = open, FALSE = closed, null = not locked
 */
#define AIRLOCK_SYSTEM_BLACKBOARD_EXTERIOR_DOOR_LOCKED_STATE "exterior_locked_val"

//* airlock cycling blackboard keys *//

// none yet //
