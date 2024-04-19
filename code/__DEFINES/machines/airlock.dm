//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* /obj/machinery/airlock_controller/door_state

/// interior doors locked open, exterior doors locked closed
#define AIRLOCK_DOORS_LOCKED_INTERIOR 1
/// exterior doors locked open, interior doors locked closed
#define AIRLOCK_DOORS_LOCKED_EXTERIOR 2
/// all doors locked open
#define AIRLOCK_DOORS_LOCKED_OPEN 3
/// interior doors unlocked, exterior doors locked closed
#define AIRLOCK_DOORS_UNLOCKED_INTERIOR 4
/// exterior doors unlocked, interior doors locked closed
#define AIRLOCK_DOORS_UNLOCKED_EXTERIOR 5
/// all doors unlocked
#define AIRLOCK_DOORS_UNLOCKED 6

//* /obj/machinery/airlock_controller/dock_state

/// we don't have a dock
#define AIRLOCK_DOCK_NONE 0
/// we are undocked
#define AIRLOCK_DOCK_UNDOCKED 1
/// we are docked
#define AIRLOCK_DOCK_DOCKED 2

//* /obj/machinery/airlock_controller/mode_state


//* /obj/machinery/airlock_controller/op_state

/// nothing
#define AIRLOCK_OP_IDLE 0
/// cycling to interior
#define AIRLOCK_OP_CYCLE_IN 1
/// cycling to exterior
#define AIRLOCK_OP_CYCLE_OUT 2
