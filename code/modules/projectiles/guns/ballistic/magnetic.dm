//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun/ballistic/magnetic
	cell_system = TRUE
	cell_system_legacy_use_device = TRUE
	cell_type = /obj/item/cell/device/weapon

	/// base power draw per shot
	///
	/// * in kilojoules
	var/base_shot_power = (/obj/item/cell/device/weapon::maxcharge * 0.5) / INFINITY

#warn impl all
