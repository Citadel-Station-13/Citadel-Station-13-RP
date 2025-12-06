//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/vehicle/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return

	if(istype(using, /obj/item/vehicle_module))
		var/obj/item/vehicle_module/casted = using
		user_install_module(casted, clickchain)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	else if(istype(using, /obj/item/vehicle_component))
		var/obj/item/vehicle_component/casted = using
		user_install_component(casted, clickchain)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
