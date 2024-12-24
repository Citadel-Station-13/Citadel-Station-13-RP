//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Airlock Sides *//

#define AIRLOCK_SIDE_INTERIOR "interior"
#define AIRLOCK_SIDE_EXTERIOR "exterior"
#define AIRLOCK_SIDE_NEUTRAL "neutral"

#warn DEFINE_ENUM for sensor and controller

//* /obj/machinery/airlock_component/controller/(interior|exterior)_environment_mode

/// detect atmos on tile; autodetects and sets to manual after
#define AIRLOCK_ENVIRONMENT_AUTODETECT "detect"
/// manually specify environment
#define AIRLOCK_ENVIRONMENT_MANUAL "manual"
/// adaptive; continually matches the environment when possible.
#define AIRLOCK_ENVIRONMENT_ADAPTIVE "adaptive"
/// ignore the atmos entirely
#define AIRLOCK_ENVIRONMENT_IGNORE "ignore"

#warn DEFINE_ENUM

//* /obj/machinery/airlock_component/controller/(interior|exterior)_state

/// locked open
#define AIRLOCK_STATE_LOCKED_OPEN 1
/// locked closed
#define AIRLOCK_STATE_LOCKED_CLOSED 2
/// unlocked
#define AIRLOCK_STATE_UNLOCKED 3

#warn DEFINE_ENUM

//*                         used internally as returns from airlock programs                                  *//
//* also used as callback inputs for /obj/machinery/airlock_component/controller/var/datum/callback/on_finish *//

/// still cycling
#define AIRLOCK_CYCLE_STATUS_CONTINUE 0
/// finished cycling
#define AIRLOCK_CYCLE_STATUS_FINISHED 1
/// user aborted cycling
#define AIRLOCK_CYCLE_STATUS_ABORTED 2
/// cycling failed
#define AIRLOCK_CYCLE_STATUS_FAILED 3

//* /obj/machinery/airlock_component/cycler op return codes *//

/// keep cycling
#define AIRLOCK_CYCLER_OP_CONTINUE 1
/// finished
#define AIRLOCK_CYCLER_OP_FINISHED 2
/// unpowered
#define AIRLOCK_CYCLER_OP_NO_POWER 3
/// insufficient air
#define AIRLOCK_CYCLER_OP_NO_GAS 4
/// pumping against too much of a gradient
#define AIRLOCK_CYCLER_OP_HIGH_RESISTANCE 5
/// fatal error
#define AIRLOCK_CYCLER_OP_FATAL 6

//  todo: /datum/airlock_program/dynamic_reconcile  //
//*          below defines are for that.           *//
//  todo: DEFINE_BITFIELD and DEFINE_ENUM as needed //

/// cycle gas ratios; implies EXPEL_UNWANTED_GAS
#define AIRLOCK_DYNAMIC_RECONCILE_MATCH_GAS_RATIOS (1<<0)
/// expel bad gases
#define AIRLOCK_DYNAMIC_RECONCILE_EXPEL_UNWANTED_GAS (1<<1)
/// match pressure; implies REGULATE_PRESSURE
#define AIRLOCK_DYNAMIC_RECONCILE_MATCH_PRESSURE (1<<2)
/// prevent pressure mismatches that result in people dying/flying around
#define AIRLOCK_DYNAMIC_RECONCILE_REGULATE_PRESSURE (1<<3)
/// match temperature; implies REGULATE_TEMPERATURE
#define AIRLOCK_DYNAMIC_RECONCILE_MATCH_TEMPERATURE (1<<4)
/// prevent temperature mismatches that result in people dying/severe area temperature changes
#define AIRLOCK_DYNAMIC_RECONCILE_REGULATE_TEMPERATURE (1<<5)

