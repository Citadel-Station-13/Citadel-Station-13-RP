//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//


#warn fuck

/obj/item/rig/proc/add_module(obj/item/rig_module/module, datum/event_args/actor/actor)

/obj/item/rig/proc/remove_module(obj/item/rig_module/module, datum/event_args/actor/actor)

/obj/item/rig/proc/can_add_module(obj/item/rig_module/module, datum/event_args/actor/actor, silent)

/obj/item/rig/proc/can_remove_module(obj/item/rig_module/module, datum/event_args/actor/actor, silent)

/obj/item/rig/proc/try_add_module(obj/item/rig_module/module, datum/event_args/actor/actor, silent)
	if(!can_add_module(module, actor, silent))
		return FALSE
	return add_module(module, actor)

/obj/item/rig/proc/try_remove_module(obj/item/rig_module/module, datum/event_args/actor/actor, silent)
	if(!can_remove_module(module, actor, silent))
		return FALSE
	return remove_module(module, actor)
