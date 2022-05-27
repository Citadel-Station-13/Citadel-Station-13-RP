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
 *
 * FAQ:
 * - "Why is there parentheses vomit everywhere?"
 *     Because order of operations is important and we want our macros to not mess up when someone does, say, capacity - charge in SMES.
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

#define POWER_SCALE_POWER_OF_TEN(S)		((S)*3)

#define POWER_ACCURACY					0.001
#define POWER_QUANTIZE(P)				(round(P, POWER_ACCURACY))

/* CONVERSION HELPERS */
#define WH_TO_J(WH)				(60*60*(WH))
#define KWH_TO_KJ(KWH)			(60*60*(KWH))
#define WH_TO_KJ(WH)			(60*60*((WH)*0.001))
#define KWH_TO_J(KWH)			(60*60*1000*(KWH))	// WARNING: LOSS OF PRECISION LIKELY
#define J_TO_WH(J)				((J)*(1/(60*60)))
#define KJ_TO_WH(KJ)			((KJ)*(1000/(60*60)))
#define KJ_TO_KWH(KJ)			((KJ)*(1/(60*60)))
#define J_TO_KWH(J)				((J)*(1/(60*60*1000)))
#define KW_TO_KWH(KW, T)		((KW*T)*(1/(60*60)))
#define W_TO_WH(W, T)			(((W)*(T))*(1/(60*60)))
#define W_TO_KWH(W, T)			(((W)*(T)*0.001)*(1/(60*60)))
#define KW_TO_WH(KW, T)			(((KW)*(T)*1000)*(1/(60*60)))
// watt minutes - why you'd do this is beyond me
#define WH_TO_WM(WH)			((WH)*60)
#define KWH_TO_WM(KWH)			((KWH)*60*1000)
#define KWH_TO_KWM(KWH)			((KWH)*60)
#define WWH_TO_KWM(WH)			((WH)*60*0.001)
#define W_TO_WM(W, T)			(((W)*(T))*(1/60))
#define KW_TO_WM(KW, T)			(((KW)*(T)*1000)*(1/60))
#define W_TO_KWM(W, T)			(((W)*(T)*0.001)*(1/60))
#define KW_TO_KWM(KW, T)		(((KW)*(T))*(1/60))
#define KJ_TO_KWM(KJ)			((KJ)*(1/60))
#define J_TO_KWM(J)				(((J)*0.001)*(1/60))
#define KJ_TO_WM(KJ)			((KJ)*(1000/60))
#define J_TO_WM(J)				((J)*(1/60))
#define KWM_TO_J(KWM)			((KWM)*(60*1000))
#define KWM_TO_KJ(KWM)			((KWM)*60)
#define WM_TO_J(WM)				((WM)*60)
#define WM_TO_KJ(WM)			((WM)*(60*0.001))
#define KWM_TO_KW(KWM, T)		(((KWM)*60)/(T))
#define KWM_TO_W(KWM, T)		(((KWM)*60)*(1000/(T)))
#define WM_TO_W(WM, T)			(((WM)*60)/(T))
#define WM_TO_KW(WM, T)			(((WM)*(60*0.001))/(T))

/proc/render_power_unit(unit)
	switch(unit)
		if(ENUM_POWER_UNIT_GENERIC)
			return "u"
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
/proc/render_power(amount, power_scale = ENUM_POWER_SCALE_NONE, unit = ENUM_POWER_UNIT_GENERIC, accuracy = POWER_ACCURACY, conversion = TRUE)
	if(!conversion)
		return "[round(amount, accuracy)] [render_power_scale(power_scale)][render_power_unit(unit)]"
	if(amount <= 0)
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
#define SMES_COIL_STORAGE_BASIC				(100)
#define SMES_COIL_FLOW_BASIC				(250)
#define SMES_COIL_STORAGE_WEAK				(20)
#define SMES_COIL_FLOW_WEAK					(150)
#define SMES_COIL_STORAGE_TRANSMISSION		(10)
#define SMES_COIL_FLOW_TRANSMISSION			(1000)
#define SMES_COIL_STORAGE_CAPACITANCE		(1000)
#define SMES_COIL_FLOW_CAPACITANCE			(50)

