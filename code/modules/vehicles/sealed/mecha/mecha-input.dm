//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/vehicle/sealed/mecha/on_vehicle_click(datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/vehicle_module/using_module)
	// -- Legacy --
	if(phasing)
		clickchain.chat_feedback(
			SPAN_WARNING("Unable to interact with objects while phasing."),
			target = src,
		)
		return clickchain_flags
	// -- End --
	return ..()

/obj/vehicle/sealed/mecha/request_click_target_scrmabling(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	target = ..()
	var/stacks = fault_check(/datum/mecha_fault/calibration_lost)
	if(stacks)
		if(min(45, prob(stacks) * 5))
			#warn need a random targetable or a floor / wall

/obj/vehicle/sealed/mecha/request_click_angle_scrmabling(angle, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	angle = ..()
	var/stacks = fault_check(/datum/mecha_fault/calibration_lost)
	if(stacks)
		angle += gaussian(0, min(stacks * 2, 45))
