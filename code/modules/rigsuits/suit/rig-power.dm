//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/rig/proc/process_power(dt)
	power_main_bus.tick(dt)
	power_aux_bus.tick(dt)
