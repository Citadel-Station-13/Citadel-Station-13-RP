//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//? master file for balancing / efficiency tuning

//* Cells

/// the closest thing we'll get to a cvar - cellrate is kJ per cell unit. kJ to avoid float precision loss.
GLOBAL_VAR_INIT(cellrate, 0.5)
/**
 * current calculations
 * cellrate 0.5 = 0.5 kj/unit
 * for 10k cell, 5000kj
 * 1 Wh = 60J-S*60s/m = 3600J = 3.6kJ
 * 10k cell --> 1388.89 Wh
 * damn, future cells be pogging
 */
/// the closest thing we'll get to a cvar - affects cell use_scaled - higher = things use less energy. handheld devices usually use this.
GLOBAL_VAR_INIT(cellefficiency, 1)

//* Computers

/// Idle usage of a mid-range control computer in watts
#define POWER_USAGE_COMPUTER_MID_IDLE 50
/// Active usage of a mid-range control computer in watts
#define POWER_USAGE_COMPUTER_MID_ACTIVE 500

//* Equipment

/// cost of shield difussion in cell units
#define CELL_COST_SHIELD_DIFFUSION			120

//* Machinery

/// idle power usage of a lathe in watts
#define POWER_USAGE_LATHE_IDLE 25
/// active power usage of lathe scaling to decisecond work unit (e.g. 4x speed lathe is 4 for input) in watts
#define POWER_USAGE_LATHE_ACTIVE_SCALE(factor) (factor * 1000)
/// Idle usage of a nanite chamber in watts
#define POWER_USAGE_NANITE_CHAMBER_IDLE 100
/// Active usage of a nanite chamber in watts
#define POWER_USAGE_NANITE_CHAMBER_ACTIVE 5000

//* Misc

//#define THERMOMACHINE_CHEAT_FACTOR						1
#define RECHARGER_CHEAT_FACTOR							5
#define SYNTHETIC_NUTRITION_KJ_PER_UNIT					10
#define SYNTHETIC_NUTRITION_INDUCER_CHEAT_FACTOR		2
#define CYBORG_POWER_USAGE_MULTIPLIER					2
#define SPACE_HEATER_CHEAT_FACTOR						1.5
#define THERMOREGULATOR_CHEAT_FACTOR					5
