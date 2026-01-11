//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/proc/log_rigsuit(obj/item/rig/rig, datum/event_args/actor/actor, msg)
	global.event_logger.log__rigsuit_raw(rig, actor, "log", list("msg" = msg))

/proc/log_rigsuit_hotbind(obj/item/rig/rig, datum/event_args/actor/actor, action, list/params)
	global.event_logger.log__rigsuit_hotbind(rig, actor, action, params)

/**
 * * No additional params are needed as clickchain actor data list is logged to event logger.
 */
/proc/log_rigsuit_click(obj/item/rig/rig, datum/event_args/actor/clickchain/clickchain)
	global.event_logger.log__rigsuit_click(rig, clickchain)

/proc/log_rigsuit_activation_state_change(obj/item/rig/rig, datum/event_args/actor/actor, old_state, new_state)
	global.event_logger.log__rigsuit_raw(rig, actor, "activation", list("old_state" = old_state, "new_state" = new_state))

/proc/log_rigsuit_piece(obj/item/rig/rig, datum/component/rig_piece/piece, datum/event_args/actor/actor, msg)
	global.event_logger.log__rigsuit_raw(rig, actor, "piece-log", list("piece" = ref(piece), "msg" = msg))

/proc/log_rigsuit_piece_seal_state_change(obj/item/rig/rig, datum/component/rig_piece/piece, datum/event_args/actor/actor, old_state, new_state)
	global.event_logger.log__rigsuit_raw(rig, actor, "piece-activation", list("piece" = ref(piece), "old_state" = old_state, "new_state" = new_state))

#warn call these from rig code???
