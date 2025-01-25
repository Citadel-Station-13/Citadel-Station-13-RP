//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun/ballistic/magnetic
	cell_system = TRUE
	cell_system_legacy_use_device = TRUE
	cell_type = /obj/item/cell/device/weapon

	/// base power draw per shot
	///
	/// * in kilojoules
	var/base_shot_power = /obj/item/cell/device/weapon::maxcharge * (1 / 24)

	/// Render battery state.
	///
	/// * Uses MAGNETIC_RENDER_BATTERY_* enums
	#warn impl
	var/render_battery_overlay = MAGNETIC_RENDER_BATTERY_NEVER

#warn impl all

/obj/item/gun/ballistic/magnetic/prime_casing(datum/gun_firing_cycle/cycle, obj/item/ammo_casing/casing, casing_primer)
	var/shot_power_draw = base_shot_power * casing.effective_mass_multiplier
	if(!obj_cell_slot.check_charge(shot_power_draw))
		casing_primer = CASING_PRIMER_CHEMICAL
	. = ..()
	if(!isnum(.))
		obj_cell_slot.use(shot_power_draw)
