//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/vehicle/sealed/mecha/draw_module_power_oneoff(obj/item/vehicle_module/module, joules)
	var/penalty = get_power_draw_penalty()
	return power_cell.use(DYNAMIC_J_TO_CELL_UNITS(joules * penalty))

/obj/vehicle/sealed/mecha/draw_component_power_oneoff(obj/item/vehicle_component/component, joules)
	var/penalty = get_power_draw_penalty()
	return power_cell.use(DYNAMIC_J_TO_CELL_UNITS(joules * penalty))

/obj/vehicle/sealed/mecha/draw_sourced_power_oneoff(source, name, joules)
	var/penalty = get_power_draw_penalty()
	return power_cell.use(DYNAMIC_J_TO_CELL_UNITS(joules * penalty))

/obj/vehicle/sealed/mecha/proc/get_power_draw_penalty()
	var/penalty = 1
	if(comp_electrical)
		penalty = max(comp_electrical.get_electrical_draw_penalty(), 1)
	else
		penalty = 1.5
	#warn hook short circuis into this
	return penalty

/obj/vehicle/sealed/mecha/estimate_cell_power_remaining()
	return power_cell ? power_cell.charge : 0

/obj/vehicle/sealed/mecha/get_cell(inducer)
	return power_cell
