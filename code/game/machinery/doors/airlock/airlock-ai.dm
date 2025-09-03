//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/machinery/door/airlock/on_silicon_control_shift_click(mob/living/silicon/user, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	var/log_str
	// TODO: we only have 'attempted' because the procs don't have real ret vals
	if(!density)
		close()
		log_str = "close (attempted)"
		actor.chat_feedback(
			SPAN_NOTICE("You send [src] a command to close."),
			target = src,
		)
	else
		open()
		log_str = "open (attempted)"
		actor.chat_feedback(
			SPAN_NOTICE("You send [src] a command to open."),
			target = src,
		)
	actor.data[ACTOR_DATA_SILICON_CONTROL_LOG] = "airlock [COORD(src)] [src] [log_str]"
	return TRUE

/obj/machinery/door/airlock/on_silicon_control_alt_click(mob/living/silicon/user, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	var/log_str
	// TODO: we only have 'attempted' because the procs don't have real ret vals
	if(electrified_until)
		electrify(0, TRUE)
		log_str = "electrify off (attempted)"
	else
		electrify(-1, TRUE)
		log_str = "electrify on (attempted)"
	actor.data[ACTOR_DATA_SILICON_CONTROL_LOG] = "airlock [COORD(src)] [src] [log_str]"
	return TRUE

/obj/machinery/door/airlock/on_silicon_control_ctrl_click(mob/living/silicon/user, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	var/log_str
	// TODO: we only have 'attempted' because the procs don't have real ret vals
	if(locked)
		toggle_bolt(user)
		log_str = "unbolt (attempted)"
	else
		toggle_bolt(user)
		log_str = "bolt (attempted)"
	actor.data[ACTOR_DATA_SILICON_CONTROL_LOG] = "airlock [COORD(src)] [src] [log_str]"
	return TRUE

/obj/machinery/door/airlock/on_silicon_control_ctrl_shift_click(mob/living/silicon/user, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	// TODO: emergency access
	return FALSE

/obj/machinery/door/airlock/on_silicon_control_middle_click(mob/living/silicon/user, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	// TODO: flash the lights or something else?
	return FALSE
