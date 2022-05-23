/**
 * **MASTER POWER/BALANCING FILE**
 *
 * floating point only goes up to 16 million for precision
 *
 * hence, everything uses its own units and converts around
 * mostly, anyways
 * there is a standard use power proc that is "universal"-ish, which uses kJ, as that's the best "center" for one-off uses, or ticked uses.
 *
 * WARNING:
 * You CANNOT JUST CHANGE THE UNITS.
 * Math is usually hardcoded for performance, and because things like storage units require a "time" factor for conversion.
 */

// DO NOT TOUCH THESE UNLESS YOU KNOW WHAT YOU ARE DOING
#define ENUM_POWER_UNIT_GENERIC			0
#define ENUM_POWER_UNIT_JOULE			1
#define ENUM_POWER_UNIT_WATT			2
#define ENUM_POWER_UNIT_WATT_HOUR		3

// DO NOT TOUCH THESE UNLESS YOU KNOW WHAT YOU ARE DOING
#define ENUM_POWER_SCALE_NONE			0
#define ENUM_POWER_SCALE_KILO			1
#define ENUM_POWER_SCALE_MEGA			2
#define ENUM_POWER_SCALE_GIGA			3
#define ENUM_POWER_SCALE_TERA			4
#define ENUM_POWER_SCALE_PETA			5

#define POWER_SCALE_POWER_OF_TEN(S)		(S*3)

#define POWER_ACCURACY					0.001
#define POWER_QUANTIZE(P)				(round(P, POWER_ACCURACY))

/* CONVERSION HELPERS */
#define WH_TO_J(WH)				(60*60*WH)
#define KWH_TO_KJ(KWH)			(60*60*KWH)
#define WH_TO_KJ(WH)			(60*60*(WH*0.001)
#define KWH_TO_J(KWH)			(60*60*1000*KWH)	// WARNING: LOSS OF PRECISION LIKELY
#define J_TO_WH(J)				(J*(1/(60*60)))
#define KJ_TO_WH(KJ)			(KJ*(1000/(60*60)))
#define KJ_TO_KWH(KJ)			(KJ*(1/(60*60)))
#define J_TO_KWH(J)				(J*(1/(60*60*1000)))

/proc/render_power_unit(unit)
	switch(unit)
		if(ENUM_POWER_UNIT_GENERIC)
			return ""
		if(ENUM_POWER_UNIT_JOULE)
			return "J"
		if(ENUM_POWER_UNIT_WATT)
			return "W"
		if(ENUM_POWER_UNIT_WATT_HOUR)
			return "Wh"

/proc/render_power_scale(scale)
	switch(scale)
		if(ENUM_POWER_SCALE_NONE)
			return ""
		if(ENUM_POWER_SCALE_KILO)
			return "k"
		if(ENUM_POWER_SCALE_MEGA)
			return "M"
		if(ENUM_POWER_SCALE_GIGA)
			return "G"
		if(ENUM_POWER_SCALE_TERA)
			return "T"
		if(ENUM_POWER_SCALE_PETA)
			return "P"

/**
 * renders power unit
 */
/proc/render_power(amount, power_scale = ENUM_POWER_SCALE_NONE, unit = ENUM_POWER_UNIT_GENERIC, conversion = TRUE, accuracy = POWER_ACCURACY)
	if(!conversion)
		return "[round(amount, accuracy)] [render_power_scale(power_scale)][render_power_unit(unit)]"
	if(!amount)
		return "0 [render_power_unit(unit)]"
	if(amount > 1000)
		while(amount > 1000)
			amount *= 0.001
			++power_scale
	else if(amount < 0)
		while(amount < 0)
			amount *= 1000
			--power_scale
	return "[round(amount, accuracy)] [render_power_scale(power_scale)][render_power_unit(unit)]"

/* universal */
/// used in drain_energy, use_energy
#define POWER_UNIT_UNIVERSAL_ENERGY			ENUM_POWER_UNIT_JOULE
/// used in use_power
#define POWER_UNIT_UNIVERSAL_FLOW			ENUM_POWER_UNIT_WATT

/* power grid aka /datum/powernet */
#define POWER_UNIT_GRID_FLOW				ENUM_POWER_UNIT_WATT
#define POWER_SCALE_GRID_FLOW				ENUM_POWER_SCALE_KILO

/* SMES */
#define POWER_UNIT_GRID_STORAGE				ENUM_POWER_UNIT_WATT_HOUR
#define POWER_SCALE_GRID_STORAGE			ENUM_POWER_SCALE_KILO

// coil values are at grid storage scales
#define SMES_COIL_STORAGE_BASIC				(250)
#define SMES_COIL_FLOW_BASIC				(250)
#define SMES_COIL_STORAGE_WEAK				(50)
#define SMES_COIL_FLOW_WEAK					(150)
#define SMES_COIL_STORAGE_TRANSMISSION		(10)
#define SMES_COIL_FLOW_TRANSMISSION			(1000)
#define SMES_COIL_STORAGE_CAPACITANCE		(1000)
#define SMES_COIL_FLOW_CAPACITANCE			(50)

/* cells */
// Cells practically use their own power systems
// "Use power from cell" for **handheld/portable devices**, semantically, should always use cell units and not a "real unit"
// This way we can tweak balance with just cellrate.

// dynamic indicates this isn't constant

#define DYNAMIC_KJ_TO_CELL_UNITS(KJ)		(KJ / GLOB.cellrate)
#define DYNAMIC_J_TO_CELL_UNITS(J)			((J * 0.001) / GLOB.cellrate)
/// dt in seconds
#define DYNAMIC_W_TO_CELL_UNITS(W, DT)		(DYNAMIC_J_TO_CELL_UNITS(W) * DT)
/// dt in seconds
#define DYNAMIC_KW_TO_CELL_UNITS(KW, DT)	(DYNAMIC_KJ_TO_CELL_UNITS(KW) * DT)
#define DYNAMIC_WH_TO_CELL_UNITS(WH)		((0.36 * WH) / GLOB.cellrate)
#define DYNAMIC_KWH_TO_CELL_UNITS(KWH)		((3600 * KWH) / GLOB.cellrate)

/// the closest thing we'll get to a cvar - cellrate is kJ per cell unit. kJ to avoid float precision loss.
GLOBAL_VAR_INIT(cellrate, 0.05)

/**
 * OLD CALCS FOR ABOVE
 * Multiplier for watts per tick <> cell storage (e.g., 0.02 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
 * = 50Ws/u
 * 1000u -> 50000Ws -> 138.889 Wh
 * 1200u -> 166.667 Wh
 * #define CELLRATE 0.002 // It's a conversion constant. power_used*CELLRATE = charge_provided, or charge_used/CELLRATE = power_provided
 */

/**
 * misc
 */

#define THERMOMACHINE_CHEAT_FACTOR			2.5
#define RECHARGER_CHEAT_FACTOR				5
