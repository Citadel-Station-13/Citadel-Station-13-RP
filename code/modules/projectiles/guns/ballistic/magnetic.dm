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
