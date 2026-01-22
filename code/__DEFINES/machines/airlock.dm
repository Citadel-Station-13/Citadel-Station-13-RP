//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* airlock sides *//

#define AIRLOCK_SIDE_INTERIOR "interior"
#define AIRLOCK_SIDE_EXTERIOR "exterior"
#define AIRLOCK_SIDE_NEUTRAL "neutral"

#warn DEFINE_ENUM for sensor and controller

//* airlock cycler operation return codes *//

/// worked
#define AIRLOCK_CYCLER_OP_SUCCESS 0
/// fatal error
#define AIRLOCK_CYCLER_OP_FATAL 1
/// unpowered
#define AIRLOCK_CYCLER_OP_NO_POWER 2
/// insufficient air
#define AIRLOCK_CYCLER_OP_NO_GAS 3
/// pumping against too much of a gradient
#define AIRLOCK_CYCLER_OP_HIGH_RESISTANCE 4
/// literally a machine is missing
#define AIRLOCK_CYCLER_OP_MISSING_COMPONENT 5

//* airlock cycle finish status *//

#define AIRLOCK_CYCLE_FIN_SUCCESS 0
#define AIRLOCK_CYCLE_FIN_FAILED 1
#define AIRLOCK_CYCLE_FIN_ABORTED 2
