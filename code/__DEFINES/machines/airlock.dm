//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Airlock Sides *//

#define AIRLOCK_SIDE_INTERIOR "interior"
#define AIRLOCK_SIDE_EXTERIOR "exterior"
#define AIRLOCK_SIDE_NEUTRAL "neutral"

#warn DEFINE_ENUM for sensor and controller

#warn below

//* Airlock Program - Dynamic *//

/// vacuum mode only
#define AIRLOCK_DYNAMIC_PROGRAM_PHASE_VACUUM_DRAIN_TO_

#define AIRLOCK_DYNAMIC_PROGRAM_PHASE_SEALING "sealing"
#define AIRLOCK_DYNAMIC_PROGRAM_PHASE_UNSEALING "unsealing"

#define AIRLOCK_DYNAMIC_PROGRAM_PHASE_CURTAIN_RECONCILE "reconcile"



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
