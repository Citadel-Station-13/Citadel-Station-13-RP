//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//


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

/obj/item/rig/proc/on_module_weight_change(obj/item/rig_module/module, old_value, new_value)
	module_weight_tally += (new_value - old_value)
	update_module_weight()

/obj/item/rig/proc/on_module_complexity_change(obj/item/rig_module/module, old_value, new_value)

/obj/item/rig/proc/on_module_volume_change(obj/item/rig_module/module, old_value, new_value)

/obj/item/rig/proc/update_module_weight()
	#warn impl
