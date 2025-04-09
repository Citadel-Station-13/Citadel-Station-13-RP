//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun/projectile/energy/on_modular_component_uninstall(obj/item/gun_component/component, datum/event_args/actor/actor, silent)
	..()
	// auto switch
	if(component == modular_particle_array_active)
		auto_set_particle_array(null)

/obj/item/gun/projectile/energy/on_modular_component_install(obj/item/gun_component/component, datum/event_args/actor/actor, silent)
	..()
	// auto switch
	if(!modular_particle_array_active)
		auto_set_particle_array(null)

/**
 * Unlike [set_particle_array], this will automatically pick the first inserted
 * array if the passed in array is null and there is one available.
 */
/obj/item/gun/projectile/energy/proc/auto_set_particle_array(obj/item/gun_component/particle_array/array)
	if(!modular_system)
		return
	if(!array)
		array = get_next_particle_array()
	return set_particle_array(array)

/obj/item/gun/projectile/energy/proc/set_particle_array(obj/item/gun_component/particle_array/array)
	if(!modular_system)
		return
	if(array == modular_particle_array_active)
		return

	modular_particle_array_active = array
	update_icon()

/obj/item/gun/projectile/energy/proc/get_next_particle_array(obey_safety) as /obj/item/gun_component/particle_array
	if(!modular_system)
		return

	if(!modular_particle_array_active)
		for(var/obj/item/gun_component/particle_array/first_array in modular_components)
			if(obey_safety && lethal_safety && first_array.considered_lethal)
				continue
			return first_array
	else
		var/current_index = modular_components.Find(modular_particle_array_active)
		if(!current_index)
			CRASH("can't find current particle array in active")
		// default to current
		. = modular_particle_array_active
		for(var/i in current_index + 1 to length(modular_components))
			var/obj/item/gun_component/particle_array/maybe_array = modular_components[i]
			if(!istype(maybe_array))
				continue
			if(obey_safety && lethal_safety && maybe_array.considered_lethal)
				continue
			return maybe_array
		for(var/i in 1 to current_index - 1)
			var/obj/item/gun_component/particle_array/maybe_array = modular_components[i]
			if(!istype(maybe_array))
				continue
			if(obey_safety && lethal_safety && maybe_array.considered_lethal)
				continue
			return maybe_array

/obj/item/gun/projectile/energy/proc/user_swap_particle_array(datum/event_args/actor/actor)
	auto_set_particle_array(get_next_particle_array())
	if(modular_particle_array_active)
		actor.chat_feedback(
			SPAN_NOTICE("You set [src] to use its [modular_particle_array_active.selection_name] emitter."),
			target = src,
		)
	else
		actor.chat_feedback(
			SPAN_WARNING("[src] has no particle emitters installed, or all of them are disabled by safeties!"),
			target = src,
		)
	playsound(src, selector_sound, 50, TRUE)
