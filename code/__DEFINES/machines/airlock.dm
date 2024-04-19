//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* /obj/machinery/airlock_controller/(interior|exterior)_state

/// locked open
#define AIRLOCK_STATE_LOCKED_OPEN 1
/// locked closed
#define AIRLOCK_STATE_LOCKED_CLOSED 2
/// unlocked
#define AIRLOCK_STATE_UNLOCKED 3

//* /obj/machinery/airlock_controller/dock_state

/// we don't have a dock
#define AIRLOCK_DOCK_NONE 0
/// we are undocked
#define AIRLOCK_DOCK_UNDOCKED 1
/// we are docked
#define AIRLOCK_DOCK_DOCKED 2
/// we are undocking
#define AIRLOCK_DOCK_UNDOCKING 3
/// we are docking
#define AIRLOCK_DOCK_DOCKING 4
/// we are in an invalid / aborted state
#define AIRLOCK_DOCK_UNKNOWN 5
/// we are overridden
#define AIRLOCK_DOCK_OVERRIDDN 6

//* /obj/machinery/airlock_controller/mode_state

/// security lockdown
#define AIRLOCK_MODE_LOCKDOWN 0
/// normal - allow cycling in / out
#define AIRLOCK_MODE_NORMAL 1
/// docking - the dock handles operations
#define AIRLOCK_MODE_DOCK 2

#warn impl

//* /obj/machinery/airlock_controller/op_state

/// nothing
#define AIRLOCK_OP_IDLE 0
/// cycling to interior
#define AIRLOCK_OP_CYCLE_IN 1
/// cycling to exterior
#define AIRLOCK_OP_CYCLE_OUT 2