/**
 * OLD CALCS
 * translates Watt into Kilowattminutes with respect to machinery schedule_interval ~(2s*1W*1min/60s)
 * #define SMESRATE 0.03333
 * #define SMESMAXCHARGELEVEL 250000
 * #define SMESMAXOUTPUT 250000
 */

/* cells */
// Cells practically use their own power systems
// "Use power from cell" for **handheld/portable devices**, semantically, should always use cell units and not a "real unit"
// This way we can tweak balance with just cellrate.

// dynamic indicates this isn't constant

#define DYNAMIC_KJ_TO_CELL_UNITS(KJ)		((KJ) / GLOB.cellrate)
#define DYNAMIC_J_TO_CELL_UNITS(J)			(((J) * 0.001) / GLOB.cellrate)
#define DYNAMIC_CELL_UNITS_TO_KJ(U)			((U) * GLOB.cellrate)
#define DYNAMIC_CELL_UNITS_TO_J(U)			((U) * (1000 * GLOB.cellrate))
/// dt in seconds
#define DYNAMIC_W_TO_CELL_UNITS(W, DT)		(DYNAMIC_J_TO_CELL_UNITS(W) * (DT))
/// dt in seconds
#define DYNAMIC_KW_TO_CELL_UNITS(KW, DT)	(DYNAMIC_KJ_TO_CELL_UNITS(KW) * (DT))
/// dt in "seconds this will be drained over" - usually 1
#define DYNAMIC_CELL_UNITS_TO_W(U, DT)		(DYNAMIC_CELL_UNITS_TO_J(U) / (DT))
/// dt in "seconds this will sbe drained over" - usually 1
#define DYNAMIC_CELL_UNITS_TO_KW(U, DT)		(DYNAMIC_CELL_UNITS_TO_KJ(U) / (DT))
#define DYNAMIC_WH_TO_CELL_UNITS(WH)		((3.6 * (WH)) / GLOB.cellrate)
#define DYNAMIC_KWH_TO_CELL_UNITS(KWH)		((3600 * (KWH)) / GLOB.cellrate)
#define DYNAMIC_CELL_UNITS_TO_KWH(U)		(((U) * GLOB.cellrate) / (60 * 60))
#define DYNAMIC_CELL_UNITS_TO_WH(U)			(((U) * GLOB.cellrate) / ((60 * 60) / 1000))
#define DYNAMIC_KWM_TO_CELL_UNITS(KWM)		(((KWM) * 60) / GLOB.cellrate)
#define DYNAMIC_WM_TO_CELL_UNITS(WM)		(((WM) * (60 / 1000)) / GLOB.cellrate)
#define DYNAMIC_CELL_UNITS_TO_KWM(U)		(((U) * GLOB.cellrate) / (60))
#define DYNAMIC_CELL_UNITS_TO_WM(U)			(((U) * GLOB.cellrate) / (60 / 1000))

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

/**
 * OLD CALCS FOR ABOVE
 * Multiplier for watts per tick <> cell storage (e.g., 0.02 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
 * = 50Ws/u
 * #define CELLRATE 0.002 // It's a conversion constant. power_used*CELLRATE = charge_provided, or charge_used/CELLRATE = power_provided
 */

/**
 * misc
 */

#define THERMOMACHINE_CHEAT_FACTOR						2.5
#define RECHARGER_CHEAT_FACTOR							5
#define SYNTHETIC_NUTRITION_KJ_PER_UNIT					10
#define SYNTHETIC_NUTRITION_INDUCER_CHEAT_FACTOR		2
#define CYBORG_POWER_USAGE_MULTIPLIER					2
#define SPACE_HEATER_CHEAT_FACTOR						1.5
#define THERMOREGULATOR_CHEAT_FACTOR					5

/**
 * LEGACY ENUMS
 *
 * D O N O T U S E T H E S E
 *
 * The only exception is kilowatts, since machines/apcs opeate on units scale, meaning 1 to 16 million are reasonable!
 * However when you get to "MEGAWATTS" you are cutting it way too close to comfort
 * If something uses more than 1 MW it shouldn't be APC wired at all!
 */
#define KILOWATTS			* 1000
#define MEGAWATTS			* 1000000

/**
 * BALANCING - CELL AND EQUIPMENT
 */
/// cost of shield difussion
#define CELL_COST_SHIELD_DIFFUSION			120

/**
 * BALANCING - MACHINERY POWER
 */
