//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/rig_module/basic/power_sink
	name = /obj/item/rig_module/basic::name + " (power sink)"
	desc = /obj/item/rig_module/basic::desc + " This one allows an operator to drain power from \
	devices to recharge the suit's internal batteries."

	display_name = "power sink"
	display_desc = "Allows draining power from various electrical devices. This can damage the thing \
	being siphoned from if it cannot handle the current, and will likely trip overdraw sensors."

	impl_click = TRUE

	click_cooldown = 0.8 SECONDS

	/// drain rate in kilowatts
	var/drain_power = 500
	/// emit sparks while draining?
	var/emit_sparks = TRUE

	/// currently draining
	var/atom/movable/draining_entity
	/// currently draining: kilojoules drained
	var/draining_kj_so_far

#warn impl

/obj/item/rig_module/basic/power_sink/process(delta_time)
	if(draining_entity)
		siphon_power(draining_entity, delta_time)

/obj/item/rig_module/basic/power_sink/on_uninstall(obj/item/rig/rig, datum/event_args/actor/actor, silent)
	..()
	interrupt()

/obj/item/rig_module/basic/power_sink/proc/start_draining(atom/movable/target)
	draining_entity = target
	draining_kj_so_far = 0

	START_PROCESSING(SSprocessing, src)

/obj/item/rig_module/basic/power_sink/proc/stop_draining()
	if(!draining_entity)
		return

	STOP_PROCESSING(SSprocessing, src)

/obj/item/rig_module/basic/power_sink/proc/interrupt()
	stop_draining()

/obj/item/rig_module/basic/power_sink/lazy_on_click(atom/target, mob/user, intent, zone, efficiency, datum/event_args/actor/actor)
	if(draining_entity)
		actor?.chat_feedback(
			SPAN_WARNING("You're already draining something."),
			target = target,
		)
		return TRUE
	if(!rig_reachability(target, user))
		actor?.chat_feedback(
			SPAN_WARNING("You need to be closer to [target] to use [src] on it."),
			target = target,
		)
		return TRUE


/obj/item/rig_module/basic/power_sink/proc/siphon_power(atom/movable/target, dt)
	var/kj_to_draw = min(drain_power * dt, predict_power_needed())
	var/kj_drawn = target.drain_energy(src, kj_to_draw, ENERGY_DRAIN_SURGE)

	if(emit_sparks)
		#warn emit sparks

	var/should_continue = handle_siphoned_power(kj_drawn)
	if(!should_continue)
		stop_draining()

/**
 * @return amount in kj
 */
/obj/item/rig_module/basic/power_sink/proc/predict_power_needed()
	#warn impl

/**
 * @params
 * * amount - amount in kj
 *
 * @return TRUE to continue, FALSE to stop
 */
/obj/item/rig_module/basic/power_sink/proc/handle_siphoned_power(amount)
	#warn impl
