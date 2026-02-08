//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/vehicle_module/lazy/smokescreen
	name = /obj/item/vehicle_module::name + " (smokescreen emitter)"
	desc = "A mounted smokescreen emitter for vehicles. Useful to provide some mediocre cover in a pinch."
	#warn sprite
	var/charges_max = 5
	var/charges = 5
	var/cooldown = 10 SECONDS
	var/next_use = 0
	var/auto_recharge = TRUE
	var/auto_recharge_delay = 1 MINUTES

	var/recharge_timer_id

/obj/item/vehicle_module/lazy/smokescreen/render_ui()
	..()
	l_ui_button("smokepop", "Emit Smoke", "Pop Smokescreen ([charges] / [charges_max])", confirm = TRUE)

/obj/item/vehicle_module/lazy/smokescreen/on_l_ui_button(datum/event_args/actor/actor, key)
	. = ..()
	if(.)
		return
	switch(key)
		if("smokepop")
			try_emit_smoke(actor)
			return TRUE

/obj/item/vehicle_module/lazy/smokescreen/proc/dispatch_recharge_timer(delay)
	if(recharge_timer_id)
		deltimer(recharge_timer_id)
		recharge_timer_id = null
	recharge_timer_id = addtimer(CALLBACK(src, PROC_REF(recharge_one)), delay, TIMER_STOPPABLE)

/obj/item/vehicle_module/lazy/smokescreen/proc/recharge_one()
	if(charges >= charges_max)
		return
	charges++
	if(auto_recharge && charges < charges_max)
		dispatch_recharge_timer(auto_recharge_delay)

/obj/item/vehicle_module/lazy/smokescreen/proc/try_emit_smoke(datum/event_args/actor/actor)
	if(!isturf(vehicle?.loc))
		actor?.chat_feedback(SPAN_WARNING("Not enough clearance around the vehicle to emit smoke."), target = vehicle)
		return FALSE
	if(charges <= 0)
		actor?.chat_feedback(
			SPAN_WARNING("Not enough smokescreen charges left."),
			target = vehicle,
		)
		return TRUE
	vehicle_log_for_admins(actor, "smoke-popped")
	emit_smoke(actor)
	return TRUE

/obj/item/vehicle_module/lazy/smokescreen/proc/emit_smoke(datum/event_args/actor/actor)
	if(!isturf(vehicle?.loc))
		return FALSE
	var/datum/effect_system/smoke_spread/we_should_cache_this_later = new
	we_should_cache_this_later.attach(vehicle)
	we_should_cache_this_later.set_up(10, 0, vehicle.loc)
	we_should_cache_this_later.start()
	qdel(we_should_cache_this_later)
	playsound(src, 'sound/effects/smoke.ogg', 50, TRUE)
	charges = max(0, charges - 1)
	return TRUE
