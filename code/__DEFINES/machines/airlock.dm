//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* /obj/machinery/airlock_component/controller/config_cycle_mode

/// 'classic' airlock behavior; siphon all air and replace as needed
///
/// the least non-deterministic at not wasting gas, because all gas
/// is allowed to go through the reclamation cycle.
#define AIRLOCK_CONFIG_MODE_CLASSIC "classic"
/// 'dynamic' airlocks; shunts air towards desired state
///
/// allows the usage of interior / exterior toggles, and minimum tolerable
/// pressures, but is a heuristic algorithm
///
/// not recommended for use in air-constrained environments.
#define AIRLOCK_CONFIG_MODE_DYNAMIC "dynamic"

#warn DEFINE_ENUM

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

//* /obj/machinery/airlock_component/controller/config_dynamic_(interior|exterior)_toggles

/// cycle gas ratios; implies EXPEL_UNWANTED_GAS
#define AIRLOCK_CONFIG_TOGGLE_MATCH_GAS_RATIOS (1<<0)
/// expel bad gases
#define AIRLOCK_CONFIG_TOGGLE_EXPEL_UNWANTED_GAS (1<<1)
/// match pressure; implies REGULATE_PRESSURE
#define AIRLOCK_CONFIG_TOGGLE_MATCH_PRESSURE (1<<2)
/// prevent pressure mismatches that result in people dying/flying around
#define AIRLOCK_CONFIG_TOGGLE_REGULATE_PRESSURE (1<<3)
/// match temperature; implies REGULATE_TEMPERATURE
#define AIRLOCK_CONFIG_TOGGLE_MATCH_TEMPERATURE (1<<4)
/// prevent temperature mismatches that result in people dying/severe area temperature changes
#define AIRLOCK_CONFIG_TOGGLE_REGULATE_TEMPERATURE (1<<5)

#warn DEFINE_BITFIELD

//* /obj/machinery/airlock_component/controller/(interior|exterior)_state

/// locked open
#define AIRLOCK_STATE_LOCKED_OPEN 1
/// locked closed
#define AIRLOCK_STATE_LOCKED_CLOSED 2
/// unlocked
#define AIRLOCK_STATE_UNLOCKED 3

#warn DEFINE_ENUM

//* Airlock Sides

#define AIRLOCK_SIDE_INTERIOR "interior"
#define AIRLOCK_SIDE_EXTERIOR "exterior"

//* /obj/machinery/airlock_component/controller/(cycle_state|aborted_state)

#define AIRLOCK_CYCLE_INACTIVE "inactive"

// for classic / replace //

/// currently draining existing air
#define AIRLOCK_CYCLE_CLASSIC_DRAIN "classic-drain"
/// currently refilling with desired air
#define AIRLOCK_CYCLE_CLASSIC_REPLACE "classic-fill"

// for dynamic //

/// currently equalizing air
#define AIRLOCK_CYCLE_DYNAMIC_EQUALIZATION "dynamic"

#warn DEFINE_ENUM

//* callback inputs for /obj/machinery/airlock_component/controller/var/datum/callback/on_finish

#define AIRLOCK_OP_STATUS_FINISHED 1
#define AIRLOCK_OP_STATUS_ABORTED 2
#define AIRLOCK_OP_STATUS_FAILED 3

//* returns from airlock peripherals on cycling operations to communicate if it is working

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

#warn eval below

//* /obj/machinery/airlock_component/controller/dock_state

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

