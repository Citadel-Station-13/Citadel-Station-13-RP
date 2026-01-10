//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/vehicle/sealed/mecha/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	// legacy-ish paintkit hook
	if(istype(using, /obj/item/kit/paint))
		var/obj/item/kit/paint/casted = using
		casted.customize(src, clickchain.performer)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	// route a bunch of old style shit to maint panel
	// so players from other servers aren't confused by new input / ui system
	if(istype(using, /obj/item/card/id))
		get_maint_controller()?.ui_interact(clickchain.performer)
	if(istype(using, /obj/item/tool))
		get_maint_controller()?.ui_interact(clickchain.performer)
	if(istype(using, /obj/item/cell))
		get_maint_controller()?.ui_interact(clickchain.performer)

/obj/vehicle/sealed/mecha/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args)
	. = ..()

/obj/vehicle/sealed/mecha/welder_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	. = ..()

#warn weld fixw

/obj/vehicle/sealed/mecha/context_menu_act(datum/event_args/actor/e_args, key)
	. = ..()
	if(.)
		return
	switch(key)
		if("maint")
			// TODO: remote control?
			get_maint_controller()?.ui_interact(e_args.performer)

/obj/vehicle/sealed/mecha/context_menu_query(datum/event_args/actor/e_args)
	. = ..()
	.["maint"] = create_context_menu_tuple(
		"access maint panel",
		src,
		1,
		MOBILITY_CAN_USE,
		FALSE,
	)
