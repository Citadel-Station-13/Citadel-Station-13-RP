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

/obj/item/vehicle_module/lazy/smokescreen/render_ui()
	..()

/obj/item/vehicle_module/lazy/smokescreen/on_l_ui_button(datum/event_args/actor/actor, key)
	. = ..()
	if(.)
		return

/obj/item/vehicle_module/lazy/smokescreen/proc/try_emit_smoke(datum/event_args/actor/actor)
	if(!isturf(vehicle?.loc))
		#warn yell
		return FALSE

/obj/item/vehicle_module/lazy/smokescreen/proc/emit_smoke(datum/event_args/actor/actor)
	if(!isturf(vehicle?.loc))
		return FALSE
	var/datum/effect_system/smoke_spread/we_should_cache_this_later = new
	we_should_cache_this_later.attach(vehicle)
	we_should_cache_this_later.set_up(10, 0, vehicle.loc)
	we_should_cache_this_later.start()
	qdel(we_should_cache_this_later)
	playsound(src, 'sound/effects/smoke.ogg', 50, TRUE)
	return TRUE

#warn impl
