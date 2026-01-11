//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/rig/proc/request_maint()
	RETURN_TYPE(/datum/rig_maint_panel)
	if(isnull(maint_panel))
		maint_panel = new(src)
	return maint_panel

/obj/item/rig/proc/is_maint_panel_locked()
	// todo: better access locking? maybe. for now, it's always unlocked if not being worn.
	return maint_panel_locked && (activation_state == RIG_ACTIVATION_ONLINE)

/obj/item/rig/proc/get_maint_panel_armor()
	if(!maint_panel_armor)
		maint_panel_armor = fetch_armor_struct(maint_panel_armor_type)
	return maint_panel_armor

/obj/item/rig/proc/repair_maint_panel(datum/event_args/actor/actor, obj/item/tool)

/obj/item/rig/proc/attack_maint_panel(datum/event_args/actor/actor, obj/item/tool, damage_multiplier = 1)

/obj/item/rig/proc/cut_maint_panel(datum/event_args/actor/actor, obj/item/tool)

#warn impl all

/obj/item/rig/proc/is_maint_panel_self_reachable()
	return maint_panel_allow_wearer

/obj/item/rig/proc/can_reach_maint_panel(datum/event_args/actor/actor, silent)

/obj/item/rig/proc/can_reach_maint_panel_interior(datum/event_args/actor/actor, silent)

#warn impl above two
