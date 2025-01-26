//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/proc/log_gun_firing_cycle(obj/item/gun, atom/firer, datum/gun_firing_cycle/cycle, datum/event_args/actor/actor)
	global.event_logger.log__gun_firing_cycle(gun, cycle)
	log_attack("gun-fire: [actor ? actor.actor_log_string() : "[firer] (no actor)"] using [gun] firing at [cycle.original_target || "null"] with angle [cycle.original_angle]: [cycle.cycle_iterations_fired] fired, '[cycle.firemode]' firemode")
