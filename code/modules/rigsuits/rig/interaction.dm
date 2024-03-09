//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/rig/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(istype(I, /obj/item/rig_module))
		#warn impl
	#warn cells / eris cells / power
	return ..()

/obj/item/rig/screwdriver_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	. = ..()

/obj/item/rig/crowbar_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	. = ..()

/obj/item/rig/welder_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	. = ..()

/obj/item/rig/dynamic_tool_act(obj/item/I, datum/event_args/actor/clickchain/e_args, function, flags, hint)
	. = ..()

/obj/item/rig/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args, list/hint_images)
	. = ..()

/obj/item/rig/context_query(datum/event_args/actor/e_args)
	. = ..()

/obj/item/rig/context_act(datum/event_args/actor/e_args, key)
	. = ..()


#warn impl - attackby, etc

