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

/obj/vehicle/sealed/mecha/request_click_target_scrambling(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	target = ..()
	var/stacks = fault_check(/datum/mecha_fault/calibration_lost)
	if(stacks)
		if(prob(min(45, stacks * 5)))
			// shitty but whatever
			var/turf/original_target_turf = get_turf(target)
			for(var/i in 1 to 10)
				// yes this means you can hit yourself
				// "it hurt itself in its confusion!"
				// lol, lmao
				target = pick(view(1, original_target_turf))
				if(target.atom_flags & (ATOM_NONWORLD | ATOM_ABSTRACT))
					continue
				if(!target.is_melee_targetable(clickchain, clickchain_flags))
					continue
				break

/obj/vehicle/sealed/mecha/request_click_angle_scrambling(angle, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	angle = ..()
	var/stacks = fault_check(/datum/mecha_fault/calibration_lost)
	if(stacks)
		angle += gaussian(0, min(stacks * 2, 45))
