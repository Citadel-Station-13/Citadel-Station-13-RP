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
