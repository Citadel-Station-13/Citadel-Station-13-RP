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

	// handle this last
	var/list/obj/item/vehicle_module/interested_modules = list()
	for(var/obj/item/vehicle_module/module as anything in modules)
		if(module.interested_using_item_on(using, clickchain, clickchain_flags, src))
			interested_modules += module
	var/obj/item/vehicle_module/receiving
	switch(length(interested_modules))
		if(0)
		if(1)
			receiving = interested_modules[1]
		else
			var/list/rendered_choices = list()
			for(var/obj/item/vehicle_module/rendering_module as anything in interested_modules)
				var/image/rendering_image = image(rendering_module)
				rendering_image.maptext_y = 32
				rendering_image.maptext = MAPTEXT_CENTER("[rendering_module.name]")
				rendered_choices[rendering_module] = rendering_image
			receiving = show_radial_menu(
				clickchain.initiator,
				src,
				choices = rendered_choices,
				require_near = TRUE
			)
	if(receiving)
		return receiving.receive_using_item_on(using, clickchain, clickchain_flags, src)
