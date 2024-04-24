//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/obj/machinery/airlock_peripheral/vent
	name = "airlock vent"
	desc = "A large vent used in an airlock to dispel unwanted waste gases and use as a heat source/sink."

	#warn sprite

	/// are we allowed to vent gas?
	var/allow_gas_venting = TRUE
	/// are we allowed to siphon gas?
	var/allow_gas_siphon = TRUE
	/// are we allowed to vent heat?
	var/allow_heat_venting = TRUE
	/// are we allowed to siphon heat?
	var/allow_heat_siphon = TRUE

#warn impl
