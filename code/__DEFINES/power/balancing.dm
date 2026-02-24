//? master file for balancing / efficiency tuning

//* Cells

#define CELLRATE_DEFAULT 0.5

/**
 * current calculations
 * cellrate 0.5 = 0.5 kj/unit
 * for 10k cell, 5000kj
 * 1 Wh = 60J-S*60s/m = 3600J = 3.6kJ
 * 10k cell --> 1388.89 Wh
 * damn, future cells be pogging
 *
 * * Funnily enough, this puts our cells at just about ~10x the capacity of modern day cells.
 *   That's pretty reasonable given they're meant to power energy weapons and hilariously
 *   sci-fi technologies.
 */

#define DEFAULT_CELLRATE 0.5
/// the closest thing we'll get to a cvar - cellrate is kJ per cell unit. kJ to avoid float precision loss.
GLOBAL_VAR_INIT(cellrate, DEFAULT_CELLRATE)

/// Divisible by 1, 2, 3.
#define POWER_CELL_CAPACITY_BASE 1200

/// base
/// * this is a default; power cell datums can override this
#define POWER_CELL_MULTIPLIER_SMALL 2
/// vs small is 100% space-efficient
/// * this is a default; power cell datums can override this
#define POWER_CELL_MULTIPLIER_WEAPON 4
/// vs weapon is 125% space-efficient
/// * this is a default; power cell datums can override this
#define POWER_CELL_MULTIPLIER_MEDIUM 10
/// vs medium is 150% space-efficient
/// * this is a default; power cell datums can override this
#define POWER_CELL_MULTIPLIER_LARGE 30

/// * only provided for completeness; many cell types have more capacity than this.
#define POWER_CELL_CAPACITY_SMALL (POWER_CELL_CAPACITY_BASE * POWER_CELL_MULTIPLIER_SMALL)
/// * only provided for completeness; many cell types have more capacity than this.
#define POWER_CELL_CAPACITY_MEDIUM (POWER_CELL_CAPACITY_BASE * POWER_CELL_MULTIPLIER_MEDIUM)
/// * only provided for completeness; many cell types have more capacity than this.
#define POWER_CELL_CAPACITY_LARGE (POWER_CELL_CAPACITY_BASE * POWER_CELL_MULTIPLIER_LARGE)
/// * only provided for completeness; many cell types have more capacity than this.
#define POWER_CELL_CAPACITY_WEAPON (POWER_CELL_CAPACITY_BASE * POWER_CELL_MULTIPLIER_WEAPON)

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
