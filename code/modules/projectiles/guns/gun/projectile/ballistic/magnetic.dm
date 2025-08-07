//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun/projectile/ballistic/magnetic
	cell_system = TRUE
	cell_system_legacy_use_device = TRUE
	cell_type = /obj/item/cell/device/weapon

	modular_component_slots = list(
		GUN_COMPONENT_ACCELERATION_COIL = 1,
		GUN_COMPONENT_ACTIVE_COOLER = 1,
		GUN_COMPONENT_ENERGY_HANDLER = 1,
		GUN_COMPONENT_POWER_UNIT = 1,
	)

	/// base power draw per shot in cell units
	var/base_charge_cost = /obj/item/cell/device/weapon::maxcharge * (1 / 24)

	/// Render battery state.
	///
	/// * Uses MAGNETIC_RENDER_BATTERY_* enums
	var/render_battery_overlay = MAGNETIC_RENDER_BATTERY_NEVER

/obj/item/gun/projectile/ballistic/magnetic/prime_casing(datum/gun_firing_cycle/cycle, obj/item/ammo_casing/casing, casing_primer)
	var/shot_power_draw = base_charge_cost * casing.casing_effective_mass_multiplier
	if(!obj_cell_slot.check_charge(shot_power_draw))
		casing_primer = CASING_PRIMER_CHEMICAL
	else
		casing_primer = CASING_PRIMER_CHEMICAL | CASING_PRIMER_MAGNETIC
	. = ..()
	if(!isnum(.))
		obj_cell_slot.use(shot_power_draw)

/obj/item/gun/projectile/ballistic/magnetic/update_icon()
	. = ..()
	switch(render_battery_overlay)
		if(MAGNETIC_RENDER_BATTERY_BOTH)
			if(obj_cell_slot?.cell)
				add_overlay("[base_icon_state]-battery-in")
			else
				add_overlay("[base_icon_state]-battery-out")
		if(MAGNETIC_RENDER_BATTERY_IN)
			if(obj_cell_slot?.cell)
				add_overlay("[base_icon_state]-battery")
		if(MAGNETIC_RENDER_BATTERY_OUT)
			if(!obj_cell_slot?.cell)
				add_overlay("[base_icon_state]-battery")
