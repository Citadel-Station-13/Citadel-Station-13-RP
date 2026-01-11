//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * launches things. simple as.
 * * consider using rig gun API for launcher guns usually, but, this is a good lazy one that
 *   supports more like selection.
 */
/obj/item/rig_module/launcher


#warn impl


/obj/item/rig_module/launcher/proc/yeet_entity(atom/movable/entity, atom/target, datum/event_args/actor/clickchain/clickchain)

/obj/item/rig_module/launcher/is_rig_click_module()
	return TRUE
