//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/rig/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(istype(I, /obj/item/rig_module))
		#warn impl
	if(istype(I, /obj/item/cell))
		#warn impl
	if(istype(I, /obj/item/tank))
		#warn impl
	return ..()

/obj/item/rig/tool_act(obj/item/I, datum/event_args/actor/clickchain/e_args, function, flags, hint)
	. = ..()
	if(.)
		return
	var/datum/rig_maint_panel/panel = request_maint()
	panel.ui_interact(e_args.initiator)

/obj/item/rig/context_query(datum/event_args/actor/e_args)
	var/list/tuples = ..()
	if(e_args.performer == wearer)
		tuples[++tuples.len] = atom_context_tuple("access controls", image(src), 1, NONE)
	tuples[++tuples.len] = atom_context_tuple("maint panel", image(src), 1, MOBILITY_CAN_USE)

/obj/item/rig/context_act(datum/event_args/actor/e_args, key)
	. = ..()
	if(.)
		return
	switch(key)
		if("access controls")
			if(e_args.initiator != wearer)
				return TRUE
			ui_interact(e_args.initiator)
			return TRUE
		if("maint panel")
			if(!e_args.performer.Reachability(src))
				e_args.chat_feedback(
					SPAN_WARNING("You can't reach that right now."),
					target = src,
				)
				return TRUE
			var/datum/rig_maint_panel/panel = request_maint()
			panel.ui_interact(e_args.initiator)
			return TRUE
