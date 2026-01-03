//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/vehicle/sealed/mecha/examine_render_components(datum/event_args/examine/examine)
	. = ..()
	if(comp_armor)
		. += comp_armor.examine_render_on_vehicle(examine)
	else
		. += "It has no armor plating."
	if(comp_hull)
		. += comp_hull.examine_render_on_vehicle(examine)
	else
		. += "It has no hull paneling."

/obj/vehicle/sealed/mecha/exists_hardcoded_slot_for_component(obj/item/vehicle_component/v_comp)
	if(istype(v_comp, /obj/item/vehicle_component/plating/mecha_armor))
		return TRUE
	else if(istype(v_comp, /obj/item/vehicle_component/plating/mecha_hull))
		return TRUE
	else if(istype(v_comp, /obj/item/vehicle_component/mecha_actuator))
		return TRUE
	else if(istype(v_comp, /obj/item/vehicle_component/mecha_electrical))
		return TRUE
	else if(istype(v_comp, /obj/item/vehicle_component/mecha_gas))
		return TRUE
	return ..()

/obj/vehicle/sealed/mecha/has_free_hardcoded_slot_for_component(obj/item/vehicle_component/v_comp)
	if(istype(v_comp, /obj/item/vehicle_component/plating/mecha_armor))
		return !comp_armor
	else if(istype(v_comp, /obj/item/vehicle_component/plating/mecha_hull))
		return !comp_hull
	else if(istype(v_comp, /obj/item/vehicle_component/mecha_actuator))
		return !comp_actuator
	else if(istype(v_comp, /obj/item/vehicle_component/mecha_electrical))
		return !comp_electrical
	else if(istype(v_comp, /obj/item/vehicle_component/mecha_gas))
		return !comp_gas
	return ..()

/obj/vehicle/sealed/mecha/place_hardcoded_slot_for_component(obj/item/vehicle_component/v_comp)
	if(istype(v_comp, /obj/item/vehicle_component/plating/mecha_armor))
		if(!comp_armor)
			comp_armor = v_comp
			return TRUE
		return FALSE
	else if(istype(v_comp, /obj/item/vehicle_component/plating/mecha_hull))
		if(!comp_hull)
			comp_hull = v_comp
			return TRUE
		return FALSE
	else if(istype(v_comp, /obj/item/vehicle_component/mecha_actuator))
		if(!comp_actuator)
			comp_actuator = v_comp
			return TRUE
		return FALSE
	else if(istype(v_comp, /obj/item/vehicle_component/mecha_electrical))
		if(!comp_electrical)
			comp_electrical = v_comp
			return TRUE
		return FALSE
	else if(istype(v_comp, /obj/item/vehicle_component/mecha_gas))
		if(!comp_gas)
			comp_gas = v_comp
			return TRUE
		return FALSE
	return ..()

/obj/vehicle/sealed/mecha/unplace_hardcoded_slot_for_component(obj/item/vehicle_component/v_comp)
	if(istype(v_comp, /obj/item/vehicle_component/plating/mecha_armor))
		. = comp_armor
		comp_armor = null
		return
	else if(istype(v_comp, /obj/item/vehicle_component/plating/mecha_hull))
		. = comp_hull
		comp_hull = null
		return
	else if(istype(v_comp, /obj/item/vehicle_component/mecha_actuator))
		. = comp_actuator
		comp_actuator = null
		return
	else if(istype(v_comp, /obj/item/vehicle_component/mecha_electrical))
		. = comp_electrical
		comp_electrical = null
		return
	else if(istype(v_comp, /obj/item/vehicle_component/mecha_gas))
		. = comp_gas
		comp_gas = null
		return
	return ..()
