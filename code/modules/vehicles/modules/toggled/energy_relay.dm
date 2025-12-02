//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/vehicle_module/toggled/energy_relay
	name = "energy relay"
	desc = "A wireless energy tap that siphons power from the nearest APC. The efficiency is quite low."
	#warn sprite; "tesla"?

	vehicle_encumbrance = 2.5
	module_slot = VEHICLE_MODULE_SLOT_UTILITY

	/// multiplier for power pulled to give to cell
	var/pull_efficiency = 0.5
	/// in watts
	var/pull_power = 5000
	/// power channel to pull from
	var/pull_power_channel = EQUIP

/obj/item/vehicle_module/toggled/energy_relay/on_activate(datum/event_args/actor/actor, silent)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/vehicle_module/toggled/energy_relay/on_deactivate(datum/event_args/actor/actor, silent)
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/vehicle_module/toggled/energy_relay/process(delta_time)
	if(!active)
		return PROCESS_KILL
	if(!vehicle)
		return PROCESS_KILL
	// TODO: generic API for this, don't use get_cell **or** inducer_scan.
	// TODO: this entirely bypasses the mech's electrical harness, but we can't make that
	//       work because /vehicle level doesn't have it ):
	var/obj/item/cell/maybe_cell = vehicle.get_cell()
	if(!maybe_cell)
		return
	var/area/maybe_area = get_area(vehicle)
	if(!maybe_area)
		return
	if(!maybe_area.powered(pull_power_channel))
		return
	var/missing_units = maybe_cell.maxcharge - maybe_cell.charge
	var/missing = DYNAMIC_CELL_UNITS_TO_W(missing_units, delta_time)
	var/draw = min(missing, pull_power)
	var/drawn = maybe_area.use_power_oneoff(draw, pull_power_channel)
	maybe_cell.give(DYNAMIC_W_TO_CELL_UNITS(drawn, delta_time))
