//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: buildable

/obj/machinery/airlock_component/cycler
	name = "airlock cycler"
	desc = "A set of machinery used for manipulating the atmosphere inside of an airlock. Doubles as a gas sensor."
	#warn sprite

	/// does pumping with gradient (favorable) require power
	var/thermal_favorable_requires_power = FALSE
	/// power efficiency of favorable regulation; 10 = takes 1 joule to move 10 joules of heat
	var/thermal_favorable_efficiency = THERMODYNAMICS_AIRLOCK_HEAT_PUMP_EFFICIENCY_FAVORABLE
	/// power efficiency of unfavorable regulation; 10 = takes 1 joule to move 10 joules of heat
	var/thermal_unfavorable_efficiency = THERMODYNAMICS_AIRLOCK_HEAT_PUMP_EFFICIENCY_UNFAVORABLE
	/// power efficiency of electric heating. > 1 breaks thermodynamics but that's fine
	var/thermal_electrical_heating_efficiency = THERMODYNAMICS_AIRLOCK_ELECTRIC_HEATING_EFFICIENCY
	/// thermal pumping or heating power in kw
	var/thermal_power = 50

	/// pumping power in kw
	var/pumping_power = 50

	/// last status during cycling
	var/last_op_status

#warn impl

/obj/machinery/airlock_component/cycler/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
